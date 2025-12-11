import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'fireworks_demo.dart';
import 'loading_animations_demo.dart';
import 'page_transitions_demo.dart';

class AnimationsScreen extends StatefulWidget {
  const AnimationsScreen({super.key});

  @override
  State<AnimationsScreen> createState() => _AnimationsScreenState();
}

class _AnimationsScreenState extends State<AnimationsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isExpanded = false;
  bool _isVisible = true;
  double _containerSize = 100;
  Color _containerColor = Colors.blue;
  double _rotationAngle = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('动画效果'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 高级动画演示入口
            _buildAdvancedAnimationsSection(context),
            const SizedBox(height: 24),
            _buildSection(
              title: 'AnimatedContainer 隐式动画',
              child: Column(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        setState(() {
                          _containerSize = _containerSize == 100 ? 150 : 100;
                          _containerColor = _containerColor == Colors.blue
                              ? Colors.purple
                              : Colors.blue;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        width: _containerSize,
                        height: _containerSize,
                        decoration: BoxDecoration(
                          color: _containerColor,
                          borderRadius: BorderRadius.circular(_containerSize == 100 ? 16 : 75),
                        ),
                        child: const Center(
                          child: Text('点击', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('点击方块查看动画效果', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'AnimatedOpacity & AnimatedCrossFade',
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          setState(() => _isVisible = !_isVisible);
                        },
                        child: Text(_isVisible ? '隐藏' : '显示'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AnimatedOpacity(
                    opacity: _isVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      height: 80,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(child: Text('透明度动画')),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedCrossFade(
                    firstChild: Container(
                      height: 80,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('视图 A', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    secondChild: Container(
                      height: 80,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('视图 B', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    crossFadeState: _isVisible
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'AnimatedRotation & AnimatedScale',
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            _rotationAngle += 0.25;
                            _isExpanded = !_isExpanded;
                          });
                        },
                        child: const Text('动画'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AnimatedRotation(
                        turns: _rotationAngle,
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.refresh, color: Colors.white),
                        ),
                      ),
                      AnimatedScale(
                        scale: _isExpanded ? 1.5 : 1.0,
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.zoom_in, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Hero 动画',
              child: Column(
                children: [
                  const Text('点击图标查看 Hero 动画效果'),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: List.generate(4, (index) {
                      final colors = [Colors.red, Colors.blue, Colors.green, Colors.orange];
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  _HeroDetailPage(color: colors[index], heroTag: 'hero_$index'),
                            ),
                          );
                        },
                        child: Hero(
                          tag: 'hero_$index',
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: colors[index],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.star, color: Colors.white),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: '页面切换动画',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () => _navigateWithAnimation(
                      context,
                      SharedAxisTransitionType.horizontal,
                      '水平共享轴',
                    ),
                    child: const Text('水平'),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        _navigateWithAnimation(context, SharedAxisTransitionType.vertical, '垂直共享轴'),
                    child: const Text('垂直'),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        _navigateWithAnimation(context, SharedAxisTransitionType.scaled, '缩放共享轴'),
                    child: const Text('缩放'),
                  ),
                  ElevatedButton(
                    onPressed: () => _navigateWithFade(context),
                    child: const Text('淡入淡出'),
                  ),
                  ElevatedButton(
                    onPressed: () => _navigateWithSlide(context),
                    child: const Text('滑动'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'OpenContainer 动画',
              child: OpenContainer(
                transitionType: ContainerTransitionType.fadeThrough,
                transitionDuration: const Duration(milliseconds: 500),
                closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                closedElevation: 0,
                closedColor: Theme.of(context).colorScheme.primaryContainer,
                openBuilder: (context, action) => const _OpenContainerDetailPage(),
                closedBuilder: (context, action) => ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.open_in_new)),
                  title: const Text('点击展开'),
                  subtitle: const Text('OpenContainer 转场动画'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    action();
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'AnimatedList',
              child: ElevatedButton(
                onPressed: () => _showAnimatedListDemo(context),
                child: const Text('查看动画列表'),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: '显式动画控制器',
              child: Column(
                children: [
                  RotationTransition(
                    turns: Tween(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.sync, color: Colors.white, size: 40),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          _controller.forward();
                        },
                        child: const Text('开始'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          _controller.reverse();
                        },
                        child: const Text('反向'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          _controller.repeat();
                        },
                        child: const Text('循环'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          _controller.stop();
                        },
                        child: const Text('停止'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          _controller.reset();
                        },
                        child: const Text('重置'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
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
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  void _navigateWithAnimation(BuildContext context, SharedAxisTransitionType type, String title) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => _TransitionDemoPage(title: title),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: type,
            child: child,
          );
        },
      ),
    );
  }

  void _navigateWithFade(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const _TransitionDemoPage(title: '淡入淡出'),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _navigateWithSlide(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const _TransitionDemoPage(title: '滑动动画'),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
            child: child,
          );
        },
      ),
    );
  }

  void _showAnimatedListDemo(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.push(context, MaterialPageRoute(builder: (context) => const _AnimatedListDemoPage()));
  }

  Widget _buildAdvancedAnimationsSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  '高级动画演示',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildAnimationEntry(
              context,
              title: '加载动画',
              description: '各种加载效果：脉冲、旋转、波浪、骨架屏',
              icon: Icons.hourglass_empty,
              color: Colors.blue,
              screen: const LoadingAnimationsDemoScreen(),
            ),
            const SizedBox(height: 8),
            _buildAnimationEntry(
              context,
              title: '页面切换',
              description: 'Material Motion 规范转场动画',
              icon: Icons.swap_horiz,
              color: Colors.green,
              screen: const PageTransitionsDemoScreen(),
            ),
            const SizedBox(height: 8),
            _buildAnimationEntry(
              context,
              title: '烟花效果',
              description: '粒子烟花、彩纸庆祝效果',
              icon: Icons.celebration,
              color: Colors.orange,
              screen: const FireworksDemoScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimationEntry(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required Widget screen,
  }) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        },
      ),
    );
  }
}

class _HeroDetailPage extends StatelessWidget {
  final Color color;
  final String heroTag;

  const _HeroDetailPage({required this.color, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hero 详情')),
      body: Center(
        child: Hero(
          tag: heroTag,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(24)),
            child: const Icon(Icons.star, color: Colors.white, size: 80),
          ),
        ),
      ),
    );
  }
}

class _TransitionDemoPage extends StatelessWidget {
  final String title;

  const _TransitionDemoPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, size: 80, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            const Text('页面切换动画演示'),
          ],
        ),
      ),
    );
  }
}

