import 'package:flutter/material.dart';

import 'local_notification_demo.dart';
import 'notification_channels_demo.dart';
import 'scheduled_notification_demo.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('通知推送'), backgroundColor: colorScheme.inversePrimary),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(context, colorScheme),
          const SizedBox(height: 24),
          _buildDemoCard(
            context,
            title: '本地通知',
            subtitle: '立即发送通知、带图片通知、操作按钮',
            icon: Icons.notifications_active,
            color: Colors.blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LocalNotificationDemoScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _buildDemoCard(
            context,
            title: '定时通知',
            subtitle: '延迟通知、定时提醒、重复通知',
            icon: Icons.schedule,
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ScheduledNotificationDemoScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _buildDemoCard(
            context,
            title: '通知渠道',
            subtitle: '自定义声音、振动模式、重要级别',
            icon: Icons.tune,
            color: Colors.purple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationChannelsDemoScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.notifications, size: 64, color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              '通知推送功能',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '使用 flutter_local_notifications 实现本地通知',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
