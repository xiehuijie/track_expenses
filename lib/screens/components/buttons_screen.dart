import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ButtonsScreen extends StatefulWidget {
  const ButtonsScreen({super.key});

  @override
  State<ButtonsScreen> createState() => _ButtonsScreenState();
}

class _ButtonsScreenState extends State<ButtonsScreen> {
  bool _isLoading = false;
  int _selectedIndex = 0;

  void _triggerHaptic() {
    HapticFeedback.mediumImpact();
  }

  void _triggerLightHaptic() {
    HapticFeedback.lightImpact();
  }

  void _triggerHeavyHaptic() {
    HapticFeedback.heavyImpact();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('按钮组件'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection(
              title: 'Elevated Button',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _triggerHaptic();
                      _showSnackBar('Elevated Button 被点击');
                    },
                    child: const Text('默认'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _triggerHaptic();
                      _showSnackBar('带图标按钮被点击');
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('带图标'),
                  ),
                  ElevatedButton(onPressed: null, child: const Text('禁用')),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            _triggerHaptic();
                            setState(() => _isLoading = true);
                            await Future.delayed(const Duration(seconds: 2));
                            setState(() => _isLoading = false);
                          },
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('加载状态'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Filled Button',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton(
                    onPressed: () {
                      _triggerHaptic();
                      _showSnackBar('Filled Button 被点击');
                    },
                    child: const Text('默认'),
                  ),
                  FilledButton.tonal(
                    onPressed: () {
                      _triggerLightHaptic();
                      _showSnackBar('Tonal Button 被点击');
                    },
                    child: const Text('Tonal'),
                  ),
                  FilledButton.icon(
                    onPressed: () {
                      _triggerHaptic();
                    },
                    icon: const Icon(Icons.favorite),
                    label: const Text('带图标'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Outlined Button',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      _triggerLightHaptic();
                      _showSnackBar('Outlined Button 被点击');
                    },
                    child: const Text('默认'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      _triggerLightHaptic();
                    },
                    icon: const Icon(Icons.bookmark_border),
                    label: const Text('带图标'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Text Button',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  TextButton(
                    onPressed: () {
                      _triggerLightHaptic();
                      _showSnackBar('Text Button 被点击');
                    },
                    child: const Text('默认'),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      _triggerLightHaptic();
                    },
                    icon: const Icon(Icons.info_outline),
                    label: const Text('带图标'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Icon Button',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  IconButton(
                    onPressed: () {
                      _triggerLightHaptic();
                      _showSnackBar('Icon Button 被点击');
                    },
                    icon: const Icon(Icons.favorite_border),
                  ),
                  IconButton.filled(
                    onPressed: () {
                      _triggerHaptic();
                    },
                    icon: const Icon(Icons.add),
                  ),
                  IconButton.filledTonal(
                    onPressed: () {
                      _triggerLightHaptic();
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton.outlined(
                    onPressed: () {
                      _triggerLightHaptic();
                    },
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Floating Action Button',
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  FloatingActionButton.small(
                    heroTag: 'fab_small',
                    onPressed: () {
                      _triggerHaptic();
                      _showSnackBar('小型 FAB 被点击');
                    },
                    child: const Icon(Icons.add),
                  ),
                  FloatingActionButton(
                    heroTag: 'fab_normal',
                    onPressed: () {
                      _triggerHeavyHaptic();
                      _showSnackBar('FAB 被点击');
                    },
                    child: const Icon(Icons.navigation),
                  ),
                  FloatingActionButton.large(
                    heroTag: 'fab_large',
                    onPressed: () {
                      _triggerHeavyHaptic();
                    },
                    child: const Icon(Icons.add_a_photo),
                  ),
                  FloatingActionButton.extended(
                    heroTag: 'fab_extended',
                    onPressed: () {
                      _triggerHeavyHaptic();
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('创建'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Segmented Button',
              child: SegmentedButton<int>(
                segments: const [
                  ButtonSegment(
                    value: 0,
                    label: Text('日'),
                    icon: Icon(Icons.wb_sunny),
                  ),
                  ButtonSegment(
                    value: 1,
                    label: Text('周'),
                    icon: Icon(Icons.date_range),
                  ),
                  ButtonSegment(
                    value: 2,
                    label: Text('月'),
                    icon: Icon(Icons.calendar_month),
                  ),
                ],
                selected: {_selectedIndex},
                onSelectionChanged: (Set<int> newSelection) {
                  _triggerLightHaptic();
                  setState(() {
                    _selectedIndex = newSelection.first;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: '触觉反馈演示',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '点击下列按钮体验不同的触觉反馈强度',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          _showSnackBar('轻触反馈');
                        },
                        child: const Text('轻触'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          _showSnackBar('中度反馈');
                        },
                        child: const Text('中度'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          HapticFeedback.heavyImpact();
                          _showSnackBar('重度反馈');
                        },
                        child: const Text('重度'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          _showSnackBar('选择反馈');
                        },
                        child: const Text('选择'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          HapticFeedback.vibrate();
                          _showSnackBar('震动');
                        },
                        child: const Text('震动'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
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
