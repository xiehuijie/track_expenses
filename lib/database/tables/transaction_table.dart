import 'package:drift/drift.dart';

import 'ledger_table.dart';
import 'category_table.dart';
import 'stakeholder_table.dart';

/// 交易表 (Transaction) [transaction]
/// 用于记录每一笔交易（支出、收入）的信息。
@DataClassName('TransactionData')
class Transactions extends Table {
  @override
  String get tableName => 'transactions';

  /// 交易唯一标识 - 自增主键
  IntColumn get transactionId =>
      integer().autoIncrement().named('transaction_id')();

  /// 关联的账本唯一标识 - 索引[0]
  IntColumn get ledgerId =>
      integer().named('ledger_id').references(Ledger, #ledgerId)();

  /// 关联的分类唯一标识 - 索引[1]
  IntColumn get categoryId =>
      integer().named('category_id').references(Category, #categoryId)();

  /// 交易类型（支出/收入）- 索引[2]
  TextColumn get type => text().check(
    type.isIn(['expense', 'income', 'transfer']),
  )();

  /// 交易时间戳（毫秒级UNIX时间戳）- 索引[0]，索引[1]
  IntColumn get timestamp => integer()();

  /// 创建时间戳（毫秒级UNIX时间戳）
  IntColumn get createdAt => integer().named('created_at')();

  /// 更新时间戳（毫秒级UNIX时间戳）
  IntColumn get updatedAt => integer().named('updated_at')();

  /// 关联的相关方唯一标识 - 可为空，索引[3]
  IntColumn get stakeholderId => integer()
      .named('stakeholder_id')
      .nullable()
      .references(Stakeholder, #stakeholderId)();

  /// 交易地点纬度 - 可为空
  RealColumn get locationLat => real().named('location_lat').nullable()();

  /// 交易地点经度 - 可为空
  RealColumn get locationLng => real().named('location_lng').nullable()();

  /// 交易地点名称 - 可为空
  TextColumn get locationName => text().named('location_name').nullable()();

  /// 交易备注
  TextColumn get note => text()();
}
