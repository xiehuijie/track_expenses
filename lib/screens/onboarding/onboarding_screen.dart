import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('引导教程'), backgroundColor: colorScheme.inversePrimary),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(context, colorScheme),
          const SizedBox(height: 24),
          _buildDemoCard(
            context,
            title: '功能引导演示',
            subtitle: '使用 Tutorial Coach Mark 创建功能引导',
            icon: Icons.tour,
            color: Colors.blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TutorialDemoScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _buildDemoCard(
            context,
            title: '首次使用引导',
            subtitle: '新用户首次打开应用的欢迎流程',
            icon: Icons.waving_hand,
            color: Colors.green,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WelcomeFlowScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _buildDemoCard(
            context,
            title: '功能提示演示',
            subtitle: 'Tooltip 和提示卡片',
            icon: Icons.info_outline,
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TooltipDemoScreen()),
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
            Icon(Icons.school, size: 64, color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              '引导与教程',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '帮助用户快速上手应用的各种引导方式',
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

// 功能引导演示页面
class TutorialDemoScreen extends StatefulWidget {
  const TutorialDemoScreen({super.key});

  @override
  State<TutorialDemoScreen> createState() => _TutorialDemoScreenState();
}

class _TutorialDemoScreenState extends State<TutorialDemoScreen> {
  late TutorialCoachMark _tutorialCoachMark;

  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _filterKey = GlobalKey();
  final GlobalKey _addKey = GlobalKey();
  final GlobalKey _menuKey = GlobalKey();
  final GlobalKey _listKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _createTutorial();
    });
  }

  void _createTutorial() {
    _tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Theme.of(context).colorScheme.primary,
      textSkip: '跳过',
      paddingFocus: 10,
      opacityShadow: 0.8,
      pulseEnable: true,
      onFinish: () {
        _showSnackbar('教程完成！');
      },
      onSkip: () {
        _showSnackbar('已跳过教程');
        return true;
      },
    );
  }

  List<TargetFocus> _createTargets() {
    return [
      TargetFocus(
        identify: 'search',
        keyTarget: _searchKey,
        alignSkip: Alignment.bottomRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return _buildTargetContent(
                title: '搜索功能',
                description: '点击这里可以搜索您需要的内容，支持关键词搜索。',
                onNext: () => controller.next(),
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: 'filter',
        keyTarget: _filterKey,
        alignSkip: Alignment.bottomRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return _buildTargetContent(
                title: '筛选功能',
                description: '使用筛选器可以快速过滤数据，让您更高效地找到目标。',
                onNext: () => controller.next(),
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: 'add',
        keyTarget: _addKey,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocus.Circle,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return _buildTargetContent(
                title: '添加新项目',
                description: '点击此按钮可以快速添加新的项目或记录。',
                onNext: () => controller.next(),
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: 'menu',
        keyTarget: _menuKey,
        alignSkip: Alignment.bottomRight,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return _buildTargetContent(
                title: '更多选项',
                description: '这里有更多功能选项，包括设置、帮助和关于我们。',
                onNext: () => controller.next(),
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: 'list',
        keyTarget: _listKey,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocus.RRect,
        radius: 16,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return _buildTargetContent(
                title: '数据列表',
                description: '这里显示所有数据，您可以点击查看详情或左滑删除。',
                isLast: true,
                onNext: () => controller.next(),
              );
            },
          ),
        ],
      ),
    ];
  }

  Widget _buildTargetContent({
    required String title,
    required String description,
    bool isLast = false,
    required VoidCallback onNext,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(description, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onNext,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(isLast ? '完成' : '下一步'),
          ),
        ],
      ),
    );
  }

  void _showTutorial() {
    HapticFeedback.mediumImpact();
    _tutorialCoachMark.show(context: context);
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('功能引导'),
        backgroundColor: colorScheme.inversePrimary,
        actions: [
          IconButton(
            key: _searchKey,
            icon: const Icon(Icons.search),
            onPressed: () => _showSnackbar('搜索功能'),
          ),
          IconButton(
            key: _filterKey,
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showSnackbar('筛选功能'),
          ),
          PopupMenuButton(
            key: _menuKey,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 1, child: Text('设置')),
              const PopupMenuItem(value: 2, child: Text('帮助')),
              const PopupMenuItem(value: 3, child: Text('关于')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.tour, size: 48, color: colorScheme.primary),
                    const SizedBox(height: 12),
                    Text(
                      'Tutorial Coach Mark',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '点击下方按钮开始功能引导演示',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _showTutorial,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('开始引导'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            key: _listKey,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: colorScheme.primaryContainer,
                      child: Text('${index + 1}'),
                    ),
                    title: Text('示例项目 ${index + 1}'),
                    subtitle: const Text('点击查看详情'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: _addKey,
        onPressed: () => _showSnackbar('添加新项目'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// 欢迎流程页面
class WelcomeFlowScreen extends StatefulWidget {
  const WelcomeFlowScreen({super.key});

  @override
  State<WelcomeFlowScreen> createState() => _WelcomeFlowScreenState();
}

class _WelcomeFlowScreenState extends State<WelcomeFlowScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_WelcomePageData> _pages = [
    _WelcomePageData(
      icon: Icons.waving_hand,
      title: '欢迎使用',
      description: '感谢您选择我们的应用，让我们一起探索强大的功能。',
      color: Colors.blue,
    ),
    _WelcomePageData(
      icon: Icons.speed,
      title: '快速高效',
      description: '简洁的界面设计，让您的操作更加快捷流畅。',
      color: Colors.green,
    ),
    _WelcomePageData(
      icon: Icons.security,
      title: '安全可靠',
      description: '您的数据安全是我们的首要任务，采用最先进的加密技术。',
      color: Colors.orange,
    ),
    _WelcomePageData(
      icon: Icons.rocket_launch,
      title: '开始使用',
      description: '一切准备就绪，现在就开始您的精彩旅程吧！',
      color: Colors.purple,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    HapticFeedback.lightImpact();
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('欢迎流程完成！'), behavior: SnackBarBehavior.floating));
    }
  }

  void _skip() {
    HapticFeedback.lightImpact();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 跳过按钮
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(onPressed: _skip, child: const Text('跳过')),
              ),
            ),
            // 页面内容
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _buildPage(page);
                },
              ),
            ),
            // 指示器
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (index) {
                  final isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive ? colorScheme.primary : colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
            // 按钮
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _nextPage,
                  child: Text(_currentPage == _pages.length - 1 ? '开始使用' : '下一步'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_WelcomePageData page) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(color: page.color.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(page.icon, size: 80, color: page.color),
          ),
          const SizedBox(height: 48),
          Text(
            page.title,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            page.description,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _WelcomePageData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  _WelcomePageData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

// Tooltip 演示页面
class TooltipDemoScreen extends StatelessWidget {
  const TooltipDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('功能提示'), backgroundColor: colorScheme.inversePrimary),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 基础 Tooltip
            _buildSection(
              context,
              title: '基础 Tooltip',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Tooltip(
                    message: '这是一个保存按钮',
                    child: IconButton(icon: const Icon(Icons.save), onPressed: () {}),
                  ),
                  Tooltip(
                    message: '编辑当前内容',
                    child: IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
                  ),
                  Tooltip(
                    message: '删除选中项',
                    child: IconButton(icon: const Icon(Icons.delete), onPressed: () {}),
                  ),
                  Tooltip(
                    message: '分享到其他应用',
                    child: IconButton(icon: const Icon(Icons.share), onPressed: () {}),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // 自定义样式 Tooltip
            _buildSection(
              context,
              title: '自定义样式 Tooltip',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Tooltip(
                    message: '自定义背景色',
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(color: Colors.white),
                    child: const Chip(label: Text('蓝色')),
                  ),
                  Tooltip(
                    message: '绿色提示',
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(color: Colors.white),
                    child: const Chip(label: Text('绿色')),
                  ),
                  Tooltip(
                    message: '橙色提示',
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(color: Colors.white),
                    child: const Chip(label: Text('橙色')),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // 提示卡片
            _buildSection(
              context,
              title: '提示卡片',
              child: Column(
                children: [
                  _buildTipCard(
                    context,
                    icon: Icons.lightbulb,
                    title: '小技巧',
                    description: '长按任意项目可以查看更多操作选项。',
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 12),
                  _buildTipCard(
                    context,
                    icon: Icons.info,
                    title: '提示',
                    description: '双击可以快速编辑内容。',
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildTipCard(
                    context,
                    icon: Icons.warning,
                    title: '注意',
                    description: '删除操作不可撤销，请谨慎操作。',
                    color: Colors.orange,
                    isDismissible: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // 引导式提示
            _buildSection(
              context,
              title: '步骤提示',
              child: Column(
                children: [
                  _buildStepTip(context, 1, '创建账户', '首先注册一个新账户', true),
                  _buildStepTip(context, 2, '完善信息', '填写您的基本信息', true),
                  _buildStepTip(context, 3, '开始使用', '探索各种功能', false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required Widget child}) {
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

  Widget _buildTipCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    bool isDismissible = false,
  }) {
    final card = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
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
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: color),
                ),
                const SizedBox(height: 2),
                Text(description, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          if (isDismissible)
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () {},
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );

    return card;
  }

  Widget _buildStepTip(
    BuildContext context,
    int step,
    String title,
    String description,
    bool isCompleted,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green : colorScheme.outlineVariant,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : Text(
                      '$step',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted ? colorScheme.onSurfaceVariant : colorScheme.onSurface,
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
