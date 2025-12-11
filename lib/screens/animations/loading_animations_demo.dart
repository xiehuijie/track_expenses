import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoadingAnimationsDemoScreen extends StatefulWidget {
  const LoadingAnimationsDemoScreen({super.key});

  @override
  State<LoadingAnimationsDemoScreen> createState() => _LoadingAnimationsDemoScreenState();
}

class _LoadingAnimationsDemoScreenState extends State<LoadingAnimationsDemoScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _spinController;
  late AnimationController _waveController;
  late AnimationController _dotController;
  late AnimationController _skeletonController;

  bool _showSkeletonDemo = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _spinController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat();

    _waveController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();

    _dotController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat();

    _skeletonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _spinController.dispose();
    _waveController.dispose();
    _dotController.dispose();
    _skeletonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('加载动画'), backgroundColor: colorScheme.inversePrimary),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 脉冲加载
            _buildAnimationCard(
              context,
              title: '脉冲加载',
              description: '缩放动画效果',
              child: _buildPulseLoader(colorScheme),
            ),
            const SizedBox(height: 16),
            // 旋转加载
            _buildAnimationCard(
              context,
              title: '旋转加载',
              description: '多种旋转样式',
              child: _buildSpinLoaders(colorScheme),
            ),
            const SizedBox(height: 16),
            // 波浪加载
            _buildAnimationCard(
              context,
              title: '波浪加载',
              description: '波浪扩散效果',
              child: _buildWaveLoader(colorScheme),
            ),
            const SizedBox(height: 16),
            // 跳动点
            _buildAnimationCard(
              context,
              title: '跳动加载',
              description: '点状弹跳动画',
              child: _buildDotLoader(colorScheme),
            ),
            const SizedBox(height: 16),
            // 骨架屏
            _buildAnimationCard(
              context,
              title: '骨架屏加载',
              description: '内容占位动画',
              child: _buildSkeletonLoader(colorScheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimationCard(
    BuildContext context, {
    required String title,
    required String description,
    required Widget child,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildPulseLoader(ColorScheme colorScheme) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 单个脉冲
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 0.8 + 0.4 * _pulseController.value,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(1 - 0.5 * _pulseController.value),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
          // 嵌套脉冲
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              alignment: Alignment.center,
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    final delay = index * 0.3;
                    final value = (_pulseController.value + delay) % 1.0;
                    return Container(
                      width: 20 + 40 * value,
                      height: 20 + 40 * value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.primary.withOpacity(1 - value),
                          width: 2,
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
          // Logo 脉冲
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 0.9 + 0.2 * sin(_pulseController.value * pi),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.flutter_dash, color: colorScheme.onPrimary),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSpinLoaders(ColorScheme colorScheme) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 基础旋转
          AnimatedBuilder(
            animation: _spinController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _spinController.value * 2 * pi,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.surfaceContainerHighest, width: 4),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 14,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // 渐变旋转
          AnimatedBuilder(
            animation: _spinController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _spinController.value * 2 * pi,
                child: CustomPaint(
                  size: const Size(40, 40),
                  painter: GradientSpinnerPainter(color: colorScheme.primary, strokeWidth: 4),
                ),
              );
            },
          ),
          // 多色旋转
          AnimatedBuilder(
            animation: _spinController,
            builder: (context, child) {
              return SizedBox(
                width: 40,
                height: 40,
                child: Stack(
                  alignment: Alignment.center,
                  children: List.generate(8, (index) {
                    final angle = index * pi / 4;
                    final opacity = (index + 1) / 8;
                    return Transform.rotate(
                      angle: angle + _spinController.value * 2 * pi,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: 6,
                          height: 12,
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(opacity),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWaveLoader(ColorScheme colorScheme) {
    return Center(
      child: SizedBox(
        width: 200,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                final delay = index * 0.1;
                final value = sin((_waveController.value + delay) * 2 * pi);
                return Container(
                  width: 12,
                  height: 20 + 20 * (value + 1) / 2,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _buildDotLoader(ColorScheme colorScheme) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 跳动点
          SizedBox(
            width: 80,
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _dotController,
                  builder: (context, child) {
                    final delay = index * 0.2;
                    final progress = (_dotController.value + delay) % 1.0;
                    final bounce = sin(progress * pi);
                    return Transform.translate(
                      offset: Offset(0, -15 * bounce),
                      child: Container(
                        width: 12,
                        height: 12,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
          // 缩放点
          SizedBox(
            width: 80,
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _dotController,
                  builder: (context, child) {
                    final delay = index * 0.2;
                    final progress = (_dotController.value + delay) % 1.0;
                    final scale = 0.5 + 0.5 * sin(progress * pi);
                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 12,
                        height: 12,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader(ColorScheme colorScheme) {
    return Column(
      children: [
        // 演示按钮
        FilledButton.tonalIcon(
          onPressed: () {
            HapticFeedback.lightImpact();
            setState(() => _showSkeletonDemo = !_showSkeletonDemo);
          },
          icon: Icon(_showSkeletonDemo ? Icons.visibility_off : Icons.visibility),
          label: Text(_showSkeletonDemo ? '隐藏骨架屏' : '显示骨架屏'),
        ),
        const SizedBox(height: 16),
        // 骨架屏效果
        if (_showSkeletonDemo)
          AnimatedBuilder(
            animation: _skeletonController,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildShimmerBox(60, 60, true),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildShimmerBox(double.infinity, 16, false),
                              const SizedBox(height: 8),
                              _buildShimmerBox(150, 12, false),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildShimmerBox(double.infinity, 120, false),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildShimmerBox(double.infinity, 36, false)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildShimmerBox(double.infinity, 36, false)),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildShimmerBox(double width, double height, bool isCircle) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseColor = colorScheme.surfaceContainerHigh;
    final highlightColor = colorScheme.surface;

    return AnimatedBuilder(
      animation: _skeletonController,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isCircle ? null : BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [baseColor, highlightColor, baseColor],
              stops: [0.0, _skeletonController.value, 1.0],
            ),
          ),
        );
      },
    );
  }
}

class GradientSpinnerPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  GradientSpinnerPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = SweepGradient(
        colors: [color.withOpacity(0), color],
        stops: const [0.0, 1.0],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect.deflate(strokeWidth / 2), 0, 2 * pi * 0.75, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
