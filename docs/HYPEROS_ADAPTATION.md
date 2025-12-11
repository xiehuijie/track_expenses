# 小米 HyperOS 适配指南

## 概述

小米澎湃OS (HyperOS) 为开发者提供了丰富的系统级能力和服务。本文档介绍如何让 Flutter 应用更好地适配小米 HyperOS 系统。

## HyperOS 主要服务能力

### 1. CloudKit - 云同步服务

提供基于小米账号的云同步能力，帮助应用数据轻松上云。

**Flutter 适配方案:**

- 使用 Platform Channel 调用原生 CloudKit SDK
- 或使用 REST API 接入

```dart
// 示例: Platform Channel 调用
const platform = MethodChannel('com.example/cloudkit');

Future<void> syncToCloud(Map<String, dynamic> data) async {
  try {
    await platform.invokeMethod('syncData', data);
  } catch (e) {
    print('CloudKit sync failed: $e');
  }
}
```

### 2. MiPush - 小米推送服务

小米设备上推送送达率最高的推送服务。

**Flutter 适配:**

推荐使用 `flutter_mipush` 或通过 Platform Channel 集成原生 SDK。

```yaml
# pubspec.yaml
dependencies:
  flutter_mipush: ^x.x.x  # 查看最新版本
```

### 3. MiHaptic - 触感反馈

小米设备专属的高品质触感反馈。

**已实现:** 本项目使用 `vibration` 包提供基础触感反馈。

```dart
import 'package:vibration/vibration.dart';

// 轻触反馈
await Vibration.vibrate(duration: 10, amplitude: 50);

// 重触反馈  
await Vibration.vibrate(duration: 20, amplitude: 100);
```

### 4. 小米账号服务

接入小米账号实现用户登录。

**集成方式:**

1. 注册开发者账号
2. 创建应用获取 AppID
3. 通过 Platform Channel 集成原生 SDK

### 5. 光子引擎

小米系统级渲染优化引擎，提升应用渲染性能。

**适配建议:**

- 应用无需特殊适配
- 确保遵循 Android 渲染最佳实践
- 使用标准 Flutter 动画 API

## 系统适配

### 通知与状态栏

HyperOS 对通知样式有特殊要求：

```dart
// Android 通知渠道设置
const androidDetails = AndroidNotificationDetails(
  'channel_id',
  '渠道名称',
  channelDescription: '渠道描述',
  importance: Importance.high,
  priority: Priority.high,
  // 小米设备建议设置小图标
  icon: '@mipmap/ic_notification',
);
```

### 多任务与多窗口

HyperOS 支持分屏和小窗模式：

```xml
<!-- AndroidManifest.xml -->
<activity
    android:name=".MainActivity"
    android:resizeableActivity="true"
    android:supportsPictureInPicture="true">
</activity>
```

### 小部件适配

如需开发桌面小部件，需要使用原生 Android 实现。

Flutter 端可通过 Platform Channel 与小部件通信。

### 桌面图标适配

确保提供自适应图标：

```
android/app/src/main/res/
├── mipmap-hdpi/
│   ├── ic_launcher.png
│   ├── ic_launcher_foreground.png
│   └── ic_launcher_background.png
├── mipmap-mdpi/
├── mipmap-xhdpi/
├── mipmap-xxhdpi/
└── mipmap-xxxhdpi/
```

## 权限适配

HyperOS 对权限管理更加严格：

### 必要权限

```xml
<!-- AndroidManifest.xml -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.VIBRATE" />
```

### 敏感权限

对于敏感权限，需在运行时请求并说明用途：

```dart
// 使用 permission_handler
final status = await Permission.camera.request();
if (status.isGranted) {
  // 权限已授予
}
```

### 权限说明

在应用详情页或首次请求时说明权限用途，符合 HyperOS 权限规范。

## 应用商店发布

### 上架要求

1. **应用信息完整:** 名称、图标、描述、截图
2. **隐私合规:** 提供隐私政策链接
3. **权限声明:** 说明每个权限的用途
4. **APK 签名:** 使用正式签名而非调试签名

### 包体优化建议

```bash
# 分架构打包
flutter build apk --split-per-abi --release

# 或使用 App Bundle
flutter build appbundle --release
```

### 推荐 APK

对于小米应用商店，推荐上传 **arm64-v8a** 版本 (27.9 MB)。

## HyperOS 特色功能

### 1. 贴贴分享

支持设备间快速分享内容。

### 2. 应用接力

在不同小米设备间无缝接力使用应用。

### 3. 小米超级岛

实时应用状态展示在状态栏。

### 4. 动态照片

支持动态照片格式的拍摄和展示。

## 开发者资源

- **开发者文档:** https://dev.mi.com/xiaomihyperos/documentation
- **管理中心:** https://dev.mi.com/xiaomihyperos/console
- **云测平台:** 提供真机测试服务
- **联系我们:** https://dev.mi.com/xiaomihyperos/contact

## 测试建议

### 真机测试

建议在以下设备上测试：

- 小米 14 系列 (HyperOS 1.0)
- 小米 13 系列 (升级 HyperOS)
- Redmi Note 12 系列
- 小米平板 6 系列

### 测试要点

1. 通知显示和推送
2. 权限请求流程
3. 分屏/小窗模式
4. 暗色主题适配
5. 触感反馈效果
6. 应用启动速度

## 参考链接

- [HyperOS 开放能力](https://dev.mi.com/xiaomihyperos/ability)
- [系统适配指南](https://dev.mi.com/xiaomihyperos/documentation)
- [应用分发](https://dev.mi.com/xiaomihyperos/app-distribute)
- [CloudKit 文档](https://dev.mi.com/xiaomihyperos/documentation/detail?pId=2013)
- [MiHaptic 文档](https://dev.mi.com/xiaomihyperos/documentation/detail?pId=1526)
