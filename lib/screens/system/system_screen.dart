import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SystemScreen extends StatefulWidget {
  const SystemScreen({super.key});

  @override
  State<SystemScreen> createState() => _SystemScreenState();
}

class _SystemScreenState extends State<SystemScreen> with SingleTickerProviderStateMixin {
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
        title: const Text('系统调用'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.folder_open), text: '文件选择'),
            Tab(icon: Icon(Icons.share), text: '分享'),
            Tab(icon: Icon(Icons.link), text: 'URL 启动'),
            Tab(icon: Icon(Icons.copy), text: '剪贴板'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [_FilePickerTab(), _ShareTab(), _UrlLauncherTab(), _ClipboardTab()],
      ),
    );
  }
}

// 文件选择标签页
class _FilePickerTab extends StatefulWidget {
  const _FilePickerTab();

  @override
  State<_FilePickerTab> createState() => _FilePickerTabState();
}

class _FilePickerTabState extends State<_FilePickerTab> {
  List<PlatformFile> _selectedFiles = [];
  String? _selectedDirectory;
  bool _isLoading = false;

  Future<void> _pickFile({bool allowMultiple = false}) async {
    HapticFeedback.lightImpact();
    setState(() => _isLoading = true);

    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: allowMultiple);

      if (result != null) {
        setState(() => _selectedFiles = result.files);
      }
    } catch (e) {
      _showError('选择文件失败: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImages() async {
    HapticFeedback.lightImpact();
    setState(() => _isLoading = true);

    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: true);

      if (result != null) {
        setState(() => _selectedFiles = result.files);
      }
    } catch (e) {
      _showError('选择图片失败: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickCustomType() async {
    HapticFeedback.lightImpact();
    setState(() => _isLoading = true);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
      );

      if (result != null) {
        setState(() => _selectedFiles = result.files);
      }
    } catch (e) {
      _showError('选择文件失败: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickDirectory() async {
    HapticFeedback.lightImpact();

    try {
      final result = await FilePicker.platform.getDirectoryPath();
      if (result != null) {
        setState(() => _selectedDirectory = result);
      }
    } catch (e) {
      _showError('选择目录失败: $e');
    }
  }

  void _clearSelection() {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedFiles = [];
      _selectedDirectory = null;
    });
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / 1024 / 1024).toStringAsFixed(1)} MB';
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
                    '文件选择器',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : () => _pickFile(),
                        icon: const Icon(Icons.insert_drive_file),
                        label: const Text('单个文件'),
                      ),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : () => _pickFile(allowMultiple: true),
                        icon: const Icon(Icons.file_copy),
                        label: const Text('多个文件'),
                      ),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _pickImages,
                        icon: const Icon(Icons.image),
                        label: const Text('图片'),
                      ),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _pickCustomType,
                        icon: const Icon(Icons.description),
                        label: const Text('文档'),
                      ),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _pickDirectory,
                        icon: const Icon(Icons.folder),
                        label: const Text('目录'),
                      ),
                    ],
                  ),
                  if (_isLoading) ...[
                    const SizedBox(height: 16),
                    const Center(child: CircularProgressIndicator()),
                  ],
                ],
              ),
            ),
          ),
          if (_selectedFiles.isNotEmpty || _selectedDirectory != null) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '选择结果',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        IconButton(icon: const Icon(Icons.clear), onPressed: _clearSelection),
                      ],
                    ),
                    const Divider(),
                    if (_selectedDirectory != null) ...[
                      ListTile(
                        leading: const Icon(Icons.folder),
                        title: const Text('选择的目录'),
                        subtitle: Text(_selectedDirectory!),
                      ),
                    ],
                    ...(_selectedFiles.map((file) {
                      return ListTile(
                        leading: Icon(_getFileIcon(file.extension)),
                        title: Text(file.name),
                        subtitle: Text(
                          '${_formatBytes(file.size)}${file.path != null ? ' • ${file.path}' : ''}',
                        ),
                      );
                    })),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getFileIcon(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'mp3':
      case 'wav':
        return Icons.audio_file;
      case 'mp4':
      case 'avi':
        return Icons.video_file;
      default:
        return Icons.insert_drive_file;
    }
  }
}

// 分享标签页
class _ShareTab extends StatefulWidget {
  const _ShareTab();

  @override
  State<_ShareTab> createState() => _ShareTabState();
}

class _ShareTabState extends State<_ShareTab> {
  final _textController = TextEditingController(text: 'Hello from Flutter!');

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _shareText() async {
    HapticFeedback.mediumImpact();

    try {
      await Share.share(_textController.text, subject: 'Flutter 分享测试');
    } catch (e) {
      _showError('分享失败: $e');
    }
  }

