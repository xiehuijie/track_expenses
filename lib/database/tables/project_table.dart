import 'package:drift/drift.dart';

import 'ledger_table.dart';

/// 项目表 (Project) [project]
/// 记录项目相关的信息，项目可用于对交易进行归类和预算管理。
@DataClassName('ProjectData')
class Project extends Table {
  /// 项目唯一标识 - 自增主键
  IntColumn get projectId =>
      integer().autoIncrement().named('project_id')();

  /// 关联的账本唯一标识 - 唯一约束[0]（与name组合），索引[0]
  IntColumn get ledgerId =>
      integer().named('ledger_id').references(Ledger, #ledgerId)();

  /// 项目名称 - 唯一约束[0]（与ledgerId组合）
  TextColumn get name => text()();

  /// 项目描述
  TextColumn get description => text()();

  /// 项目预算（以货币最小单位存储）
  IntColumn get budget => integer()();

  /// 项目图标
  TextColumn get icon => text()();

  /// 是否归档（0=false, 1=true）- 索引[1]
  IntColumn get archived => integer().withDefault(const Constant(0))();

  /// 创建时间戳（毫秒级UNIX时间戳）
  IntColumn get createdAt => integer().named('created_at')();

  /// 更新时间戳（毫秒级UNIX时间戳）
  IntColumn get updatedAt => integer().named('updated_at')();

  /// 项目开始日期（1900日期系统天数）
  IntColumn get startDate => integer().named('start_date')();

  /// 项目结束日期（1900日期系统天数）
  IntColumn get endDate => integer().named('end_date')();

  @override
  List<Set<Column>> get uniqueKeys => [{ledgerId, name}];
}
