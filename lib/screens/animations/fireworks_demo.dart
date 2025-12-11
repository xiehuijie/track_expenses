import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FireworksDemoScreen extends StatefulWidget {
  const FireworksDemoScreen({super.key});

  @override
  State<FireworksDemoScreen> createState() => _FireworksDemoScreenState();
}

class _FireworksDemoScreenState extends State<FireworksDemoScreen> with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late ConfettiController _topConfettiController;
  late AnimationController _fireworkController;
  final List<_Firework> _fireworks = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _topConfettiController = ConfettiController(duration: const Duration(seconds: 5));
    _fireworkController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))
          ..addListener(() {
            setState(() {
              _fireworks.removeWhere((f) => f.isDead);
            });
          });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _topConfettiController.dispose();
    _fireworkController.dispose();
    super.dispose();
  }

  void _launchFirework(Offset position) {
    HapticFeedback.mediumImpact();
    setState(() {
      _fireworks.add(
        _Firework(
          position: position,
          color: Color.fromARGB(
            255,
            _random.nextInt(256),
            _random.nextInt(256),
            _random.nextInt(256),
          ),
          startTime: DateTime.now(),
        ),
      );
    });
    _fireworkController.forward(from: 0);
  }

  void _playConfetti() {
    HapticFeedback.heavyImpact();
    _confettiController.play();
  }

  void _playTopConfetti() {
    HapticFeedback.heavyImpact();
    _topConfettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('烟花效果'), backgroundColor: colorScheme.inversePrimary),
      body: Stack(
        children: [
          // 主内容
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 说明卡片
                _buildInfoCard(context, colorScheme),
                const SizedBox(height: 16),
                // 点击区域
                _buildTapArea(context, colorScheme),
                const SizedBox(height: 16),
                // Confetti 控制
                _buildConfettiControls(context, colorScheme),
                const SizedBox(height: 16),
                // 预设效果
                _buildPresetEffects(context, colorScheme),
              ],
            ),
          ),
          // 烟花动画层
          ..._fireworks.map((firework) => _FireworkWidget(firework: firework)),
          // Confetti 中心
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _topConfettiController,
              blastDirection: pi / 2,
              blastDirectionality: BlastDirectionality.explosive,
              maxBlastForce: 20,
              minBlastForce: 8,
              emissionFrequency: 0.05,
              numberOfParticles: 25,
              gravity: 0.1,
              colors: const [
                Colors.red,
                Colors.orange,
                Colors.yellow,
                Colors.green,
                Colors.blue,
                Colors.purple,
                Colors.pink,
              ],
            ),
          ),
          // Confetti 底部
          Align(
            alignment: Alignment.bottomCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: -pi / 2,
              blastDirectionality: BlastDirectionality.explosive,
              maxBlastForce: 30,
              minBlastForce: 15,
              emissionFrequency: 0.08,
              numberOfParticles: 30,
              gravity: 0.2,
              shouldLoop: false,
              colors: const [
                Colors.red,
                Colors.orange,
                Colors.yellow,
                Colors.green,
                Colors.blue,
                Colors.purple,
              ],
              createParticlePath: (size) {
                final path = Path();
                path.addOval(Rect.fromCircle(center: Offset.zero, radius: 5));
                return path;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.celebration, size: 48, color: colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              '烟花与粒子效果',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '点击屏幕任意位置或使用下方按钮触发效果',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTapArea(BuildContext context, ColorScheme colorScheme) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: GestureDetector(
        onTapDown: (details) {
          _launchFirework(details.localPosition);
        },
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [colorScheme.primaryContainer, colorScheme.surface],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.touch_app,
                  size: 48,
                  color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                ),
                const SizedBox(height: 8),
                Text(
                  '点击此区域放烟花',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfettiControls(BuildContext context, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confetti 彩纸效果',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _playConfetti,
                    icon: const Icon(Icons.arrow_upward),
                    label: const Text('底部喷射'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.tonalIcon(
                    onPressed: _playTopConfetti,
                    icon: const Icon(Icons.arrow_downward),
                    label: const Text('顶部掉落'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetEffects(BuildContext context, ColorScheme colorScheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '预设效果',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildEffectChip('🎆 烟花表演', () => _multiFireworks(), Colors.red),
                _buildEffectChip('🎉 庆祝效果', () {
                  _playConfetti();
                  _playTopConfetti();
                }, Colors.orange),
                _buildEffectChip('✨ 星光闪烁', () => _starBurst(), Colors.amber),
                _buildEffectChip('🌈 彩虹烟花', () => _rainbowFireworks(), Colors.purple),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEffectChip(String label, VoidCallback onTap, Color color) {
    return ActionChip(
      avatar: CircleAvatar(backgroundColor: color.withOpacity(0.2), child: null),
      label: Text(label),
      onPressed: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
    );
  }

  void _multiFireworks() {
    final size = MediaQuery.of(context).size;
    for (int i = 0; i < 5; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        _launchFirework(
          Offset(_random.nextDouble() * (size.width - 100) + 50, _random.nextDouble() * 150 + 50),
        );
      });
    }
  }

  void _starBurst() {
    final size = MediaQuery.of(context).size;
    final center = Offset(size.width / 2, 100);
    for (int i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      final offset = Offset(center.dx + cos(angle) * 50, center.dy + sin(angle) * 50);
      Future.delayed(Duration(milliseconds: i * 100), () {
        _launchFirework(offset);
      });
    }
  }

  void _rainbowFireworks() {
    final size = MediaQuery.of(context).size;
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.purple,
    ];
    final spacing = (size.width - 100) / (colors.length - 1);
    for (int i = 0; i < colors.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        setState(() {
          _fireworks.add(
            _Firework(
              position: Offset(50 + i * spacing, 100),
              color: colors[i],
              startTime: DateTime.now(),
            ),
          );
        });
        _fireworkController.forward(from: 0);
      });
    }
  }
}

class _Firework {
  final Offset position;
  final Color color;
  final DateTime startTime;

  _Firework({required this.position, required this.color, required this.startTime});

  bool get isDead => DateTime.now().difference(startTime).inMilliseconds > 1000;

  double get progress {
    final elapsed = DateTime.now().difference(startTime).inMilliseconds;
    return (elapsed / 1000).clamp(0.0, 1.0);
  }
}

class _FireworkWidget extends StatelessWidget {
  final _Firework firework;
  final int particleCount = 30;

  const _FireworkWidget({required this.firework});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: firework.position.dx,
      top: firework.position.dy,
      child: CustomPaint(
        size: const Size(200, 200),
        painter: _FireworkPainter(
          color: firework.color,
          progress: firework.progress,
          particleCount: particleCount,
        ),
      ),
    );
  }
}

class _FireworkPainter extends CustomPainter {
  final Color color;
  final double progress;
  final int particleCount;
  final Random _random = Random(42);

  _FireworkPainter({required this.color, required this.progress, required this.particleCount});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(-size.width / 2, -size.height / 2);
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < particleCount; i++) {
      final angle = (i / particleCount) * 2 * pi + _random.nextDouble() * 0.3;
      final speed = 50 + _random.nextDouble() * 50;
      final particleProgress = Curves.easeOut.transform(progress);

      final x = center.dx + cos(angle) * speed * particleProgress;
      final y =
          center.dy + sin(angle) * speed * particleProgress + 20 * progress * progress; // 重力效果

      final opacity = (1 - progress).clamp(0.0, 1.0);
      final particleSize = 3 + _random.nextDouble() * 3;

      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), particleSize * (1 - progress * 0.5), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _FireworkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
