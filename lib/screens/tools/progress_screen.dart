import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  double _progressValue = 0.6;
  int _stepValue = 30;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('进度指示器'),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection(
              title: '线性进度条',
              child: Column(
                children: [
                  LinearProgressIndicator(value: _progressValue),
                  const SizedBox(height: 16),
                  LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width - 64,
                    lineHeight: 20.0,
                    percent: _progressValue,
                    center: Text(
                      '${(_progressValue * 100).toInt()}%',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    progressColor: colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Slider(
                    value: _progressValue,
                    onChanged: (value) =>
                        setState(() => _progressValue = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: '圆形进度条',
              child: Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: [
                  CircularPercentIndicator(
                    radius: 60.0,
                    lineWidth: 13.0,
                    animation: true,
                    percent: _progressValue,
                    center: Text(
                      '${(_progressValue * 100).toInt()}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: colorScheme.primary,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                  ),
                  CircularPercentIndicator(
                    radius: 60.0,
                    lineWidth: 13.0,
                    animation: true,
                    percent: 0.7,
                    center: const Icon(
                      Icons.check,
                      size: 40.0,
                      color: Colors.green,
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: Colors.green,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                  ),
                  CircularPercentIndicator(
                    radius: 60.0,
                    lineWidth: 13.0,
                    animation: true,
                    percent: 0.3,
                    center: const Text(
                      '30/100',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    circularStrokeCap: CircularStrokeCap.butt,
                    progressColor: colorScheme.secondary,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: '步骤进度条',
              child: Column(
                children: [
                  StepProgressIndicator(
                    totalSteps: 100,
                    currentStep: _stepValue,
                    size: 10,
                    padding: 0,
                    selectedColor: colorScheme.primary,
                    unselectedColor: colorScheme.surfaceContainerHighest,
                    roundedEdges: const Radius.circular(10),
                  ),
                  const SizedBox(height: 16),
                  StepProgressIndicator(
                    totalSteps: 10,
                    currentStep: (_stepValue / 10).round(),
                    size: 30,
                    selectedColor: colorScheme.secondary,
                    unselectedColor: colorScheme.surfaceContainerHighest,
                    customStep: (index, color, _) => Container(
                      color: color,
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('当前步骤: $_stepValue / 100'),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (_stepValue > 0) {
                                setState(() => _stepValue -= 10);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              if (_stepValue < 100) {
                                setState(() => _stepValue += 10);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: '多彩进度条',
              child: Column(
                children: [
                  StepProgressIndicator(
                    totalSteps: 100,
                    currentStep: 75,
                    size: 15,
                    selectedGradientColor: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primary,
                        colorScheme.secondary,
                        colorScheme.tertiary,
                      ],
                    ),
                    unselectedColor: colorScheme.surfaceContainerHighest,
                    roundedEdges: const Radius.circular(10),
                  ),
                  const SizedBox(height: 16),
                  StepProgressIndicator(
                    totalSteps: 20,
                    currentStep: 12,
                    size: 8,
                    selectedColor: Colors.green,
                    unselectedColor: colorScheme.surfaceContainerHighest,
                    customSize: (index, _) => (index + 1) * 2,
                  ),
                ],
              ),
            ),
          ],
        ),
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
}