class _OpenContainerDetailPage extends StatelessWidget {
  const _OpenContainerDetailPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('详情页面')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.open_in_new, size: 80),
            const SizedBox(height: 16),
            Text('OpenContainer 展开', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            const Text('这是使用 OpenContainer 打开的详情页'),
          ],
        ),
      ),
    );
  }
}

class _AnimatedListDemoPage extends StatefulWidget {
  const _AnimatedListDemoPage();

  @override
  State<_AnimatedListDemoPage> createState() => _AnimatedListDemoPageState();
}

class _AnimatedListDemoPageState extends State<_AnimatedListDemoPage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<String> _items = [];
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimatedList'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: _addItem)],
      ),
      body: AnimatedList(
        key: _listKey,
        padding: const EdgeInsets.all(16),
        initialItemCount: _items.length,
        itemBuilder: (context, index, animation) {
          return SlideTransition(
            position: animation.drive(Tween(begin: const Offset(1, 0), end: Offset.zero)),
            child: FadeTransition(
              opacity: animation,
              child: Card(
                child: ListTile(
                  title: Text(_items[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeItem(index),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: _addItem, child: const Icon(Icons.add)),
    );
  }

  void _addItem() {
    HapticFeedback.lightImpact();
    final index = _items.length;
    _counter++;
    _items.add('项目 $_counter');
    _listKey.currentState?.insertItem(index);
  }

  void _removeItem(int index) {
    HapticFeedback.mediumImpact();
    final removedItem = _items[index];
    _items.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => SlideTransition(
        position: animation.drive(Tween(begin: const Offset(-1, 0), end: Offset.zero)),
        child: FadeTransition(
          opacity: animation,
          child: Card(child: ListTile(title: Text(removedItem))),
        ),
      ),
    );
  }
}
