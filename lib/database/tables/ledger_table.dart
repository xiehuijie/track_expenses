import 'package:drift/drift.dart';

import 'currency_table.dart';

/// 账本表 (Ledger) [ledger]
/// 用于描述账本信息，不同账本下的分类、账户、相关方将被认为是不同的实体。
@DataClassName('LedgerData')
class Ledger extends Table {
  /// 账本唯一标识 - 自增主键
  IntColumn get ledgerId =>
      integer().autoIncrement().named('ledger_id')();

  /// 账本名称 - 唯一约束[0]
  TextColumn get name => text().unique()();

  /// 账本货币本币代码 - 外键
  TextColumn get currencyCode =>
      text().named('currency_code').references(Currency, #currencyCode)();

  /// 账本描述
  TextColumn get description => text()();

  /// 账本封面
  TextColumn get photo => text()();

  /// 是否自动包含新增账户（0=false, 1=true）
  IntColumn get autoAccount =>
      integer().named('auto_account').withDefault(const Constant(0))();

  /// 是否自动包含新增分类（0=false, 1=true）
  IntColumn get autoCategory =>
      integer().named('auto_category').withDefault(const Constant(0))();

  /// 创建时间戳（毫秒级UNIX时间戳）
  IntColumn get createdAt => integer().named('created_at')();

  /// 更新时间戳（毫秒级UNIX时间戳）
  IntColumn get updatedAt => integer().named('updated_at')();

  /// 备注
  TextColumn get note => text()();
}
