import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../services/notification_service.dart';

class ScheduledNotificationDemoScreen extends StatefulWidget {
  const ScheduledNotificationDemoScreen({super.key});

  @override
  State<ScheduledNotificationDemoScreen> createState() => _ScheduledNotificationDemoScreenState();
}

class _ScheduledNotificationDemoScreenState extends State<ScheduledNotificationDemoScreen> {
  final NotificationService _notificationService = NotificationService();
  bool _isInitialized = false;
  bool _hasPermission = false;
  int _notificationId = 100;
  List<PendingNotificationRequest> _pendingNotifications = [];

  int _delayMinutes = 1;
  RepeatInterval _repeatInterval = RepeatInterval.hourly;

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    await _notificationService.init();
    final permission = await _notificationService.requestPermission();
    await _loadPendingNotifications();
    setState(() {
      _isInitialized = true;
      _hasPermission = permission;
    });
  }

  Future<void> _loadPendingNotifications() async {
    final pending = await _notificationService.getPendingNotifications();
    setState(() => _pendingNotifications = pending);
  }

  Future<void> _scheduleDelayedNotification() async {
    if (!_hasPermission) {
      _showPermissionDeniedSnackbar();
      return;
    }

    HapticFeedback.mediumImpact();
    _notificationId++;
    final scheduledTime = DateTime.now().add(Duration(minutes: _delayMinutes));

    await _notificationService.scheduleNotification(
      id: _notificationId,
      title: '定时提醒',
      body: '这是 $_delayMinutes 分钟前设置的提醒',
      scheduledTime: scheduledTime,
      payload: 'scheduled_$_notificationId',
    );

    await _loadPendingNotifications();
    _showSuccessSnackbar('通知将在 $_delayMinutes 分钟后发送');
  }

  Future<void> _schedulePeriodicNotification() async {
    if (!_hasPermission) {
      _showPermissionDeniedSnackbar();
      return;
    }

    HapticFeedback.mediumImpact();
    _notificationId++;

    await _notificationService.showPeriodicNotification(
      id: _notificationId,
      title: '重复提醒',
      body: '这是一条 ${_getIntervalName(_repeatInterval)} 重复的通知',
      interval: _repeatInterval,
      payload: 'periodic_$_notificationId',
    );

    await _loadPendingNotifications();
    _showSuccessSnackbar('已设置 ${_getIntervalName(_repeatInterval)} 重复通知');
  }

  Future<void> _cancelNotification(int id) async {
    HapticFeedback.lightImpact();
    await _notificationService.cancelNotification(id);
    await _loadPendingNotifications();
    _showInfoSnackbar('已取消通知 #$id');
  }

  Future<void> _cancelAllNotifications() async {
    HapticFeedback.mediumImpact();
    await _notificationService.cancelAllNotifications();
    await _loadPendingNotifications();
    _showInfoSnackbar('已取消所有通知');
  }

  String _getIntervalName(RepeatInterval interval) {
    switch (interval) {
      case RepeatInterval.everyMinute:
        return '每分钟';
      case RepeatInterval.hourly:
        return '每小时';
      case RepeatInterval.daily:
        return '每天';
      case RepeatInterval.weekly:
        return '每周';
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
        title: const Text('定时通知'),
        backgroundColor: colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPendingNotifications,
            tooltip: '刷新',
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _cancelAllNotifications,
            tooltip: '取消所有',
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
                  // 延迟通知
                  _buildDelayedNotificationCard(context, colorScheme),
                  const SizedBox(height: 16),
                  // 重复通知
                  _buildPeriodicNotificationCard(context, colorScheme),
                  const SizedBox(height: 16),
                  // 待发送通知列表
                  _buildPendingNotificationsCard(context, colorScheme),
                ],
              ),
            ),
    );
  }

  Widget _buildDelayedNotificationCard(BuildContext context, ColorScheme colorScheme) {
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
                  child: const Icon(Icons.schedule, color: Colors.orange),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '延迟通知',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '设置指定时间后发送通知',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('延迟时间: $_delayMinutes 分钟', style: Theme.of(context).textTheme.bodyMedium),
            Slider(
              value: _delayMinutes.toDouble(),
              min: 1,
              max: 30,
              divisions: 29,
              label: '$_delayMinutes 分钟',
              onChanged: (value) {
                setState(() => _delayMinutes = value.toInt());
              },
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _hasPermission ? _scheduleDelayedNotification : null,
                icon: const Icon(Icons.alarm_add),
                label: const Text('设置定时通知'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodicNotificationCard(BuildContext context, ColorScheme colorScheme) {
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
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.repeat, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '重复通知',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '设置周期性重复的通知',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '重复间隔',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildIntervalChip(RepeatInterval.everyMinute),
                _buildIntervalChip(RepeatInterval.hourly),
                _buildIntervalChip(RepeatInterval.daily),
                _buildIntervalChip(RepeatInterval.weekly),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _hasPermission ? _schedulePeriodicNotification : null,
                icon: const Icon(Icons.notifications_active),
                label: const Text('设置重复通知'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntervalChip(RepeatInterval interval) {
    final isSelected = _repeatInterval == interval;
    return FilterChip(
      label: Text(_getIntervalName(interval)),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _repeatInterval = interval);
        }
      },
    );
  }

  Widget _buildPendingNotificationsCard(BuildContext context, ColorScheme colorScheme) {
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
                  child: const Icon(Icons.pending_actions, color: Colors.purple),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '待发送通知',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${_pendingNotifications.length} 条通知等待发送',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_pendingNotifications.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.notifications_off_outlined,
                        size: 48,
                        color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '没有待发送的通知',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _pendingNotifications.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final notification = _pendingNotifications[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: colorScheme.primaryContainer,
                      child: Text(
                        '#${notification.id}',
                        style: TextStyle(color: colorScheme.onPrimaryContainer, fontSize: 12),
                      ),
                    ),
                    title: Text(notification.title ?? '无标题'),
                    subtitle: Text(notification.body ?? '无内容'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _cancelNotification(notification.id),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
