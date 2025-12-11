import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PageTransitionsDemoScreen extends StatelessWidget {
  const PageTransitionsDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('页面切换动画'), backgroundColor: colorScheme.inversePrimary),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 说明
          _buildInfoCard(context, colorScheme),
          const SizedBox(height: 16),
          // Material 转场
          _buildSection(
            context,
            title: 'Material 转场动画',
            children: [
              _buildTransitionTile(
                context,
                title: 'Container Transform',
                description: '容器变形转场效果',
                icon: Icons.transform,
                color: Colors.blue,
                onTap: () => _showContainerTransformDemo(context),
              ),
              _buildTransitionTile(
                context,
                title: 'Shared Axis',
                description: '共享轴转场效果',
                icon: Icons.swap_horiz,
                color: Colors.green,
                onTap: () => _showSharedAxisDemo(context),
              ),
              _buildTransitionTile(
                context,
                title: 'Fade Through',
                description: '淡入淡出转场效果',
                icon: Icons.blur_on,
                color: Colors.orange,
                onTap: () => _showFadeThroughDemo(context),
              ),
              _buildTransitionTile(
                context,
                title: 'Fade Scale',
                description: '缩放淡入转场效果',
                icon: Icons.zoom_in,
                color: Colors.purple,
                onTap: () => _showFadeScaleDemo(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 自定义转场
          _buildSection(
            context,
            title: '自定义转场动画',
            children: [
              _buildTransitionTile(
                context,
                title: '滑动转场',
                description: '从右侧滑入的转场效果',
                icon: Icons.arrow_forward,
                color: Colors.red,
                onTap: () => _showSlideTransitionDemo(context),
              ),
              _buildTransitionTile(
                context,
                title: '旋转转场',
                description: '旋转进入的转场效果',
                icon: Icons.rotate_right,
                color: Colors.teal,
                onTap: () => _showRotationTransitionDemo(context),
              ),
              _buildTransitionTile(
                context,
                title: '缩放转场',
                description: '从中心放大的转场效果',
                icon: Icons.zoom_out_map,
                color: Colors.indigo,
                onTap: () => _showScaleTransitionDemo(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.animation, size: 48, color: colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              '页面切换动画',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '使用 animations 包实现 Material Motion 规范',
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

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTransitionTile(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.2),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: Text(description),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
    );
  }

  void _showContainerTransformDemo(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const _ContainerTransformDemoPage()));
  }

  void _showSharedAxisDemo(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const _SharedAxisDemoPage()));
  }

  void _showFadeThroughDemo(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const _FadeThroughDemoPage()));
  }

  void _showFadeScaleDemo(BuildContext context) {
    showModal<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fade Scale 转场'),
        content: const Text('此对话框使用了 Fade Scale 转场效果'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('关闭'))],
      ),
    );
  }

  void _showSlideTransitionDemo(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const _DemoDetailPage(title: '滑动转场', color: Colors.red);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeInOut));
          return SlideTransition(position: animation.drive(tween), child: child);
        },
      ),
    );
  }

  void _showRotationTransitionDemo(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        reverseTransitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const _DemoDetailPage(title: '旋转转场', color: Colors.teal);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return RotationTransition(
            turns: Tween(
              begin: 0.5,
              end: 1.0,
            ).chain(CurveTween(curve: Curves.easeOut)).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
      ),
    );
  }

  void _showScaleTransitionDemo(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const _DemoDetailPage(title: '缩放转场', color: Colors.indigo);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: Tween(
              begin: 0.0,
              end: 1.0,
            ).chain(CurveTween(curve: Curves.fastOutSlowIn)).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
      ),
    );
  }
}

