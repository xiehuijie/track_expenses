import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountInputDemoScreen extends StatefulWidget {
  const AmountInputDemoScreen({super.key});

  @override
  State<AmountInputDemoScreen> createState() => _AmountInputDemoScreenState();
}

class _AmountInputDemoScreenState extends State<AmountInputDemoScreen> {
  String _amount = '0';
  bool _hasDecimal = false;
  int _decimalPlaces = 0;

  void _onKeyPressed(String key) {
    HapticFeedback.lightImpact();

    setState(() {
      if (key == 'C') {
        _amount = '0';
        _hasDecimal = false;
        _decimalPlaces = 0;
      } else if (key == '⌫') {
        if (_amount.length > 1) {
          final lastChar = _amount[_amount.length - 1];
          if (lastChar == '.') {
            _hasDecimal = false;
          } else if (_hasDecimal) {
            _decimalPlaces--;
          }
          _amount = _amount.substring(0, _amount.length - 1);
        } else {
          _amount = '0';
        }
      } else if (key == '.') {
        if (!_hasDecimal) {
          _hasDecimal = true;
          _amount = '$_amount.';
        }
      } else {
        // 数字
        if (_hasDecimal && _decimalPlaces >= 2) return;
        if (_hasDecimal) _decimalPlaces++;

        if (_amount == '0' && key != '.') {
          _amount = key;
        } else {
          _amount = '$_amount$key';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('金额输入'), backgroundColor: colorScheme.inversePrimary),
      body: Column(
        children: [
          // 金额显示区域
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: colorScheme.surfaceContainerLow),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '输入金额',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      Text(
                        _formatAmount(_amount),
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '大写: ${_convertToChineseAmount(_amount)}',
                      style: TextStyle(color: colorScheme.onSecondaryContainer, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 数字键盘
          Expanded(
            flex: 3,
            child: Container(
              color: colorScheme.surface,
              child: Column(
                children: [
                  _buildKeyboardRow(['1', '2', '3'], colorScheme),
                  _buildKeyboardRow(['4', '5', '6'], colorScheme),
                  _buildKeyboardRow(['7', '8', '9'], colorScheme),
                  _buildKeyboardRow(['.', '0', '⌫'], colorScheme),
                  _buildBottomRow(colorScheme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyboardRow(List<String> keys, ColorScheme colorScheme) {
    return Expanded(child: Row(children: keys.map((key) => _buildKey(key, colorScheme)).toList()));
  }

  Widget _buildKey(String key, ColorScheme colorScheme) {
    final isBackspace = key == '⌫';

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onKeyPressed(key),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                width: 0.5,
              ),
            ),
            child: Center(
              child: isBackspace
                  ? Icon(Icons.backspace_outlined, color: colorScheme.onSurface, size: 28)
                  : Text(
                      key,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomRow(ColorScheme colorScheme) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: colorScheme.errorContainer,
              child: InkWell(
                onTap: () => _onKeyPressed('C'),
                child: Center(
                  child: Text(
                    '清除',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: colorScheme.onErrorContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Material(
              color: colorScheme.primary,
              child: InkWell(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('确认金额: ¥${_formatAmount(_amount)}'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Center(
                  child: Text(
                    '确认',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(String amount) {
    final value = double.tryParse(amount) ?? 0;
    if (amount.endsWith('.')) {
      return '${_formatNumber(value.toInt())}.';
    }
    if (amount.contains('.')) {
      final parts = amount.split('.');
      return '${_formatNumber(int.parse(parts[0]))}.${parts[1]}';
    }
    return _formatNumber(value.toInt());
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  String _convertToChineseAmount(String amount) {
    final value = double.tryParse(amount) ?? 0;
    if (value == 0) return '零元整';

    final units = ['', '拾', '佰', '仟', '万', '拾', '佰', '仟', '亿'];
    final digits = ['零', '壹', '贰', '叁', '肆', '伍', '陆', '柒', '捌', '玖'];

    final intPart = value.toInt();
    final decPart = ((value - intPart) * 100).round();

    String result = '';
    String numStr = intPart.toString();

    for (int i = 0; i < numStr.length; i++) {
      final digit = int.parse(numStr[i]);
      final unit = units[numStr.length - 1 - i];
      if (digit != 0) {
        result += digits[digit] + unit;
      } else if (result.isNotEmpty && !result.endsWith('零')) {
        result += '零';
      }
    }

    if (result.endsWith('零')) {
      result = result.substring(0, result.length - 1);
    }
    result += '元';

    if (decPart == 0) {
      result += '整';
    } else {
      final jiao = decPart ~/ 10;
      final fen = decPart % 10;
      if (jiao > 0) result += '${digits[jiao]}角';
      if (fen > 0) result += '${digits[fen]}分';
    }

    return result;
  }
}
