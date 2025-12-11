import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'calendar_demo.dart';
import 'charts_demo.dart';
import 'heatmap_demo.dart';
import 'particles_demo.dart';
import 'progress_demo.dart';

class UtilityComponentsScreen extends StatelessWidget {
  const UtilityComponentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final demos = [
      _DemoItem(
        title: '图表',
        subtitle: '折线图、柱状图、饼图等',
        icon: Icons.bar_chart,
        screen: const ChartsDemoScreen(),
      ),
      _DemoItem(
        title: '日历',
        subtitle: '可交互日历组件',
        icon: Icons.calendar_month,
        screen: const CalendarDemoScreen(),
      ),
      _DemoItem(
        title: '粒子效果',
        subtitle: '烟花、雪花、粒子动画',
        icon: Icons.celebration,
        screen: const ParticlesDemoScreen(),
      ),
      _DemoItem(
        title: '进度条',
        subtitle: '线性、环形、自定义进度条',
        icon: Icons.hourglass_empty,
        screen: const ProgressDemoScreen(),
      ),
      _DemoItem(
        title: '热力图',
        subtitle: 'GitHub 风格热力图',
        icon: Icons.grid_view,
        screen: const HeatmapDemoScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('工具类组件'), backgroundColor: colorScheme.inversePrimary),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: demos.length,
        itemBuilder: (context, index) {
          final demo = demos[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: colorScheme.primaryContainer,
                child: Icon(demo.icon, color: colorScheme.onPrimaryContainer),
              ),
              title: Text(
                demo.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(demo.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.push(context, MaterialPageRoute(builder: (context) => demo.screen));
              },
            ),
          );
        },
      ),
    );
  }
}

class _DemoItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget screen;

  _DemoItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.screen,
  });
}
