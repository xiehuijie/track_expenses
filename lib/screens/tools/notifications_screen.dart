import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('Notification tapped: ${response.payload}');
        },
      );

      // Request notification permission
      await Permission.notification.request();

      setState(() => _isInitialized = true);
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }

  Future<void> _showSimpleNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'simple_channel',
      '简单通知',
      channelDescription: '用于显示简单通知',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notificationsPlugin.show(
      0,
      '简单通知',
      '这是一个简单的通知消息',
      details,
      payload: 'simple_notification',
    );
  }

  Future<void> _showBigTextNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'bigtext_channel',
      '大文本通知',
      channelDescription: '用于显示大文本通知',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(
        '这是一个很长很长的通知内容，用来展示大文本样式的通知。你可以在这里放置更多的信息，通知会自动展开以显示完整内容。',
        htmlFormatBigText: true,
        contentTitle: '大文本通知标题',
        htmlFormatContentTitle: true,
        summaryText: '总结文本',
        htmlFormatSummaryText: true,
      ),
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notificationsPlugin.show(
      1,
      '大文本通知',
      '这是一个很长的通知...',
      details,
      payload: 'bigtext_notification',
    );
  }

  Future<void> _showProgressNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'progress_channel',
      '进度通知',
      channelDescription: '用于显示进度通知',
      importance: Importance.low,
      priority: Priority.low,
      showProgress: true,
      maxProgress: 100,
      progress: 0,
      onlyAlertOnce: true,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    // Show initial notification
    await _notificationsPlugin.show(
      2,
      '下载中',
      '正在下载文件...',
      details,
    );

    // Update progress
    for (int i = 0; i <= 100; i += 20) {
      await Future.delayed(const Duration(seconds: 1));
      final progressDetails = AndroidNotificationDetails(
        'progress_channel',
        '进度通知',
        channelDescription: '用于显示进度通知',
        importance: Importance.low,
        priority: Priority.low,
        showProgress: true,
        maxProgress: 100,
        progress: i,
        onlyAlertOnce: true,
      );
      await _notificationsPlugin.show(
        2,
        '下载中',
        '$i% 完成',
        NotificationDetails(android: progressDetails, iOS: iosDetails),
      );
    }
  }

  Future<void> _scheduleNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'scheduled_channel',
      '定时通知',
      channelDescription: '用于显示定时通知',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notificationsPlugin.zonedSchedule(
      3,
      '定时通知',
      '这是一个5秒后的定时通知',
      DateTime.now().add(const Duration(seconds: 5)).toUtc(),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已安排5秒后的通知')),
      );
    }
  }

  Future<void> _cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已取消所有通知')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('通知功能'),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: _isInitialized
          ? SingleChildScrollView(
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
                            '基础通知',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: _showSimpleNotification,
                            icon: const Icon(Icons.notifications),
                            label: const Text('显示简单通知'),
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            onPressed: _showBigTextNotification,
                            icon: const Icon(Icons.subject),
                            label: const Text('显示大文本通知'),
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
                            '进度通知',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: _showProgressNotification,
                            icon: const Icon(Icons.download),
                            label: const Text('显示进度通知'),
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
                            '定时通知',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: _scheduleNotification,
                            icon: const Icon(Icons.schedule),
                            label: const Text('安排5秒后通知'),
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
                            '管理',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: _cancelAllNotifications,
                            icon: const Icon(Icons.clear_all),
                            label: const Text('取消所有通知'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
