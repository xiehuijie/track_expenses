import 'dart:math' as math;

import 'package:flutter/material.dart';

class ProgressDemoScreen extends StatefulWidget {
  const ProgressDemoScreen({super.key});

  @override
  State<ProgressDemoScreen> createState() => _ProgressDemoScreenState();
}

class _ProgressDemoScreenState extends State<ProgressDemoScreen> with TickerProviderStateMixin {
  late AnimationController _linearController;
  late AnimationController _circularController;
  late AnimationController _customController;
  double _sliderValue = 0.6;

  @override
  void initState() {
    super.initState();
    _linearController = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat();

    _circularController = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat();

    _customController = AnimationController(vsync: this, duration: const Duration(seconds: 4))
      ..repeat();
  }

  @override
  void dispose() {
    _linearController.dispose();
    _circularController.dispose();
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('进度条演示'), backgroundColor: colorScheme.inversePrimary),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 线性进度条
          _buildSection(
            context,
            title: '线性进度条',
            child: Column(
              children: [
                // 确定进度
                Row(
                  children: [
                    const Text('确定进度: '),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: _sliderValue,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text('${(_sliderValue * 100).toInt()}%'),
                  ],
                ),
                const SizedBox(height: 16),
                Slider(
                  value: _sliderValue,
                  onChanged: (value) => setState(() => _sliderValue = value),
                ),
                const SizedBox(height: 24),
                // 不确定进度
                const Row(
                  children: [
                    Text('不确定进度: '),
                    Expanded(child: LinearProgressIndicator()),
                  ],
                ),
                const SizedBox(height: 24),
                // 自定义颜色
                Row(
                  children: [
                    const Text('自定义颜色: '),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: 0.7,
                        minHeight: 12,
                        borderRadius: BorderRadius.circular(6),
                        backgroundColor: colorScheme.errorContainer,
                        valueColor: AlwaysStoppedAnimation<Color>(colorScheme.error),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 环形进度条
          _buildSection(
            context,
            title: '环形进度条',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: CircularProgressIndicator(
                            value: _sliderValue,
                            strokeWidth: 8,
                            backgroundColor: colorScheme.surfaceContainerHighest,
                          ),
                        ),
                        Text(
                          '${(_sliderValue * 100).toInt()}%',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('确定进度'),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(strokeWidth: 8),
                    ),
                    const SizedBox(height: 8),
                    const Text('不确定进度'),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: 0.75,
                        strokeWidth: 12,
                        backgroundColor: colorScheme.tertiaryContainer,
                        valueColor: AlwaysStoppedAnimation<Color>(colorScheme.tertiary),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('圆角样式'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 自定义进度条
          _buildSection(
            context,
            title: '自定义进度条',
            child: Column(
              children: [
                // 渐变进度条
                _GradientProgressBar(
                  value: _sliderValue,
                  height: 20,
                  gradient: LinearGradient(colors: [colorScheme.primary, colorScheme.tertiary]),
                ),
                const SizedBox(height: 8),
                const Text('渐变进度条'),
                const SizedBox(height: 24),

                // 分段进度条
                _SegmentedProgressBar(
                  value: _sliderValue,
                  segmentCount: 5,
                  height: 16,
                  activeColor: colorScheme.primary,
                  inactiveColor: colorScheme.surfaceContainerHighest,
                ),
                const SizedBox(height: 8),
                const Text('分段进度条'),
                const SizedBox(height: 24),

                // 波浪进度条
                SizedBox(
                  height: 100,
                  child: _WaveProgressIndicator(
                    value: _sliderValue,
                    color: colorScheme.primary,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('波浪进度条'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 步骤进度条
          _buildSection(
            context,
            title: '步骤进度指示器',
            child: _StepProgressIndicator(
              currentStep: ((_sliderValue * 4).round()).clamp(0, 4),
              totalSteps: 5,
              activeColor: colorScheme.primary,
              completedColor: colorScheme.primaryContainer,
              inactiveColor: colorScheme.surfaceContainerHighest,
              stepLabels: const ['开始', '填写信息', '确认', '支付', '完成'],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required Widget child}) {
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
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

// 渐变进度条
class _GradientProgressBar extends StatelessWidget {
  final double value;
  final double height;
  final Gradient gradient;

  const _GradientProgressBar({required this.value, required this.height, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: constraints.maxWidth * value.clamp(0.0, 1.0),
                height: height,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// 分段进度条
class _SegmentedProgressBar extends StatelessWidget {
  final double value;
  final int segmentCount;
  final double height;
  final Color activeColor;
  final Color inactiveColor;

  const _SegmentedProgressBar({
    required this.value,
    required this.segmentCount,
    required this.height,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final activeSegments = (value * segmentCount).ceil();

    return Row(
      children: List.generate(segmentCount, (index) {
        final isActive = index < activeSegments;
        return Expanded(
          child: Container(
            height: height,
            margin: EdgeInsets.only(right: index < segmentCount - 1 ? 4 : 0),
            decoration: BoxDecoration(
              color: isActive ? activeColor : inactiveColor,
              borderRadius: BorderRadius.circular(height / 2),
            ),
          ),
        );
      }),
    );
  }
}

// 波浪进度条
class _WaveProgressIndicator extends StatefulWidget {
  final double value;
  final Color color;
  final Color backgroundColor;

  const _WaveProgressIndicator({
    required this.value,
    required this.color,
    required this.backgroundColor,
  });

  @override
  State<_WaveProgressIndicator> createState() => _WaveProgressIndicatorState();
}

class _WaveProgressIndicatorState extends State<_WaveProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _WavePainter(
                value: widget.value,
                wavePhase: _controller.value,
                color: widget.color,
              ),
              child: Center(
                child: Text(
                  '${(widget.value * 100).toInt()}%',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final double value;
  final double wavePhase;
  final Color color;

  _WavePainter({required this.value, required this.wavePhase, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = 10.0;
    final baseHeight = size.height * (1 - value);

    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y =
          baseHeight +
          math.sin((x / size.width * 4 * math.pi) + (wavePhase * 2 * math.pi)) * waveHeight;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // 第二层波浪
    final paint2 = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y =
          baseHeight +
          math.sin((x / size.width * 3 * math.pi) + (wavePhase * 2 * math.pi) + math.pi / 2) *
              waveHeight *
              0.8;
      path2.lineTo(x, y);
    }

    path2.lineTo(size.width, size.height);
    path2.close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.wavePhase != wavePhase;
  }
}

// 步骤进度指示器
class _StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final Color activeColor;
  final Color completedColor;
  final Color inactiveColor;
  final List<String> stepLabels;

  const _StepProgressIndicator({
    required this.currentStep,
    required this.totalSteps,
    required this.activeColor,
    required this.completedColor,
    required this.inactiveColor,
    required this.stepLabels,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps * 2 - 1, (index) {
            if (index.isEven) {
              final stepIndex = index ~/ 2;
              final isCompleted = stepIndex < currentStep;
              final isActive = stepIndex == currentStep;

              return Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? activeColor
                      : isActive
                      ? activeColor
                      : inactiveColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : Text(
                          '${stepIndex + 1}',
                          style: TextStyle(
                            color: isActive ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              );
            } else {
              final lineIndex = index ~/ 2;
              final isCompleted = lineIndex < currentStep;

              return Expanded(
                child: Container(height: 3, color: isCompleted ? activeColor : inactiveColor),
              );
            }
          }),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: stepLabels.map((label) {
            return SizedBox(
              width: 60,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
