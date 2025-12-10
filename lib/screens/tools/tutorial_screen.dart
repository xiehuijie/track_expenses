import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final GlobalKey _keyButton1 = GlobalKey();
  final GlobalKey _keyButton2 = GlobalKey();
  final GlobalKey _keyButton3 = GlobalKey();
  final GlobalKey _keyButton4 = GlobalKey();
  TutorialCoachMark? _tutorialCoachMark;

  @override
  void dispose() {
    _tutorialCoachMark?.finish();
    super.dispose();
  }

  void _showTutorial() {
    _tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black,
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('教程完成！')),
        );
      },
      onSkip: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('教程已跳过')),
        );
        return true;
      },
    );
    _tutorialCoachMark?.show(context: context);
  }

  List<TargetFocus> _createTargets() {
    return [
      TargetFocus(
        identify: "Target 1",
        keyTarget: _keyButton1,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "欢迎使用！",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 24.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "这是第一个按钮，点击它可以执行某些操作。",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => controller.next(),
                      child: const Text("下一步"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "Target 2",
        keyTarget: _keyButton2,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "第二步",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 24.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "这个按钮具有不同的功能，可以用来切换设置。",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => controller.next(),
                      child: const Text("下一步"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "Target 3",
        keyTarget: _keyButton3,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "第三步",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 24.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "这里可以查看更多信息。",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => controller.next(),
                      child: const Text("下一步"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "Target 4",
        keyTarget: _keyButton4,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "完成！",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 24.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "最后一个按钮，用于保存你的设置。",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => controller.next(),
                      child: const Text("完成"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('引导教程'),
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
                      '功能引导演示',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '点击"开始教程"按钮，系统将引导你了解各个功能按钮的用途。',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _showTutorial,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('开始教程'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '功能按钮',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureButton(
                      key: _keyButton1,
                      icon: Icons.home,
                      title: '主页',
                      description: '返回应用主页',
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureButton(
                      key: _keyButton2,
                      icon: Icons.settings,
                      title: '设置',
                      description: '调整应用设置和偏好',
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureButton(
                      key: _keyButton3,
                      icon: Icons.info,
                      title: '关于',
                      description: '查看应用信息',
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureButton(
                      key: _keyButton4,
                      icon: Icons.save,
                      title: '保存',
                      description: '保存当前设置',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '提示',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '• 在教程过程中，页面会高亮显示当前讲解的功能\n'
                      '• 可以点击"下一步"继续或"跳过"结束教程\n'
                      '• 教程结束后可以再次启动',
                      style: TextStyle(fontSize: 14, height: 1.5),
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

  Widget _buildFeatureButton({
    required Key key,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('点击了 $title')),
          );
        },
      ),
    );
  }
}
