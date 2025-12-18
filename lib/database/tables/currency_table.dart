import 'package:drift/drift.dart';

import '../enums.dart';

/// 货币表 (Currency) [currency]
/// 记录系统支持的货币信息，除了系统内置货币外，用户还可以自定义货币。
@DataClassName('CurrencyData')
class Currency extends Table {
  /// 货币代码（如USD）- 主键
  TextColumn get currencyCode => text().named('currency_code')();

  /// 货币名称
  TextColumn get name => text()();

  /// 货币符号（如$）
  TextColumn get symbol => text()();

  /// 货币符号位置
  TextColumn get position =>
      text().check(position.isIn(['prefix', 'suffix']))();

  /// 小数位数
  IntColumn get decimal => integer()();

  /// 货币图标
  TextColumn get icon => text()();

  /// 货币来源
  TextColumn get source => text().check(source.isIn(['system', 'custom']))();

  @override
  Set<Column> get primaryKey => {currencyCode};
}
