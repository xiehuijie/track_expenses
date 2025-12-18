import 'package:drift/drift.dart';

/// 相关方表 (Stakeholder) [stakeholder]
/// 用于描述参与交易相关的人员、商户、企业、实体等对象。
@DataClassName('StakeholderData')
class Stakeholder extends Table {
  /// 相关方唯一标识 - 自增主键
  IntColumn get stakeholderId =>
      integer().autoIncrement().named('stakeholder_id')();

  /// 相关方名称
  TextColumn get name => text()();

  /// 相关方类型 - 索引[0]
  TextColumn get type => text().check(
    type.isIn(['person', 'merchant', 'company', 'other']),
  )();

  /// 相关方头像
  TextColumn get avatar => text()();

  /// 相关方描述
  TextColumn get description => text()();

  /// 联系方式
  TextColumn get contact => text()();

  /// 创建时间戳（毫秒级UNIX时间戳）
  IntColumn get createdAt => integer().named('created_at')();

  /// 更新时间戳（毫秒级UNIX时间戳）
  IntColumn get updatedAt => integer().named('updated_at')();

  /// 备注
  TextColumn get note => text()();
}
