import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 记账类别选择器
class CategorySelectorDemo extends StatefulWidget {
  const CategorySelectorDemo({super.key});

  @override
  State<CategorySelectorDemo> createState() => _CategorySelectorDemoState();
}

class _CategorySelectorDemoState extends State<CategorySelectorDemo>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ExpenseCategory? _selectedCategory;

  final List<ExpenseCategory> _expenseCategories = [
    ExpenseCategory(name: '餐饮', icon: Icons.restaurant, color: Colors.orange, emoji: '🍜'),
    ExpenseCategory(name: '交通', icon: Icons.directions_car, color: Colors.blue, emoji: '🚗'),
    ExpenseCategory(name: '购物', icon: Icons.shopping_bag, color: Colors.pink, emoji: '🛍️'),
    ExpenseCategory(name: '娱乐', icon: Icons.movie, color: Colors.purple, emoji: '🎬'),
    ExpenseCategory(name: '医疗', icon: Icons.local_hospital, color: Colors.red, emoji: '🏥'),
    ExpenseCategory(name: '教育', icon: Icons.school, color: Colors.indigo, emoji: '📚'),
    ExpenseCategory(name: '运动', icon: Icons.fitness_center, color: Colors.green, emoji: '⚽'),
    ExpenseCategory(name: '旅行', icon: Icons.flight, color: Colors.cyan, emoji: '✈️'),
    ExpenseCategory(name: '通讯', icon: Icons.phone, color: Colors.teal, emoji: '📱'),
    ExpenseCategory(name: '住房', icon: Icons.home, color: Colors.brown, emoji: '🏠'),
    ExpenseCategory(name: '水电', icon: Icons.bolt, color: Colors.amber, emoji: '💡'),
    ExpenseCategory(name: '其他', icon: Icons.more_horiz, color: Colors.grey, emoji: '📦'),
  ];

  final List<ExpenseCategory> _incomeCategories = [
    ExpenseCategory(name: '工资', icon: Icons.payment, color: Colors.green, emoji: '💰'),
    ExpenseCategory(name: '奖金', icon: Icons.card_giftcard, color: Colors.teal, emoji: '🎁'),
    ExpenseCategory(name: '投资', icon: Icons.trending_up, color: Colors.blue, emoji: '📈'),
    ExpenseCategory(name: '兼职', icon: Icons.work, color: Colors.purple, emoji: '💼'),
    ExpenseCategory(name: '红包', icon: Icons.redeem, color: Colors.red, emoji: '🧧'),
    ExpenseCategory(name: '退款', icon: Icons.replay, color: Colors.orange, emoji: '↩️'),
    ExpenseCategory(name: '其他', icon: Icons.more_horiz, color: Colors.grey, emoji: '💵'),
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
        title: const Text('类别选择'),
        backgroundColor: colorScheme.surfaceContainer,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '支出', icon: Icon(Icons.arrow_upward)),
            Tab(text: '收入', icon: Icon(Icons.arrow_downward)),
          ],
        ),
      ),
      body: Column(
        children: [
          // 当前选中类别显示
          if (_selectedCategory != null)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _selectedCategory!.color.withOpacity(0.2),
                    _selectedCategory!.color.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _selectedCategory!.color, width: 2),
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: _selectedCategory!.color,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(_selectedCategory!.emoji, style: const TextStyle(fontSize: 32)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '已选择类别',
                          style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _selectedCategory!.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.check_circle, color: _selectedCategory!.color, size: 32),
                ],
              ),
            ),

          // 类别网格
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCategoryGrid(_expenseCategories),
                _buildCategoryGrid(_incomeCategories),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(List<ExpenseCategory> categories) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.9,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = _selectedCategory?.name == category.name;

        return InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            setState(() {
              _selectedCategory = category;
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? category.color.withOpacity(0.2)
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
              border: isSelected ? Border.all(color: category.color, width: 2) : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: category.color.withOpacity(isSelected ? 1.0 : 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Text(category.emoji, style: const TextStyle(fontSize: 28))),
                ),
                const SizedBox(height: 8),
                Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ExpenseCategory {
  final String name;
  final IconData icon;
  final Color color;
  final String emoji;

  ExpenseCategory({
    required this.name,
    required this.icon,
    required this.color,
    required this.emoji,
  });
}
