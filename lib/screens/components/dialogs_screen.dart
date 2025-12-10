import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogsScreen extends StatelessWidget {
  const DialogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('对话框与提示'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection(
              context: context,
              title: 'AlertDialog 警告对话框',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () => _showBasicDialog(context),
                    child: const Text('基础对话框'),
                  ),
                  ElevatedButton(
                    onPressed: () => _showConfirmDialog(context),
                    child: const Text('确认对话框'),
                  ),
                  ElevatedButton(
                    onPressed: () => _showCustomDialog(context),
                    child: const Text('自定义对话框'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context: context,
              title: 'SimpleDialog 简单对话框',
              child: ElevatedButton(
                onPressed: () => _showSimpleDialog(context),
                child: const Text('选择选项'),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context: context,
              title: 'BottomSheet 底部弹出',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () => _showModalBottomSheet(context),
                    child: const Text('模态底部弹出'),
                  ),
                  ElevatedButton(
                    onPressed: () => _showScrollableBottomSheet(context),
                    child: const Text('可滚动底部弹出'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context: context,
              title: 'SnackBar 提示条',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () => _showBasicSnackBar(context),
                    child: const Text('基础提示'),
                  ),
                  ElevatedButton(
                    onPressed: () => _showActionSnackBar(context),
                    child: const Text('带操作提示'),
                  ),
                  ElevatedButton(
                    onPressed: () => _showFloatingSnackBar(context),
                    child: const Text('浮动提示'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context: context,
              title: 'Banner 横幅',
              child: ElevatedButton(
                onPressed: () => _showMaterialBanner(context),
                child: const Text('显示横幅'),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context: context,
              title: 'Tooltip 工具提示',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  const Tooltip(message: '这是一个基础工具提示', child: Icon(Icons.info_outline)),
                  Tooltip(
                    richMessage: TextSpan(
                      children: [
                        const TextSpan(text: '这是一个 '),
                        TextSpan(
                          text: '富文本',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const TextSpan(text: ' 工具提示'),
                      ],
                    ),
                    child: const Icon(Icons.text_format),
                  ),
                  Tooltip(
                    message: '长按或悬停查看',
                    waitDuration: const Duration(milliseconds: 500),
                    showDuration: const Duration(seconds: 2),
                    child: ElevatedButton(onPressed: () {}, child: const Text('带 Tooltip')),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context: context,
              title: 'PopupMenu 弹出菜单',
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      HapticFeedback.selectionClick();
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('选择了: $value')));
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: '编辑',
                        child: ListTile(leading: Icon(Icons.edit), title: Text('编辑')),
                      ),
                      const PopupMenuItem(
                        value: '分享',
                        child: ListTile(leading: Icon(Icons.share), title: Text('分享')),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: '删除',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text('删除', style: TextStyle(color: Colors.red)),
                        ),
                      ),
                    ],
                    child: const ListTile(title: Text('点击显示菜单'), trailing: Icon(Icons.more_vert)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context: context,
              title: 'ExpansionPanel 展开面板',
              child: const _ExpansionPanelDemo(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required Widget child,
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
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  void _showBasicDialog(BuildContext context) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('基础对话框'),
        content: const Text('这是一个简单的警告对话框示例。'),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog(BuildContext context) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded, size: 48),
        title: const Text('确认删除？'),
        content: const Text('此操作无法撤销，确定要删除吗？'),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              HapticFeedback.heavyImpact();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已删除')));
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  void _showCustomDialog(BuildContext context) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(Icons.check, size: 40, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 16),
              Text(
                '操作成功！',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '您的操作已成功完成',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  },
                  child: const Text('完成'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSimpleDialog(BuildContext context) async {
    HapticFeedback.mediumImpact();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('选择一个选项'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              HapticFeedback.selectionClick();
              Navigator.pop(context, '选项 1');
            },
            child: const ListTile(leading: Icon(Icons.looks_one), title: Text('选项 1')),
          ),
          SimpleDialogOption(
            onPressed: () {
              HapticFeedback.selectionClick();
              Navigator.pop(context, '选项 2');
            },
            child: const ListTile(leading: Icon(Icons.looks_two), title: Text('选项 2')),
          ),
          SimpleDialogOption(
            onPressed: () {
              HapticFeedback.selectionClick();
              Navigator.pop(context, '选项 3');
            },
            child: const ListTile(leading: Icon(Icons.looks_3), title: Text('选项 3')),
          ),
        ],
      ),
    );
    if (result != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('您选择了: $result')));
    }
  }

  void _showModalBottomSheet(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text('模态底部弹出', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('分享'),
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('复制链接'),
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('编辑'),
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showScrollableBottomSheet(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.25,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: 30,
                itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text('项目 ${index + 1}'),
                  subtitle: const Text('点击选择此项'),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBasicSnackBar(BuildContext context) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('这是一个基础提示'), duration: Duration(seconds: 2)));
  }

  void _showActionSnackBar(BuildContext context) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('项目已删除'),
        action: SnackBarAction(
          label: '撤销',
          onPressed: () {
            HapticFeedback.mediumImpact();
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showFloatingSnackBar(BuildContext context) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('浮动提示条'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showMaterialBanner(BuildContext context) {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        content: const Text('这是一个 Material Banner 横幅提示'),
        leading: const Icon(Icons.info),
        actions: [
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text('了解更多'),
          ),
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}

class _ExpansionPanelDemo extends StatefulWidget {
  const _ExpansionPanelDemo();

  @override
  State<_ExpansionPanelDemo> createState() => _ExpansionPanelDemoState();
}

class _ExpansionPanelDemoState extends State<_ExpansionPanelDemo> {
  final List<bool> _isExpanded = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (index, isExpanded) {
        HapticFeedback.selectionClick();
        setState(() {
          _isExpanded[index] = isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          headerBuilder: (context, isExpanded) =>
              const ListTile(title: Text('面板 1'), subtitle: Text('点击展开查看详情')),
          body: const Padding(
            padding: EdgeInsets.all(16),
            child: Text('这是面板 1 的内容。可以放置任何 Widget。'),
          ),
          isExpanded: _isExpanded[0],
        ),
        ExpansionPanel(
          headerBuilder: (context, isExpanded) =>
              const ListTile(title: Text('面板 2'), subtitle: Text('点击展开查看详情')),
          body: const Padding(padding: EdgeInsets.all(16), child: Text('这是面板 2 的内容。支持动画过渡效果。')),
          isExpanded: _isExpanded[1],
        ),
        ExpansionPanel(
          headerBuilder: (context, isExpanded) =>
              const ListTile(title: Text('面板 3'), subtitle: Text('点击展开查看详情')),
          body: const Padding(padding: EdgeInsets.all(16), child: Text('这是面板 3 的内容。')),
          isExpanded: _isExpanded[2],
          canTapOnHeader: true,
        ),
      ],
    );
  }
}
