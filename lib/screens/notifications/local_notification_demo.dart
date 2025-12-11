import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/notification_service.dart';

class LocalNotificationDemoScreen extends StatefulWidget {
  const LocalNotificationDemoScreen({super.key});

  @override
  State<LocalNotificationDemoScreen> createState() => _LocalNotificationDemoScreenState();
}

class _LocalNotificationDemoScreenState extends State<LocalNotificationDemoScreen> {
  final NotificationService _notificationService = NotificationService();
  bool _isInitialized = false;
  bool _hasPermission = false;
  int _notificationId = 0;
  double _progressValue = 0;
  bool _isProgressRunning = false;

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    await _notificationService.init();
    final permission = await _notificationService.requestPermission();
    setState(() {
      _isInitialized = true;
      _hasPermission = permission;
    });
  }

  Future<void> _sendSimpleNotification() async {
    if (!_hasPermission) {
      _showPermissionDeniedSnackbar();
      return;
    }

    HapticFeedback.mediumImpact();
    _notificationId++;
    await _notificationService.showSimpleNotification(
      id: _notificationId,
      title: '简单通知',
      body: '这是一条简单的本地通知，通知 ID: $_notificationId',
      payload: 'simple_$_notificationId',
    );

    _showSuccessSnackbar('简单通知已发送');
  }

  Future<void> _sendActionNotification() async {
    if (!_hasPermission) {
      _showPermissionDeniedSnackbar();
      return;
    }

    HapticFeedback.mediumImpact();
    _notificationId++;
    await _notificationService.showActionNotification(
      id: _notificationId,
      title: '带操作按钮的通知',
      body: '点击下方按钮进行操作',
      payload: 'action_$_notificationId',
    );

    _showSuccessSnackbar('操作通知已发送');
  }

  Future<void> _sendProgressNotification() async {
    if (!_hasPermission) {
      _showPermissionDeniedSnackbar();
      return;
    }

    if (_isProgressRunning) {
      _showInfoSnackbar('进度通知正在运行中');
      return;
    }

    HapticFeedback.mediumImpact();
    _notificationId++;
    final progressId = _notificationId;

    setState(() {
      _isProgressRunning = true;
      _progressValue = 0;
    });

    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 500));
      await _notificationService.showProgressNotification(
        id: progressId,
        title: '下载中...',
        progress: i,
        maxProgress: 100,
      );
      setState(() => _progressValue = i / 100);
    }

    setState(() {
      _isProgressRunning = false;
      _progressValue = 0;
    });

    _showSuccessSnackbar('下载完成！');
  }

  Future<void> _cancelAllNotifications() async {
    HapticFeedback.mediumImpact();
    await _notificationService.cancelAllNotifications();
    _showInfoSnackbar('已取消所有通知');
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showInfoSnackbar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
  }

  void _showPermissionDeniedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.warning, color: Colors.white),
            SizedBox(width: 8),
            Text('请先授予通知权限'),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(label: '重试', textColor: Colors.white, onPressed: _initNotifications),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('本地通知'),
        backgroundColor: colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _cancelAllNotifications,
            tooltip: '取消所有通知',
          ),
        ],
      ),
      body: !_isInitialized
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 权限状态
                  _buildPermissionCard(colorScheme),
                  const SizedBox(height: 16),
                  // 简单通知
                  _buildNotificationCard(
                    context,
                    title: '简单通知',
                    description: '发送一条基本的本地通知，包含标题和内容',
                    icon: Icons.notifications,
                    color: Colors.blue,
                    onPressed: _sendSimpleNotification,
                  ),
                  const SizedBox(height: 12),
                  // 操作按钮通知
                  _buildNotificationCard(
                    context,
                    title: '操作按钮通知',
                    description: '发送带有操作按钮的通知，支持快捷操作',
                    icon: Icons.touch_app,
                    color: Colors.green,
                    onPressed: _sendActionNotification,
                  ),
                  const SizedBox(height: 12),
                  // 进度条通知
                  _buildProgressCard(context),
                ],
              ),
            ),
    );
  }

  Widget _buildPermissionCard(ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (_hasPermission ? Colors.green : Colors.orange).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _hasPermission ? Icons.check_circle : Icons.warning,
                color: _hasPermission ? Colors.green : Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '通知权限',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _hasPermission ? '已授权，可以发送通知' : '未授权，点击重试',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            if (!_hasPermission)
              IconButton(icon: const Icon(Icons.refresh), onPressed: _initNotifications),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _hasPermission ? onPressed : null,
                icon: const Icon(Icons.send),
                label: const Text('发送通知'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.downloading, color: Colors.purple),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '进度条通知',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '模拟下载进度，显示进度条通知',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_isProgressRunning) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: _progressValue,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Text(
                '${(_progressValue * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _hasPermission && !_isProgressRunning ? _sendProgressNotification : null,
                icon: Icon(_isProgressRunning ? Icons.hourglass_top : Icons.download),
                label: Text(_isProgressRunning ? '下载中...' : '模拟下载'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
