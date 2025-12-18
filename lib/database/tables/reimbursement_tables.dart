import 'package:drift/drift.dart';

import 'account_table.dart';
import 'currency_table.dart';
import 'transaction_table.dart';

/// 报销计划表 (Reimbursement) [reimbursement]
@DataClassName('ReimbursementData')
class Reimbursement extends Table {
  /// 报销唯一标识 - 自增主键
  IntColumn get reimbursementId =>
      integer().autoIncrement().named('reimbursement_id')();

  /// 报销计划名称 - 唯一约束[0]
  TextColumn get name => text().unique()();

  /// 报销计划描述
  TextColumn get description => text()();

  /// 对应货币代码
  TextColumn get currencyCode =>
      text().named('currency_code').references(Currency, #currencyCode)();

  /// 是否归档（0=false, 1=true）- 索引[0]
  IntColumn get archived => integer().withDefault(const Constant(0))();

  /// 创建时间戳（毫秒级UNIX时间戳）
  IntColumn get createdAt => integer().named('created_at')();

  /// 更新时间戳（毫秒级UNIX时间戳）
  IntColumn get updatedAt => integer().named('updated_at')();
}

/// 报销项目表 (ReimbursementItem) [reimbursement_item]
@DataClassName('ReimbursementItemData')
class ReimbursementItem extends Table {
  @override
  String get tableName => 'reimbursement_item';

  /// 报销项唯一标识 - 自增主键
  IntColumn get reimbursementItemId =>
      integer().autoIncrement().named('reimbursement_item_id')();

  /// 关联的报销唯一标识 - 索引[0]
  IntColumn get reimbursementId => integer()
      .named('reimbursement_id')
      .references(Reimbursement, #reimbursementId)();

  /// 关联的交易唯一标识
  IntColumn get transactionId => integer()
      .named('transaction_id')
      .references(Transactions, #transactionId)();

  /// 报销金额（以货币最小单位存储）
  IntColumn get amount => integer()();

  /// 备注
  TextColumn get note => text()();
}

/// 报销明细表 (ReimbursementDetail) [reimbursement_detail]
@DataClassName('ReimbursementDetailData')
class ReimbursementDetail extends Table {
  @override
  String get tableName => 'reimbursement_detail';

  /// 报销明细唯一标识 - 自增主键
  IntColumn get reimbursementDetailId =>
      integer().autoIncrement().named('reimbursement_detail_id')();

  /// 关联的报销唯一标识 - 索引[0]
  IntColumn get reimbursementId => integer()
      .named('reimbursement_id')
      .references(Reimbursement, #reimbursementId)();

  /// 关联的报销收入交易标识
  IntColumn get transactionId => integer()
      .named('transaction_id')
      .references(Transactions, #transactionId)();

  /// 关联的账户唯一标识
  IntColumn get accountId =>
      integer().named('account_id').references(Account, #accountId)();

  /// 报销金额（以货币最小单位存储）
  IntColumn get amount => integer()();

  /// 报销到账时间戳（毫秒级UNIX时间戳）
  IntColumn get timestamp => integer()();

  /// 创建时间戳（毫秒级UNIX时间戳）
  IntColumn get createdAt => integer().named('created_at')();

  /// 更新时间戳（毫秒级UNIX时间戳）
  IntColumn get updatedAt => integer().named('updated_at')();

  /// 备注
  TextColumn get note => text()();
}
