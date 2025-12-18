import 'package:drift/drift.dart';

import 'account_table.dart';
import 'ledger_table.dart';
import 'category_table.dart';

/// 账户账本关联表 (LedgerAccountRelation) [relation_account_ledger]
/// 定义账户与账本的关联关系。
@DataClassName('RelationAccountLedgerData')
class RelationAccountLedger extends Table {
  @override
  String get tableName => 'relation_account_ledger';

  /// 关联的账户唯一标识 - 复合主键
  IntColumn get accountId =>
      integer().named('account_id').references(Account, #accountId)();

  /// 关联的账本唯一标识 - 复合主键
  IntColumn get ledgerId =>
      integer().named('ledger_id').references(Ledger, #ledgerId)();

  @override
  Set<Column> get primaryKey => {accountId, ledgerId};
}

/// 分类账本关联表 (LedgerCategoryRelation) [relation_category_ledger]
/// 定义分类与账本的关联关系。
@DataClassName('RelationCategoryLedgerData')
class RelationCategoryLedger extends Table {
  @override
  String get tableName => 'relation_category_ledger';

  /// 关联的分类唯一标识 - 复合主键
  IntColumn get categoryId =>
      integer().named('category_id').references(Category, #categoryId)();

  /// 关联的账本唯一标识 - 复合主键
  IntColumn get ledgerId =>
      integer().named('ledger_id').references(Ledger, #ledgerId)();

  @override
  Set<Column> get primaryKey => {categoryId, ledgerId};
}