// Container Transform 演示页
class _ContainerTransformDemoPage extends StatelessWidget {
  const _ContainerTransformDemoPage();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Container Transform'),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        itemBuilder: (context, index) {
          final color = Colors.primaries[index % Colors.primaries.length];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OpenContainer(
              transitionDuration: const Duration(milliseconds: 500),
              closedElevation: 2,
              closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              closedColor: colorScheme.surface,
              openColor: colorScheme.surface,
              closedBuilder: (context, openContainer) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color.withOpacity(0.2),
                    child: Text('${index + 1}'),
                  ),
                  title: Text('列表项 ${index + 1}'),
                  subtitle: const Text('点击查看详情'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: openContainer,
                );
              },
              openBuilder: (context, closeContainer) {
                return _DemoDetailPage(title: '详情页 ${index + 1}', color: color);
              },
            ),
          );
        },
      ),
    );
  }
}

// Shared Axis 演示页
class _SharedAxisDemoPage extends StatefulWidget {
  const _SharedAxisDemoPage();

  @override
  State<_SharedAxisDemoPage> createState() => _SharedAxisDemoPageState();
}

class _SharedAxisDemoPageState extends State<_SharedAxisDemoPage> {
  int _currentIndex = 0;
  SharedAxisTransitionType _transitionType = SharedAxisTransitionType.horizontal;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Shared Axis'), backgroundColor: colorScheme.inversePrimary),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SegmentedButton<SharedAxisTransitionType>(
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
                  icon: Icon(Icons.zoom_out_map),
                ),
              ],
              selected: {_transitionType},
              onSelectionChanged: (types) {
                setState(() => _transitionType = types.first);
              },
            ),
          ),
          Expanded(
            child: PageTransitionSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
                return SharedAxisTransition(
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: _transitionType,
                  child: child,
                );
              },
              child: _buildPage(_currentIndex),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          HapticFeedback.selectionClick();
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: '首页'),
          NavigationDestination(icon: Icon(Icons.search), label: '搜索'),
          NavigationDestination(icon: Icon(Icons.person), label: '我的'),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    final colors = [Colors.blue, Colors.green, Colors.orange];
    final icons = [Icons.home, Icons.search, Icons.person];
    final labels = ['首页', '搜索', '我的'];

    return Container(
      key: ValueKey(index),
      color: colors[index].withOpacity(0.1),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icons[index], size: 64, color: colors[index]),
            const SizedBox(height: 16),
            Text(labels[index], style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
    );
  }
}

// Fade Through 演示页
class _FadeThroughDemoPage extends StatefulWidget {
  const _FadeThroughDemoPage();

  @override
  State<_FadeThroughDemoPage> createState() => _FadeThroughDemoPageState();
}

class _FadeThroughDemoPageState extends State<_FadeThroughDemoPage> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _items = [
    {'title': '照片', 'icon': Icons.photo, 'color': Colors.purple},
    {'title': '视频', 'icon': Icons.videocam, 'color': Colors.red},
    {'title': '音乐', 'icon': Icons.music_note, 'color': Colors.green},
    {'title': '文档', 'icon': Icons.description, 'color': Colors.blue},
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fade Through'),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // 选择器
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              children: List.generate(_items.length, (index) {
                final item = _items[index];
                final isSelected = _selectedIndex == index;
                return FilterChip(
                  selected: isSelected,
                  avatar: Icon(
                    item['icon'] as IconData,
                    color: isSelected ? colorScheme.onPrimary : item['color'] as Color,
                  ),
                  label: Text(item['title'] as String),
                  onSelected: (_) {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedIndex = index);
                  },
                );
              }),
            ),
          ),
          // 内容区
          Expanded(
            child: PageTransitionSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
                return FadeThroughTransition(
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
              child: _buildContent(_selectedIndex),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(int index) {
    final item = _items[index];
    final color = item['color'] as Color;

    return Container(
      key: ValueKey(index),
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
              child: Icon(item['icon'] as IconData, size: 80, color: color),
            ),
            const SizedBox(height: 24),
            Text(
              item['title'] as String,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '使用 Fade Through 切换内容',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 详情页
class _DemoDetailPage extends StatelessWidget {
  final String title;
  final Color color;

  const _DemoDetailPage({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: color.withOpacity(0.3)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
              child: Icon(Icons.check_circle, size: 80, color: color),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '转场动画演示页面',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('返回'),
            ),
          ],
        ),
      ),
    );
  }
}
