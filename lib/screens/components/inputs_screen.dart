import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputsScreen extends StatefulWidget {
  const InputsScreen({super.key});

  @override
  State<InputsScreen> createState() => _InputsScreenState();
}

class _InputsScreenState extends State<InputsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _passwordController = TextEditingController();
  final _searchController = TextEditingController();

  bool _obscurePassword = true;
  String? _selectedDropdownValue;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final List<String> _dropdownItems = ['选项 1', '选项 2', '选项 3', '选项 4'];

  @override
  void dispose() {
    _textController.dispose();
    _passwordController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('输入框组件'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSection(
                title: 'TextField 基础',
                child: Column(
                  children: [
                    TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        labelText: '基础输入框',
                        hintText: '请输入文本',
                        prefixIcon: Icon(Icons.edit),
                      ),
                      onChanged: (value) {
                        HapticFeedback.selectionClick();
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: '密码输入框',
                        hintText: '请输入密码',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: '多行输入框',
                        hintText: '请输入多行文本...',
                        alignLabelWithHint: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: 'TextFormField 验证',
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: '邮箱',
                        hintText: 'example@email.com',
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入邮箱';
                        }
                        if (!value.contains('@')) {
                          return '请输入有效的邮箱地址';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: '手机号',
                        hintText: '请输入手机号',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入手机号';
                        }
                        if (value.length != 11) {
                          return '手机号应为11位';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('验证通过！')),
                          );
                        }
                      },
                      child: const Text('验证表单'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: '搜索栏',
                child: Column(
                  children: [
                    SearchBar(
                      controller: _searchController,
                      hintText: '搜索...',
                      leading: const Icon(Icons.search),
                      trailing: [
                        IconButton(
                          icon: const Icon(Icons.mic),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                          },
                        ),
                      ],
                      onChanged: (value) {
                        // 实时搜索
                      },
                    ),
                    const SizedBox(height: 16),
                    SearchAnchor(
                      builder: (context, controller) {
                        return SearchBar(
                          controller: controller,
                          hintText: '搜索建议...',
                          leading: const Icon(Icons.search),
                          onTap: () {
                            controller.openView();
                          },
                          onChanged: (_) {
                            controller.openView();
                          },
                        );
                      },
                      suggestionsBuilder: (context, controller) {
                        final suggestions =
                            [
                                  'Flutter',
                                  'Dart',
                                  'Material',
                                  'Widget',
                                  'Animation',
                                ]
                                .where(
                                  (item) => item.toLowerCase().contains(
                                    controller.text.toLowerCase(),
                                  ),
                                )
                                .toList();
                        return suggestions.map((suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                            onTap: () {
                              HapticFeedback.selectionClick();
                              controller.closeView(suggestion);
                            },
                          );
                        }).toList();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: '下拉选择',
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: _selectedDropdownValue,
                      decoration: const InputDecoration(
                        labelText: '选择选项',
                        prefixIcon: Icon(Icons.list),
                      ),
                      items: _dropdownItems.map((item) {
                        return DropdownMenuItem(value: item, child: Text(item));
                      }).toList(),
                      onChanged: (value) {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _selectedDropdownValue = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownMenu<String>(
                      label: const Text('Dropdown Menu'),
                      leadingIcon: const Icon(Icons.category),
                      dropdownMenuEntries: _dropdownItems.map((item) {
                        return DropdownMenuEntry(value: item, label: item);
                      }).toList(),
                      onSelected: (value) {
                        HapticFeedback.selectionClick();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: '日期和时间选择',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () async {
                        HapticFeedback.lightImpact();
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          HapticFeedback.mediumImpact();
                          setState(() {
                            _selectedDate = date;
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        _selectedDate != null
                            ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
                            : '选择日期',
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () async {
                        HapticFeedback.lightImpact();
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          HapticFeedback.mediumImpact();
                          setState(() {
                            _selectedTime = time;
                          });
                        }
                      },
                      icon: const Icon(Icons.access_time),
                      label: Text(
                        _selectedTime != null
                            ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                            : '选择时间',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: '数字输入',
                child: Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: '仅数字',
                        prefixIcon: Icon(Icons.numbers),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        labelText: '金额',
                        prefixIcon: Icon(Icons.attach_money),
                        prefixText: '¥ ',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
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
