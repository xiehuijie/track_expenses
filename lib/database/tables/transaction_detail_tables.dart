import 'package:drift/drift.dart';

import 'account_table.dart';
import 'category_table.dart';
import 'currency_table.dart';
import 'transaction_table.dart';

/// 交易明细表 (TransactionItem) [transaction_item]
/// 记录某笔交易中各账户的具体变动明细。
@DataClassName('TransactionItemData')
class TransactionItem extends Table {
  @override
  String get tableName => 'transaction_item';

  /// 交易明细唯一标识 - 自增主键
  IntColumn get transactionItemId =>
      integer().autoIncrement().named('transaction_item_id')();

  /// 所属交易的唯一标识 - 索引[0]
  IntColumn get transactionId => integer()
      .named('transaction_id')
      .references(Transactions, #transactionId)();

  /// 关联的账户唯一标识 - 索引[0]，索引[1]
  IntColumn get accountId =>
      integer().named('account_id').references(Account, #accountId)();

  /// 交易时货币代码
  TextColumn get currencyCode =>
      text().named('currency_code').references(Currency, #currencyCode)();

  /// 交易时金额（交易币，以货币最小单位存储）
  IntColumn get amount => integer()();

  /// 实际交易金额（本币，以货币最小单位存储）
  IntColumn get realAmount => integer().named('real_amount')();
}

/// 交易减免表 (TransactionReduce) [transaction_deduce]
/// 记录某笔交易发生减免时的相关信息。
@DataClassName('TransactionReduceData')
class TransactionReduce extends Table {
  @override
  String get tableName => 'transaction_deduce';

  /// 交易减值唯一标识 - 自增主键
  IntColumn get transactionDecreaseId =>
      integer().autoIncrement().named('transaction_decrease_id')();

  /// 所属交易的唯一标识 - 索引[0]
  IntColumn get transactionId => integer()
      .named('transaction_id')
      .references(Transactions, #transactionId)();

  /// 关联的分类唯一标识
  IntColumn get categoryId =>
      integer().named('category_id').references(Category, #categoryId)();

  /// 减免时货币代码
  TextColumn get currencyCode =>
      text().named('currency_code').references(Currency, #currencyCode)();

  /// 减值时金额（交易币，以货币最小单位存储）
  IntColumn get amount => integer()();

  /// 实际减值金额（本币，以货币最小单位存储）
  IntColumn get realAmount => integer().named('real_amount')();
}

/// 交易退款表 (TransactionRefund) [transaction_refund]
/// 记录某笔支出交易发生退款时的相关信息。
@DataClassName('TransactionRefundData')
class TransactionRefund extends Table {
  @override
  String get tableName => 'transaction_refund';

  /// 交易退款唯一标识 - 自增主键
  IntColumn get transactionRefundId =>
      integer().autoIncrement().named('transaction_refund_id')();

  /// 所属交易的唯一标识 - 索引[0]
  IntColumn get transactionId => integer()
      .named('transaction_id')
      .references(Transactions, #transactionId)();

  /// 关联的账户唯一标识 - 索引[1]
  IntColumn get accountId =>
      integer().named('account_id').references(Account, #accountId)();

  /// 退款时货币代码
  TextColumn get currencyCode =>
      text().named('currency_code').references(Currency, #currencyCode)();

  /// 退款时金额（交易币，以货币最小单位存储）
  IntColumn get amount => integer()();

  /// 实际退款金额（本币，以货币最小单位存储）
  IntColumn get realAmount => integer().named('real_amount')();

  /// 退款时间戳（毫秒级UNIX时间戳）- 索引[0]
  IntColumn get timestamp => integer()();

  /// 创建时间戳（毫秒级UNIX时间戳）
  IntColumn get createdAt => integer().named('created_at')();

  /// 更新时间戳（毫秒级UNIX时间戳）
  IntColumn get updatedAt => integer().named('updated_at')();

  /// 退款备注
  TextColumn get note => text()();
}
