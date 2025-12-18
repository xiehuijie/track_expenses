import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../database/database.dart';
import '../../database/enums.dart';

/// 数据库开发测试页面
/// 用于测试各CRUD方法以及检查数据库内容
class DatabaseTestScreen extends StatefulWidget {
  const DatabaseTestScreen({super.key});

  @override
  State<DatabaseTestScreen> createState() => _DatabaseTestScreenState();
}

class _DatabaseTestScreenState extends State<DatabaseTestScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _db = AppDatabase.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
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
        title: const Text('数据库测试'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.monetization_on), text: '货币'),
            Tab(icon: Icon(Icons.account_balance_wallet), text: '账户'),
            Tab(icon: Icon(Icons.book), text: '账本'),
            Tab(icon: Icon(Icons.category), text: '分类'),
            Tab(icon: Icon(Icons.people), text: '相关方'),
            Tab(icon: Icon(Icons.receipt_long), text: '交易'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _CurrencyTab(db: _db),
          _AccountTab(db: _db),
          _LedgerTab(db: _db),
          _CategoryTab(db: _db),
          _StakeholderTab(db: _db),
          _TransactionTab(db: _db),
        ],
      ),
    );
  }
}

/// 货币管理标签页
class _CurrencyTab extends StatefulWidget {
  final AppDatabase db;

  const _CurrencyTab({required this.db});

  @override
  State<_CurrencyTab> createState() => _CurrencyTabState();
}

class _CurrencyTabState extends State<_CurrencyTab> {
  List<CurrencyData> _currencies = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final currencies = await widget.db.getAllCurrencies();
      setState(() => _currencies = currencies);
    } catch (e) {
      _showError('加载货币失败: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  void _showSuccess(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _addCurrency() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _AddCurrencyDialog(),
    );

    if (result != null) {
      try {
        await widget.db.insertCurrency(
          CurrencyCompanion.insert(
            currencyCode: result['code']!,
            name: result['name']!,
            symbol: result['symbol']!,
            position: 'prefix',
            decimal: int.parse(result['decimal'] ?? '2'),
            icon: result['icon'] ?? '💰',
            source: 'custom',
          ),
        );
        _showSuccess('货币添加成功');
        await _loadData();
      } catch (e) {
        _showError('添加货币失败: $e');
      }
    }
  }

  Future<void> _deleteCurrency(String code) async {
    HapticFeedback.mediumImpact();
    try {
      await widget.db.deleteCurrency(code);
      await _loadData();
      _showSuccess('货币删除成功');
    } catch (e) {
      _showError('删除货币失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '货币列表 (${_currencies.length} 条)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadData,
              ),
              FilledButton.icon(
                onPressed: _addCurrency,
                icon: const Icon(Icons.add),
                label: const Text('添加'),
              ),
            ],
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _currencies.isEmpty
                  ? const Center(child: Text('暂无数据'))
                  : ListView.builder(
                      itemCount: _currencies.length,
                      itemBuilder: (context, index) {
                        final currency = _currencies[index];
                        return ListTile(
                          leading: Text(
                            currency.icon,
                            style: const TextStyle(fontSize: 24),
                          ),
                          title: Text(
                            '${currency.name} (${currency.currencyCode})',
                          ),
                          subtitle: Text(
                            '符号: ${currency.symbol} | 小数位: ${currency.decimal} | 来源: ${currency.source}',
                          ),
                          trailing: currency.source == 'custom'
                              ? IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () =>
                                      _deleteCurrency(currency.currencyCode),
                                )
                              : null,
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

/// 添加货币对话框
class _AddCurrencyDialog extends StatefulWidget {
  @override
  State<_AddCurrencyDialog> createState() => _AddCurrencyDialogState();
}

class _AddCurrencyDialogState extends State<_AddCurrencyDialog> {
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _symbolController = TextEditingController();
  final _decimalController = TextEditingController(text: '2');
  final _iconController = TextEditingController(text: '💰');

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _symbolController.dispose();
    _decimalController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('添加货币'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(labelText: '货币代码 (如: BTC)'),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '货币名称'),
            ),
            TextField(
              controller: _symbolController,
              decoration: const InputDecoration(labelText: '货币符号'),
            ),
            TextField(
              controller: _decimalController,
              decoration: const InputDecoration(labelText: '小数位数'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _iconController,
              decoration: const InputDecoration(labelText: '图标'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            if (_codeController.text.isEmpty || _nameController.text.isEmpty) {
              return;
            }
            Navigator.of(context).pop({
              'code': _codeController.text,
              'name': _nameController.text,
              'symbol': _symbolController.text,
              'decimal': _decimalController.text,
              'icon': _iconController.text,
            });
          },
          child: const Text('添加'),
        ),
      ],
    );
  }
}

