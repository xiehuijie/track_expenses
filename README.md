# Flutter Material Design Showcase 📱

一个全面展示 Flutter Material Design 组件和系统能力的示例应用程序。

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-blue.svg)](https://flutter.dev/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## 🎯 应用信息

- **应用名称**: Material Design Showcase
- **包名**: 
  - Android: `fun.geek213.track_expenses`
  - iOS: `fun.geek213.trackExpenses`
- **版本**: 1.0.0

## ✨ 功能特性

### 🎨 Material Design 组件
- **按钮组件**: ElevatedButton, FilledButton, OutlinedButton, TextButton, IconButton, FAB, SegmentedButton
- **输入组件**: TextField, TextFormField, SearchBar, DropdownMenu, DatePicker, TimePicker
- **选择组件**: Switch, Checkbox, Radio, Slider, Chips (Filter, Choice, Action, Input)
- **对话框组件**: AlertDialog, SimpleDialog, BottomSheet, SnackBar, Banner, Tooltip, PopupMenu
- **导航组件**: AppBar, SliverAppBar, TabBar, BottomNavigationBar, NavigationBar, NavigationRail, Drawer, Stepper
- **列表与卡片**: Card, ListTile, ExpansionTile, GridView, ReorderableListView, Dismissible, DataTable

### 🎭 动画与特效
- **隐式动画**: AnimatedContainer, AnimatedOpacity, AnimatedCrossFade, AnimatedRotation, AnimatedScale
- **显式动画**: AnimationController, RotationTransition, SlideTransition, FadeTransition
- **页面切换**: SharedAxisTransition, FadeThrough, OpenContainer
- **Hero 动画**: 跨页面共享元素动画
- **特效动画**: 烟花庆祝效果、缩放动画、脉搏动画、旋转动画
- **Lottie 动画**: 支持 Lottie 动画播放
- **Confetti 效果**: 彩纸庆祝效果

### 🛠️ 工具组件
- **图表**: 折线图、柱状图、饼图 (fl_chart)
- **日历**: 日历选择、事件管理 (table_calendar)
- **二维码**: 生成二维码、自定义样式 (qr_flutter)
- **进度指示器**: 线性、圆形、步骤进度条 (percent_indicator, step_progress_indicator)
- **通知**: 本地通知、定时通知、进度通知 (flutter_local_notifications)
- **引导教程**: Intro.js 风格的功能引导 (tutorial_coach_mark)

### 💼 业务组件
- **金额输入**: 数字键盘、金额格式化、快捷金额选择

### 💾 数据存储
- **SharedPreferences**: 键值对持久化存储
- **SQLite**: 结构化数据库存储 (sqflite)
- **文件操作**: 文本文件、JSON 文件读写

### 🔧 硬件调用
- **相机**: 相机预览、拍照、图片选择
- **生物识别**: 指纹、面部识别验证 (已修复 Android FragmentActivity 问题)
- **传感器**: 加速度计、陀螺仪、磁力计
- **设备信息**: 获取设备详细信息

### 🌐 系统调用
- **文件选择**: 单文件、多文件、图片、自定义类型
- **分享**: 文本、文件、链接分享
- **URL 启动**: 打开网页、邮件、电话、短信、地图
- **剪贴板**: 复制、粘贴操作
- **触觉反馈**: 轻触、中度、重度、选择、振动

### 🎨 主题系统
- **多主题色**: 10种主题颜色（紫、蓝、红、绿、橙、青、粉、琥珀、靛蓝、青蓝）
- **深色模式**: 支持浅色/深色主题切换
- **自定义主题**: 通过设置对话框动态切换主题颜色

### 🌍 国际化
- **多语言支持**: 中文、英文
- **动态切换**: 运行时切换语言
- **扩展性**: 为后续添加更多语言打好基础

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

### 核心依赖

| 包名                          | 版本    | 用途                      |
| ----------------------------- | ------- | ------------------------- |
| `flutter`                     | SDK     | Flutter 框架              |
| `flutter_localizations`       | SDK     | Flutter 国际化支持        |
| `cupertino_icons`             | ^1.0.8  | iOS 风格图标              |

### UI 组件与动画

| 包名                          | 版本    | 用途                      |
| ----------------------------- | ------- | ------------------------- |
| `animations`                  | ^2.0.11 | Material Design 动画库    |
| `lottie`                      | ^3.2.1  | Lottie 动画播放           |
| `confetti`                    | ^0.7.0  | 彩纸特效                  |

### 图表与可视化

| 包名                          | 版本    | 用途                      |
| ----------------------------- | ------- | ------------------------- |
| `fl_chart`                    | ^0.70.1 | 图表组件库                |
| `percent_indicator`           | ^4.2.3  | 百分比进度指示器          |
| `step_progress_indicator`     | ^1.0.2  | 步骤进度指示器            |

### 日历与时间

| 包名                          | 版本    | 用途                      |
| ----------------------------- | ------- | ------------------------- |
| `table_calendar`              | ^3.1.2  | 日历组件                  |

### 二维码

| 包名                          | 版本    | 用途                      |
| ----------------------------- | ------- | ------------------------- |
| `qr_flutter`                  | ^4.1.0  | 二维码生成                |
| `qr_code_scanner`             | ^1.0.1  | 二维码扫描                |

### 通知与引导

| 包名                              | 版本     | 用途                      |
| --------------------------------- | -------- | ------------------------- |
| `flutter_local_notifications`     | ^18.0.1  | 本地通知                  |
| `tutorial_coach_mark`             | ^1.2.11  | 功能引导教程              |

### 国际化

| 包名                          | 版本    | 用途                      |
| ----------------------------- | ------- | ------------------------- |
| `intl`                        | ^0.19.0 | 国际化和本地化            |

### 数据存储

| 包名                          | 版本    | 用途                      |
| ----------------------------- | ------- | ------------------------- |
| `shared_preferences`          | ^2.3.4  | 键值对存储                |
| `sqflite`                     | ^2.4.1  | SQLite 数据库             |
| `path_provider`               | ^2.1.5  | 获取系统目录路径          |
| `path`                        | ^1.9.1  | 路径操作工具              |

### 硬件与传感器

| 包名                          | 版本     | 用途                      |
| ----------------------------- | -------- | ------------------------- |
| `camera`                      | ^0.11.1  | 相机功能                  |
| `local_auth`                  | ^2.3.0   | 生物识别                  |
| `sensors_plus`                | ^6.1.1   | 传感器数据                |
| `vibration`                   | ^2.0.1   | 振动反馈                  |
| `device_info_plus`            | ^11.2.1  | 设备信息                  |
| `image_picker`                | ^1.1.2   | 图片选择                  |

### 系统功能

| 包名                          | 版本     | 用途                      |
| ----------------------------- | -------- | ------------------------- |
| `file_picker`                 | ^8.1.7   | 文件选择器                |
| `share_plus`                  | ^10.1.4  | 系统分享                  |
| `url_launcher`                | ^6.3.1   | URL 启动                  |
| `permission_handler`          | ^11.3.1  | 权限管理                  |

### 特效（可选）

| 包名                          | 版本    | 用途                      |
| ----------------------------- | ------- | ------------------------- |
| `particles_flutter`           | ^0.1.4  | 粒子效果                  |

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

## 📱 小米 HyperOS 特性集成说明

### 概述

小米 HyperOS 提供了丰富的系统特性和 SDK，但这些功能主要针对小米生态应用开发，需要通过小米开放平台申请开发者权限。

### 1. 小米超级岛 (HyperConnect)

**功能描述**: 
小米超级岛是 HyperOS 的核心交互功能之一，支持灵动岛式的通知和快捷操作。

**集成要求**:
- 需要在小米开放平台（https://dev.mi.com）注册开发者账号
- 申请超级岛接入权限
- 使用小米提供的 SDK 和 API

**开发文档**: https://dev.mi.com/xiaomihyperos/ability/hyperos-island

**Flutter 集成**:
目前小米超级岛暂无官方 Flutter SDK，需要通过 MethodChannel 调用原生 Android SDK。

**集成步骤**:
1. 申请小米开发者账号并通过认证
2. 在应用管理中创建应用并申请超级岛权限
3. 集成小米超级岛 SDK (原生 Android)
4. 通过 Flutter MethodChannel 封装接口

**状态**: ⏳ 需要小米开发者账号及权限申请

### 2. MiPush (小米推送)

**功能描述**:
小米推送服务提供高效的消息推送能力，支持透传消息和通知消息。

**集成要求**:
- 在小米开放平台注册并创建应用
- 获取 AppID 和 AppKey
- 集成 MiPush SDK

**开发文档**: https://dev.mi.com/console/doc/detail?pId=68

**Flutter 插件**:
可以使用第三方插件如 `flutter_mipush` 或通过 MethodChannel 自行封装。

**集成步骤**:
1. 在小米开放平台创建应用，获取 AppID 和 AppKey
2. 在 Android 项目中添加 MiPush SDK 依赖
3. 在 AndroidManifest.xml 中配置必要的权限和服务
4. 实现 PushMessageReceiver 处理推送消息
5. 通过 Flutter MethodChannel 与原生代码通信

**关键权限**:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
<uses-permission android:name="android.permission.GET_TASKS" />
<uses-permission android:name="android.permission.VIBRATE" />
```

**状态**: ⏳ 需要小米开发者账号

### 3. MiHaptic (小米触感反馈)

**功能描述**:
MiHaptic 提供丰富的震动反馈效果，支持自定义震动模式和触感效果。

**集成要求**:
- 小米设备运行 HyperOS 或 MIUI 12+
- 集成 MiHaptic SDK

**开发文档**: https://dev.mi.com/xiaomihyperos/ability/haptic

**Flutter 现有方案**:
目前可以使用 `vibration` 包实现基础震动功能（已集成），对于更高级的 MiHaptic 特性需要：
1. 集成小米官方 MiHaptic SDK
2. 通过 MethodChannel 封装接口

**基础震动功能**（已实现）:
```dart
import 'package:vibration/vibration.dart';

// 轻触反馈
Vibration.vibrate(duration: 10);

// 中度反馈
Vibration.vibrate(duration: 30);

// 重度反馈
Vibration.vibrate(duration: 50);

// 自定义模式
Vibration.vibrate(
  pattern: [0, 100, 50, 100],
  intensities: [0, 128, 0, 255],
);
```

**高级功能** (需要 MiHaptic SDK):
- 预设震动效果库
- 与音频同步的触感效果
- 更精细的震动控制
- 震动效果编辑器

**状态**: ⚠️ 基础震动已实现，高级功能需要小米开发者账号

### 集成建议

1. **优先级排序**:
   - MiHaptic (基础功能已实现，高级功能可选)
   - MiPush (推送服务，可提升用户体验)
   - 小米超级岛 (创新交互，适合特色功能展示)

2. **替代方案**:
   - 使用 Flutter 自带的 `flutter_local_notifications` 替代 MiPush 实现本地通知（已集成）
   - 使用 `vibration` 包实现基础震动功能（已集成）
   - 针对非小米设备提供兼容方案

3. **开发流程**:
   - 注册小米开发者账号
   - 提交应用审核
   - 获取必要的 AppID 和密钥
   - 集成对应的 SDK
   - 通过 MethodChannel 封装 Dart API

### 参考资源

- 小米开放平台: https://dev.mi.com
- HyperOS 开发者文档: https://dev.mi.com/xiaomihyperos
- 小米推送服务: https://dev.mi.com/console/appservice/push.html
- Flutter Platform Channels: https://flutter.dev/docs/development/platform-integration/platform-channels

## 🐛 已知问题修复

### 1. 深色模式卡片颜色问题 ✅
**问题描述**: 深色模式下各首页 tab 中的卡片使用了硬编码颜色，导致显示不正确。

**解决方案**: 
- 将所有硬编码的 `Colors.grey[x]` 替换为主题相关的颜色
- 使用 `Theme.of(context).colorScheme.surfaceContainerHighest` 等主题颜色
- 使用 `Theme.of(context).colorScheme.onSurfaceVariant` 作为次要文本颜色

**修改文件**:
- `lib/screens/hardware/hardware_screen.dart`
- `lib/screens/components/dialogs_screen.dart`
- `lib/screens/storage/storage_screen.dart`

### 2. Android 指纹识别问题 ✅
**问题描述**: 指纹在安卓机型上无法使用，提示 `PlatformException(no_fragment_activaty, local_auth plugin requires activity to be a FragmentActivity., null)`

**原因**: `MainActivity` 继承自 `FlutterActivity` 而非 `FlutterFragmentActivity`，导致 `local_auth` 插件无法正常工作。

**解决方案**: 
将 `MainActivity.kt` 中的基类从 `FlutterActivity` 改为 `FlutterFragmentActivity`:

```kotlin
// 修改前
class MainActivity : FlutterActivity()

// 修改后
class MainActivity : FlutterFragmentActivity()
```

**文件位置**: `android/app/src/main/kotlin/fun/geek213/track_expenses/MainActivity.kt`

## 🚀 优化建议

### 包体积优化

当前 Android APK 大小约为 50MB，可以通过以下方式优化：

1. **分架构打包**:
```bash
flutter build apk --split-per-abi
```
这将生成多个 APK，每个针对特定的 CPU 架构（arm64-v8a, armeabi-v7a, x86_64），用户只需下载对应的版本。

2. **启用代码混淆和压缩**:
在 `android/app/build.gradle.kts` 中配置 ProGuard/R8:
```kotlin
buildTypes {
    release {
        isMinifyEnabled = true
        isShrinkResources = true
        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
    }
}
```

3. **移除未使用的资源**:
- 检查并删除未使用的图片、字体等资源
- 使用 `flutter build apk --analyze-size` 分析包大小

4. **优化图片资源**:
- 使用 WebP 格式替代 PNG/JPEG
- 使用适当的分辨率，避免过大的图片

5. **延迟加载**:
- 将不常用的功能设为延迟加载
- 使用 deferred 导入

## 🤝 贡献

欢迎提交 Issue 和 Pull Request!

### 开发指南

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 提交 Pull Request

## 📄 许可证

MIT License

---

**开发者**: Track Expenses Team  
**最后更新**: 2024-12  
**Flutter 版本**: 3.9.2+
