import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectionsScreen extends StatefulWidget {
  const SelectionsScreen({super.key});

  @override
  State<SelectionsScreen> createState() => _SelectionsScreenState();
}

class _SelectionsScreenState extends State<SelectionsScreen> {
  // Switch states
  bool _switchValue1 = false;
  bool _switchValue2 = true;
  bool _switchValue3 = false;

  // Checkbox states
  bool _checkboxValue1 = false;
  bool _checkboxValue2 = true;
  bool? _checkboxValue3; // tristate

  // Radio state
  int _radioValue = 1;

  // Slider states
  double _sliderValue = 50;
  RangeValues _rangeValues = const RangeValues(20, 80);

  // Chip states
  final Set<String> _selectedChips = {'Flutter'};
  int _selectedChoiceChip = 0;

  void _triggerHaptic() {
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择控件'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection(
              title: 'Switch 开关',
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('通知'),
                    subtitle: const Text('开启推送通知'),
                    secondary: const Icon(Icons.notifications),
                    value: _switchValue1,
                    onChanged: (value) {
                      _triggerHaptic();
                      setState(() => _switchValue1 = value);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('深色模式'),
                    subtitle: const Text('使用深色主题'),
                    secondary: const Icon(Icons.dark_mode),
                    value: _switchValue2,
                    onChanged: (value) {
                      _triggerHaptic();
                      setState(() => _switchValue2 = value);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('自动更新'),
                    subtitle: const Text('自动下载更新'),
                    secondary: const Icon(Icons.system_update),
                    value: _switchValue3,
                    onChanged: (value) {
                      _triggerHaptic();
                      setState(() => _switchValue3 = value);
                    },
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Wrap(
                      spacing: 16,
                      children: [
                        Switch(
                          value: _switchValue1,
                          onChanged: (value) {
                            _triggerHaptic();
                            setState(() => _switchValue1 = value);
                          },
                        ),
                        Switch(
                          value: true,
                          onChanged: null, // Disabled
                        ),
                        Switch.adaptive(
                          value: _switchValue2,
                          onChanged: (value) {
                            _triggerHaptic();
                            setState(() => _switchValue2 = value);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Checkbox 复选框',
              child: Column(
                children: [
                  CheckboxListTile(
                    title: const Text('同意用户协议'),
                    subtitle: const Text('请阅读并同意用户协议'),
                    secondary: const Icon(Icons.description),
                    value: _checkboxValue1,
                    onChanged: (value) {
                      _triggerHaptic();
                      setState(() => _checkboxValue1 = value!);
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('接收促销邮件'),
                    value: _checkboxValue2,
                    onChanged: (value) {
                      _triggerHaptic();
                      setState(() => _checkboxValue2 = value!);
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('三态复选框'),
                    subtitle: const Text('可以是未选中、选中或不确定状态'),
                    value: _checkboxValue3,
                    tristate: true,
                    onChanged: (value) {
                      _triggerHaptic();
                      setState(() => _checkboxValue3 = value);
                    },
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Checkbox(
                          value: _checkboxValue1,
                          onChanged: (value) {
                            _triggerHaptic();
                            setState(() => _checkboxValue1 = value!);
                          },
                        ),
                        Checkbox(
                          value: true,
                          onChanged: null, // Disabled
                        ),
                        Checkbox.adaptive(
                          value: _checkboxValue2,
                          onChanged: (value) {
                            _triggerHaptic();
                            setState(() => _checkboxValue2 = value!);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Radio 单选框',
              child: Column(
                children: [
                  RadioListTile<int>(
                    title: const Text('选项一'),
                    subtitle: const Text('这是第一个选项'),
                    value: 1,
                    groupValue: _radioValue,
                    onChanged: (value) {
                      _triggerHaptic();
                      setState(() => _radioValue = value!);
                    },
                  ),
                  RadioListTile<int>(
                    title: const Text('选项二'),
                    subtitle: const Text('这是第二个选项'),
                    value: 2,
                    groupValue: _radioValue,
                    onChanged: (value) {
                      _triggerHaptic();
                      setState(() => _radioValue = value!);
                    },
                  ),
                  RadioListTile<int>(
                    title: const Text('选项三'),
                    subtitle: const Text('这是第三个选项'),
                    value: 3,
                    groupValue: _radioValue,
                    onChanged: (value) {
                      _triggerHaptic();
                      setState(() => _radioValue = value!);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Slider 滑块',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('基础滑块: ${_sliderValue.round()}'),
                  Slider(
                    value: _sliderValue,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: _sliderValue.round().toString(),
                    onChanged: (value) {
                      setState(() => _sliderValue = value);
                    },
                    onChangeEnd: (value) {
                      _triggerHaptic();
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '范围滑块: ${_rangeValues.start.round()} - ${_rangeValues.end.round()}',
                  ),
                  RangeSlider(
                    values: _rangeValues,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    labels: RangeLabels(
                      _rangeValues.start.round().toString(),
                      _rangeValues.end.round().toString(),
                    ),
                    onChanged: (values) {
                      setState(() => _rangeValues = values);
                    },
                    onChangeEnd: (values) {
                      _triggerHaptic();
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('自定义滑块:'),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.green,
                      inactiveTrackColor: Colors.green.withOpacity(0.3),
                      thumbColor: Colors.green,
                      overlayColor: Colors.green.withOpacity(0.2),
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 12,
                      ),
                      trackHeight: 8,
                    ),
                    child: Slider(
                      value: _sliderValue,
                      min: 0,
                      max: 100,
                      onChanged: (value) {
                        setState(() => _sliderValue = value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Chip 芯片',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('基础 Chip:'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      const Chip(label: Text('标签')),
                      const Chip(
                        avatar: CircleAvatar(child: Text('A')),
                        label: Text('带头像'),
                      ),
                      Chip(
                        label: const Text('可删除'),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () {
                          _triggerHaptic();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Chip 已删除')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Action Chip:'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.add, size: 18),
                        label: const Text('添加'),
                        onPressed: () {
                          _triggerHaptic();
                        },
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.edit, size: 18),
                        label: const Text('编辑'),
                        onPressed: () {
                          _triggerHaptic();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Filter Chip (多选):'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['Flutter', 'Dart', 'Android', 'iOS', 'Web'].map((
                      label,
                    ) {
                      final isSelected = _selectedChips.contains(label);
                      return FilterChip(
                        label: Text(label),
                        selected: isSelected,
                        onSelected: (selected) {
                          _triggerHaptic();
                          setState(() {
                            if (selected) {
                              _selectedChips.add(label);
                            } else {
                              _selectedChips.remove(label);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text('Choice Chip (单选):'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(4, (index) {
                      return ChoiceChip(
                        label: Text('选项 ${index + 1}'),
                        selected: _selectedChoiceChip == index,
                        onSelected: (selected) {
                          _triggerHaptic();
                          setState(() {
                            _selectedChoiceChip = index;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  const Text('Input Chip:'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      InputChip(
                        avatar: const CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://via.placeholder.com/150',
                          ),
                        ),
                        label: const Text('John Doe'),
                        onDeleted: () {
                          _triggerHaptic();
                        },
                        onPressed: () {
                          _triggerHaptic();
                        },
                      ),
                      InputChip(
                        avatar: const Icon(Icons.location_on, size: 18),
                        label: const Text('北京'),
                        onPressed: () {
                          _triggerHaptic();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
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
}
