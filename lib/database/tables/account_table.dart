import 'package:drift/drift.dart';

import 'currency_table.dart';

/// 账户表 (Account) [account]
/// 用于描述基础的账户信息。
@DataClassName('AccountData')
class Account extends Table {
  /// 账户唯一标识 - 自增主键
  IntColumn get accountId =>
      integer().autoIncrement().named('account_id')();

  /// 账户名称 - 唯一约束[0]
  TextColumn get name => text().unique()();

  /// 账户描述
  TextColumn get description => text()();

  /// 账户图标
  TextColumn get icon => text()();

  /// 账户类型 - 索引[0]
  TextColumn get type => text().check(
    type.isIn(['balance', 'credit', 'loan', 'invest', 'prepaid', 'bonus']),
  )();

  /// 账户货币代码 - 外键
  TextColumn get currencyCode =>
      text().named('currency_code').references(Currency, #currencyCode)();

  /// 创建时间戳（毫秒级UNIX时间戳）
  IntColumn get createdAt => integer().named('created_at')();

  /// 更新时间戳（毫秒级UNIX时间戳）
  IntColumn get updatedAt => integer().named('updated_at')();

  /// 备注
  TextColumn get note => text()();
}

/// 账户元数据表 (AccountMeta) [account_meta]
/// 存储账户的扩展元数据信息，采用键值对形式。
@DataClassName('AccountMetaData')
class AccountMeta extends Table {
  @override
  String get tableName => 'account_meta';

  /// 关联的账户唯一标识 - 复合主键
  IntColumn get accountId =>
      integer().named('account_id').references(Account, #accountId)();

  /// 元数据作用域 - 复合主键
  TextColumn get scope =>
      text().check(scope.isIn(['system', 'custom']))();

  /// 元数据键 - 复合主键
  TextColumn get key => text()();

  /// 元数据值
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {accountId, scope, key};
}

/// 信用账户表 (CreditAccount) [account_credit]
/// 在基础账户表的基础上，扩展信用账户特有的信息。
@DataClassName('CreditAccountData')
class AccountCredit extends Table {
  @override
  String get tableName => 'account_credit';

  /// 关联的账户唯一标识 - 主键和外键
  IntColumn get accountId =>
      integer().named('account_id').references(Account, #accountId)();

  /// 信用额度（以货币最小单位存储）
  IntColumn get creditLimit => integer().named('credit_limit')();

  /// 账单日（1~28）
  IntColumn get billingCycleDay => integer().named('billing_cycle_day')();

  /// 还款日（1~28）
  IntColumn get paymentDueDay => integer().named('payment_due_day')();

  @override
  Set<Column> get primaryKey => {accountId};
}

/// 赠送金账户表 (BonusAccount) [account_bonus]
/// 在基础账户表的基础上，定义此赠送金账户与预付款账户的关联关系。
@DataClassName('BonusAccountData')
class AccountBonus extends Table {
  @override
  String get tableName => 'account_bonus';

  /// 对应的赠送金账户唯一标识 - 复合主键
  IntColumn get bonusAccountId =>
      integer().named('bonus_account_id').references(Account, #accountId)();

  /// 对应的预付款账户唯一标识 - 复合主键
  IntColumn get prepaidAccountId =>
      integer().named('prepaid_account_id').references(Account, #accountId)();

  @override
  Set<Column> get primaryKey => {bonusAccountId, prepaidAccountId};
}
