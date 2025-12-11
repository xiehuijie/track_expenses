import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class EffectsScreen extends StatefulWidget {
  const EffectsScreen({super.key});

  @override
  State<EffectsScreen> createState() => _EffectsScreenState();
}

class _EffectsScreenState extends State<EffectsScreen>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('特效动画'),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSection(
                  title: '烟花庆祝效果',
                  child: Column(
                    children: [
                      const Text('点击按钮触发烟花效果', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () {
                          _confettiController.play();
                        },
                        icon: const Icon(Icons.celebration),
                        label: const Text('发射烟花 🎉'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: '缩放动画',
                  child: Column(
                    children: [
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () {
                          _scaleController.reset();
                          _scaleController.forward();
                        },
                        child: const Text('播放动画'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: '加载动画',
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildLoadingIndicator(
                        '圆形',
                        const CircularProgressIndicator(),
                      ),
                      _buildLoadingIndicator(
                        '线性',
                        const SizedBox(
                          width: 100,
                          child: LinearProgressIndicator(),
                        ),
                      ),
                      _buildLoadingIndicator(
                        '刷新',
                        const RefreshProgressIndicator(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: '脉搏动画',
                  child: Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 1000),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: 1.0 + (value * 0.2),
                          child: Opacity(
                            opacity: 1.0 - value,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colorScheme.secondary.withOpacity(0.5),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.notifications_active,
                                  color: colorScheme.secondary,
                                  size: 50,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      onEnd: () {
                        setState(() {});
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildSection(
                  title: '旋转动画',
                  child: Center(
                    child: RotationTransition(
                      turns: Tween<double>(
                        begin: 0.0,
                        end: 1.0,
                      ).animate(_rotationController),
                      child: Icon(
                        Icons.sync,
                        size: 60,
                        color: colorScheme.tertiary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.orange,
                Colors.purple,
              ],
              numberOfParticles: 30,
              gravity: 0.3,
            ),
          ),
        ],
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

  Widget _buildLoadingIndicator(String label, Widget indicator) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 50, height: 50, child: Center(child: indicator)),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
