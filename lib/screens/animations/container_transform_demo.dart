import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

/// 容器变换动画演示
class ContainerTransformDemo extends StatelessWidget {
  const ContainerTransformDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('容器变换动画'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 说明卡片
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '容器变换动画可以在两个界面之间创建平滑的过渡效果，让用户感受到连贯的交互体验。',
                style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Fade Through 效果
          _buildSectionTitle(context, 'Fade Through 淡入淡出'),
          const SizedBox(height: 12),
          _OpenContainerWrapper(
            transitionType: ContainerTransitionType.fadeThrough,
            closedBuilder: (context, action) {
              return _buildSmallCard(context, '淡入淡出过渡', '点击查看详情', Icons.blur_on, Colors.blue);
            },
          ),
          const SizedBox(height: 16),

          // Fade 效果
          _buildSectionTitle(context, 'Fade 渐变'),
          const SizedBox(height: 12),
          _OpenContainerWrapper(
            transitionType: ContainerTransitionType.fade,
            closedBuilder: (context, action) {
              return _buildSmallCard(context, '渐变过渡', '点击查看详情', Icons.filter_vintage, Colors.green);
            },
          ),
          const SizedBox(height: 32),

          // 网格布局示例
          _buildSectionTitle(context, '网格卡片 - OpenContainer'),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return _OpenContainerWrapper(
                transitionType: ContainerTransitionType.fadeThrough,
                closedBuilder: (context, action) {
                  return Card(
                    elevation: 2,
                    child: InkWell(
                      onTap: action,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(_getIconForIndex(index), size: 48, color: _getColorForIndex(index)),
                          const SizedBox(height: 12),
                          Text('卡片 ${index + 1}', style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 32),

          // 列表项示例
          _buildSectionTitle(context, '列表项 - OpenContainer'),
          const SizedBox(height: 12),
          ...List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _OpenContainerWrapper(
                transitionType: ContainerTransitionType.fadeThrough,
                closedBuilder: (context, action) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getColorForIndex(index),
                        child: Icon(_getIconForIndex(index), color: Colors.white),
                      ),
                      title: Text('列表项 ${index + 1}'),
                      subtitle: const Text('点击查看详细内容'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: action,
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSmallCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(width: 16),
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
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    const icons = [Icons.star, Icons.favorite, Icons.shopping_bag, Icons.card_giftcard];
    return icons[index % icons.length];
  }

  Color _getColorForIndex(int index) {
    const colors = [Colors.orange, Colors.red, Colors.purple, Colors.teal];
    return colors[index % colors.length];
  }
}

class _OpenContainerWrapper extends StatelessWidget {
  const _OpenContainerWrapper({required this.closedBuilder, required this.transitionType});

  final CloseContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: transitionType,
      transitionDuration: const Duration(milliseconds: 500),
      closedElevation: 0,
      closedColor: Theme.of(context).colorScheme.surface,
      openColor: Theme.of(context).colorScheme.surface,
      closedBuilder: closedBuilder,
      openBuilder: (context, action) {
        return const _DetailPage();
      },
    );
  }
}

class _DetailPage extends StatelessWidget {
  const _DetailPage();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('详情页面'), backgroundColor: colorScheme.surfaceContainer),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [colorScheme.primary, colorScheme.secondary]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: Icon(Icons.image, size: 64, color: colorScheme.onPrimary)),
          ),
          const SizedBox(height: 24),
          Text(
            '详细内容',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            '这是通过 OpenContainer 动画打开的详情页面。'
            '您可以看到平滑的容器变换动画效果。'
            '\n\n'
            '容器变换动画可以为应用提供更流畅、更自然的导航体验，'
            '特别适合从列表项、卡片等元素导航到详情页面的场景。'
            '\n\n'
            'Material Design 推荐使用这种动画来增强用户体验。',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('返回'),
          ),
        ],
      ),
    );
  }
}