/// 账户管理标签页
class _AccountTab extends StatefulWidget {
  final AppDatabase db;

  const _AccountTab({required this.db});

  @override
  State<_AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<_AccountTab> {
  List<AccountData> _accounts = [];
  List<CurrencyData> _currencies = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final accounts = await widget.db.getAllAccounts();
      final currencies = await widget.db.getAllCurrencies();
      setState(() {
        _accounts = accounts;
        _currencies = currencies;
      });
    } catch (e) {
      _showError('加载账户失败: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  void _showSuccess(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _addAccount() async {
    if (_currencies.isEmpty) {
      _showError('请先添加货币');
      return;
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _AddAccountDialog(currencies: _currencies),
    );

    if (result != null) {
      try {
        final now = DateTime.now().millisecondsSinceEpoch;
        await widget.db.insertAccount(
          AccountCompanion.insert(
            name: result['name'] as String,
            description: result['description'] as String? ?? '',
            icon: result['icon'] as String? ?? '💳',
            type: result['type'] as String,
            currencyCode: result['currencyCode'] as String,
            createdAt: now,
            updatedAt: now,
            note: '',
          ),
        );
        _showSuccess('账户添加成功');
        await _loadData();
      } catch (e) {
        _showError('添加账户失败: $e');
      }
    }
  }

  Future<void> _deleteAccount(int id) async {
    HapticFeedback.mediumImpact();
    try {
      await widget.db.deleteAccount(id);
      await _loadData();
      _showSuccess('账户删除成功');
    } catch (e) {
      _showError('删除账户失败: $e');
    }
  }

  String _getAccountTypeName(String type) {
    return AccountType.fromValue(type).name;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '账户列表 (${_accounts.length} 条)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadData,
              ),
              FilledButton.icon(
                onPressed: _addAccount,
                icon: const Icon(Icons.add),
                label: const Text('添加'),
              ),
            ],
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _accounts.isEmpty
                  ? const Center(child: Text('暂无数据'))
                  : ListView.builder(
                      itemCount: _accounts.length,
                      itemBuilder: (context, index) {
                        final account = _accounts[index];
                        return ListTile(
                          leading: Text(
                            account.icon,
                            style: const TextStyle(fontSize: 24),
                          ),
                          title: Text(account.name),
                          subtitle: Text(
                            '类型: ${_getAccountTypeName(account.type)} | 货币: ${account.currencyCode}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteAccount(account.accountId),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

/// 添加账户对话框
class _AddAccountDialog extends StatefulWidget {
  final List<CurrencyData> currencies;

  const _AddAccountDialog({required this.currencies});

  @override
  State<_AddAccountDialog> createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<_AddAccountDialog> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _iconController = TextEditingController(text: '💳');
  String _selectedType = AccountType.balance.value;
  late String _selectedCurrency;

  @override
  void initState() {
    super.initState();
    _selectedCurrency = widget.currencies.first.currencyCode;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('添加账户'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '账户名称'),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: '账户描述'),
            ),
            TextField(
              controller: _iconController,
              decoration: const InputDecoration(labelText: '账户图标'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(labelText: '账户类型'),
              items: AccountType.values.map((type) {
                return DropdownMenuItem(value: type.value, child: Text(type.name));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCurrency,
              decoration: const InputDecoration(labelText: '货币'),
              items: widget.currencies.map((currency) {
                return DropdownMenuItem(
                  value: currency.currencyCode,
                  child: Text('${currency.name} (${currency.currencyCode})'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCurrency = value);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            if (_nameController.text.isEmpty) return;
            Navigator.of(context).pop({
              'name': _nameController.text,
              'description': _descController.text,
              'icon': _iconController.text,
              'type': _selectedType,
              'currencyCode': _selectedCurrency,
            });
          },
          child: const Text('添加'),
        ),
      ],
    );
  }
}

/// 账本管理标签页
class _LedgerTab extends StatefulWidget {
  final AppDatabase db;

  const _LedgerTab({required this.db});

  @override
  State<_LedgerTab> createState() => _LedgerTabState();
}

class _LedgerTabState extends State<_LedgerTab> {
  List<LedgerData> _ledgers = [];
  List<CurrencyData> _currencies = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final ledgers = await widget.db.getAllLedgers();
      final currencies = await widget.db.getAllCurrencies();
      setState(() {
        _ledgers = ledgers;
        _currencies = currencies;
      });
    } catch (e) {
      _showError('加载账本失败: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  void _showSuccess(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _addLedger() async {
    if (_currencies.isEmpty) {
      _showError('请先添加货币');
      return;
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _AddLedgerDialog(currencies: _currencies),
    );

    if (result != null) {
      try {
        final now = DateTime.now().millisecondsSinceEpoch;
        await widget.db.insertLedger(
          LedgerCompanion.insert(
            name: result['name'] as String,
            currencyCode: result['currencyCode'] as String,
            description: result['description'] as String? ?? '',
            photo: '',
            createdAt: now,
            updatedAt: now,
            note: '',
          ),
        );
        _showSuccess('账本添加成功');
        await _loadData();
      } catch (e) {
        _showError('添加账本失败: $e');
      }
    }
  }

  Future<void> _deleteLedger(int id) async {
    HapticFeedback.mediumImpact();
    try {
      await widget.db.deleteLedger(id);
      await _loadData();
      _showSuccess('账本删除成功');
    } catch (e) {
      _showError('删除账本失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '账本列表 (${_ledgers.length} 条)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadData,
              ),
              FilledButton.icon(
                onPressed: _addLedger,
                icon: const Icon(Icons.add),
                label: const Text('添加'),
              ),
            ],
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _ledgers.isEmpty
                  ? const Center(child: Text('暂无数据'))
                  : ListView.builder(
                      itemCount: _ledgers.length,
                      itemBuilder: (context, index) {
                        final ledger = _ledgers[index];
                        return ListTile(
                          leading: const Icon(Icons.book, size: 32),
                          title: Text(ledger.name),
                          subtitle: Text(
                            '货币: ${ledger.currencyCode} | ${ledger.description}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteLedger(ledger.ledgerId),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

/// 添加账本对话框
class _AddLedgerDialog extends StatefulWidget {
  final List<CurrencyData> currencies;

  const _AddLedgerDialog({required this.currencies});

  @override
  State<_AddLedgerDialog> createState() => _AddLedgerDialogState();
}

class _AddLedgerDialogState extends State<_AddLedgerDialog> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  late String _selectedCurrency;

  @override
  void initState() {
    super.initState();
    _selectedCurrency = widget.currencies.first.currencyCode;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('添加账本'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '账本名称'),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: '账本描述'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCurrency,
              decoration: const InputDecoration(labelText: '本币'),
              items: widget.currencies.map((currency) {
                return DropdownMenuItem(
                  value: currency.currencyCode,
                  child: Text('${currency.name} (${currency.currencyCode})'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCurrency = value);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            if (_nameController.text.isEmpty) return;
            Navigator.of(context).pop({
              'name': _nameController.text,
              'description': _descController.text,
              'currencyCode': _selectedCurrency,
            });
          },
          child: const Text('添加'),
        ),
      ],
    );
  }
}

/// 分类管理标签页
class _CategoryTab extends StatefulWidget {
  final AppDatabase db;

  const _CategoryTab({required this.db});

  @override
  State<_CategoryTab> createState() => _CategoryTabState();
}

class _CategoryTabState extends State<_CategoryTab> {
  List<CategoryData> _categories = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final categories = await widget.db.getAllCategories();
      setState(() => _categories = categories);
    } catch (e) {
      _showError('加载分类失败: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  void _showSuccess(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _addCategory() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _AddCategoryDialog(),
    );

    if (result != null) {
      try {
        await widget.db.insertCategory(
          CategoryCompanion.insert(
            name: result['name'] as String,
            type: result['type'] as String,
            icon: result['icon'] as String? ?? '📁',
          ),
        );
        _showSuccess('分类添加成功');
        await _loadData();
      } catch (e) {
        _showError('添加分类失败: $e');
      }
    }
  }

  Future<void> _deleteCategory(int id) async {
    HapticFeedback.mediumImpact();
    try {
      await widget.db.deleteCategory(id);
      await _loadData();
      _showSuccess('分类删除成功');
    } catch (e) {
      _showError('删除分类失败: $e');
    }
  }

  String _getCategoryTypeName(String type) {
    return CategoryType.fromValue(type).name;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '分类列表 (${_categories.length} 条)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadData,
              ),
              FilledButton.icon(
                onPressed: _addCategory,
                icon: const Icon(Icons.add),
                label: const Text('添加'),
              ),
            ],
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _categories.isEmpty
                  ? const Center(child: Text('暂无数据'))
                  : ListView.builder(
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        return ListTile(
                          leading: Text(
                            category.icon,
                            style: const TextStyle(fontSize: 24),
                          ),
                          title: Text(category.name),
                          subtitle: Text(
                            '类型: ${_getCategoryTypeName(category.type)}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _deleteCategory(category.categoryId),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

/// 添加分类对话框
class _AddCategoryDialog extends StatefulWidget {
  @override
  State<_AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<_AddCategoryDialog> {
  final _nameController = TextEditingController();
  final _iconController = TextEditingController(text: '📁');
  String _selectedType = CategoryType.expense.value;

  @override
  void dispose() {
    _nameController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('添加分类'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '分类名称'),
            ),
            TextField(
              controller: _iconController,
              decoration: const InputDecoration(labelText: '分类图标'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(labelText: '分类类型'),
              items: CategoryType.values.map((type) {
                return DropdownMenuItem(value: type.value, child: Text(type.name));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            if (_nameController.text.isEmpty) return;
            Navigator.of(context).pop({
              'name': _nameController.text,
              'icon': _iconController.text,
              'type': _selectedType,
            });
          },
          child: const Text('添加'),
        ),
      ],
    );
  }
}

/// 相关方管理标签页
class _StakeholderTab extends StatefulWidget {
  final AppDatabase db;

  const _StakeholderTab({required this.db});

  @override
  State<_StakeholderTab> createState() => _StakeholderTabState();
}

class _StakeholderTabState extends State<_StakeholderTab> {
  List<StakeholderData> _stakeholders = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final stakeholders = await widget.db.getAllStakeholders();
      setState(() => _stakeholders = stakeholders);
    } catch (e) {
      _showError('加载相关方失败: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  void _showSuccess(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _addStakeholder() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _AddStakeholderDialog(),
    );

    if (result != null) {
      try {
        final now = DateTime.now().millisecondsSinceEpoch;
        await widget.db.insertStakeholder(
          StakeholderCompanion.insert(
            name: result['name'] as String,
            type: result['type'] as String,
            avatar: result['avatar'] as String? ?? '👤',
            description: result['description'] as String? ?? '',
            contact: '',
            createdAt: now,
            updatedAt: now,
            note: '',
          ),
        );
        _showSuccess('相关方添加成功');
        await _loadData();
      } catch (e) {
        _showError('添加相关方失败: $e');
      }
    }
  }

  Future<void> _deleteStakeholder(int id) async {
    HapticFeedback.mediumImpact();
    try {
      await widget.db.deleteStakeholder(id);
      await _loadData();
      _showSuccess('相关方删除成功');
    } catch (e) {
      _showError('删除相关方失败: $e');
    }
  }

  String _getStakeholderTypeName(String type) {
    return StakeholderType.fromValue(type).name;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '相关方列表 (${_stakeholders.length} 条)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadData,
              ),
              FilledButton.icon(
                onPressed: _addStakeholder,
                icon: const Icon(Icons.add),
                label: const Text('添加'),
              ),
            ],
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _stakeholders.isEmpty
                  ? const Center(child: Text('暂无数据'))
                  : ListView.builder(
                      itemCount: _stakeholders.length,
                      itemBuilder: (context, index) {
                        final stakeholder = _stakeholders[index];
                        return ListTile(
                          leading: Text(
                            stakeholder.avatar,
                            style: const TextStyle(fontSize: 24),
                          ),
                          title: Text(stakeholder.name),
                          subtitle: Text(
                            '类型: ${_getStakeholderTypeName(stakeholder.type)}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _deleteStakeholder(stakeholder.stakeholderId),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

/// 添加相关方对话框
class _AddStakeholderDialog extends StatefulWidget {
  @override
  State<_AddStakeholderDialog> createState() => _AddStakeholderDialogState();
}

class _AddStakeholderDialogState extends State<_AddStakeholderDialog> {
  final _nameController = TextEditingController();
  final _avatarController = TextEditingController(text: '👤');
  final _descController = TextEditingController();
  String _selectedType = StakeholderType.person.value;

  @override
  void dispose() {
    _nameController.dispose();
    _avatarController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('添加相关方'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '名称'),
            ),
            TextField(
              controller: _avatarController,
              decoration: const InputDecoration(labelText: '头像'),
            ),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: '描述'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(labelText: '类型'),
              items: StakeholderType.values.map((type) {
                return DropdownMenuItem(value: type.value, child: Text(type.name));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            if (_nameController.text.isEmpty) return;
            Navigator.of(context).pop({
              'name': _nameController.text,
              'avatar': _avatarController.text,
              'description': _descController.text,
              'type': _selectedType,
            });
          },
          child: const Text('添加'),
        ),
      ],
    );
  }
}

/// 交易管理标签页
class _TransactionTab extends StatefulWidget {
  final AppDatabase db;

  const _TransactionTab({required this.db});

  @override
  State<_TransactionTab> createState() => _TransactionTabState();
}

class _TransactionTabState extends State<_TransactionTab> {
  List<TransactionData> _transactions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final transactions = await widget.db.getAllTransactions();
      setState(() => _transactions = transactions);
    } catch (e) {
      _showError('加载交易失败: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  void _showSuccess(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _deleteTransaction(int id) async {
    HapticFeedback.mediumImpact();
    try {
      await widget.db.deleteTransaction(id);
      await _loadData();
      _showSuccess('交易删除成功');
    } catch (e) {
      _showError('删除交易失败: $e');
    }
  }

  String _getTransactionTypeName(String type) {
    return TransactionType.fromValue(type).name;
  }

  String _formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '交易列表 (${_transactions.length} 条)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadData,
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '提示: 交易需要先创建账本和分类，然后通过完整的交易流程添加。这里仅展示已有交易。',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _transactions.isEmpty
                  ? const Center(child: Text('暂无交易数据'))
                  : ListView.builder(
                      itemCount: _transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = _transactions[index];
                        return ListTile(
                          leading: Icon(
                            transaction.type == 'expense'
                                ? Icons.arrow_downward
                                : transaction.type == 'income'
                                    ? Icons.arrow_upward
                                    : Icons.swap_horiz,
                            color: transaction.type == 'expense'
                                ? Colors.red
                                : transaction.type == 'income'
                                    ? Colors.green
                                    : Colors.blue,
                          ),
                          title: Text(
                            '${_getTransactionTypeName(transaction.type)} #${transaction.transactionId}',
                          ),
                          subtitle: Text(
                            '${_formatTimestamp(transaction.timestamp)} | ${transaction.note}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                _deleteTransaction(transaction.transactionId),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
