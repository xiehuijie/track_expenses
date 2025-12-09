import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
        title: const Text('数据存储'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.settings), text: 'Preferences'),
            Tab(icon: Icon(Icons.storage), text: 'SQLite'),
            Tab(icon: Icon(Icons.folder), text: '文件'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [_SharedPreferencesTab(), _SQLiteTab(), _FileStorageTab()],
      ),
    );
  }
}

// SharedPreferences 标签页
class _SharedPreferencesTab extends StatefulWidget {
  const _SharedPreferencesTab();

  @override
  State<_SharedPreferencesTab> createState() => _SharedPreferencesTabState();
}

class _SharedPreferencesTabState extends State<_SharedPreferencesTab> {
  final _keyController = TextEditingController();
  final _valueController = TextEditingController();
  Map<String, dynamic> _savedData = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      final data = <String, dynamic>{};
      for (final key in keys) {
        data[key] = prefs.get(key);
      }
      setState(() => _savedData = data);
    } catch (e) {
      _showError('加载数据失败: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveData() async {
    if (_keyController.text.isEmpty || _valueController.text.isEmpty) {
      _showError('请输入键和值');
      return;
    }

    HapticFeedback.mediumImpact();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyController.text, _valueController.text);
      _keyController.clear();
      _valueController.clear();
      await _loadAllData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('保存成功')));
      }
    } catch (e) {
      _showError('保存失败: $e');
    }
  }

  Future<void> _deleteData(String key) async {
    HapticFeedback.mediumImpact();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
      await _loadAllData();
    } catch (e) {
      _showError('删除失败: $e');
    }
  }

  Future<void> _clearAll() async {
    HapticFeedback.heavyImpact();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await _loadAllData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已清除所有数据')));
      }
    } catch (e) {
      _showError('清除失败: $e');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '添加数据',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _keyController,
                    decoration: const InputDecoration(labelText: '键 (Key)', hintText: '输入键名'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _valueController,
                    decoration: const InputDecoration(labelText: '值 (Value)', hintText: '输入值'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _saveData,
                          icon: const Icon(Icons.save),
                          label: const Text('保存'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: _clearAll,
                        icon: const Icon(Icons.delete_forever),
                        label: const Text('清除全部'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '已保存数据',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(icon: const Icon(Icons.refresh), onPressed: _loadAllData),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_savedData.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: Text('暂无数据')),
                    )
                  else
                    ...(_savedData.entries.map((entry) {
                      return ListTile(
                        title: Text(entry.key),
                        subtitle: Text('${entry.value}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteData(entry.key),
                        ),
                      );
                    })),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// SQLite 标签页
class _SQLiteTab extends StatefulWidget {
  const _SQLiteTab();

  @override
  State<_SQLiteTab> createState() => _SQLiteTabState();
}

class _SQLiteTabState extends State<_SQLiteTab> {
  Database? _database;
  List<Map<String, dynamic>> _items = [];
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _database?.close();
    super.dispose();
  }

  Future<void> _initDatabase() async {
    if (kIsWeb) {
      // Web 不支持 sqflite
      return;
    }

    setState(() => _isLoading = true);
    try {
      final dbPath = await getDatabasesPath();
      final dbFile = path.join(dbPath, 'demo.db');

      _database = await openDatabase(
        dbFile,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE items (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              description TEXT,
              created_at TEXT DEFAULT CURRENT_TIMESTAMP
            )
          ''');
        },
      );
      await _loadItems();
    } catch (e) {
      _showError('数据库初始化失败: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadItems() async {
    if (_database == null) return;
    try {
      final items = await _database!.query('items', orderBy: 'id DESC');
      setState(() => _items = items);
    } catch (e) {
      _showError('加载数据失败: $e');
    }
  }

  Future<void> _addItem() async {
    if (_database == null) {
      _showError('数据库未初始化');
      return;
    }
    if (_nameController.text.isEmpty) {
      _showError('请输入名称');
      return;
    }

    HapticFeedback.mediumImpact();
    try {
      await _database!.insert('items', {
        'name': _nameController.text,
        'description': _descController.text,
      });
      _nameController.clear();
      _descController.clear();
      await _loadItems();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('添加成功')));
      }
    } catch (e) {
      _showError('添加失败: $e');
    }
  }

  Future<void> _deleteItem(int id) async {
    HapticFeedback.mediumImpact();
    try {
      await _database!.delete('items', where: 'id = ?', whereArgs: [id]);
      await _loadItems();
    } catch (e) {
      _showError('删除失败: $e');
    }
  }

  Future<void> _clearAll() async {
    HapticFeedback.heavyImpact();
    try {
      await _database!.delete('items');
      await _loadItems();
    } catch (e) {
      _showError('清除失败: $e');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const Center(child: Text('SQLite 在 Web 平台不可用'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '添加记录',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: '名称', hintText: '输入名称'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descController,
                    decoration: const InputDecoration(labelText: '描述', hintText: '输入描述（可选）'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _addItem,
                          icon: const Icon(Icons.add),
                          label: const Text('添加'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: _clearAll,
                        icon: const Icon(Icons.delete_forever),
                        label: const Text('清空表'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '数据列表 (${_items.length} 条)',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(icon: const Icon(Icons.refresh), onPressed: _loadItems),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: Text('暂无数据')),
                    )
                  else
                    ...(_items.map((item) {
                      return ListTile(
                        title: Text(item['name'] ?? ''),
                        subtitle: Text(item['description'] ?? ''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('ID: ${item['id']}', style: const TextStyle(color: Colors.grey)),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteItem(item['id']),
                            ),
                          ],
                        ),
                      );
                    })),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 文件存储标签页
class _FileStorageTab extends StatefulWidget {
  const _FileStorageTab();

  @override
  State<_FileStorageTab> createState() => _FileStorageTabState();
}

class _FileStorageTabState extends State<_FileStorageTab> {
  final _contentController = TextEditingController();
  String _fileContent = '';
  String _filePath = '';
  Map<String, String> _directories = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDirectories();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _loadDirectories() async {
    if (kIsWeb) return;

    try {
      final directories = <String, String>{};

      // 应用文档目录
      final appDocDir = await getApplicationDocumentsDirectory();
      directories['应用文档目录'] = appDocDir.path;

      // 临时目录
      final tempDir = await getTemporaryDirectory();
      directories['临时目录'] = tempDir.path;

      // 应用支持目录
      try {
        final supportDir = await getApplicationSupportDirectory();
        directories['应用支持目录'] = supportDir.path;
      } catch (_) {}

      // 缓存目录
      try {
        final cacheDir = await getApplicationCacheDirectory();
        directories['缓存目录'] = cacheDir.path;
      } catch (_) {}

      setState(() => _directories = directories);
    } catch (e) {
      debugPrint('加载目录失败: $e');
    }
  }

  Future<void> _saveToFile() async {
    if (kIsWeb) {
      _showError('Web 平台文件操作受限');
      return;
    }

    if (_contentController.text.isEmpty) {
      _showError('请输入内容');
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/demo_file.txt');
      await file.writeAsString(_contentController.text);

      setState(() => _filePath = file.path);
      _contentController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('文件已保存: ${file.path}')));
      }
    } catch (e) {
      _showError('保存失败: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _readFromFile() async {
    if (kIsWeb) {
      _showError('Web 平台文件操作受限');
      return;
    }

    HapticFeedback.lightImpact();
    setState(() => _isLoading = true);

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/demo_file.txt');

      if (await file.exists()) {
        final content = await file.readAsString();
        setState(() {
          _fileContent = content;
          _filePath = file.path;
        });
      } else {
        _showError('文件不存在');
      }
    } catch (e) {
      _showError('读取失败: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveJsonFile() async {
    if (kIsWeb) {
      _showError('Web 平台文件操作受限');
      return;
    }

    HapticFeedback.mediumImpact();

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/demo_data.json');

      final jsonData = {
        'name': 'Flutter Demo',
        'version': '1.0.0',
        'timestamp': DateTime.now().toIso8601String(),
        'items': [
          {'id': 1, 'title': '项目 1'},
          {'id': 2, 'title': '项目 2'},
          {'id': 3, 'title': '项目 3'},
        ],
      };

      await file.writeAsString(const JsonEncoder.withIndent('  ').convert(jsonData));

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('JSON 文件已保存: ${file.path}')));
      }
    } catch (e) {
      _showError('保存 JSON 失败: $e');
    }
  }

  Future<void> _readJsonFile() async {
    if (kIsWeb) {
      _showError('Web 平台文件操作受限');
      return;
    }

    HapticFeedback.lightImpact();

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/demo_data.json');

      if (await file.exists()) {
        final content = await file.readAsString();
        final jsonData = json.decode(content);
        setState(() {
          _fileContent = const JsonEncoder.withIndent('  ').convert(jsonData);
          _filePath = file.path;
        });
      } else {
        _showError('JSON 文件不存在，请先保存');
      }
    } catch (e) {
      _showError('读取 JSON 失败: $e');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const Center(child: Text('文件操作在 Web 平台受限'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '系统目录',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...(_directories.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w500)),
                          Text(
                            entry.value,
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  })),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '文本文件操作',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(labelText: '文件内容', hintText: '输入要保存的内容'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _isLoading ? null : _saveToFile,
                          icon: const Icon(Icons.save),
                          label: const Text('保存'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isLoading ? null : _readFromFile,
                          icon: const Icon(Icons.file_open),
                          label: const Text('读取'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'JSON 文件操作',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _saveJsonFile,
                          icon: const Icon(Icons.data_object),
                          label: const Text('保存 JSON'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _readJsonFile,
                          icon: const Icon(Icons.file_open),
                          label: const Text('读取 JSON'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_fileContent.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '文件内容',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (_filePath.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        '路径: $_filePath',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SelectableText(
                        _fileContent,
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
