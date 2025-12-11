import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app/theme.dart';
import '../l10n/generated/app_localizations.dart';
import 'animations/animations_screen.dart';
import 'animations/container_transform_demo.dart';
import 'animations/shared_axis_demo.dart';
import 'business/business_components_screen.dart';
import 'business/category_selector_demo.dart';
import 'business/currency_picker_demo.dart';
import 'business/emoji_icon_picker_demo.dart';
import 'components/buttons_screen.dart';
import 'components/cards_lists_screen.dart';
import 'components/dialogs_screen.dart';
import 'components/forms_screen.dart';
import 'components/info_display_screen.dart';
import 'components/inputs_screen.dart';
import 'components/layouts_screen.dart';
import 'components/navigation_screen.dart';
import 'components/selections_screen.dart';
import 'hardware/hardware_screen.dart';
import 'notifications/notifications_screen.dart';
import 'onboarding/onboarding_screen.dart';
import 'storage/storage_screen.dart';
import 'system/map_location_demo.dart';
import 'system/system_screen.dart';
import 'utilities/utility_components_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final void Function(ThemeMode)? onSetThemeMode;
  final void Function(ThemeColor)? onSetThemeColor;
  final void Function(Locale?)? onSetLocale;
  final ThemeMode? currentThemeMode;
  final ThemeColor? currentThemeColor;
  final Locale? currentLocale;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    this.onSetThemeMode,
    this.onSetThemeColor,
    this.onSetLocale,
    this.currentThemeMode,
    this.currentThemeColor,
    this.currentLocale,
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
        _DemoItem(
          title: '表单组件',
          subtitle: '表单验证、输入框、下拉菜单、评分',
          icon: Icons.article,
          screen: const FormsScreen(),
        ),
        _DemoItem(
          title: '信息展示',
          subtitle: 'Badge、Chip、Divider、进度指示器',
          icon: Icons.info,
          screen: const InfoDisplayScreen(),
        ),
        _DemoItem(
          title: '布局组件',
          subtitle: 'Stack、Wrap、GridView、Flexible',
          icon: Icons.view_quilt,
          screen: const LayoutsScreen(),
        ),
      ],
    ),
    _CategoryItem(
      title: '动画与效果',
      icon: Icons.animation,
      items: [
        _DemoItem(
          title: '动画效果',
          subtitle: '页面切换、Hero、隐式/显式动画',
          icon: Icons.motion_photos_on,
          screen: const AnimationsScreen(),
        ),
        _DemoItem(
          title: '容器变换动画',
          subtitle: 'OpenContainer、淡入淡出、卡片过渡',
          icon: Icons.flip_to_front,
          screen: const ContainerTransformDemo(),
        ),
        _DemoItem(
          title: '共享轴动画',
          subtitle: '水平、垂直、缩放过渡动画',
          icon: Icons.swap_horiz,
          screen: const SharedAxisDemo(),
        ),
        _DemoItem(
          title: '可视化组件',
          subtitle: '图表、日历、热力图、进度条、粒子效果',
          icon: Icons.auto_graph,
          screen: const UtilityComponentsScreen(),
        ),
      ],
    ),
    _CategoryItem(
      title: '系统能力',
      icon: Icons.settings_applications,
      items: [
        _DemoItem(
          title: '数据存储',
          subtitle: 'SharedPreferences, SQLite, 文件操作',
          icon: Icons.save,
          screen: const StorageScreen(),
        ),
        _DemoItem(
          title: '硬件功能',
          subtitle: '摄像头、生物识别、传感器',
          icon: Icons.camera_alt,
          screen: const HardwareScreen(),
        ),
        _DemoItem(
          title: '系统功能',
          subtitle: '文件选择、分享、URL启动',
          icon: Icons.share,
          screen: const SystemScreen(),
        ),
        _DemoItem(
          title: '地图定位',
          subtitle: '位置选择、坐标查看、系统地图',
          icon: Icons.map,
          screen: const MapLocationDemo(),
        ),
        _DemoItem(
          title: '通知推送',
          subtitle: '本地通知、定时通知、通知渠道',
          icon: Icons.notifications_active,
          screen: const NotificationsScreen(),
        ),
        _DemoItem(
          title: '引导教程',
          subtitle: '功能引导、欢迎流程、功能提示',
          icon: Icons.tour,
          screen: const OnboardingScreen(),
        ),
      ],
    ),
    _CategoryItem(
      title: '业务能力',
      icon: Icons.business_center,
      items: [
        _DemoItem(
          title: '支付组件',
          subtitle: '支付方式选择、订单信息展示',
          icon: Icons.payment,
          screen: const BusinessComponentsScreen(),
        ),
        _DemoItem(
          title: '类别选择',
          subtitle: '收支分类、图标选择、颜色标识',
          icon: Icons.category,
          screen: const CategorySelectorDemo(),
        ),
        _DemoItem(
          title: '货币选择',
          subtitle: '多国货币、汇率符号、国旗显示',
          icon: Icons.money,
          screen: const CurrencyPickerDemo(),
        ),
        _DemoItem(
          title: 'Emoji & 图标',
          subtitle: '表情选择、Material 图标库',
          icon: Icons.emoji_emotions,
          screen: const EmojiIconPickerDemo(),
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
        backgroundColor: colorScheme.surfaceContainer,
        foregroundColor: colorScheme.onSurface,
        actions: [
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            onPressed: () => _showThemeSettings(context),
            tooltip: '主题设置',
          ),
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
      backgroundColor: colorScheme.surface,
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
    final colorScheme = Theme.of(context).colorScheme;

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
      child: Container(
        key: ValueKey(_selectedIndex),
        color: colorScheme.surface,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: category.items.length,
          itemBuilder: (context, index) {
            final item = category.items[index];
            return _buildDemoCard(item);
          },
        ),
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
        closedElevation: 0,
        closedColor: Theme.of(context).colorScheme.surface,
        closedBuilder: (context, openContainer) {
          final colorScheme = Theme.of(context).colorScheme;
          return Card(
            elevation: 0,
            color: colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: colorScheme.primaryContainer,
                child: Icon(item.icon, color: colorScheme.onPrimaryContainer),
              ),
              title: Text(
                item.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              subtitle: Text(item.subtitle, style: TextStyle(color: colorScheme.onSurfaceVariant)),
              trailing: Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
              onTap: () {
                HapticFeedback.lightImpact();
                openContainer();
              },
            ),
          );
        },
      ),
    );
  }

  void _showThemeSettings(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题
                  Center(
                    child: Container(
                      width: 32,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    l10n.themeSettings,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  // 语言
                  Text(
                    l10n.language,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  _buildLanguageSelector(context, l10n),
                  const SizedBox(height: 24),

                  // 主题模式
                  Text(
                    l10n.themeMode,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  _buildThemeModeSelector(context, l10n),
                  const SizedBox(height: 24),

                  // 主题颜色
                  Text(
                    l10n.themeColor,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  _buildThemeColorSelector(context),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLanguageSelector(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentLocale = widget.currentLocale;

    return Row(
      children: [
        _buildModeOption(
          context: context,
          icon: Icons.translate,
          label: l10n.followSystem,
          isSelected: currentLocale == null,
          onTap: () {
            widget.onSetLocale?.call(null);
            Navigator.pop(context);
          },
          colorScheme: colorScheme,
        ),
        const SizedBox(width: 12),
        _buildModeOption(
          context: context,
          icon: Icons.language,
          label: l10n.chinese,
          isSelected: currentLocale?.languageCode == 'zh',
          onTap: () {
            widget.onSetLocale?.call(const Locale('zh'));
            Navigator.pop(context);
          },
          colorScheme: colorScheme,
        ),
        const SizedBox(width: 12),
        _buildModeOption(
          context: context,
          icon: Icons.language,
          label: l10n.english,
          isSelected: currentLocale?.languageCode == 'en',
          onTap: () {
            widget.onSetLocale?.call(const Locale('en'));
            Navigator.pop(context);
          },
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  Widget _buildThemeModeSelector(BuildContext context, AppLocalizations l10n) {
    final currentMode = widget.currentThemeMode ?? ThemeMode.system;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        _buildModeOption(
          context: context,
          icon: Icons.brightness_auto,
          label: l10n.followSystem,
          isSelected: currentMode == ThemeMode.system,
          onTap: () {
            widget.onSetThemeMode?.call(ThemeMode.system);
            Navigator.pop(context);
          },
          colorScheme: colorScheme,
        ),
        const SizedBox(width: 12),
        _buildModeOption(
          context: context,
          icon: Icons.light_mode,
          label: l10n.lightMode,
          isSelected: currentMode == ThemeMode.light,
          onTap: () {
            widget.onSetThemeMode?.call(ThemeMode.light);
            Navigator.pop(context);
          },
          colorScheme: colorScheme,
        ),
        const SizedBox(width: 12),
        _buildModeOption(
          context: context,
          icon: Icons.dark_mode,
          label: l10n.darkMode,
          isSelected: currentMode == ThemeMode.dark,
          onTap: () {
            widget.onSetThemeMode?.call(ThemeMode.dark);
            Navigator.pop(context);
          },
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  Widget _buildModeOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primaryContainer : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: isSelected ? Border.all(color: colorScheme.primary, width: 2) : null,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeColorSelector(BuildContext context) {
    final currentColor = widget.currentThemeColor ?? ThemeColor.purple;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: ThemeColor.values.map((color) {
        final isSelected = color == currentColor;
        return InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onSetThemeColor?.call(color);
            Navigator.pop(context);
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.color,
              borderRadius: BorderRadius.circular(16),
              border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.color.withValues(alpha: 0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isSelected) const Icon(Icons.check, color: Colors.white, size: 28),
                Text(
                  color.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
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
