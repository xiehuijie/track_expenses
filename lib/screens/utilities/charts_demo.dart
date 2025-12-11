import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartsDemoScreen extends StatefulWidget {
  const ChartsDemoScreen({super.key});

  @override
  State<ChartsDemoScreen> createState() => _ChartsDemoScreenState();
}

class _ChartsDemoScreenState extends State<ChartsDemoScreen> with SingleTickerProviderStateMixin {
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('图表演示'),
        backgroundColor: colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '折线图', icon: Icon(Icons.show_chart)),
            Tab(text: '柱状图', icon: Icon(Icons.bar_chart)),
            Tab(text: '饼图', icon: Icon(Icons.pie_chart)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _LineChartDemo(colorScheme: colorScheme),
          _BarChartDemo(colorScheme: colorScheme),
          _PieChartDemo(colorScheme: colorScheme),
        ],
      ),
    );
  }
}

class _LineChartDemo extends StatelessWidget {
  final ColorScheme colorScheme;

  const _LineChartDemo({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('月度数据趋势', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            '展示过去6个月的数据变化',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: colorScheme.outlineVariant, strokeWidth: 1);
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(color: colorScheme.outlineVariant, strokeWidth: 1);
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}k',
                          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const months = ['1月', '2月', '3月', '4月', '5月', '6月'];
                        if (value.toInt() < months.length) {
                          return Text(
                            months[value.toInt()],
                            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: colorScheme.outline),
                ),
                minX: 0,
                maxX: 5,
                minY: 0,
                maxY: 6,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 3),
                      FlSpot(1, 1.5),
                      FlSpot(2, 4),
                      FlSpot(3, 3.5),
                      FlSpot(4, 5),
                      FlSpot(5, 4.5),
                    ],
                    isCurved: true,
                    color: colorScheme.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 5,
                          color: colorScheme.primary,
                          strokeWidth: 2,
                          strokeColor: colorScheme.surface,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 1),
                      FlSpot(1, 2.8),
                      FlSpot(2, 2),
                      FlSpot(3, 4),
                      FlSpot(4, 3),
                      FlSpot(5, 5.5),
                    ],
                    isCurved: true,
                    color: colorScheme.secondary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 5,
                          color: colorScheme.secondary,
                          strokeWidth: 2,
                          strokeColor: colorScheme.surface,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: colorScheme.secondary.withValues(alpha: 0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendItem(color: colorScheme.primary, label: '收入'),
              const SizedBox(width: 24),
              _LegendItem(color: colorScheme.secondary, label: '支出'),
            ],
          ),
        ],
      ),
    );
  }
}

class _BarChartDemo extends StatelessWidget {
  final ColorScheme colorScheme;

  const _BarChartDemo({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('周数据对比', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            '每日收入支出对比',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 20,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => colorScheme.inverseSurface,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '\$${value.toInt()}',
                          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
                        if (value.toInt() < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              days[value.toInt()],
                              style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: colorScheme.outlineVariant, strokeWidth: 1);
                  },
                ),
                barGroups: [
                  _makeGroupData(0, 8, 12, colorScheme),
                  _makeGroupData(1, 10, 8, colorScheme),
                  _makeGroupData(2, 14, 11, colorScheme),
                  _makeGroupData(3, 15, 13, colorScheme),
                  _makeGroupData(4, 13, 9, colorScheme),
                  _makeGroupData(5, 10, 15, colorScheme),
                  _makeGroupData(6, 16, 10, colorScheme),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendItem(color: colorScheme.primary, label: '收入'),
              const SizedBox(width: 24),
              _LegendItem(color: colorScheme.tertiary, label: '支出'),
            ],
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y1, double y2, ColorScheme colorScheme) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: colorScheme.primary,
          width: 12,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
        BarChartRodData(
          toY: y2,
          color: colorScheme.tertiary,
          width: 12,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }
}

class _PieChartDemo extends StatefulWidget {
  final ColorScheme colorScheme;

  const _PieChartDemo({required this.colorScheme});

  @override
  State<_PieChartDemo> createState() => _PieChartDemoState();
}

class _PieChartDemoState extends State<_PieChartDemo> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('支出分类', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            '各类支出占比',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: widget.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 60,
                sections: _buildSections(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _LegendItem(color: widget.colorScheme.primary, label: '餐饮 35%'),
              _LegendItem(color: widget.colorScheme.secondary, label: '交通 20%'),
              _LegendItem(color: widget.colorScheme.tertiary, label: '购物 25%'),
              _LegendItem(color: widget.colorScheme.error, label: '娱乐 20%'),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    return [
      PieChartSectionData(
        color: widget.colorScheme.primary,
        value: 35,
        title: '35%',
        radius: touchedIndex == 0 ? 70 : 60,
        titleStyle: TextStyle(
          fontSize: touchedIndex == 0 ? 16 : 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: widget.colorScheme.secondary,
        value: 20,
        title: '20%',
        radius: touchedIndex == 1 ? 70 : 60,
        titleStyle: TextStyle(
          fontSize: touchedIndex == 1 ? 16 : 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: widget.colorScheme.tertiary,
        value: 25,
        title: '25%',
        radius: touchedIndex == 2 ? 70 : 60,
        titleStyle: TextStyle(
          fontSize: touchedIndex == 2 ? 16 : 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: widget.colorScheme.error,
        value: 20,
        title: '20%',
        radius: touchedIndex == 3 ? 70 : 60,
        titleStyle: TextStyle(
          fontSize: touchedIndex == 3 ? 16 : 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
