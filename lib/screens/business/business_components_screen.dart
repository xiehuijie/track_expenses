import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'amount_input_demo.dart';
import 'otp_input_demo.dart';
import 'payment_demo.dart';
import 'qr_scanner_demo.dart';

class BusinessComponentsScreen extends StatelessWidget {
  const BusinessComponentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final demos = [
      _DemoItem(
        title: '金额输入',
        subtitle: '自定义数字键盘、金额格式化',
        icon: Icons.attach_money,
        screen: const AmountInputDemoScreen(),
      ),
      _DemoItem(
        title: 'OTP验证码',
        subtitle: '短信验证码输入组件',
        icon: Icons.pin,
        screen: const OtpInputDemoScreen(),
      ),
      _DemoItem(
        title: '支付组件',
        subtitle: '支付方式选择、支付确认流程',
        icon: Icons.payment,
        screen: const PaymentDemoScreen(),
      ),
      _DemoItem(
        title: '二维码扫描',
        subtitle: '相机扫描二维码/条形码',
        icon: Icons.qr_code_scanner,
        screen: const QrScannerDemoScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('业务类组件'), backgroundColor: colorScheme.inversePrimary),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: demos.length,
        itemBuilder: (context, index) {
          final demo = demos[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: colorScheme.primaryContainer,
                child: Icon(demo.icon, color: colorScheme.onPrimaryContainer),
              ),
              title: Text(
                demo.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(demo.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.push(context, MaterialPageRoute(builder: (context) => demo.screen));
              },
            ),
          );
        },
      ),
    );
  }
}

class _DemoItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget screen;

  _DemoItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.screen,
  });
}
