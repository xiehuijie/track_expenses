import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MoneyInputScreen extends StatefulWidget {
  const MoneyInputScreen({super.key});

  @override
  State<MoneyInputScreen> createState() => _MoneyInputScreenState();
}

class _MoneyInputScreenState extends State<MoneyInputScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _displayAmount = '0.00';

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onNumberPressed(String value) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_displayAmount == '0.00') {
        _displayAmount = '0.0$value';
      } else {
        // Remove the decimal point, add the new digit, then reformat
        String withoutDecimal = _displayAmount.replaceAll('.', '');
        withoutDecimal += value;
        // Keep only the last meaningful digits
        if (withoutDecimal.length > 10) {
          withoutDecimal = withoutDecimal.substring(withoutDecimal.length - 10);
        }
        // Insert decimal point 2 digits from the right
        int length = withoutDecimal.length;
        _displayAmount = '${withoutDecimal.substring(0, length - 2)}.${withoutDecimal.substring(length - 2)}';
      }
      _amountController.text = _displayAmount;
    });
  }

  void _onBackspace() {
    HapticFeedback.selectionClick();
    setState(() {
      String withoutDecimal = _displayAmount.replaceAll('.', '');
      if (withoutDecimal.length > 2) {
        withoutDecimal = withoutDecimal.substring(0, withoutDecimal.length - 1);
        int length = withoutDecimal.length;
        _displayAmount = '${withoutDecimal.substring(0, length - 2)}.${withoutDecimal.substring(length - 2)}';
      } else {
        _displayAmount = '0.00';
      }
      _amountController.text = _displayAmount;
    });
  }

  void _onClear() {
    HapticFeedback.mediumImpact();
    setState(() {
      _displayAmount = '0.00';
      _amountController.text = _displayAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('金额输入'),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '输入金额',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '¥',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _displayAmount,
                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                        color: colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '常用金额',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildQuickAmount('10'),
                              _buildQuickAmount('50'),
                              _buildQuickAmount('100'),
                              _buildQuickAmount('200'),
                              _buildQuickAmount('500'),
                              _buildQuickAmount('1000'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildKeypad(),
        ],
      ),
    );
  }

  Widget _buildQuickAmount(String amount) {
    return ActionChip(
      label: Text('¥$amount'),
      onPressed: () {
        HapticFeedback.selectionClick();
        setState(() {
          _displayAmount = '$amount.00';
          _amountController.text = _displayAmount;
        });
      },
    );
  }

  Widget _buildKeypad() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              _buildKeypadButton('1'),
              _buildKeypadButton('2'),
              _buildKeypadButton('3'),
            ],
          ),
          Row(
            children: [
              _buildKeypadButton('4'),
              _buildKeypadButton('5'),
              _buildKeypadButton('6'),
            ],
          ),
          Row(
            children: [
              _buildKeypadButton('7'),
              _buildKeypadButton('8'),
              _buildKeypadButton('9'),
            ],
          ),
          Row(
            children: [
              _buildKeypadButton('C', onPressed: _onClear, color: colorScheme.error),
              _buildKeypadButton('0'),
              _buildKeypadButton('⌫', onPressed: _onBackspace),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('金额: ¥$_displayAmount')),
                );
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('确认', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadButton(String value, {VoidCallback? onPressed, Color? color}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Material(
          color: color ?? Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onPressed ?? () => _onNumberPressed(value),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 60,
              alignment: Alignment.center,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color != null ? Theme.of(context).colorScheme.onError : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
