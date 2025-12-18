import 'package:drift/drift.dart';

/// 分类表 (Category) [category]
/// 记录交易分类信息，用于对交易进行分类管理。支持多级分类结构。
@DataClassName('CategoryData')
class Category extends Table {
  /// 分类唯一标识 - 自增主键
  IntColumn get categoryId =>
      integer().autoIncrement().named('category_id')();

  /// 父级分类唯一标识 - 索引[0]，可为空
  IntColumn get parentId =>
      integer().named('parent_id').nullable()();

  /// 分类名称 - 唯一约束[0]（与type组合）
  TextColumn get name => text()();

  /// 分类类型 - 唯一约束[0]（与name组合），索引[0]
  TextColumn get type => text().check(
    type.isIn(['expense', 'income', 'discount', 'cost']),
  )();

  /// 分类图标
  TextColumn get icon => text()();

  /// 分类排序值
  IntColumn get order => integer().named('sort_order').withDefault(const Constant(0))();

  @override
  List<Set<Column>> get uniqueKeys => [{name, type}];
}
