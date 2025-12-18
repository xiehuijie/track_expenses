import 'package:drift/drift.dart';

import 'project_table.dart';
import 'transaction_table.dart';

/// 交易与项目关联表 (TransactionProjectRelation) [relation_project_transaction]
@DataClassName('RelationProjectTransactionData')
class RelationProjectTransaction extends Table {
  @override
  String get tableName => 'relation_project_transaction';

  /// 关联的交易唯一标识 - 复合主键
  IntColumn get transactionId => integer()
      .named('transaction_id')
      .references(Transactions, #transactionId)();

  /// 关联的项目唯一标识 - 复合主键
  IntColumn get projectId =>
      integer().named('project_id').references(Project, #projectId)();

  @override
  Set<Column> get primaryKey => {transactionId, projectId};
}

/// 交易关联表 (TransactionRelation) [relation_transaction]
/// 用于记录交易之间的关联关系。
@DataClassName('RelationTransactionData')
class RelationTransaction extends Table {
  @override
  String get tableName => 'relation_transaction';

  /// 关联的目标交易唯一标识 - 复合主键
  IntColumn get targetTransactionId => integer()
      .named('target_transaction_id')
      .references(Transactions, #transactionId)();

  /// 关联的源交易唯一标识 - 复合主键
  IntColumn get sourceTransactionId => integer()
      .named('source_transaction_id')
      .references(Transactions, #transactionId)();

  /// 关联关系类型
  TextColumn get type => text().check(
    type.isIn(['afterwards', 'forwards', 'children', 'parent', 'related']),
  )();

  @override
  Set<Column> get primaryKey => {targetTransactionId, sourceTransactionId};
}
