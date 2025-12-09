import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'animations/animations_screen.dart';
import 'components/buttons_screen.dart';
import 'components/cards_lists_screen.dart';
import 'components/dialogs_screen.dart';
import 'components/inputs_screen.dart';
import 'components/navigation_screen.dart';
import 'components/selections_screen.dart';
import 'hardware/hardware_screen.dart';
import 'storage/storage_screen.dart';
import 'system/system_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const HomeScreen({super.key, required this.onToggleTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<_CategoryItem> _categories = [
    _CategoryItem(
      title: 'Material 组件',
      icon: Icons.widgets_outlined,
      items: [
        _DemoItem(
          title: '按钮',
          subtitle: 'ElevatedButton, FilledButton, TextButton 等',
          icon: Icons.smart_button,
          screen: const ButtonsScreen(),
        ),
        _DemoItem(
          title: '输入框',
          subtitle: 'TextField, TextFormField, 搜索栏',
          icon: Icons.edit,
          screen: const InputsScreen(),
        ),
        _DemoItem(
          title: '选择控件',
          subtitle: 'Switch, Checkbox, Radio, Slider, Chips',
          icon: Icons.check_box,
          screen: const SelectionsScreen(),
        ),
        _DemoItem(
          title: '对话框与提示',
          subtitle: 'Dialog, BottomSheet, Snackbar, Toast',
          icon: Icons.chat_bubble_outline,
          screen: const DialogsScreen(),
        ),
        _DemoItem(
          title: '导航组件',
          subtitle: 'AppBar, Drawer, TabBar, BottomNav',
          icon: Icons.menu,
          screen: const NavigationScreen(),
        ),
        _DemoItem(
          title: '卡片与列表',
          subtitle: 'Card, ListTile, ExpansionTile, GridView',
          icon: Icons.view_list,
          screen: const CardsListsScreen(),
        ),
      ],
    ),
    _CategoryItem(
      title: '动画与布局',
      icon: Icons.animation,
      items: [
        _DemoItem(
          title: '动画效果',
          subtitle: '页面切换、Hero、隐式/显式动画',
          icon: Icons.motion_photos_on,
          screen: const AnimationsScreen(),
        ),
      ],
    ),
    _CategoryItem(
      title: '数据存储',
      icon: Icons.storage,
      items: [
        _DemoItem(
          title: '存储能力',
          subtitle: 'SharedPreferences, SQLite, 文件操作',
          icon: Icons.save,
          screen: const StorageScreen(),
        ),
      ],
    ),
    _CategoryItem(
      title: '硬件调用',
      icon: Icons.devices,
      items: [
        _DemoItem(
          title: '硬件功能',
          subtitle: '摄像头、生物识别、传感器',
          icon: Icons.camera_alt,
          screen: const HardwareScreen(),
        ),
      ],
    ),
    _CategoryItem(
      title: '系统调用',
      icon: Icons.settings_applications,
      items: [
        _DemoItem(
          title: '系统功能',
          subtitle: '文件选择、分享、URL启动',
          icon: Icons.share,
          screen: const SystemScreen(),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Material Design Showcase'),
        backgroundColor: colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(theme.brightness == Brightness.light ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              HapticFeedback.lightImpact();
              widget.onToggleTheme();
            },
            tooltip: '切换主题',
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          HapticFeedback.selectionClick();
          setState(() => _selectedIndex = index);
        },
        destinations: _categories.map((category) {
          return NavigationDestination(icon: Icon(category.icon), label: category.title);
        }).toList(),
      ),
    );
  }

  Widget _buildBody() {
    final category = _categories[_selectedIndex];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: ListView.builder(
        key: ValueKey(_selectedIndex),
        padding: const EdgeInsets.all(16),
        itemCount: category.items.length,
        itemBuilder: (context, index) {
          final item = category.items[index];
          return _buildDemoCard(item);
        },
      ),
    );
  }

  Widget _buildDemoCard(_DemoItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: OpenContainer(
        transitionType: ContainerTransitionType.fadeThrough,
        transitionDuration: const Duration(milliseconds: 400),
        openBuilder: (context, _) => item.screen,
        closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        closedElevation: 2,
        closedBuilder: (context, openContainer) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(item.icon, color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
            title: Text(
              item.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(item.subtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              HapticFeedback.lightImpact();
              openContainer();
            },
          );
        },
      ),
    );
  }
}

class _CategoryItem {
  final String title;
  final IconData icon;
  final List<_DemoItem> items;

  _CategoryItem({required this.title, required this.icon, required this.items});
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
