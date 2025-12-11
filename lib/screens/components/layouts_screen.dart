import 'package:flutter/material.dart';

/// 布局组件演示
class LayoutsScreen extends StatelessWidget {
  const LayoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('布局组件'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Stack Layout
          _buildSectionTitle(context, 'Stack 堆叠布局'),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade300, Colors.purple.shade300],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '堆叠布局示例',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '元素可以重叠放置',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('标签'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Wrap Layout
          _buildSectionTitle(context, 'Wrap 自动换行布局'),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  10,
                  (index) => Chip(
                    label: Text('标签 ${index + 1}'),
                    avatar: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // GridView
          _buildSectionTitle(context, 'GridView 网格布局'),
          const SizedBox(height: 12),
          SizedBox(
            height: 300,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getIconForIndex(index),
                          size: 32,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '项目 ${index + 1}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 32),

          // Flexible & Expanded
          _buildSectionTitle(context, 'Flexible & Expanded'),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('Flexible 示例'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          height: 50,
                          color: Colors.blue.shade200,
                          child: const Center(child: Text('Flex: 1')),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        flex: 2,
                        child: Container(
                          height: 50,
                          color: Colors.green.shade200,
                          child: const Center(child: Text('Flex: 2')),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        flex: 1,
                        child: Container(
                          height: 50,
                          color: Colors.orange.shade200,
                          child: const Center(child: Text('Flex: 1')),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Expanded 示例'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 50,
                        color: Colors.purple.shade200,
                        child: const Center(child: Text('固定')),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 50,
                          color: Colors.pink.shade200,
                          child: const Center(child: Text('Expanded')),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 80,
                        height: 50,
                        color: Colors.purple.shade200,
                        child: const Center(child: Text('固定')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Padding & Margin
          _buildSectionTitle(context, 'Padding & Margin'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Padding',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        color: Colors.white.withOpacity(0.5),
                        child: const Text('内边距'),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Margin\n外边距',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Align & Center
          _buildSectionTitle(context, 'Align & Center'),
          const SizedBox(height: 12),
          Card(
            child: SizedBox(
              height: 200,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.red.shade200,
                          child: const Text('TopLeft'),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.green.shade200,
                          child: const Text('Center'),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.blue.shade200,
                          child: const Text('BottomRight'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  IconData _getIconForIndex(int index) {
    const icons = [
      Icons.home,
      Icons.search,
      Icons.favorite,
      Icons.shopping_cart,
      Icons.settings,
      Icons.person,
      Icons.notifications,
      Icons.mail,
      Icons.camera,
    ];
    return icons[index % icons.length];
  }
}
