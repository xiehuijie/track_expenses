# Flutter Material Design Showcase

一个全面展示 Flutter Material Design 组件和系统能力的示例应用程序。

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.2+-blue.svg)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows%20%7C%20macOS%20%7C%20Linux-lightgrey.svg)](https://flutter.dev/multi-platform)

## 📱 功能特性

### Material Design 组件
- **按钮组件**: ElevatedButton, FilledButton, OutlinedButton, TextButton, IconButton, FAB, SegmentedButton
- **输入组件**: TextField, TextFormField, SearchBar, DropdownMenu, DatePicker, TimePicker
- **选择组件**: Switch, Checkbox, Radio, Slider, Chips (Filter, Choice, Action, Input)
- **对话框组件**: AlertDialog, SimpleDialog, BottomSheet, SnackBar, Banner, Tooltip, PopupMenu
- **导航组件**: AppBar, SliverAppBar, TabBar, BottomNavigationBar, NavigationBar, NavigationRail, Drawer, Stepper
- **列表与卡片**: Card, ListTile, ExpansionTile, GridView, ReorderableListView, Dismissible, DataTable

### 🎨 主题与国际化
- **6种主题色**: 深蓝(默认)、蓝绿色、紫色、橙色、绿色、粉色
- **深色模式**: 完整的深色主题支持
- **多语言**: 中文、English 双语支持
- **Material 3**: 完整的 Material Design 3 设计规范

### 动画效果
- **隐式动画**: AnimatedContainer, AnimatedOpacity, AnimatedCrossFade, AnimatedRotation, AnimatedScale
- **显式动画**: AnimationController, RotationTransition, SlideTransition, FadeTransition
- **页面切换**: SharedAxisTransition, FadeThrough, OpenContainer (Material Motion)
- **Hero 动画**: 跨页面共享元素动画
- **AnimatedList**: 列表项添加/删除动画
- **加载动画**: 脉冲、旋转、波浪、骨架屏加载效果
- **粒子效果**: 烟花/礼花庆祝动画 (confetti)

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

### 📊 实用工具组件
- **图表组件**: 折线图、柱状图、饼图、雷达图 (fl_chart)
- **日历组件**: 月视图、周视图、事件标记 (table_calendar)
- **粒子动画**: 自定义粒子效果动画
- **热力图**: GitHub 贡献图风格热力图
- **进度指示器**: 线性、圆形、百分比、步骤进度

### 💼 业务组件
- **支付组件**: 支付方式选择、订单信息展示
- **金额输入**: 带格式化的金额输入键盘
- **二维码扫描**: 实时 QR 码扫描与识别 (mobile_scanner)
- **验证码输入**: OTP 验证码输入组件

### 🔔 通知推送
- **本地通知**: 即时通知发送 (flutter_local_notifications)
- **定时通知**: 计划任务通知、时区支持
- **通知渠道**: Android 通知渠道管理 (重要性级别配置)

### 📖 用户引导
- **新手引导**: 功能介绍、操作指引 (tutorial_coach_mark)
- **高亮提示**: 交互式元素高亮教程

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
├── main.dart                    # 应用入口
├── app/
│   ├── app.dart                # MaterialApp 配置
│   └── theme.dart              # 主题配置 (6种颜色)
├── l10n/
│   ├── app_localizations.dart  # 国际化抽象类
│   ├── app_localizations_en.dart # 英文翻译
│   └── app_localizations_zh.dart # 中文翻译
├── services/
│   └── notification_service.dart # 通知服务
├── providers/
│   └── locale_provider.dart    # 语言状态管理
└── screens/
    ├── home_screen.dart        # 主页面
    ├── settings_screen.dart    # 设置页面
    ├── components/             # Material 组件展示
    │   ├── buttons_screen.dart
    │   ├── inputs_screen.dart
    │   ├── selections_screen.dart
    │   ├── dialogs_screen.dart
    │   ├── navigation_screen.dart
    │   └── cards_lists_screen.dart
    ├── animations/             # 动画展示
    │   ├── animations_screen.dart
    │   ├── loading_animations_demo.dart
    │   ├── fireworks_demo.dart
    │   └── page_transitions_demo.dart
    ├── storage/                # 数据存储展示
    │   └── storage_screen.dart
    ├── hardware/               # 硬件调用展示
    │   └── hardware_screen.dart
    ├── system/                 # 系统调用展示
    │   └── system_screen.dart
    ├── utilities/              # 实用工具组件
    │   ├── utilities_screen.dart
    │   ├── charts_demo.dart
    │   ├── calendar_demo.dart
    │   ├── particles_demo.dart
    │   ├── heatmap_demo.dart
    │   └── progress_indicators_demo.dart
    ├── business/               # 业务组件
    │   ├── business_components_screen.dart
    │   ├── payment_demo.dart
    │   ├── amount_input_demo.dart
    │   ├── qr_scanner_demo.dart
    │   └── otp_input_demo.dart
    ├── notifications/          # 通知演示
    │   ├── notifications_screen.dart
    │   ├── local_notification_demo.dart
    │   ├── scheduled_notification_demo.dart
    │   └── notification_channels_demo.dart
    └── onboarding/             # 用户引导
        └── onboarding_screen.dart
```

## 📋 依赖说明

### 核心依赖

| 包名         | 版本 | 用途                   |
| ------------ | ---- | ---------------------- |
| `provider`   | ^6.0 | 状态管理               |
| `animations` | ^2.0 | Material Design 动画库 |
| `vibration`  | ^2.0 | 振动反馈               |

### 数据存储

| 包名                 | 版本 | 用途             |
| -------------------- | ---- | ---------------- |
| `shared_preferences` | ^2.5 | 键值对存储       |
| `sqflite`            | ^2.4 | SQLite 数据库    |
| `path_provider`      | ^2.1 | 获取系统目录路径 |

### 系统功能

| 包名                 | 版本  | 用途       |
| -------------------- | ----- | ---------- |
| `file_picker`        | ^8.1  | 文件选择器 |
| `share_plus`         | ^10.1 | 系统分享   |
| `url_launcher`       | ^6.3  | URL 启动   |
| `permission_handler` | ^11.4 | 权限管理   |

### 硬件功能

| 包名               | 版本  | 用途       |
| ------------------ | ----- | ---------- |
| `camera`           | ^0.11 | 相机功能   |
| `local_auth`       | ^2.3  | 生物识别   |
| `sensors_plus`     | ^6.1  | 传感器数据 |
| `device_info_plus` | ^11.2 | 设备信息   |
| `image_picker`     | ^1.1  | 图片选择   |

### 实用工具

| 包名              | 版本  | 用途          |
| ----------------- | ----- | ------------- |
| `fl_chart`        | ^0.70 | 图表组件      |
| `table_calendar`  | ^3.2  | 日历组件      |
| `confetti_widget` | ^0.4  | 烟花/礼花效果 |

### 业务组件

| 包名             | 版本 | 用途           |
| ---------------- | ---- | -------------- |
| `mobile_scanner` | ^7.0 | 二维码扫描     |
| `pinput`         | ^5.0 | OTP 验证码输入 |

### 通知推送

| 包名                          | 版本  | 用途     |
| ----------------------------- | ----- | -------- |
| `flutter_local_notifications` | ^18.0 | 本地通知 |
| `timezone`                    | ^0.9  | 时区支持 |

### 用户引导

| 包名                  | 版本 | 用途          |
| --------------------- | ---- | ------------- |
| `tutorial_coach_mark` | ^1.2 | 新手引导/教程 |

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

## � 相关文档

- [APK 包体积优化指南](docs/APK_OPTIMIZATION.md) - 详细的安装包优化方案
- [小米 HyperOS 适配指南](docs/HYPEROS_ADAPTATION.md) - 小米设备功能适配说明

## 📦 应用信息

| 项目                   | 值                           |
| ---------------------- | ---------------------------- |
| Android 包名           | `fun.geek213.track_expenses` |
| iOS Bundle ID          | `fun.geek213.trackExpenses`  |
| 最低 Android 版本      | Android 8.0 (API 26)         |
| 最低 iOS 版本          | iOS 12.0                     |
| APK 大小 (arm64-v8a)   | ~28 MB                       |
| APK 大小 (armeabi-v7a) | ~24 MB                       |

## 🔄 版本历史

### v1.0.0

- 🎉 完整的 Material Design 3 组件展示
- 🎨 6 种主题色 + 深色模式支持
- 🌍 中英文双语支持
- 📊 实用工具组件 (图表、日历、热力图等)
- 💼 业务组件 (支付、二维码、OTP 等)
- 🔔 本地通知支持
- 📖 新手引导功能
- ⚡ 包体积优化 (分架构 APK)

## �📄 许可证

MIT License
