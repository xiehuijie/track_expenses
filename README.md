# Flutter Material Design Showcase

一个全面展示 Flutter Material Design 组件和系统能力的示例应用程序。

## 📱 功能特性

### Material Design 组件
- **按钮组件**: ElevatedButton, FilledButton, OutlinedButton, TextButton, IconButton, FAB, SegmentedButton
- **输入组件**: TextField, TextFormField, SearchBar, DropdownMenu, DatePicker, TimePicker
- **选择组件**: Switch, Checkbox, Radio, Slider, Chips (Filter, Choice, Action, Input)
- **对话框组件**: AlertDialog, SimpleDialog, BottomSheet, SnackBar, Banner, Tooltip, PopupMenu
- **导航组件**: AppBar, SliverAppBar, TabBar, BottomNavigationBar, NavigationBar, NavigationRail, Drawer, Stepper
- **列表与卡片**: Card, ListTile, ExpansionTile, GridView, ReorderableListView, Dismissible, DataTable

### 动画效果
- **隐式动画**: AnimatedContainer, AnimatedOpacity, AnimatedCrossFade, AnimatedRotation, AnimatedScale
- **显式动画**: AnimationController, RotationTransition, SlideTransition, FadeTransition
- **页面切换**: SharedAxisTransition, FadeThrough, OpenContainer
- **Hero 动画**: 跨页面共享元素动画
- **AnimatedList**: 列表项添加/删除动画

### 数据存储
- **SharedPreferences**: 键值对持久化存储
- **SQLite**: 结构化数据库存储 (sqflite)
- **文件操作**: 文本文件、JSON 文件读写

### 硬件调用
- **相机**: 相机预览、拍照、图片选择
- **生物识别**: 指纹、面部识别验证
- **传感器**: 加速度计、陀螺仪、磁力计
- **设备信息**: 获取设备详细信息

### 系统调用
- **文件选择**: 单文件、多文件、图片、自定义类型
- **分享**: 文本、文件、链接分享
- **URL 启动**: 打开网页、邮件、电话、短信、地图
- **剪贴板**: 复制、粘贴操作
- **触觉反馈**: 轻触、中度、重度、选择、振动

## 🚀 快速开始

### 环境要求

- Flutter SDK >= 3.9.2
- Dart SDK >= 3.9.2
- Android Studio / VS Code
- Xcode (仅 macOS，用于 iOS 开发)

### 安装依赖

```bash
# 获取依赖
flutter pub get
```

### 开发模式运行

```bash
# 运行在已连接的设备或模拟器上
flutter run

# 指定设备运行
flutter run -d <device_id>

# 查看可用设备
flutter devices

# 运行在 Chrome (Web)
flutter run -d chrome

# 运行在 Windows
flutter run -d windows

# 运行在 macOS
flutter run -d macos
```

### 热重载

在开发过程中，按 `r` 进行热重载，按 `R` 进行热重启。

## 📦 打包编译

### Android

```bash
# 构建 APK (debug)
flutter build apk --debug

# 构建 APK (release)
flutter build apk --release

# 构建 App Bundle (用于 Google Play)
flutter build appbundle --release

# 分架构构建 APK
flutter build apk --split-per-abi
```

APK 输出位置: `build/app/outputs/flutter-apk/`

### iOS

```bash
# 构建 iOS (需要 macOS 和 Xcode)
flutter build ios --release

# 构建 IPA (需要有效的签名配置)
flutter build ipa --release
```

IPA 输出位置: `build/ios/ipa/`

### 其他平台

```bash
# Web
flutter build web --release

# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

## 🧪 测试

```bash
# 运行所有单元测试
flutter test

# 运行特定测试文件
flutter test test/widget_test.dart

# 运行测试并生成覆盖率报告
flutter test --coverage

# 查看覆盖率报告 (需要 lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 🔍 代码质量

```bash
# 分析代码
flutter analyze

# 格式化代码
dart format lib/

# 格式化并检查
dart format --set-exit-if-changed lib/

# 应用自动修复
dart fix --apply
```

## 📁 项目结构

```
lib/
├── main.dart                 # 应用入口
├── app/
│   ├── app.dart             # MaterialApp 配置
│   └── theme.dart           # 主题配置
└── screens/
    ├── home_screen.dart     # 主页面
    ├── components/          # Material 组件展示
    │   ├── buttons_screen.dart
    │   ├── inputs_screen.dart
    │   ├── selections_screen.dart
    │   ├── dialogs_screen.dart
    │   ├── navigation_screen.dart
    │   └── cards_lists_screen.dart
    ├── animations/          # 动画展示
    │   └── animations_screen.dart
    ├── storage/             # 数据存储展示
    │   └── storage_screen.dart
    ├── hardware/            # 硬件调用展示
    │   └── hardware_screen.dart
    └── system/              # 系统调用展示
        └── system_screen.dart
```

## 📋 依赖说明

| 包名                 | 用途                   |
| -------------------- | ---------------------- |
| `animations`         | Material Design 动画库 |
| `vibration`          | 振动反馈               |
| `shared_preferences` | 键值对存储             |
| `sqflite`            | SQLite 数据库          |
| `path_provider`      | 获取系统目录路径       |
| `file_picker`        | 文件选择器             |
| `share_plus`         | 系统分享               |
| `url_launcher`       | URL 启动               |
| `camera`             | 相机功能               |
| `local_auth`         | 生物识别               |
| `sensors_plus`       | 传感器数据             |
| `permission_handler` | 权限管理               |
| `device_info_plus`   | 设备信息               |
| `image_picker`       | 图片选择               |

## ⚙️ 平台配置

### Android

某些功能需要在 `android/app/src/main/AndroidManifest.xml` 中添加权限:

```xml
<!-- 相机 -->
<uses-permission android:name="android.permission.CAMERA" />

<!-- 生物识别 -->
<uses-permission android:name="android.permission.USE_BIOMETRIC" />

<!-- 振动 -->
<uses-permission android:name="android.permission.VIBRATE" />

<!-- 存储 (Android 10 以下) -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### iOS

在 `ios/Runner/Info.plist` 中添加相应的使用说明:

```xml
<!-- 相机 -->
<key>NSCameraUsageDescription</key>
<string>需要访问相机以拍摄照片</string>

<!-- 相册 -->
<key>NSPhotoLibraryUsageDescription</key>
<string>需要访问相册以选择照片</string>

<!-- 生物识别 -->
<key>NSFaceIDUsageDescription</key>
<string>需要使用 Face ID 进行身份验证</string>
```

## 🤝 贡献

欢迎提交 Issue 和 Pull Request!

## 📄 许可证

MIT License
