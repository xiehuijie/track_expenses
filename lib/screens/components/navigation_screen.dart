import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _bottomNavIndex = 0;
  int _railIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('导航组件'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection(
              title: 'AppBar 应用栏',
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _showAppBarDemo(context),
                    child: const Text('查看 AppBar 示例'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _showSliverAppBarDemo(context),
                    child: const Text('查看 SliverAppBar 示例'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'TabBar 标签栏',
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(icon: Icon(Icons.home), text: '首页'),
                      Tab(icon: Icon(Icons.explore), text: '发现'),
                      Tab(icon: Icon(Icons.person), text: '我的'),
                    ],
                    onTap: (_) => HapticFeedback.selectionClick(),
                  ),
                  SizedBox(
                    height: 120,
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        Center(child: Text('首页内容')),
                        Center(child: Text('发现内容')),
                        Center(child: Text('我的内容')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'BottomNavigationBar 底部导航',
              child: Column(
                children: [
                  const Text('传统样式:'),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BottomNavigationBar(
                      currentIndex: _bottomNavIndex,
                      onTap: (index) {
                        HapticFeedback.selectionClick();
                        setState(() => _bottomNavIndex = index);
                      },
                      items: const [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          label: '首页',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.search),
                          label: '搜索',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.notifications),
                          label: '通知',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.person),
                          label: '我的',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Material 3 NavigationBar:'),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: NavigationBar(
                      selectedIndex: _bottomNavIndex,
                      onDestinationSelected: (index) {
                        HapticFeedback.selectionClick();
                        setState(() => _bottomNavIndex = index);
                      },
                      destinations: const [
                        NavigationDestination(
                          icon: Icon(Icons.home_outlined),
                          selectedIcon: Icon(Icons.home),
                          label: '首页',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.search_outlined),
                          selectedIcon: Icon(Icons.search),
                          label: '搜索',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.notifications_outlined),
                          selectedIcon: Icon(Icons.notifications),
                          label: '通知',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.person_outline),
                          selectedIcon: Icon(Icons.person),
                          label: '我的',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'NavigationRail 侧边导航',
              child: SizedBox(
                height: 300,
                child: Row(
                  children: [
                    NavigationRail(
                      selectedIndex: _railIndex,
                      onDestinationSelected: (index) {
                        HapticFeedback.selectionClick();
                        setState(() => _railIndex = index);
                      },
                      labelType: NavigationRailLabelType.all,
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.home_outlined),
                          selectedIcon: Icon(Icons.home),
                          label: Text('首页'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.bookmark_outline),
                          selectedIcon: Icon(Icons.bookmark),
                          label: Text('收藏'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.settings_outlined),
                          selectedIcon: Icon(Icons.settings),
                          label: Text('设置'),
                        ),
                      ],
                    ),
                    const VerticalDivider(thickness: 1, width: 1),
                    Expanded(child: Center(child: Text('选中索引: $_railIndex'))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Drawer 抽屉导航',
              child: ElevatedButton(
                onPressed: () => _showDrawerDemo(context),
                child: const Text('查看 Drawer 示例'),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'NavigationDrawer (M3)',
              child: ElevatedButton(
                onPressed: () => _showNavigationDrawerDemo(context),
                child: const Text('查看 NavigationDrawer 示例'),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Stepper 步骤器',
              child: ElevatedButton(
                onPressed: () => _showStepperDemo(context),
                child: const Text('查看 Stepper 示例'),
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
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  void _showAppBarDemo(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('AppBar 示例'),
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => HapticFeedback.lightImpact(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => HapticFeedback.lightImpact(),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => HapticFeedback.lightImpact(),
              ),
            ],
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(48),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: SearchBar(
                  hintText: '搜索...',
                  leading: Icon(Icons.search),
                ),
              ),
            ),
          ),
          body: const Center(child: Text('带有搜索栏的 AppBar')),
        ),
      ),
    );
  }

  void _showSliverAppBarDemo(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text('SliverAppBar'),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.primaryContainer,
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.landscape,
                        size: 80,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => ListTile(title: Text('列表项 ${index + 1}')),
                  childCount: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDrawerDemo(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Drawer 示例')),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.person, size: 30),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '用户名',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'user@example.com',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('首页'),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('设置'),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('退出登录'),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          body: const Center(child: Text('从左边滑动或点击菜单按钮打开抽屉')),
        ),
      ),
    );
  }

  void _showNavigationDrawerDemo(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const _NavigationDrawerDemoPage(),
      ),
    );
  }

  void _showStepperDemo(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const _StepperDemoPage()),
    );
  }
}

class _NavigationDrawerDemoPage extends StatefulWidget {
  const _NavigationDrawerDemoPage();

  @override
  State<_NavigationDrawerDemoPage> createState() =>
      _NavigationDrawerDemoPageState();
}

class _NavigationDrawerDemoPageState extends State<_NavigationDrawerDemoPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NavigationDrawer 示例')),
      drawer: NavigationDrawer(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          HapticFeedback.selectionClick();
          setState(() => _selectedIndex = index);
          Navigator.pop(context);
        },
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text('邮件', style: Theme.of(context).textTheme.titleSmall),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.inbox_outlined),
            selectedIcon: Icon(Icons.inbox),
            label: Text('收件箱'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.send_outlined),
            selectedIcon: Icon(Icons.send),
            label: Text('已发送'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.drafts_outlined),
            selectedIcon: Icon(Icons.drafts),
            label: Text('草稿箱'),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text('标签', style: Theme.of(context).textTheme.titleSmall),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.label_outline),
            selectedIcon: Icon(Icons.label),
            label: Text('工作'),
          ),
          const NavigationDrawerDestination(
            icon: Icon(Icons.label_outline),
            selectedIcon: Icon(Icons.label),
            label: Text('个人'),
          ),
        ],
      ),
      body: Center(child: Text('选中索引: $_selectedIndex')),
    );
  }
}

class _StepperDemoPage extends StatefulWidget {
  const _StepperDemoPage();

  @override
  State<_StepperDemoPage> createState() => _StepperDemoPageState();
}

class _StepperDemoPageState extends State<_StepperDemoPage> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stepper 示例')),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          HapticFeedback.lightImpact();
          if (_currentStep < 2) {
            setState(() => _currentStep++);
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('完成所有步骤！')));
          }
        },
        onStepCancel: () {
          HapticFeedback.lightImpact();
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          }
        },
        onStepTapped: (index) {
          HapticFeedback.selectionClick();
          setState(() => _currentStep = index);
        },
        steps: [
          Step(
            title: const Text('账户信息'),
            subtitle: const Text('设置您的账户'),
            content: const TextField(
              decoration: InputDecoration(labelText: '用户名'),
            ),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('个人资料'),
            subtitle: const Text('完善您的资料'),
            content: const TextField(
              decoration: InputDecoration(labelText: '姓名'),
            ),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('确认'),
            subtitle: const Text('检查并提交'),
            content: const Text('请检查您填写的所有信息，确认无误后点击继续。'),
            isActive: _currentStep >= 2,
            state: _currentStep == 2 ? StepState.indexed : StepState.indexed,
          ),
        ],
      ),
    );
  }
}
