import 'dart:math' as math;

import 'package:flutter/material.dart';

class HeatmapDemoScreen extends StatefulWidget {
  const HeatmapDemoScreen({super.key});

  @override
  State<HeatmapDemoScreen> createState() => _HeatmapDemoScreenState();
}

class _HeatmapDemoScreenState extends State<HeatmapDemoScreen> {
  late List<List<int>> _heatmapData;
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _generateRandomData();
  }

  void _generateRandomData() {
    final random = math.Random();
    _heatmapData = List.generate(
      53, // 53周
      (week) => List.generate(
        7, // 7天
        (day) => random.nextInt(5), // 0-4 级别
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('热力图演示'), backgroundColor: colorScheme.inversePrimary),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // GitHub风格热力图
          _buildSection(
            context,
            title: 'GitHub 风格贡献图',
            subtitle: '模拟一年的活动数据',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$_selectedYear 年活动', style: Theme.of(context).textTheme.titleMedium),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () {
                            setState(() {
                              _selectedYear--;
                              _generateRandomData();
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () {
                            setState(() {
                              _selectedYear++;
                              _generateRandomData();
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            setState(() {
                              _generateRandomData();
                            });
                          },
                          tooltip: '刷新数据',
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildGitHubHeatmap(colorScheme),
                const SizedBox(height: 16),
                _buildLegend(colorScheme),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 月度热力图
          _buildSection(
            context,
            title: '月度热力图',
            subtitle: '当月每日数据展示',
            child: _MonthHeatmap(colorScheme: colorScheme),
          ),
          const SizedBox(height: 24),

          // 时间热力图
          _buildSection(
            context,
            title: '时间段热力图',
            subtitle: '一周内不同时间段的活动分布',
            child: _TimeHeatmap(colorScheme: colorScheme),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String subtitle,
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
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildGitHubHeatmap(ColorScheme colorScheme) {
    const cellSize = 12.0;
    const cellSpacing = 3.0;
    final colors = _getHeatmapColors(colorScheme);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 月份标签
          Row(
            children: [
              const SizedBox(width: 30),
              ...['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'].map(
                (month) => SizedBox(
                  width: (cellSize + cellSpacing) * 4.3,
                  child: Text(month, style: Theme.of(context).textTheme.bodySmall),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 星期标签
              Column(
                children: ['', '周一', '', '周三', '', '周五', ''].map((day) {
                  return SizedBox(
                    height: cellSize + cellSpacing,
                    child: day.isEmpty
                        ? const SizedBox()
                        : Text(day, style: Theme.of(context).textTheme.bodySmall),
                  );
                }).toList(),
              ),
              const SizedBox(width: 8),
              // 热力图格子
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(53, (week) {
                  return Column(
                    children: List.generate(7, (day) {
                      final level = _heatmapData[week][day];
                      return Tooltip(
                        message: '第${week + 1}周 星期${_getDayName(day)}\n活动等级: $level',
                        child: Container(
                          width: cellSize,
                          height: cellSize,
                          margin: const EdgeInsets.all(cellSpacing / 2),
                          decoration: BoxDecoration(
                            color: colors[level],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(ColorScheme colorScheme) {
    final colors = _getHeatmapColors(colorScheme);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('少', style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(width: 4),
        ...colors.map(
          (color) => Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
          ),
        ),
        const SizedBox(width: 4),
        Text('多', style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  List<Color> _getHeatmapColors(ColorScheme colorScheme) {
    return [
      colorScheme.surfaceContainerHighest,
      colorScheme.primary.withValues(alpha: 0.25),
      colorScheme.primary.withValues(alpha: 0.5),
      colorScheme.primary.withValues(alpha: 0.75),
      colorScheme.primary,
    ];
  }

  String _getDayName(int day) {
    const days = ['日', '一', '二', '三', '四', '五', '六'];
    return days[day];
  }
}

// 月度热力图
class _MonthHeatmap extends StatelessWidget {
  final ColorScheme colorScheme;

  const _MonthHeatmap({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final firstWeekday = firstDayOfMonth.weekday;
    final random = math.Random(42);

    final colors = [
      colorScheme.surfaceContainerHighest,
      colorScheme.tertiary.withValues(alpha: 0.25),
      colorScheme.tertiary.withValues(alpha: 0.5),
      colorScheme.tertiary.withValues(alpha: 0.75),
      colorScheme.tertiary,
    ];

    return Column(
      children: [
        // 星期标题
        Row(
          children: ['日', '一', '二', '三', '四', '五', '六'].map((day) {
            return Expanded(
              child: Center(
                child: Text(
                  day,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        // 日期格子
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemCount: 42,
          itemBuilder: (context, index) {
            final dayOffset = index - (firstWeekday % 7);
            final day = dayOffset + 1;

            if (day < 1 || day > daysInMonth) {
              return const SizedBox();
            }

            final level = random.nextInt(5);
            final isToday = day == now.day;

            return Tooltip(
              message: '${now.month}月$day日\n活动等级: $level',
              child: Container(
                decoration: BoxDecoration(
                  color: colors[level],
                  borderRadius: BorderRadius.circular(4),
                  border: isToday ? Border.all(color: colorScheme.primary, width: 2) : null,
                ),
                child: Center(
                  child: Text(
                    '$day',
                    style: TextStyle(
                      fontSize: 12,
                      color: level > 2 ? Colors.white : colorScheme.onSurface,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// 时间段热力图
class _TimeHeatmap extends StatelessWidget {
  final ColorScheme colorScheme;

  const _TimeHeatmap({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final random = math.Random(123);
    final days = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    final hours = ['0-4', '4-8', '8-12', '12-16', '16-20', '20-24'];

    final colors = [
      colorScheme.surfaceContainerHighest,
      colorScheme.secondary.withValues(alpha: 0.25),
      colorScheme.secondary.withValues(alpha: 0.5),
      colorScheme.secondary.withValues(alpha: 0.75),
      colorScheme.secondary,
    ];

    return Column(
      children: [
        // 时间标题
        Row(
          children: [
            const SizedBox(width: 40),
            ...hours.map(
              (hour) => Expanded(
                child: Center(child: Text(hour, style: Theme.of(context).textTheme.bodySmall)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // 热力图
        ...days.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  child: Text(entry.value, style: Theme.of(context).textTheme.bodySmall),
                ),
                ...hours.asMap().entries.map((hourEntry) {
                  final level = random.nextInt(5);
                  return Expanded(
                    child: Tooltip(
                      message: '${entry.value} ${hourEntry.value}\n活动等级: $level',
                      child: Container(
                        height: 32,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: colors[level],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ],
    );
  }
}
