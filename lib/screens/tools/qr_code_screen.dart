import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({super.key});

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  final TextEditingController _textController = TextEditingController(text: 'https://flutter.dev');
  String _qrData = 'https://flutter.dev';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('二维码'),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '生成二维码',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        labelText: '输入内容',
                        hintText: '输入要生成二维码的内容',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () {
                        setState(() {
                          _qrData = _textController.text;
                        });
                      },
                      icon: const Icon(Icons.qr_code),
                      label: const Text('生成'),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '二维码预览',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: QrImageView(
                        data: _qrData,
                        version: QrVersions.auto,
                        size: 250.0,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        errorStateBuilder: (context, error) {
                          return const Center(
                            child: Text(
                              '无法生成二维码',
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '内容: $_qrData',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
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
                      '自定义样式',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildCustomQrCode(
                          '彩色',
                          foregroundColor: colorScheme.primary,
                        ),
                        _buildCustomQrCode(
                          '圆角',
                          gapless: true,
                          shape: QrDataModuleShape.circle,
                        ),
                        _buildCustomQrCode(
                          '次要色',
                          foregroundColor: colorScheme.secondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomQrCode(
    String label, {
    ImageProvider? embeddedImage,
    Color? foregroundColor,
    bool gapless = false,
    QrDataModuleShape? shape,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: QrImageView(
            data: _qrData,
            version: QrVersions.auto,
            size: 100.0,
            backgroundColor: Colors.white,
            foregroundColor: foregroundColor ?? Colors.black,
            embeddedImage: embeddedImage,
            embeddedImageStyle: const QrEmbeddedImageStyle(
              size: Size(30, 30),
            ),
            gapless: gapless,
            dataModuleStyle: QrDataModuleStyle(
              dataModuleShape: shape ?? QrDataModuleShape.square,
              color: foregroundColor ?? Colors.black,
            ),
            errorStateBuilder: (context, error) {
              return const SizedBox(
                width: 100,
                height: 100,
                child: Center(child: Icon(Icons.error, color: Colors.red)),
              );
            },
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
