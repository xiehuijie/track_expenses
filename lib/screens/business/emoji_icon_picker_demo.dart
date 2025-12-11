import 'package:flutter/material.dart';

/// Emoji 和图标选择器演示
class EmojiIconPickerDemo extends StatefulWidget {
  const EmojiIconPickerDemo({super.key});

  @override
  State<EmojiIconPickerDemo> createState() => _EmojiIconPickerDemoState();
}

class _EmojiIconPickerDemoState extends State<EmojiIconPickerDemo>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedEmoji;
  IconData? _selectedIcon;

  final List<EmojiCategory> _emojiCategories = [
    EmojiCategory(
      name: '表情',
      emojis: ['😀', '😃', '😄', '😁', '😆', '😅', '🤣', '😂', '🙂', '🙃', '😉', '😊', '😇', '🥰', '😍', '🤩'],
    ),
    EmojiCategory(
      name: '手势',
      emojis: ['👍', '👎', '👌', '✌️', '🤞', '🤟', '🤘', '🤙', '👈', '👉', '👆', '👇', '☝️', '✋', '🤚', '🖐'],
    ),
    EmojiCategory(
      name: '食物',
      emojis: ['🍎', '🍊', '🍋', '🍌', '🍉', '🍇', '🍓', '🫐', '🍈', '🍒', '🍑', '🥭', '🍍', '🥥', '🥝', '🍅'],
    ),
    EmojiCategory(
      name: '动物',
      emojis: ['🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼', '🐨', '🐯', '🦁', '🐮', '🐷', '🐸', '🐵', '🐔'],
    ),
    EmojiCategory(
      name: '活动',
      emojis: ['⚽', '🏀', '🏈', '⚾', '🥎', '🎾', '🏐', '🏉', '🥏', '🎱', '🪀', '🏓', '🏸', '🏒', '🏑', '🥍'],
    ),
    EmojiCategory(
      name: '旅行',
      emojis: ['🚗', '🚕', '🚙', '🚌', '🚎', '🏎', '🚓', '🚑', '🚒', '🚐', '🛻', '🚚', '🚛', '🚜', '🏍', '🛵'],
    ),
  ];

  final List<IconCategory> _iconCategories = [
    IconCategory(
      name: '通用',
      icons: [
        Icons.home, Icons.favorite, Icons.star, Icons.bookmark,
        Icons.settings, Icons.search, Icons.notifications, Icons.mail,
        Icons.person, Icons.group, Icons.phone, Icons.email,
      ],
    ),
    IconCategory(
      name: '媒体',
      icons: [
        Icons.play_arrow, Icons.pause, Icons.stop, Icons.skip_next,
        Icons.skip_previous, Icons.volume_up, Icons.volume_down, Icons.volume_off,
        Icons.mic, Icons.camera, Icons.photo, Icons.video_call,
      ],
    ),
    IconCategory(
      name: '文件',
      icons: [
        Icons.folder, Icons.insert_drive_file, Icons.description, Icons.picture_as_pdf,
        Icons.image, Icons.audio_file, Icons.video_file, Icons.attachment,
        Icons.cloud, Icons.cloud_upload, Icons.cloud_download, Icons.save,
      ],
    ),
    IconCategory(
      name: '交互',
      icons: [
        Icons.add, Icons.remove, Icons.edit, Icons.delete,
        Icons.check, Icons.close, Icons.arrow_back, Icons.arrow_forward,
        Icons.refresh, Icons.sync, Icons.download, Icons.upload,
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emoji & 图标选择'),
        backgroundColor: colorScheme.surfaceContainer,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Emoji', icon: Icon(Icons.emoji_emotions)),
            Tab(text: '图标', icon: Icon(Icons.apps)),
          ],
        ),
      ),
      body: Column(
        children: [
          // 选中显示区域
          Container(
            padding: const EdgeInsets.all(24),
            color: colorScheme.primaryContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_tabController.index == 0 && _selectedEmoji != null) ...[
                  Text(
                    _selectedEmoji!,
                    style: const TextStyle(fontSize: 64),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '已选择 Emoji',
                        style: TextStyle(
                          color: colorScheme.onPrimaryContainer.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        _selectedEmoji!,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ] else if (_tabController.index == 1 && _selectedIcon != null) ...[
                  Icon(
                    _selectedIcon,
                    size: 64,
                    color: colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '已选择图标',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ] else ...[
                  Icon(
                    Icons.touch_app,
                    size: 48,
                    color: colorScheme.onPrimaryContainer.withOpacity(0.5),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '请选择一个',
                    style: TextStyle(
                      fontSize: 18,
                      color: colorScheme.onPrimaryContainer.withOpacity(0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // 内容区域
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEmojiGrid(),
                _buildIconGrid(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiGrid() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _emojiCategories.length,
      itemBuilder: (context, index) {
        final category = _emojiCategories[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                category.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                childAspectRatio: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: category.emojis.length,
              itemBuilder: (context, emojiIndex) {
                final emoji = category.emojis[emojiIndex];
                final isSelected = _selectedEmoji == emoji;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedEmoji = emoji;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            )
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildIconGrid() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _iconCategories.length,
      itemBuilder: (context, index) {
        final category = _iconCategories[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                category.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: category.icons.length,
              itemBuilder: (context, iconIndex) {
                final icon = category.icons[iconIndex];
                final isSelected = _selectedIcon == icon;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIcon = icon;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            )
                          : null,
                    ),
                    child: Icon(
                      icon,
                      size: 32,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

class EmojiCategory {
  final String name;
  final List<String> emojis;

  EmojiCategory({required this.name, required this.emojis});
}

class IconCategory {
  final String name;
  final List<IconData> icons;

  IconCategory({required this.name, required this.icons});
}
