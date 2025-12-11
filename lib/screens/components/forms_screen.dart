import 'package:flutter/material.dart';

/// 表单组件演示
class FormsScreen extends StatefulWidget {
  const FormsScreen({super.key});

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  
  String? _selectedCategory;
  bool _agreeToTerms = false;
  double _rating = 3.0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('表单组件'),
        backgroundColor: colorScheme.surfaceContainer,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 基本信息
            _buildSection(
              '基本信息',
              [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: '姓名',
                    hintText: '请输入您的姓名',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入姓名';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: '邮箱',
                    hintText: 'example@email.com',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
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
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: '手机号',
                    hintText: '请输入手机号',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入手机号';
                    }
                    return null;
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 交易信息
            _buildSection(
              '交易信息',
              [
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: '分类',
                    prefixIcon: Icon(Icons.category),
                    border: OutlineInputBorder(),
                  ),
                  items: ['餐饮', '交通', '购物', '娱乐', '其他']
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _selectedCategory = value);
                  },
                  validator: (value) {
                    if (value == null) {
                      return '请选择分类';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: '金额',
                    hintText: '0.00',
                    prefixIcon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                    suffixText: '元',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入金额';
                    }
                    if (double.tryParse(value) == null) {
                      return '请输入有效的金额';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '评分: ${_rating.toStringAsFixed(1)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Slider(
                      value: _rating,
                      min: 0,
                      max: 5,
                      divisions: 10,
                      label: _rating.toStringAsFixed(1),
                      onChanged: (value) {
                        setState(() => _rating = value);
                      },
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 协议确认
            CheckboxListTile(
              value: _agreeToTerms,
              onChanged: (value) {
                setState(() => _agreeToTerms = value ?? false);
              },
              title: const Text('我同意服务条款和隐私政策'),
              controlAffinity: ListTileControlAffinity.leading,
            ),

            const SizedBox(height: 24),

            // 提交按钮
            FilledButton.icon(
              onPressed: _submitForm,
              icon: const Icon(Icons.check),
              label: const Text('提交表单'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _resetForm,
              icon: const Icon(Icons.refresh),
              label: const Text('重置表单'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('请同意服务条款'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('表单提交成功！'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _amountController.clear();
    setState(() {
      _selectedCategory = null;
      _agreeToTerms = false;
      _rating = 3.0;
    });
  }
}
