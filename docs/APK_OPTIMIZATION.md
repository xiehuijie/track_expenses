# APK 包体优化指南

## 当前包体大小

| APK 类型                 | 大小        |
| ------------------------ | ----------- |
| 通用 APK (所有 ABI)      | 36.8 MB     |
| arm64-v8a (64位现代设备) | **27.9 MB** |
| armeabi-v7a (32位旧设备) | **24.2 MB** |
| x86_64 (模拟器/部分设备) | 30.0 MB     |

## 已实施的优化

### 1. 图标字体树摇优化
```
Font asset "MaterialIcons-Regular.otf" was tree-shaken, 
reducing it from 1645184 to 26444 bytes (98.4% reduction)
```

### 2. ABI 分割
使用 `--split-per-abi` 构建分架构 APK，用户只需下载对应自己设备架构的 APK。

### 3. Core Library Desugaring
启用 Java 8+ API 去糖化，减少兼容性代码。

## 主要占用分析

### Dart AOT 代码 (~9 MB 解压后)
| 包                            | 大小   |
| ----------------------------- | ------ |
| package:flutter               | 4 MB   |
| package:track_expenses        | 483 KB |
| package:flutter_localizations | 430 KB |
| package:timezone              | 390 KB |
| package:fl_chart              | 252 KB |
| dart:core                     | 281 KB |
| dart:ui                       | 231 KB |

### 原生库 (lib/)
- arm64-v8a: 25 MB
- armeabi-v7a: 3 MB  
- x86_64: 6 MB

### 资源文件
- mlkit_barcode_models: 860 KB (二维码扫描模型)
- flutter_assets: 224 KB

## 进一步优化建议

### 1. 使用 App Bundle (推荐)
```bash
flutter build appbundle --release
```
上传到 Google Play 后，会自动按设备架构和语言分发，用户下载大小更小。

### 2. 启用代码混淆
在 `android/app/build.gradle.kts` 中添加:
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

### 3. 移除未使用的依赖
检查 `pubspec.yaml`，移除未使用的包。

### 4. 图片资源优化
- 使用 WebP 格式替代 PNG/JPEG
- 使用矢量图 (SVG → flutter_svg)
- 压缩图片资源

### 5. 延迟加载功能模块
使用 Flutter 的延迟加载功能:
```dart
import 'package:flutter/foundation.dart' show kIsWeb;

// 条件导入
import 'feature.dart' if (dart.library.html) 'feature_web.dart';
```

### 6. 字体优化
- 只包含使用的字体权重
- 使用系统字体而非自定义字体

## 构建命令

### 开发构建
```bash
flutter build apk --debug
```

### 发布构建 (分割 APK)
```bash
flutter build apk --split-per-abi --release
```

### 发布构建 (App Bundle)
```bash
flutter build appbundle --release
```

### 分析包大小
```bash
flutter build apk --analyze-size --release --target-platform android-arm64
```

## 小米应用商店提交

对于小米应用商店，建议提交 arm64-v8a APK (27.9 MB)，因为大多数现代小米设备都是 64 位的。

如果需要支持更多设备，可以分别上传不同架构的 APK 或使用 App Bundle。
