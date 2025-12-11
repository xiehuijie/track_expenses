import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../services/notification_service.dart';

class NotificationChannelsDemoScreen extends StatefulWidget {
  const NotificationChannelsDemoScreen({super.key});

  @override
  State<NotificationChannelsDemoScreen> createState() => _NotificationChannelsDemoScreenState();
}

class _NotificationChannelsDemoScreenState extends State<NotificationChannelsDemoScreen> {
  final NotificationService _notificationService = NotificationService();
  bool _isInitialized = false;
  bool _hasPermission = false;
  int _notificationId = 200;

  // 通知渠道配置
  Importance _importance = Importance.high;
  bool _playSound = true;
  bool _enableVibration = true;

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

  Future<void> _sendCustomNotification() async {
    if (!_hasPermission) {
      _showPermissionDeniedSnackbar();
      return;
    }

    HapticFeedback.mediumImpact();
    _notificationId++;

    final channelId =
        'custom_${_importance.name}_${_playSound ? 's' : 'ns'}_${_enableVibration ? 'v' : 'nv'}';
    final channelName = _getChannelName();
    final channelDescription = _getChannelDescription();

    await _notificationService.showCustomChannelNotification(
      id: _notificationId,
      title: '自定义渠道通知',
      body: channelDescription,
      channelId: channelId,
      channelName: channelName,
      channelDescription: channelDescription,
      importance: _importance,
      playSound: _playSound,
      enableVibration: _enableVibration,
      payload: 'custom_$_notificationId',
    );

    _showSuccessSnackbar('已发送 $channelName 通知');
  }

  String _getChannelName() {
    return '${_getImportanceName(_importance)} 通知';
  }

  String _getChannelDescription() {
    final parts = <String>[];
    parts.add('重要级别: ${_getImportanceName(_importance)}');
    parts.add(_playSound ? '有声音' : '静音');
    parts.add(_enableVibration ? '有振动' : '无振动');
    return parts.join(' | ');
  }

  String _getImportanceName(Importance importance) {
    switch (importance) {
      case Importance.max:
        return '紧急';
      case Importance.high:
        return '高';
      case Importance.defaultImportance:
        return '默认';
      case Importance.low:
        return '低';
      case Importance.min:
        return '最低';
      case Importance.none:
        return '无';
      default:
        return '未知';
    }
  }

  Color _getImportanceColor(Importance importance) {
    switch (importance) {
      case Importance.max:
        return Colors.red;
      case Importance.high:
        return Colors.orange;
      case Importance.defaultImportance:
        return Colors.blue;
      case Importance.low:
        return Colors.grey;
      case Importance.min:
        return Colors.grey.shade400;
      default:
        return Colors.grey;
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
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
      appBar: AppBar(title: const Text('通知渠道'), backgroundColor: colorScheme.inversePrimary),
      body: !_isInitialized
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 说明卡片
                  _buildInfoCard(context, colorScheme),
                  const SizedBox(height: 16),
                  // 重要级别选择
                  _buildImportanceCard(context, colorScheme),
                  const SizedBox(height: 16),
                  // 声音和振动设置
                  _buildSoundVibrationCard(context, colorScheme),
                  const SizedBox(height: 16),
                  // 预览和发送
                  _buildPreviewCard(context, colorScheme),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoCard(BuildContext context, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.info_outline, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '关于通知渠道',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Android 8.0 (API 26) 及以上版本需要使用通知渠道来管理通知。'
              '用户可以在系统设置中单独控制每个渠道的行为。',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImportanceCard(BuildContext context, ColorScheme colorScheme) {
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
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.priority_high, color: Colors.orange),
                ),
                const SizedBox(width: 12),
                Text(
                  '重要级别',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...Importance.values
                .where((i) => i != Importance.none && i != Importance.unspecified)
                .map((importance) => _buildImportanceOption(importance)),
          ],
        ),
      ),
    );
  }

  Widget _buildImportanceOption(Importance importance) {
    final isSelected = _importance == importance;
    final color = _getImportanceColor(importance);

    return InkWell(
      onTap: () => setState(() => _importance = importance),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Radio<Importance>(
              value: importance,
              groupValue: _importance,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _importance = value);
                }
              },
            ),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getImportanceName(importance),
                    style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                  ),
                  Text(
                    _getImportanceDescription(importance),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getImportanceDescription(Importance importance) {
    switch (importance) {
      case Importance.max:
        return '会发出声音并在屏幕上弹出';
      case Importance.high:
        return '会发出声音';
      case Importance.defaultImportance:
        return '会发出声音，但不会在屏幕上弹出';
      case Importance.low:
        return '不会发出声音';
      case Importance.min:
        return '静默通知，不会在状态栏显示';
      default:
        return '';
    }
  }

  Widget _buildSoundVibrationCard(BuildContext context, ColorScheme colorScheme) {
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
                  child: const Icon(Icons.settings, color: Colors.purple),
                ),
                const SizedBox(width: 12),
                Text(
                  '声音和振动',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('播放声音'),
              subtitle: Text(
                _playSound ? '通知到达时播放提示音' : '静音',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              secondary: Icon(
                _playSound ? Icons.volume_up : Icons.volume_off,
                color: _playSound ? Colors.green : Colors.grey,
              ),
              value: _playSound,
              onChanged: (value) => setState(() => _playSound = value),
            ),
            const Divider(),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('启用振动'),
              subtitle: Text(
                _enableVibration ? '通知到达时振动' : '不振动',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              secondary: Icon(
                _enableVibration ? Icons.vibration : Icons.mobile_off,
                color: _enableVibration ? Colors.green : Colors.grey,
              ),
              value: _enableVibration,
              onChanged: (value) => setState(() => _enableVibration = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewCard(BuildContext context, ColorScheme colorScheme) {
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
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.preview, color: Colors.green),
                ),
                const SizedBox(width: 12),
                Text(
                  '预览设置',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _getImportanceColor(_importance),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getChannelName(),
                        style: Theme.of(
                          context,
                        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(_getChannelDescription(), style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        _playSound ? Icons.volume_up : Icons.volume_off,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _playSound ? '有声音' : '静音',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        _enableVibration ? Icons.vibration : Icons.mobile_off,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _enableVibration ? '有振动' : '无振动',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _hasPermission ? _sendCustomNotification : null,
                icon: const Icon(Icons.send),
                label: const Text('发送通知'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
