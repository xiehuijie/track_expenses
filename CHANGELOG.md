# 更新日志

## [1.0.0] - 2024-12-10

### 🐛 Bug修复

#### 深色模式颜色问题
- **问题**: 深色模式下卡片、对话框、输入框等组件使用了硬编码颜色，导致显示不正确
- **修复**: 将所有硬编码颜色替换为主题相关的动态颜色
- **影响文件**:
  - `lib/screens/hardware/hardware_screen.dart`
  - `lib/screens/components/dialogs_screen.dart`
  - `lib/screens/storage/storage_screen.dart`

#### Android指纹识别问题
- **问题**: 指纹识别在Android设备上无法使用，提示需要FragmentActivity
- **修复**: 将MainActivity从FlutterActivity改为FlutterFragmentActivity
- **影响文件**: `android/app/src/main/kotlin/fun/geek213/track_expenses/MainActivity.kt`

### 🔄 包名更改

- **Android**: 从 `com.example.track_expenses` 更改为 `fun.geek213.track_expenses`
- **iOS**: 从 `com.example.trackExpenses` 更改为 `fun.geek213.trackExpenses`

### ✨ 新增功能

#### 工具组件
1. **图表组件** (fl_chart)
   - 折线图 (Line Chart)
   - 柱状图 (Bar Chart)
   - 饼图 (Pie Chart)

2. **日历组件** (table_calendar)
   - 月视图/周视图/两周视图切换
   - 事件管理
   - 日期选择与高亮

3. **二维码功能** (qr_flutter)
   - 二维码生成
   - 自定义样式（彩色、圆角等）
   - 动态内容更新

4. **进度指示器**
   - 线性进度条 (percent_indicator)
   - 圆形进度条
   - 步骤进度条 (step_progress_indicator)
   - 多彩渐变进度条

5. **本地通知** (flutter_local_notifications)
   - 简单通知
   - 大文本通知
   - 进度通知
   - 延迟通知
   - 通知管理

6. **引导教程** (tutorial_coach_mark)
   - Intro.js 风格的功能引导
   - 多步骤教程
   - 自定义引导内容
   - 可跳过功能

#### 特效动画
1. **烟花效果** (confetti)
   - 彩纸爆炸效果
   - 可配置颜色和数量

2. **Lottie动画** (lottie)
   - 支持Lottie动画播放
   - 集成准备完成

3. **内置动画**
   - 缩放动画
   - 脉搏动画
   - 旋转动画
   - 渐变动画

#### 业务组件
1. **金额输入组件**
   - 数字键盘
   - 自动金额格式化（保留两位小数）
   - 快捷金额选择
   - 清除和退格功能

### 🎨 主题系统

1. **多主题色支持**
   - 紫色 (Deep Purple)
   - 蓝色 (Blue)
   - 红色 (Red)
   - 绿色 (Green)
   - 橙色 (Orange)
   - 青色 (Teal)
   - 粉色 (Pink)
   - 琥珀色 (Amber)
   - 靛蓝色 (Indigo)
   - 青蓝色 (Cyan)

2. **明暗主题切换**
   - 浅色模式
   - 深色模式
   - 遵循Material Design 3规范

3. **设置界面**
   - 主题颜色选择器
   - 语言切换选项
   - 实时预览效果

### 🌍 国际化

1. **多语言支持**
   - 中文 (简体)
   - English (英语)

2. **本地化资源**
   - `lib/l10n/app_zh.arb` - 中文语言包
   - `lib/l10n/app_en.arb` - 英文语言包
   - `l10n.yaml` - 国际化配置文件

3. **动态切换**
   - 运行时语言切换
   - 无需重启应用

### 📦 新增依赖

#### UI组件
- `fl_chart: ^0.70.1` - 图表库
- `table_calendar: ^3.1.2` - 日历组件
- `qr_flutter: ^4.1.0` - 二维码生成
- `qr_code_scanner: ^1.0.1` - 二维码扫描
- `percent_indicator: ^4.2.3` - 百分比指示器
- `step_progress_indicator: ^1.0.2` - 步骤指示器

#### 动画特效
- `lottie: ^3.2.1` - Lottie动画
- `confetti: ^0.7.0` - 彩纸特效

#### 功能组件
- `flutter_local_notifications: ^18.0.1` - 本地通知
- `tutorial_coach_mark: ^1.2.11` - 引导教程

#### 国际化
- `intl: ^0.19.0` - 国际化支持
- `flutter_localizations` (SDK) - Flutter国际化

#### 其他
- `particles_flutter: ^0.1.4` - 粒子效果（已添加但未使用）

### 📝 文档更新

1. **README.md 大幅更新**
   - 完整的功能特性列表
   - 详细的依赖说明和版本信息
   - 小米HyperOS特性集成研究文档
   - 已知问题修复说明
   - 包体积优化建议
   - 开发指南和贡献说明

2. **小米HyperOS集成文档**
   - 小米超级岛 (HyperConnect) 集成方案
   - MiPush 推送服务集成步骤
   - MiHaptic 触感反馈实现说明

3. **优化建议**
   - 分架构打包减小APK体积
   - 代码混淆和资源压缩
   - 图片优化和延迟加载

### 🔧 配置更新

1. **Android权限**
   - 添加通知权限 `POST_NOTIFICATIONS`
   - 添加精确定时权限 `SCHEDULE_EXACT_ALARM`

2. **国际化配置**
   - 创建 `l10n.yaml` 配置文件
   - 配置ARB文件路径和输出文件名

### 🏗️ 项目结构优化

```
lib/
├── app/
│   ├── app.dart              # 应用配置（支持主题和语言切换）
│   ├── theme.dart            # 原主题配置（已弃用）
│   └── theme_provider.dart   # 新主题提供者
├── l10n/
│   ├── app_en.arb           # 英文语言包
│   └── app_zh.arb           # 中文语言包
└── screens/
    ├── business/            # 业务组件
    │   └── money_input_screen.dart
    └── tools/               # 工具组件
        ├── calendar_screen.dart
        ├── charts_screen.dart
        ├── effects_screen.dart
        ├── notifications_screen.dart
        ├── progress_screen.dart
        ├── qr_code_screen.dart
        └── tutorial_screen.dart
```

### 🔒 安全性

- 所有依赖通过GitHub Advisory Database检查
- 未发现已知安全漏洞
- CodeQL安全扫描通过

### ✅ 质量保证

1. **代码审查**
   - 修复了QR码组件中不存在的资源引用
   - 简化了通知调度实现
   - 移除了不必要的复杂度

2. **兼容性**
   - Android: 支持 API 21+
   - iOS: 支持 iOS 12+
   - Web: 部分功能受限
   - Windows/macOS/Linux: 基础功能支持

### 📊 统计信息

- **新增文件**: 15+
- **修改文件**: 10+
- **新增代码行**: 3000+
- **新增功能**: 20+
- **修复问题**: 2

### 🎯 未来计划

1. **待实现功能**
   - 粒子效果组件的实际应用
   - 热力图组件
   - 相机二维码扫描功能
   - 验证码/OTP输入组件
   - 后台推送接收

2. **优化计划**
   - 实际执行包体积优化
   - 性能优化和代码分割
   - 添加更多单元测试和集成测试

3. **小米HyperOS**
   - 等待小米开发者账号审批
   - 实现小米超级岛功能
   - 集成MiPush推送服务
   - 实现高级触感反馈

### 🙏 致谢

感谢所有开源库的贡献者和维护者！

---

**完整变更**: 查看 [GitHub Commits](https://github.com/xiehuijie/track_expenses/commits)
