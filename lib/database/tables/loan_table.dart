import 'package:drift/drift.dart';

import 'account_table.dart';
import 'stakeholder_table.dart';

/// 借贷账户表 (LoanAccount) [account_loan]
/// 在基础账户表的基础上，扩展借贷账户特有的信息。
@DataClassName('LoanAccountData')
class AccountLoan extends Table {
  @override
  String get tableName => 'account_loan';

  /// 关联的账户唯一标识 - 主键和外键
  IntColumn get accountId =>
      integer().named('account_id').references(Account, #accountId)();

  /// 关联的相关方唯一标识 - 索引[0]
  IntColumn get stakeholderId => integer()
      .named('stakeholder_id')
      .references(Stakeholder, #stakeholderId)();

  /// 借贷类型
  TextColumn get type => text().check(type.isIn(['lend', 'borrow']))();

  /// 借贷金额（以货币最小单位存储）
  IntColumn get amount => integer()();

  /// 年化利率（基点，5%=500）
  IntColumn get rate => integer()();

  /// 借贷开始日期（1900日期系统天数）
  IntColumn get startDate => integer().named('start_date')();

  /// 借贷结束日期（1900日期系统天数）- 索引[1]
  IntColumn get endDate => integer().named('end_date')();

  /// 是否归档（0=false, 1=true）- 索引[2]
  IntColumn get archived => integer().withDefault(const Constant(0))();

  /// 备注
  TextColumn get note => text()();

  @override
  Set<Column> get primaryKey => {accountId};
}

/// 借贷计划表 (LoanPlan) [loan_plan]
/// 定义借贷账户的还款/收款计划。
@DataClassName('LoanPlanData')
class LoanPlan extends Table {
  @override
  String get tableName => 'loan_plan';

  /// 计划唯一标识 - 自增主键
  IntColumn get loanPlanId =>
      integer().autoIncrement().named('loan_plan_id')();

  /// 关联的账户唯一标识 - 索引[0]
  IntColumn get accountId =>
      integer().named('account_id').references(Account, #accountId)();

  /// 计划金额（以货币最小单位存储）
  IntColumn get amount => integer()();

  /// 到期日期（1900日期系统天数）- 索引[0]
  IntColumn get dueDate => integer().named('due_date')();

  /// 创建时间戳（毫秒级UNIX时间戳）
  IntColumn get createdAt => integer().named('created_at')();

  /// 更新时间戳（毫秒级UNIX时间戳）
  IntColumn get updatedAt => integer().named('updated_at')();

  /// 备注
  TextColumn get note => text()();
}

/// 借贷实况表 (LoanRecord) [loan_record]
/// 记录借贷账户的每次还款/收款实况。
@DataClassName('LoanRecordData')
class LoanRecord extends Table {
  @override
  String get tableName => 'loan_record';

  /// 实况唯一标识 - 自增主键
  IntColumn get loanRecordId =>
      integer().autoIncrement().named('loan_record_id')();

  /// 关联的账户唯一标识 - 索引[0]
  IntColumn get accountId =>
      integer().named('account_id').references(Account, #accountId)();

  /// 实际金额（以货币最小单位存储）
  IntColumn get amount => integer()();

  /// 实际发生时间戳（毫秒级UNIX时间戳）- 索引[0]
  IntColumn get timestamp => integer()();

  /// 创建时间戳（毫秒级UNIX时间戳）
  IntColumn get createdAt => integer().named('created_at')();

  /// 更新时间戳（毫秒级UNIX时间戳）
  IntColumn get updatedAt => integer().named('updated_at')();

  /// 备注
  TextColumn get note => text()();
}
