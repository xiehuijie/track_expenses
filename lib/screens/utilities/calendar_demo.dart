import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarDemoScreen extends StatefulWidget {
  const CalendarDemoScreen({super.key});

  @override
  State<CalendarDemoScreen> createState() => _CalendarDemoScreenState();
}

class _CalendarDemoScreenState extends State<CalendarDemoScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;

  // 模拟事件数据
  final Map<DateTime, List<String>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;

    // 添加一些模拟事件
    final now = DateTime.now();
    _events[DateTime(now.year, now.month, now.day)] = ['今日待办', '会议'];
    _events[DateTime(now.year, now.month, now.day + 2)] = ['项目截止'];
    _events[DateTime(now.year, now.month, now.day + 5)] = ['团队建设'];
    _events[DateTime(now.year, now.month, now.day - 3)] = ['已完成任务'];
  }

  List<String> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('日历演示'), backgroundColor: colorScheme.inversePrimary),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: TableCalendar<String>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                selectedDecoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(color: colorScheme.onPrimaryContainer),
                rangeStartDecoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                rangeEndDecoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                rangeHighlightColor: colorScheme.primaryContainer,
                markerDecoration: BoxDecoration(
                  color: colorScheme.tertiary,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                formatButtonDecoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outline),
                  borderRadius: BorderRadius.circular(12),
                ),
                leftChevronIcon: Icon(Icons.chevron_left, color: colorScheme.onSurface),
                rightChevronIcon: Icon(Icons.chevron_right, color: colorScheme.onSurface),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _rangeStart = null;
                    _rangeEnd = null;
                    _rangeSelectionMode = RangeSelectionMode.toggledOff;
                  });
                }
              },
              onRangeSelected: (start, end, focusedDay) {
                setState(() {
                  _selectedDay = null;
                  _focusedDay = focusedDay;
                  _rangeStart = start;
                  _rangeEnd = end;
                  _rangeSelectionMode = RangeSelectionMode.toggledOn;
                });
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('选择模式:', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: const Text('单选'),
                  selected: _rangeSelectionMode == RangeSelectionMode.toggledOff,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _rangeSelectionMode = RangeSelectionMode.toggledOff;
                        _rangeStart = null;
                        _rangeEnd = null;
                      });
                    }
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('范围选择'),
                  selected: _rangeSelectionMode == RangeSelectionMode.toggledOn,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _rangeSelectionMode = RangeSelectionMode.toggledOn;
                        _selectedDay = null;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    final events = _selectedDay != null ? _getEventsForDay(_selectedDay!) : <String>[];

    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 64, color: Theme.of(context).colorScheme.outlineVariant),
            const SizedBox(height: 16),
            Text(
              _selectedDay != null ? '该日期没有事件' : '请选择日期',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(Icons.event, color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
            title: Text(events[index]),
            subtitle: Text('${_selectedDay!.year}年${_selectedDay!.month}月${_selectedDay!.day}日'),
          ),
        );
      },
    );
  }
}
