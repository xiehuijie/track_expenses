import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardsListsScreen extends StatelessWidget {
  const CardsListsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('卡片与列表'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection(
              context: context,
              title: 'Card 卡片',
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '基础卡片',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          const Text('这是一个基础卡片，包含一些文本内容。'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 8,
                    shadowColor: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.3),
                    child: Column(
                      children: [
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary,
                              ],
                            ),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.image,
                              size: 48,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '带图片的卡片',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              const Text('这个卡片包含一个头部图片区域。'),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () =>
                                        HapticFeedback.lightImpact(),
                                    child: const Text('取消'),
                                  ),
                                  const SizedBox(width: 8),
                                  FilledButton(
                                    onPressed: () =>
                                        HapticFeedback.mediumImpact(),
                                    child: const Text('确认'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('卡片被点击')));
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(child: Icon(Icons.person)),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('可点击卡片'),
                                  Text(
                                    '点击查看效果',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context: context,
              title: 'ListTile 列表项',
              child: Column(
                children: [
                  const ListTile(title: Text('基础列表项'), subtitle: Text('副标题')),
                  ListTile(
                    leading: const CircleAvatar(child: Text('A')),
                    title: const Text('带头像列表项'),
                    subtitle: const Text('副标题'),
                    trailing: const Icon(Icons.more_vert),
                    onTap: () => HapticFeedback.lightImpact(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.star),
                    title: const Text('带图标列表项'),
                    trailing: Switch(
                      value: true,
                      onChanged: (value) => HapticFeedback.selectionClick(),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.inbox),
                    title: const Text('三行列表项'),
                    subtitle: const Text('这是一个比较长的副标题文本，可以显示更多的信息内容...'),
                    isThreeLine: true,
                    trailing: const Text('12:00'),
                    onTap: () => HapticFeedback.lightImpact(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context: context,
              title: 'ExpansionTile 展开列表项',
              child: Column(
                children: [
                  ExpansionTile(
                    leading: const Icon(Icons.folder),
                    title: const Text('展开项 1'),
                    children: List.generate(
                      3,
                      (index) => ListTile(
                        leading: const Icon(Icons.insert_drive_file),
                        title: Text('文件 ${index + 1}'),
                        onTap: () => HapticFeedback.lightImpact(),
                      ),
                    ),
                  ),
                  ExpansionTile(
                    leading: const Icon(Icons.folder),
                    title: const Text('展开项 2'),
                    subtitle: const Text('包含更多选项'),
                    children: List.generate(
                      5,
                      (index) => ListTile(
                        leading: const Icon(Icons.insert_drive_file),
                        title: Text('文件 ${index + 1}'),
                        onTap: () => HapticFeedback.lightImpact(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context: context,
              title: 'GridView 网格视图',
              child: SizedBox(
                height: 300,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.primaries[index %
                                    Colors.primaries.length],
                                Colors.primaries[(index + 3) %
                                    Colors.primaries.length],
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context: context,
              title: 'ReorderableListView 可排序列表',
              child: ElevatedButton(
                onPressed: () => _showReorderableList(context),
                child: const Text('查看可排序列表'),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context: context,
              title: 'Dismissible 可滑动删除',
              child: ElevatedButton(
                onPressed: () => _showDismissibleList(context),
                child: const Text('查看可滑动删除列表'),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context: context,
              title: 'DataTable 数据表格',
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('名称')),
                    DataColumn(label: Text('数量'), numeric: true),
                    DataColumn(label: Text('价格'), numeric: true),
                  ],
                  rows: List.generate(
                    5,
                    (index) => DataRow(
                      cells: [
                        DataCell(Text('${index + 1}')),
                        DataCell(Text('产品 ${index + 1}')),
                        DataCell(Text('${(index + 1) * 10}')),
                        DataCell(Text('¥${(index + 1) * 99.0}')),
                      ],
                      onSelectChanged: (selected) {
                        HapticFeedback.selectionClick();
                      },
                    ),
                  ),
                ),
              ),
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

  void _showReorderableList(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const _ReorderableListPage()),
    );
  }

  void _showDismissibleList(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const _DismissibleListPage()),
    );
  }
}

class _ReorderableListPage extends StatefulWidget {
  const _ReorderableListPage();

  @override
  State<_ReorderableListPage> createState() => _ReorderableListPageState();
}

class _ReorderableListPageState extends State<_ReorderableListPage> {
  final List<String> _items = List.generate(10, (index) => '项目 ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('可排序列表')),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        onReorder: (oldIndex, newIndex) {
          HapticFeedback.mediumImpact();
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final item = _items.removeAt(oldIndex);
            _items.insert(newIndex, item);
          });
        },
        itemBuilder: (context, index) {
          return Card(
            key: ValueKey(_items[index]),
            child: ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text(_items[index]),
              trailing: ReorderableDragStartListener(
                index: index,
                child: const Icon(Icons.drag_handle),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DismissibleListPage extends StatefulWidget {
  const _DismissibleListPage();

  @override
  State<_DismissibleListPage> createState() => _DismissibleListPageState();
}

class _DismissibleListPageState extends State<_DismissibleListPage> {
  final List<String> _items = List.generate(10, (index) => '项目 ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('可滑动删除列表')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          return Dismissible(
            key: ValueKey(item),
            background: Container(
              color: Colors.green,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.archive, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              HapticFeedback.mediumImpact();
              setState(() {
                _items.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    direction == DismissDirection.startToEnd
                        ? '$item 已归档'
                        : '$item 已删除',
                  ),
                  action: SnackBarAction(
                    label: '撤销',
                    onPressed: () {
                      setState(() {
                        _items.insert(index, item);
                      });
                    },
                  ),
                ),
              );
            },
            child: Card(
              child: ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(item),
                subtitle: const Text('左滑归档，右滑删除'),
              ),
            ),
          );
        },
      ),
    );
  }
}
