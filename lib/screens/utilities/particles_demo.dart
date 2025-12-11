import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class ParticlesDemoScreen extends StatefulWidget {
  const ParticlesDemoScreen({super.key});

  @override
  State<ParticlesDemoScreen> createState() => _ParticlesDemoScreenState();
}

class _ParticlesDemoScreenState extends State<ParticlesDemoScreen> {
  late ConfettiController _centerController;
  late ConfettiController _topController;
  late ConfettiController _leftController;
  late ConfettiController _rightController;

  @override
  void initState() {
    super.initState();
    _centerController = ConfettiController(duration: const Duration(seconds: 3));
    _topController = ConfettiController(duration: const Duration(seconds: 5));
    _leftController = ConfettiController(duration: const Duration(seconds: 3));
    _rightController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _centerController.dispose();
    _topController.dispose();
    _leftController.dispose();
    _rightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('粒子效果演示'), backgroundColor: colorScheme.inversePrimary),
      body: Stack(
        children: [
          // 中心爆发
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _centerController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: [
                colorScheme.primary,
                colorScheme.secondary,
                colorScheme.tertiary,
                colorScheme.error,
                Colors.yellow,
                Colors.green,
              ],
              numberOfParticles: 30,
              maxBlastForce: 50,
              minBlastForce: 20,
              emissionFrequency: 0.05,
              gravity: 0.3,
              createParticlePath: (size) {
                // 星形粒子
                final path = Path();
                const numberOfPoints = 5;
                final halfWidth = size.width / 2;
                final externalRadius = halfWidth;
                final internalRadius = halfWidth / 2.5;
                final degreesPerStep = _degreesToRadians(360 / numberOfPoints);
                final halfDegreesPerStep = degreesPerStep / 2;
                path.moveTo(size.width, halfWidth);
                for (var step = 1; step <= numberOfPoints; step++) {
                  path.lineTo(
                    halfWidth + externalRadius * cos(degreesPerStep * step),
                    halfWidth + externalRadius * sin(degreesPerStep * step),
                  );
                  path.lineTo(
                    halfWidth + internalRadius * cos(degreesPerStep * step + halfDegreesPerStep),
                    halfWidth + internalRadius * sin(degreesPerStep * step + halfDegreesPerStep),
                  );
                }
                path.close();
                return path;
              },
            ),
          ),
          // 顶部下落
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _topController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 1,
              emissionFrequency: 0.02,
              numberOfParticles: 20,
              gravity: 0.1,
              shouldLoop: true,
              colors: [
                Colors.white.withValues(alpha: 0.8),
                Colors.lightBlue.shade100,
                Colors.lightBlue.shade200,
              ],
              createParticlePath: (size) {
                // 雪花形状
                return Path()..addOval(
                  Rect.fromCircle(
                    center: Offset(size.width / 2, size.height / 2),
                    radius: size.width / 2,
                  ),
                );
              },
            ),
          ),
          // 左下角
          Align(
            alignment: Alignment.bottomLeft,
            child: ConfettiWidget(
              confettiController: _leftController,
              blastDirection: -pi / 4,
              maxBlastForce: 30,
              minBlastForce: 10,
              emissionFrequency: 0.05,
              numberOfParticles: 15,
              gravity: 0.2,
              colors: [
                colorScheme.primary,
                colorScheme.primaryContainer,
                Colors.orange,
                Colors.yellow,
              ],
            ),
          ),
          // 右下角
          Align(
            alignment: Alignment.bottomRight,
            child: ConfettiWidget(
              confettiController: _rightController,
              blastDirection: -3 * pi / 4,
              maxBlastForce: 30,
              minBlastForce: 10,
              emissionFrequency: 0.05,
              numberOfParticles: 15,
              gravity: 0.2,
              colors: [
                colorScheme.secondary,
                colorScheme.secondaryContainer,
                Colors.pink,
                Colors.purple,
              ],
            ),
          ),
          // 控制按钮
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '🎉 粒子效果',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '点击下方按钮触发不同的粒子效果',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 48),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      FilledButton.icon(
                        onPressed: () {
                          _centerController.play();
                        },
                        icon: const Icon(Icons.celebration),
                        label: const Text('中心爆发'),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: () {
                          if (_topController.state == ConfettiControllerState.playing) {
                            _topController.stop();
                          } else {
                            _topController.play();
                          }
                        },
                        icon: const Icon(Icons.ac_unit),
                        label: const Text('雪花飘落'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          _leftController.play();
                          _rightController.play();
                        },
                        icon: const Icon(Icons.auto_awesome),
                        label: const Text('双侧烟花'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          _centerController.play();
                          _leftController.play();
                          _rightController.play();
                        },
                        icon: const Icon(Icons.stars),
                        label: const Text('全部触发'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextButton.icon(
                    onPressed: () {
                      _centerController.stop();
                      _topController.stop();
                      _leftController.stop();
                      _rightController.stop();
                    },
                    icon: const Icon(Icons.stop),
                    label: const Text('停止所有'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }
}