  Future<void> _shareWithResult() async {
    HapticFeedback.mediumImpact();

    try {
      await Share.share(_textController.text, subject: 'Flutter 分享测试');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('分享完成')));
      }
    } catch (e) {
      _showError('分享失败: $e');
    }
  }

  Future<void> _shareFile() async {
    if (kIsWeb) {
      _showError('Web 平台不支持文件分享');
      return;
    }

    HapticFeedback.mediumImpact();

    try {
      // 创建一个临时文件用于分享
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/share_demo.txt');
      await file.writeAsString('这是一个用于分享测试的文件内容。\n创建时间: ${DateTime.now()}');

      await Share.shareXFiles([XFile(file.path)], text: '分享文件', subject: 'Flutter 文件分享测试');
    } catch (e) {
      _showError('分享文件失败: $e');
    }
  }

  Future<void> _shareUri() async {
    HapticFeedback.mediumImpact();

    try {
      await Share.shareUri(Uri.parse('https://flutter.dev'));
    } catch (e) {
      _showError('分享链接失败: $e');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
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
                    '分享文本',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(labelText: '要分享的内容', hintText: '输入要分享的文本'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton.icon(
                        onPressed: _shareText,
                        icon: const Icon(Icons.share),
                        label: const Text('分享'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _shareWithResult,
                        icon: const Icon(Icons.info),
                        label: const Text('分享并获取结果'),
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
                    '分享其他内容',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.attach_file),
                    title: const Text('分享文件'),
                    subtitle: const Text('创建并分享一个临时文件'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _shareFile,
                  ),
                  ListTile(
                    leading: const Icon(Icons.link),
                    title: const Text('分享链接'),
                    subtitle: const Text('分享 flutter.dev 链接'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _shareUri,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// URL 启动标签页
class _UrlLauncherTab extends StatelessWidget {
  const _UrlLauncherTab();

  Future<void> _launchUrl(
    BuildContext context,
    String url, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    HapticFeedback.lightImpact();

    try {
      final uri = Uri.parse(url);
      final canLaunch = await canLaunchUrl(uri);

      if (canLaunch) {
        await launchUrl(uri, mode: mode);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('无法打开: $url')));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('打开链接失败: $e'), backgroundColor: Colors.red));
      }
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
                    '网页链接',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.public),
                    title: const Text('Flutter 官网'),
                    subtitle: const Text('https://flutter.dev'),
                    onTap: () => _launchUrl(context, 'https://flutter.dev'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.code),
                    title: const Text('GitHub'),
                    subtitle: const Text('在浏览器中打开'),
                    onTap: () => _launchUrl(
                      context,
                      'https://github.com/flutter/flutter',
                      mode: LaunchMode.externalApplication,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.web),
                    title: const Text('在应用内打开'),
                    subtitle: const Text('使用内置 WebView'),
                    onTap: () =>
                        _launchUrl(context, 'https://flutter.dev', mode: LaunchMode.inAppWebView),
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
                    '系统应用',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('发送邮件'),
                    subtitle: const Text('打开邮件应用'),
                    onTap: () => _launchUrl(
                      context,
                      'mailto:example@email.com?subject=Hello&body=This is a test email',
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('拨打电话'),
                    subtitle: const Text('打开拨号器'),
                    onTap: () => _launchUrl(context, 'tel:+1234567890'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.sms),
                    title: const Text('发送短信'),
                    subtitle: const Text('打开短信应用'),
                    onTap: () => _launchUrl(context, 'sms:+1234567890?body=Hello from Flutter'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.map),
                    title: const Text('打开地图'),
                    subtitle: const Text('显示位置'),
                    onTap: () => _launchUrl(
                      context,
                      'https://www.google.com/maps/search/?api=1&query=37.7749,-122.4194',
                    ),
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
                    '应用商店',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.android),
                    title: const Text('Google Play'),
                    subtitle: const Text('打开应用商店'),
                    onTap: () => _launchUrl(
                      context,
                      'https://play.google.com/store/apps/details?id=com.google.android.apps.maps',
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.apple),
                    title: const Text('App Store'),
                    subtitle: const Text('打开应用商店'),
                    onTap: () =>
                        _launchUrl(context, 'https://apps.apple.com/app/apple-store/id585027354'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 剪贴板标签页
class _ClipboardTab extends StatefulWidget {
  const _ClipboardTab();

  @override
  State<_ClipboardTab> createState() => _ClipboardTabState();
}

class _ClipboardTabState extends State<_ClipboardTab> {
  final _textController = TextEditingController();
  String _clipboardContent = '';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _copyToClipboard() async {
    if (_textController.text.isEmpty) {
      _showError('请输入要复制的内容');
      return;
    }

    HapticFeedback.mediumImpact();

    try {
      await Clipboard.setData(ClipboardData(text: _textController.text));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已复制到剪贴板')));
      }
    } catch (e) {
      _showError('复制失败: $e');
    }
  }

  Future<void> _pasteFromClipboard() async {
    HapticFeedback.lightImpact();

    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      if (data != null && data.text != null) {
        setState(() => _clipboardContent = data.text!);
      } else {
        setState(() => _clipboardContent = '(剪贴板为空)');
      }
    } catch (e) {
      _showError('粘贴失败: $e');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
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
                    '复制到剪贴板',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(labelText: '输入文本', hintText: '输入要复制的内容'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _copyToClipboard,
                    icon: const Icon(Icons.copy),
                    label: const Text('复制'),
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
                    '从剪贴板粘贴',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _pasteFromClipboard,
                    icon: const Icon(Icons.paste),
                    label: const Text('获取剪贴板内容'),
                  ),
                  if (_clipboardContent.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SelectableText(_clipboardContent),
                    ),
                  ],
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
                    '触觉反馈',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text('点击按钮体验不同的触觉反馈（需要在实体设备上体验）', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton(
                        onPressed: () => HapticFeedback.lightImpact(),
                        child: const Text('轻触'),
                      ),
                      ElevatedButton(
                        onPressed: () => HapticFeedback.mediumImpact(),
                        child: const Text('中度'),
                      ),
                      ElevatedButton(
                        onPressed: () => HapticFeedback.heavyImpact(),
                        child: const Text('重度'),
                      ),
                      ElevatedButton(
                        onPressed: () => HapticFeedback.selectionClick(),
                        child: const Text('选择'),
                      ),
                      ElevatedButton(
                        onPressed: () => HapticFeedback.vibrate(),
                        child: const Text('振动'),
                      ),
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
}
