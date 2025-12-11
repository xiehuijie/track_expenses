import 'package:flutter/material.dart';

/// 信息展示组件演示
class InfoDisplayScreen extends StatelessWidget {
  const InfoDisplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('信息展示组件'),
        backgroundColor: colorScheme.surfaceContainer,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Badges
          _buildSectionTitle(context, 'Badges 徽章'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 24,
            runSpacing: 16,
            children: [
              Badge(
                label: const Text('3'),
                child: Icon(Icons.notifications, size: 32, color: colorScheme.primary),
              ),
              Badge(
                label: const Text('99+'),
                child: Icon(Icons.mail, size: 32, color: colorScheme.primary),
              ),
              Badge(
                backgroundColor: Colors.red,
                child: Icon(Icons.shopping_cart, size: 32, color: colorScheme.primary),
              ),
              Badge(
                label: const Text('NEW'),
                backgroundColor: Colors.green,
                child: Icon(Icons.campaign, size: 32, color: colorScheme.primary),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Chips with different styles
          _buildSectionTitle(context, 'Chip 标签变体'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                avatar: CircleAvatar(
                  backgroundColor: colorScheme.primary,
                  child: Text('A', style: TextStyle(color: colorScheme.onPrimary)),
                ),
                label: const Text('Avatar Chip'),
              ),
              Chip(
                label: const Text('Delete Chip'),
                onDeleted: () {},
              ),
              Chip(
                label: const Text('Icon Chip'),
                avatar: const Icon(Icons.star),
              ),
              Chip(
                label: const Text('Colored Chip'),
                backgroundColor: colorScheme.tertiaryContainer,
                labelStyle: TextStyle(color: colorScheme.onTertiaryContainer),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Dividers
          _buildSectionTitle(context, 'Divider 分割线'),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.inbox),
                  title: const Text('收件箱'),
                  trailing: const Text('12'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.drafts),
                  title: const Text('草稿箱'),
                  trailing: const Text('3'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.send),
                  title: const Text('已发送'),
                  trailing: const Text('28'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Progress Indicators in context
          _buildSectionTitle(context, 'Progress 进度展示'),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('下载进度', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const LinearProgressIndicator(value: 0.7),
                  const SizedBox(height: 4),
                  Text('70% 完成', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 16),
                  const Text('上传进度', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const LinearProgressIndicator(value: 0.3),
                  const SizedBox(height: 4),
                  Text('30% 完成', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 16),
                  const Text('处理中...', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const LinearProgressIndicator(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Tooltips
          _buildSectionTitle(context, 'Tooltip 工具提示'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Tooltip(
                message: '这是一个图标按钮',
                child: IconButton(
                  icon: const Icon(Icons.info),
                  onPressed: () {},
                ),
              ),
              Tooltip(
                message: '添加新项目',
                child: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
              ),
              Tooltip(
                message: '设置选项',
                child: IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {},
                ),
              ),
              Tooltip(
                message: '分享内容',
                child: IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {},
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Info Cards
          _buildSectionTitle(context, '信息卡片'),
          const SizedBox(height: 12),
          _buildInfoCard(
            context,
            '总支出',
            '¥12,345.67',
            Icons.trending_up,
            Colors.red,
            '+15% 本月',
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            context,
            '总收入',
            '¥23,456.78',
            Icons.trending_down,
            Colors.green,
            '+8% 本月',
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            context,
            '余额',
            '¥11,111.11',
            Icons.account_balance_wallet,
            Colors.blue,
            '可用余额',
          ),

          const SizedBox(height: 32),

          // Status Indicators
          _buildSectionTitle(context, '状态指示器'),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                _buildStatusTile('已完成', Icons.check_circle, Colors.green),
                const Divider(height: 1),
                _buildStatusTile('进行中', Icons.pending, Colors.orange),
                const Divider(height: 1),
                _buildStatusTile('已取消', Icons.cancel, Colors.red),
                const Divider(height: 1),
                _buildStatusTile('待处理', Icons.schedule, Colors.blue),
              ],
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

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTile(String status, IconData icon, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(status),
      trailing: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
