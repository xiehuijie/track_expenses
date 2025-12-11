import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';

class HardwareScreen extends StatefulWidget {
  const HardwareScreen({super.key});

  @override
  State<HardwareScreen> createState() => _HardwareScreenState();
}

class _HardwareScreenState extends State<HardwareScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('硬件调用'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.camera_alt), text: '相机'),
            Tab(icon: Icon(Icons.fingerprint), text: '生物识别'),
            Tab(icon: Icon(Icons.sensors), text: '传感器'),
            Tab(icon: Icon(Icons.phone_android), text: '设备信息'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _CameraTab(),
          _BiometricTab(),
          _SensorsTab(),
          _DeviceInfoTab(),
        ],
      ),
    );
  }
}

// 相机标签页
class _CameraTab extends StatefulWidget {
  const _CameraTab();

  @override
  State<_CameraTab> createState() => _CameraTabState();
}

class _CameraTabState extends State<_CameraTab> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isLoading = false;
  String? _errorMessage;
  XFile? _capturedImage;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    if (kIsWeb) {
      setState(() => _errorMessage = '相机功能在 Web 平台受限');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 请求相机权限
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        setState(() => _errorMessage = '相机权限被拒绝');
        return;
      }

      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        setState(() => _errorMessage = '未找到可用相机');
        return;
      }

      _cameraController = CameraController(
        _cameras!.first,
        ResolutionPreset.medium,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      setState(() => _errorMessage = '相机初始化失败: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    HapticFeedback.mediumImpact();

    try {
      final image = await _cameraController!.takePicture();
      setState(() => _capturedImage = image);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('照片已保存: ${image.path}')));
      }
    } catch (e) {
      _showError('拍照失败: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    HapticFeedback.lightImpact();

    try {
      final image = await _imagePicker.pickImage(source: source);
      if (image != null) {
        setState(() => _capturedImage = image);
      }
    } catch (e) {
      _showError('选择图片失败: $e');
    }
  }

  void _disposeCamera() {
    _cameraController?.dispose();
    _cameraController = null;
    setState(() {
      _isInitialized = false;
      _capturedImage = null;
    });
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '相机预览',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(child: Text(_errorMessage!)),
                        ],
                      ),
                    )
                  else if (_isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (_isInitialized && _cameraController != null)
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AspectRatio(
                            aspectRatio: _cameraController!.value.aspectRatio,
                            child: CameraPreview(_cameraController!),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FloatingActionButton(
                              heroTag: 'capture',
                              onPressed: _takePicture,
                              child: const Icon(Icons.camera),
                            ),
                            FloatingActionButton(
                              heroTag: 'close',
                              onPressed: _disposeCamera,
                              backgroundColor: Colors.red,
                              child: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.camera_alt,
                              size: 64,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: _initCamera,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('启动相机'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '图片选择器',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library),
                          label: const Text('相册'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('拍照'),
                        ),
                      ),
                    ],
                  ),
                  if (_capturedImage != null) ...[
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: kIsWeb
                          ? Image.network(_capturedImage!.path)
                          : Image.file(File(_capturedImage!.path)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '路径: ${_capturedImage!.path}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 生物识别标签页
class _BiometricTab extends StatefulWidget {
  const _BiometricTab();

  @override
  State<_BiometricTab> createState() => _BiometricTabState();
}

class _BiometricTabState extends State<_BiometricTab> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  bool _isDeviceSupported = false;
  List<BiometricType> _availableBiometrics = [];
  String _authStatus = '未验证';
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    try {
      _isDeviceSupported = await _localAuth.isDeviceSupported();
      _canCheckBiometrics = await _localAuth.canCheckBiometrics;
      _availableBiometrics = await _localAuth.getAvailableBiometrics();
      setState(() {});
    } catch (e) {
      debugPrint('检查生物识别失败: $e');
    }
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;

    HapticFeedback.mediumImpact();
    setState(() {
      _isAuthenticating = true;
      _authStatus = '验证中...';
    });

    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: '请验证身份以继续',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      HapticFeedback.heavyImpact();
      setState(() {
        _authStatus = authenticated ? '✅ 验证成功' : '❌ 验证失败';
      });
    } catch (e) {
      setState(() => _authStatus = '验证错误: $e');
    } finally {
      setState(() => _isAuthenticating = false);
    }
  }

  String _getBiometricTypeName(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return '面部识别';
      case BiometricType.fingerprint:
        return '指纹识别';
      case BiometricType.iris:
        return '虹膜识别';
      case BiometricType.strong:
        return '强生物识别';
      case BiometricType.weak:
        return '弱生物识别';
    }
  }

  IconData _getBiometricIcon(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return Icons.face;
      case BiometricType.fingerprint:
        return Icons.fingerprint;
      case BiometricType.iris:
        return Icons.remove_red_eye;
      default:
        return Icons.security;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '设备支持状态',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStatusRow('设备支持生物识别', _isDeviceSupported),
                  _buildStatusRow('可检查生物识别', _canCheckBiometrics),
                  const Divider(),
                  Text(
                    '可用的生物识别方式:',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  if (_availableBiometrics.isEmpty)
                    const Text(
                      '无可用的生物识别方式',
                      style: TextStyle(color: Colors.grey),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableBiometrics.map((type) {
                        return Chip(
                          avatar: Icon(_getBiometricIcon(type), size: 18),
                          label: Text(_getBiometricTypeName(type)),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '身份验证',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          _authStatus.contains('成功')
                              ? Icons.check_circle
                              : _authStatus.contains('失败')
                              ? Icons.cancel
                              : Icons.fingerprint,
                          size: 80,
                          color: _authStatus.contains('成功')
                              ? Colors.green
                              : _authStatus.contains('失败')
                              ? Colors.red
                              : Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _authStatus,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: (_canCheckBiometrics && !_isAuthenticating)
                              ? _authenticate
                              : null,
                          icon: _isAuthenticating
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.fingerprint),
                          label: Text(_isAuthenticating ? '验证中...' : '开始验证'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            value ? Icons.check_circle : Icons.cancel,
            color: value ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

// 传感器标签页
class _SensorsTab extends StatefulWidget {
  const _SensorsTab();

  @override
  State<_SensorsTab> createState() => _SensorsTabState();
}

class _SensorsTabState extends State<_SensorsTab> {
  // 加速度计
  AccelerometerEvent? _accelerometerEvent;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  // 陀螺仪
  GyroscopeEvent? _gyroscopeEvent;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;

  // 磁力计
  MagnetometerEvent? _magnetometerEvent;
  StreamSubscription<MagnetometerEvent>? _magnetometerSubscription;

  bool _isListening = false;

  void _startListening() {
    HapticFeedback.mediumImpact();

    _accelerometerSubscription = accelerometerEventStream().listen((event) {
      setState(() => _accelerometerEvent = event);
    });

    _gyroscopeSubscription = gyroscopeEventStream().listen((event) {
      setState(() => _gyroscopeEvent = event);
    });

    _magnetometerSubscription = magnetometerEventStream().listen((event) {
      setState(() => _magnetometerEvent = event);
    });

    setState(() => _isListening = true);
  }

  void _stopListening() {
    HapticFeedback.lightImpact();

    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _magnetometerSubscription?.cancel();

    setState(() => _isListening = false);
  }

  @override
  void dispose() {
    _stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  FilledButton.icon(
                    onPressed: _isListening ? _stopListening : _startListening,
                    icon: Icon(_isListening ? Icons.stop : Icons.play_arrow),
                    label: Text(_isListening ? '停止监听' : '开始监听'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isListening ? '传感器监听中...' : '点击开始监听传感器数据',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSensorCard(
            title: '加速度计',
            icon: Icons.speed,
            color: Colors.blue,
            data: _accelerometerEvent != null
                ? {
                    'X': _accelerometerEvent!.x.toStringAsFixed(2),
                    'Y': _accelerometerEvent!.y.toStringAsFixed(2),
                    'Z': _accelerometerEvent!.z.toStringAsFixed(2),
                  }
                : null,
          ),
          const SizedBox(height: 16),
          _buildSensorCard(
            title: '陀螺仪',
            icon: Icons.rotate_right,
            color: Colors.green,
            data: _gyroscopeEvent != null
                ? {
                    'X': _gyroscopeEvent!.x.toStringAsFixed(2),
                    'Y': _gyroscopeEvent!.y.toStringAsFixed(2),
                    'Z': _gyroscopeEvent!.z.toStringAsFixed(2),
                  }
                : null,
          ),
          const SizedBox(height: 16),
          _buildSensorCard(
            title: '磁力计',
            icon: Icons.explore,
            color: Colors.orange,
            data: _magnetometerEvent != null
                ? {
                    'X': _magnetometerEvent!.x.toStringAsFixed(2),
                    'Y': _magnetometerEvent!.y.toStringAsFixed(2),
                    'Z': _magnetometerEvent!.z.toStringAsFixed(2),
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSensorCard({
    required String title,
    required IconData icon,
    required Color color,
    Map<String, String>? data,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (data == null)
              const Text('等待数据...', style: TextStyle(color: Colors.grey))
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: data.entries.map((entry) {
                  return Column(
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entry.value,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

// 设备信息标签页
class _DeviceInfoTab extends StatefulWidget {
  const _DeviceInfoTab();

  @override
  State<_DeviceInfoTab> createState() => _DeviceInfoTabState();
}

class _DeviceInfoTabState extends State<_DeviceInfoTab> {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
  }

  Future<void> _loadDeviceInfo() async {
    setState(() => _isLoading = true);

    try {
      if (kIsWeb) {
        final webInfo = await _deviceInfo.webBrowserInfo;
        _deviceData = {
          '浏览器': webInfo.browserName.name,
          '平台': webInfo.platform ?? '未知',
          '用户代理': webInfo.userAgent ?? '未知',
          '语言': webInfo.language ?? '未知',
          '供应商': webInfo.vendor ?? '未知',
        };
      } else if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        _deviceData = {
          '设备': androidInfo.device,
          '品牌': androidInfo.brand,
          '型号': androidInfo.model,
          '制造商': androidInfo.manufacturer,
          'Android 版本': androidInfo.version.release,
          'SDK 版本': androidInfo.version.sdkInt.toString(),
          '产品': androidInfo.product,
          '硬件': androidInfo.hardware,
          '是否物理设备': androidInfo.isPhysicalDevice ? '是' : '否',
          '设备 ID': androidInfo.id,
        };
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        _deviceData = {
          '名称': iosInfo.name,
          '系统名称': iosInfo.systemName,
          '系统版本': iosInfo.systemVersion,
          '型号': iosInfo.model,
          '本地化型号': iosInfo.localizedModel,
          '是否物理设备': iosInfo.isPhysicalDevice ? '是' : '否',
          'UUID': iosInfo.identifierForVendor ?? '未知',
        };
      } else if (Platform.isWindows) {
        final windowsInfo = await _deviceInfo.windowsInfo;
        _deviceData = {
          '计算机名': windowsInfo.computerName,
          '系统内存 (MB)': windowsInfo.systemMemoryInMegabytes.toString(),
          '用户名': windowsInfo.userName,
          '核心数': windowsInfo.numberOfCores.toString(),
          '产品 ID': windowsInfo.productId,
          '产品名': windowsInfo.productName,
        };
      } else if (Platform.isMacOS) {
        final macInfo = await _deviceInfo.macOsInfo;
        _deviceData = {
          '计算机名': macInfo.computerName,
          '主机名': macInfo.hostName,
          '架构': macInfo.arch,
          '型号': macInfo.model,
          '系统版本': macInfo.osRelease,
          '核心数': macInfo.activeCPUs.toString(),
          '内存 (GB)': (macInfo.memorySize / 1024 / 1024 / 1024).toStringAsFixed(
            2,
          ),
        };
      } else if (Platform.isLinux) {
        final linuxInfo = await _deviceInfo.linuxInfo;
        _deviceData = {
          '名称': linuxInfo.name,
          '版本': linuxInfo.version ?? '未知',
          'ID': linuxInfo.id,
          'Pretty Name': linuxInfo.prettyName,
          '变体': linuxInfo.variant ?? '未知',
        };
      }

      setState(() {});
    } catch (e) {
      debugPrint('获取设备信息失败: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.phone_android),
                      const SizedBox(width: 8),
                      Text(
                        '设备信息',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _loadDeviceInfo,
                  ),
                ],
              ),
              const Divider(),
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                ...(_deviceData.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 120,
                          child: Text(
                            entry.key,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          child: SelectableText(
                            entry.value.toString(),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  );
                })),
            ],
          ),
        ),
      ),
    );
  }
}
