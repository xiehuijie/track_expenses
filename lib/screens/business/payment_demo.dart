import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentDemoScreen extends StatefulWidget {
  const PaymentDemoScreen({super.key});

  @override
  State<PaymentDemoScreen> createState() => _PaymentDemoScreenState();
}

class _PaymentDemoScreenState extends State<PaymentDemoScreen> {
  int _selectedPaymentMethod = 0;
  bool _isProcessing = false;
  bool _paymentSuccess = false;
  late ConfettiController _confettiController;

  final List<_PaymentMethod> _paymentMethods = [
    _PaymentMethod(name: '微信支付', icon: Icons.chat_bubble, color: Colors.green, balance: 1888.88),
    _PaymentMethod(
      name: '支付宝',
      icon: Icons.account_balance_wallet,
      color: Colors.blue,
      balance: 2666.66,
    ),
    _PaymentMethod(
      name: '银行卡',
      icon: Icons.credit_card,
      color: Colors.orange,
      cardNumber: '**** **** **** 8888',
    ),
    _PaymentMethod(name: 'Apple Pay', icon: Icons.apple, color: Colors.black),
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    // 模拟支付处理
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
      _paymentSuccess = true;
    });

    _confettiController.play();
    HapticFeedback.heavyImpact();
  }

  void _resetPayment() {
    setState(() {
      _paymentSuccess = false;
      _selectedPaymentMethod = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('支付组件'), backgroundColor: colorScheme.inversePrimary),
      body: Stack(
        children: [
          _paymentSuccess ? _buildSuccessView(colorScheme) : _buildPaymentView(colorScheme),
          // 烟花效果
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: math.pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.1,
              colors: [
                colorScheme.primary,
                colorScheme.secondary,
                colorScheme.tertiary,
                Colors.yellow,
                Colors.pink,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentView(ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 订单信息
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '订单信息',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Divider(height: 24),
                  _buildOrderItem('商品名称', 'Flutter 高级开发课程'),
                  _buildOrderItem('订单编号', '2024010112345678'),
                  _buildOrderItem('创建时间', '2024-01-01 12:00:00'),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('支付金额', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        '¥ 199.00',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 支付方式
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '选择支付方式',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ..._paymentMethods.asMap().entries.map((entry) {
                    return _buildPaymentMethodTile(entry.key, entry.value, colorScheme);
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 支付按钮
          FilledButton(
            onPressed: _isProcessing ? null : _processPayment,
            style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            child: _isProcessing
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('处理中...'),
                    ],
                  )
                : const Text('立即支付 ¥199.00'),
          ),
          const SizedBox(height: 16),

          // 安全提示
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.security, size: 16, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Text(
                '安全支付由 Flutter Pay 提供保障',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodTile(int index, _PaymentMethod method, ColorScheme colorScheme) {
    final isSelected = _selectedPaymentMethod == index;

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          _selectedPaymentMethod = index;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? colorScheme.primaryContainer.withValues(alpha: 0.3) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: method.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(method.icon, color: method.color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.name,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  if (method.balance != null)
                    Text(
                      '余额: ¥${method.balance!.toStringAsFixed(2)}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  if (method.cardNumber != null)
                    Text(
                      method.cardNumber!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                ],
              ),
            ),
            Radio<int>(
              value: index,
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                HapticFeedback.selectionClick();
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessView(ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(color: Colors.green.shade100, shape: BoxShape.circle),
              child: const Icon(Icons.check, size: 60, color: Colors.green),
            ),
            const SizedBox(height: 32),
            Text(
              '支付成功',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '¥ 199.00',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '支付方式: ${_paymentMethods[_selectedPaymentMethod].name}',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 48),
            FilledButton(onPressed: _resetPayment, child: const Text('返回')),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('查看订单详情'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethod {
  final String name;
  final IconData icon;
  final Color color;
  final double? balance;
  final String? cardNumber;

  _PaymentMethod({
    required this.name,
    required this.icon,
    required this.color,
    this.balance,
    this.cardNumber,
  });
}
