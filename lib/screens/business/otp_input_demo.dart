import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInputDemoScreen extends StatefulWidget {
  const OtpInputDemoScreen({super.key});

  @override
  State<OtpInputDemoScreen> createState() => _OtpInputDemoScreenState();
}

class _OtpInputDemoScreenState extends State<OtpInputDemoScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _countdown = 0;
  Timer? _timer;
  bool _isVerifying = false;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _countdown = 60;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _onCodeChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _verifyCode();
      }
    }
  }

  void _onKeyDown(RawKeyEvent event, int index) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String get _code => _controllers.map((c) => c.text).join();

  Future<void> _verifyCode() async {
    if (_code.length != 6) return;

    setState(() {
      _isVerifying = true;
    });

    // 模拟验证
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isVerifying = false;
    });

    // 模拟验证成功
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('验证码 $_code 验证成功！'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _clearCode() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('OTP验证码'), backgroundColor: colorScheme.inversePrimary),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            // 图标
            Icon(Icons.phonelink_lock, size: 80, color: colorScheme.primary),
            const SizedBox(height: 24),
            // 标题
            Text(
              '输入验证码',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '验证码已发送至 +86 138****8888',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // OTP 输入框
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 48,
                  child: RawKeyboardListener(
                    focusNode: FocusNode(),
                    onKey: (event) => _onKeyDown(event, index),
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: colorScheme.primary, width: 2),
                        ),
                        filled: true,
                        fillColor: _focusNodes[index].hasFocus
                            ? colorScheme.primaryContainer.withValues(alpha: 0.3)
                            : colorScheme.surfaceContainerHighest,
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) => _onCodeChanged(value, index),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            // 重新发送按钮
            Center(
              child: TextButton(
                onPressed: _countdown == 0
                    ? () {
                        HapticFeedback.lightImpact();
                        _startCountdown();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('验证码已发送'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    : null,
                child: Text(_countdown > 0 ? '重新发送 (${_countdown}s)' : '重新发送验证码'),
              ),
            ),
            const SizedBox(height: 16),
            // 清除按钮
            OutlinedButton.icon(
              onPressed: _clearCode,
              icon: const Icon(Icons.clear),
              label: const Text('清除'),
            ),
            const SizedBox(height: 16),
            // 验证按钮
            FilledButton(
              onPressed: _isVerifying || _code.length != 6 ? null : _verifyCode,
              child: _isVerifying
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('验证'),
            ),
            const Spacer(),
            // 分隔线样式的 OTP
            _buildAlternativeStyle(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildAlternativeStyle(ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '其他样式',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // 下划线样式
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return Container(
                  width: 40,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: index < _code.length ? colorScheme.primary : colorScheme.outline,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      index < _code.length ? _code[index] : '',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            // 圆形样式
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                final hasValue = index < _code.length;
                return Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: hasValue ? colorScheme.primary : colorScheme.surfaceContainerHighest,
                    border: Border.all(color: hasValue ? colorScheme.primary : colorScheme.outline),
                  ),
                  child: Center(
                    child: hasValue
                        ? Text(
                            _code[index],
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          )
                        : Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorScheme.outline,
                            ),
                          ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
