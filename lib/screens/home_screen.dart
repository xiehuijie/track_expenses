import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/theme_provider.dart';
import 'animations/animations_screen.dart';
import 'business/money_input_screen.dart';
import 'components/buttons_screen.dart';
import 'components/cards_lists_screen.dart';
import 'components/dialogs_screen.dart';
import 'components/inputs_screen.dart';
import 'components/navigation_screen.dart';
import 'components/selections_screen.dart';
import 'hardware/hardware_screen.dart';
import 'storage/storage_screen.dart';
import 'system/system_screen.dart';
import 'tools/calendar_screen.dart';
import 'tools/charts_screen.dart';
import 'tools/effects_screen.dart';
import 'tools/notifications_screen.dart';
import 'tools/progress_screen.dart';
import 'tools/qr_code_screen.dart';
import 'tools/tutorial_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final Function(AppThemeColor) onChangeThemeColor;
  final Function(Locale) onChangeLocale;
  final AppThemeColor currentThemeColor;
  final Locale currentLocale;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.onChangeThemeColor,
    required this.onChangeLocale,
    required this.currentThemeColor,
    required this.currentLocale,
  });

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
        _DemoItem(
          title: '特效动画',
          subtitle: '烟花、粒子、Lottie动画',
          icon: Icons.auto_awesome,
          screen: const EffectsScreen(),
        ),
      ],
    ),
    _CategoryItem(
      title: '工具组件',
      icon: Icons.build,
      items: [
        _DemoItem(
          title: '图表',
          subtitle: '折线图、柱状图、饼图',
          icon: Icons.bar_chart,
          screen: const ChartsScreen(),
        ),
        _DemoItem(
          title: '日历',
          subtitle: '日历选择、事件管理',
          icon: Icons.calendar_month,
          screen: const CalendarScreen(),
        ),
        _DemoItem(
          title: '二维码',
          subtitle: '生成二维码、自定义样式',
          icon: Icons.qr_code,
          screen: const QRCodeScreen(),
        ),
        _DemoItem(
          title: '进度指示器',
          subtitle: '线性、圆形、步骤进度条',
          icon: Icons.trending_up,
          screen: const ProgressScreen(),
        ),
        _DemoItem(
          title: '通知',
          subtitle: '本地通知、定时通知',
          icon: Icons.notifications_active,
          screen: const NotificationsScreen(),
        ),
        _DemoItem(
          title: '引导教程',
          subtitle: 'Intro.js风格的功能引导',
          icon: Icons.help_outline,
          screen: const TutorialScreen(),
        ),
      ],
    ),
    _CategoryItem(
      title: '业务组件',
      icon: Icons.business_center,
      items: [
        _DemoItem(
          title: '金额输入',
          subtitle: '数字键盘、金额格式化',
          icon: Icons.attach_money,
          screen: const MoneyInputScreen(),
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
            icon: Icon(
              theme.brightness == Brightness.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              widget.onToggleTheme();
            },
            tooltip: '切换主题',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              HapticFeedback.lightImpact();
              _showSettingsDialog();
            },
            tooltip: '设置',
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
          return NavigationDestination(
            icon: Icon(category.icon),
            label: category.title,
          );
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
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        closedElevation: 2,
        closedBuilder: (context, openContainer) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                item.icon,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            title: Text(
              item.title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
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

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('设置'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              const Text(
                '主题颜色',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppThemeProvider.getAllThemeColors().map((
                  themeColor,
                ) {
                  final isSelected = widget.currentThemeColor == themeColor;
                  return InkWell(
                    onTap: () {
                      widget.onChangeThemeColor(themeColor);
                      HapticFeedback.selectionClick();
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: themeColor.color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: themeColor.color.withOpacity(0.5),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              const Text(
                '语言',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              RadioListTile<String>(
                title: const Text('中文'),
                value: 'zh',
                groupValue: widget.currentLocale.languageCode,
                onChanged: (value) {
                  widget.onChangeLocale(const Locale('zh', 'CN'));
                  HapticFeedback.selectionClick();
                },
              ),
              RadioListTile<String>(
                title: const Text('English'),
                value: 'en',
                groupValue: widget.currentLocale.languageCode,
                onChanged: (value) {
                  widget.onChangeLocale(const Locale('en', 'US'));
                  HapticFeedback.selectionClick();
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
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
