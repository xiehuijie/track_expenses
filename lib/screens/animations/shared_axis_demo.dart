import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

/// 共享轴动画演示
class SharedAxisDemo extends StatefulWidget {
  const SharedAxisDemo({super.key});

  @override
  State<SharedAxisDemo> createState() => _SharedAxisDemoState();
}

class _SharedAxisDemoState extends State<SharedAxisDemo> {
  SharedAxisTransitionType _transitionType = SharedAxisTransitionType.horizontal;
  bool _isFirstPage = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('共享轴动画'),
        backgroundColor: colorScheme.surfaceContainer,
      ),
      body: Column(
        children: [
          // 控制面板
          Container(
            padding: const EdgeInsets.all(16),
            color: colorScheme.surfaceContainerHighest,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '选择过渡方向',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                SegmentedButton<SharedAxisTransitionType>(
                  segments: const [
                    ButtonSegment(
                      value: SharedAxisTransitionType.horizontal,
                      label: Text('水平'),
                      icon: Icon(Icons.swap_horiz),
                    ),
                    ButtonSegment(
                      value: SharedAxisTransitionType.vertical,
                      label: Text('垂直'),
                      icon: Icon(Icons.swap_vert),
                    ),
                    ButtonSegment(
                      value: SharedAxisTransitionType.scaled,
                      label: Text('缩放'),
                      icon: Icon(Icons.open_in_full),
                    ),
                  ],
                  selected: {_transitionType},
                  onSelectionChanged: (Set<SharedAxisTransitionType> newSelection) {
                    setState(() {
                      _transitionType = newSelection.first;
                    });
                  },
                ),
              ],
            ),
          ),

          // 动画内容区域
          Expanded(
            child: PageTransitionSwitcher(
              duration: const Duration(milliseconds: 500),
              reverse: !_isFirstPage,
              transitionBuilder: (child, animation, secondaryAnimation) {
                return SharedAxisTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: _transitionType,
                  child: child,
                );
              },
              child: _isFirstPage
                  ? _buildPage(
                      key: const ValueKey('page1'),
                      context: context,
                      title: '页面 1',
                      color: colorScheme.primaryContainer,
                      icon: Icons.looks_one,
                      description: '这是第一个页面，点击按钮切换到第二页',
                    )
                  : _buildPage(
                      key: const ValueKey('page2'),
                      context: context,
                      title: '页面 2',
                      color: colorScheme.secondaryContainer,
                      icon: Icons.looks_two,
                      description: '这是第二个页面，点击按钮返回第一页',
                    ),
            ),
          ),

          // 切换按钮
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      setState(() {
                        _isFirstPage = !_isFirstPage;
                      });
                    },
                    icon: Icon(_isFirstPage ? Icons.arrow_forward : Icons.arrow_back),
                    label: Text(_isFirstPage ? '下一页' : '上一页'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage({
    required Key key,
    required BuildContext context,
    required String title,
    required Color color,
    required IconData icon,
    required String description,
  }) {
    return Container(
      key: key,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 64, color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _buildFeatureChip(context, '特性 1', Icons.check_circle),
              _buildFeatureChip(context, '特性 2', Icons.star),
              _buildFeatureChip(context, '特性 3', Icons.favorite),
              _buildFeatureChip(context, '特性 4', Icons.thumb_up),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(BuildContext context, String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }
}
