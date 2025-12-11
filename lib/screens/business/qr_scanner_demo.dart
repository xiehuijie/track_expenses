import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerDemoScreen extends StatefulWidget {
  const QrScannerDemoScreen({super.key});

  @override
  State<QrScannerDemoScreen> createState() => _QrScannerDemoScreenState();
}

class _QrScannerDemoScreenState extends State<QrScannerDemoScreen>
    with SingleTickerProviderStateMixin {
  MobileScannerController? _controller;
  bool _isScanning = false;
  String? _scannedCode;
  BarcodeFormat? _codeFormat;
  bool _torchEnabled = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _controller?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _startScanning() {
    setState(() {
      _isScanning = true;
      _scannedCode = null;
      _codeFormat = null;
      _controller = MobileScannerController(
        detectionSpeed: DetectionSpeed.normal,
        facing: CameraFacing.back,
        torchEnabled: _torchEnabled,
      );
    });
    _animationController.repeat();
  }

  void _stopScanning() {
    _controller?.dispose();
    _controller = null;
    _animationController.stop();
    setState(() {
      _isScanning = false;
    });
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue != null && _scannedCode == null) {
      HapticFeedback.heavyImpact();
      setState(() {
        _scannedCode = barcode!.rawValue;
        _codeFormat = barcode.format;
      });
      _stopScanning();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('二维码扫描'),
        backgroundColor: colorScheme.inversePrimary,
        actions: _isScanning
            ? [
                IconButton(
                  icon: Icon(_torchEnabled ? Icons.flash_on : Icons.flash_off),
                  onPressed: () async {
                    await _controller?.toggleTorch();
                    setState(() {
                      _torchEnabled = !_torchEnabled;
                    });
                  },
                  tooltip: '闪光灯',
                ),
                IconButton(
                  icon: const Icon(Icons.flip_camera_ios),
                  onPressed: () => _controller?.switchCamera(),
                  tooltip: '切换相机',
                ),
              ]
            : null,
      ),
      body: _isScanning ? _buildScannerView(colorScheme) : _buildStartView(colorScheme),
    );
  }

  Widget _buildStartView(ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 图标
          Icon(Icons.qr_code_scanner, size: 120, color: colorScheme.primary),
          const SizedBox(height: 32),
          // 标题
          Text(
            '扫描二维码',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            '支持扫描二维码、条形码等多种码型',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          // 开始扫描按钮
          FilledButton.icon(
            onPressed: _startScanning,
            icon: const Icon(Icons.camera_alt),
            label: const Text('开始扫描'),
            style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
          ),
          const SizedBox(height: 32),
          // 扫描结果
          if (_scannedCode != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          '扫描成功',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Text(
                      '类型: ${_getFormatName(_codeFormat)}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '内容:',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      _scannedCode!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: _scannedCode!));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('已复制到剪贴板'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            icon: const Icon(Icons.copy),
                            label: const Text('复制'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _startScanning,
                            icon: const Icon(Icons.refresh),
                            label: const Text('重新扫描'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          // 支持的码型
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '支持的码型',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildFormatChip('QR Code', Icons.qr_code),
                      _buildFormatChip('条形码', Icons.view_column),
                      _buildFormatChip('Data Matrix', Icons.grid_4x4),
                      _buildFormatChip('Aztec', Icons.architecture),
                      _buildFormatChip('PDF417', Icons.receipt),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatChip(String label, IconData icon) {
    return Chip(avatar: Icon(icon, size: 18), label: Text(label));
  }

  Widget _buildScannerView(ColorScheme colorScheme) {
    return Stack(
      children: [
        // 相机预览
        if (_controller != null)
          MobileScanner(controller: _controller!, onDetect: _onBarcodeDetected),
        // 扫描框
        Center(
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                // 四角装饰
                ..._buildCornerDecorations(colorScheme),
                // 扫描线动画
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Positioned(
                      top: 280 * _animationController.value,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, colorScheme.primary, Colors.transparent],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        // 底部提示
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: Text(
            '将二维码放入框内即可自动扫描',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        // 取消按钮
        Positioned(
          bottom: 32,
          left: 0,
          right: 0,
          child: Center(
            child: FilledButton.tonal(onPressed: _stopScanning, child: const Text('取消')),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCornerDecorations(ColorScheme colorScheme) {
    const cornerSize = 24.0;
    const cornerWidth = 4.0;
    final color = colorScheme.primary;

    return [
      // 左上
      Positioned(
        top: 0,
        left: 0,
        child: Container(width: cornerSize, height: cornerWidth, color: color),
      ),
      Positioned(
        top: 0,
        left: 0,
        child: Container(width: cornerWidth, height: cornerSize, color: color),
      ),
      // 右上
      Positioned(
        top: 0,
        right: 0,
        child: Container(width: cornerSize, height: cornerWidth, color: color),
      ),
      Positioned(
        top: 0,
        right: 0,
        child: Container(width: cornerWidth, height: cornerSize, color: color),
      ),
      // 左下
      Positioned(
        bottom: 0,
        left: 0,
        child: Container(width: cornerSize, height: cornerWidth, color: color),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        child: Container(width: cornerWidth, height: cornerSize, color: color),
      ),
      // 右下
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(width: cornerSize, height: cornerWidth, color: color),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(width: cornerWidth, height: cornerSize, color: color),
      ),
    ];
  }

  String _getFormatName(BarcodeFormat? format) {
    if (format == null) return '未知';

    switch (format) {
      case BarcodeFormat.qrCode:
        return 'QR Code';
      case BarcodeFormat.ean13:
        return 'EAN-13';
      case BarcodeFormat.ean8:
        return 'EAN-8';
      case BarcodeFormat.upcA:
        return 'UPC-A';
      case BarcodeFormat.upcE:
        return 'UPC-E';
      case BarcodeFormat.code128:
        return 'Code 128';
      case BarcodeFormat.code39:
        return 'Code 39';
      case BarcodeFormat.code93:
        return 'Code 93';
      case BarcodeFormat.dataMatrix:
        return 'Data Matrix';
      case BarcodeFormat.aztec:
        return 'Aztec';
      case BarcodeFormat.pdf417:
        return 'PDF417';
      default:
        return format.toString();
    }
  }
}
