import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/account_table.dart';
import 'tables/category_table.dart';
import 'tables/currency_table.dart';
import 'tables/ledger_table.dart';
import 'tables/loan_table.dart';
import 'tables/project_table.dart';
import 'tables/reimbursement_tables.dart';
import 'tables/relation_tables.dart';
import 'tables/stakeholder_table.dart';
import 'tables/transaction_detail_tables.dart';
import 'tables/transaction_relation_tables.dart';
import 'tables/transaction_table.dart';

part 'database.g.dart';

/// 应用数据库
/// 使用Drift ORM实现SQLite数据库操作
@DriftDatabase(
  tables: [
    // 基础表
    Currency,
    Account,
    AccountMeta,
    AccountCredit,
    AccountBonus,
    AccountLoan,
    LoanPlan,
    LoanRecord,
    Ledger,
    Category,
    Stakeholder,
    Project,
    // 交易相关表
    Transactions,
    TransactionItem,
    TransactionReduce,
    TransactionRefund,
    // 关联表
    RelationAccountLedger,
    RelationCategoryLedger,
    RelationProjectTransaction,
    RelationTransaction,
    // 报销表
    Reimbursement,
    ReimbursementItem,
    ReimbursementDetail,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// 私有构造函数
  AppDatabase._() : super(_openConnection());

  /// 单例实例
  static AppDatabase? _instance;

  /// 获取数据库实例
  static AppDatabase get instance {
    _instance ??= AppDatabase._();
    return _instance!;
  }

  /// 数据库版本
  @override
  int get schemaVersion => 1;

  /// 数据库迁移
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // 初始化默认货币数据
        await _initDefaultCurrencies();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // 未来版本升级逻辑
      },
    );
  }

  /// 初始化默认货币数据
  Future<void> _initDefaultCurrencies() async {
    final defaultCurrencies = [
      CurrencyCompanion.insert(
        currencyCode: 'CNY',
        name: '人民币',
        symbol: '¥',
        position: 'prefix',
        decimal: 2,
        icon: '🇨🇳',
        source: 'system',
      ),
      CurrencyCompanion.insert(
        currencyCode: 'USD',
        name: '美元',
        symbol: '\$',
        position: 'prefix',
        decimal: 2,
        icon: '🇺🇸',
        source: 'system',
      ),
      CurrencyCompanion.insert(
        currencyCode: 'EUR',
        name: '欧元',
        symbol: '€',
        position: 'prefix',
        decimal: 2,
        icon: '🇪🇺',
        source: 'system',
      ),
      CurrencyCompanion.insert(
        currencyCode: 'GBP',
        name: '英镑',
        symbol: '£',
        position: 'prefix',
        decimal: 2,
        icon: '🇬🇧',
        source: 'system',
      ),
      CurrencyCompanion.insert(
        currencyCode: 'JPY',
        name: '日元',
        symbol: '¥',
        position: 'prefix',
        decimal: 0,
        icon: '🇯🇵',
        source: 'system',
      ),
    ];

    await batch((batch) {
      batch.insertAll(currency, defaultCurrencies);
    });
  }

  // ============================================
  // 货币相关CRUD操作
  // ============================================

  /// 获取所有货币
  Future<List<CurrencyData>> getAllCurrencies() => select(currency).get();

  /// 根据货币代码获取货币
  Future<CurrencyData?> getCurrencyByCode(String code) =>
      (select(currency)..where((t) => t.currencyCode.equals(code)))
          .getSingleOrNull();

  /// 插入货币
  Future<int> insertCurrency(CurrencyCompanion data) =>
      into(currency).insert(data);

  /// 更新货币
  Future<bool> updateCurrency(CurrencyData data) => update(currency).replace(data);

  /// 删除货币
  Future<int> deleteCurrency(String code) =>
      (delete(currency)..where((t) => t.currencyCode.equals(code))).go();

  // ============================================
  // 账户相关CRUD操作
  // ============================================

  /// 获取所有账户
  Future<List<AccountData>> getAllAccounts() => select(account).get();

  /// 根据ID获取账户
  Future<AccountData?> getAccountById(int id) =>
      (select(account)..where((t) => t.accountId.equals(id))).getSingleOrNull();

  /// 根据类型获取账户
  Future<List<AccountData>> getAccountsByType(String type) =>
      (select(account)..where((t) => t.type.equals(type))).get();

  /// 插入账户
  Future<int> insertAccount(AccountCompanion data) =>
      into(account).insert(data);

  /// 更新账户
  Future<bool> updateAccount(AccountData data) => update(account).replace(data);

  /// 删除账户
  Future<int> deleteAccount(int id) =>
      (delete(account)..where((t) => t.accountId.equals(id))).go();

  // ============================================
  // 账户元数据相关CRUD操作
  // ============================================

  /// 获取账户的元数据
  Future<List<AccountMetaData>> getAccountMetaByAccountId(int accountId) =>
      (select(accountMeta)..where((t) => t.accountId.equals(accountId))).get();

  /// 插入账户元数据
  Future<int> insertAccountMeta(AccountMetaCompanion data) =>
      into(accountMeta).insert(data);

  /// 更新账户元数据
  Future<bool> updateAccountMeta(AccountMetaData data) =>
      update(accountMeta).replace(data);

  /// 删除账户元数据
  Future<int> deleteAccountMeta(int accountId, String scope, String key) =>
      (delete(accountMeta)
            ..where(
              (t) =>
                  t.accountId.equals(accountId) &
                  t.scope.equals(scope) &
                  t.key.equals(key),
            ))
          .go();

  // ============================================
  // 信用账户相关CRUD操作
  // ============================================

  /// 获取信用账户信息
  Future<CreditAccountData?> getCreditAccountById(int accountId) =>
      (select(accountCredit)..where((t) => t.accountId.equals(accountId)))
          .getSingleOrNull();

  /// 插入信用账户信息
  Future<int> insertCreditAccount(AccountCreditCompanion data) =>
      into(accountCredit).insert(data);

  /// 更新信用账户信息
  Future<bool> updateCreditAccount(CreditAccountData data) =>
      update(accountCredit).replace(data);

  /// 删除信用账户信息
  Future<int> deleteCreditAccount(int accountId) =>
      (delete(accountCredit)..where((t) => t.accountId.equals(accountId))).go();

  // ============================================
  // 借贷账户相关CRUD操作
  // ============================================

  /// 获取借贷账户信息
  Future<LoanAccountData?> getLoanAccountById(int accountId) =>
      (select(accountLoan)..where((t) => t.accountId.equals(accountId)))
          .getSingleOrNull();

  /// 获取所有借贷账户
  Future<List<LoanAccountData>> getAllLoanAccounts() =>
      select(accountLoan).get();

  /// 获取未归档的借贷账户
  Future<List<LoanAccountData>> getActiveLoanAccounts() =>
      (select(accountLoan)..where((t) => t.archived.equals(0))).get();

  /// 插入借贷账户信息
  Future<int> insertLoanAccount(AccountLoanCompanion data) =>
      into(accountLoan).insert(data);

  /// 更新借贷账户信息
  Future<bool> updateLoanAccount(LoanAccountData data) =>
      update(accountLoan).replace(data);

  /// 删除借贷账户信息
  Future<int> deleteLoanAccount(int accountId) =>
      (delete(accountLoan)..where((t) => t.accountId.equals(accountId))).go();

  // ============================================
  // 账本相关CRUD操作
  // ============================================

  /// 获取所有账本
  Future<List<LedgerData>> getAllLedgers() => select(ledger).get();

  /// 根据ID获取账本
  Future<LedgerData?> getLedgerById(int id) =>
      (select(ledger)..where((t) => t.ledgerId.equals(id))).getSingleOrNull();

  /// 插入账本
  Future<int> insertLedger(LedgerCompanion data) => into(ledger).insert(data);

  /// 更新账本
  Future<bool> updateLedger(LedgerData data) => update(ledger).replace(data);

  /// 删除账本
  Future<int> deleteLedger(int id) =>
      (delete(ledger)..where((t) => t.ledgerId.equals(id))).go();

  // ============================================
  // 分类相关CRUD操作
  // ============================================

  /// 获取所有分类
  Future<List<CategoryData>> getAllCategories() => select(category).get();

  /// 根据ID获取分类
  Future<CategoryData?> getCategoryById(int id) =>
      (select(category)..where((t) => t.categoryId.equals(id)))
          .getSingleOrNull();

  /// 根据类型获取分类
  Future<List<CategoryData>> getCategoriesByType(String type) =>
      (select(category)..where((t) => t.type.equals(type))).get();

  /// 获取子分类
  Future<List<CategoryData>> getChildCategories(int parentId) =>
      (select(category)..where((t) => t.parentId.equals(parentId))).get();

  /// 获取顶级分类
  Future<List<CategoryData>> getTopLevelCategories() =>
      (select(category)..where((t) => t.parentId.isNull())).get();

  /// 插入分类
  Future<int> insertCategory(CategoryCompanion data) =>
      into(category).insert(data);

  /// 更新分类
  Future<bool> updateCategory(CategoryData data) =>
      update(category).replace(data);

  /// 删除分类
  Future<int> deleteCategory(int id) =>
      (delete(category)..where((t) => t.categoryId.equals(id))).go();

  // ============================================
  // 相关方相关CRUD操作
  // ============================================

  /// 获取所有相关方
  Future<List<StakeholderData>> getAllStakeholders() =>
      select(stakeholder).get();

  /// 根据ID获取相关方
  Future<StakeholderData?> getStakeholderById(int id) =>
      (select(stakeholder)..where((t) => t.stakeholderId.equals(id)))
          .getSingleOrNull();

  /// 根据类型获取相关方
  Future<List<StakeholderData>> getStakeholdersByType(String type) =>
      (select(stakeholder)..where((t) => t.type.equals(type))).get();

  /// 插入相关方
  Future<int> insertStakeholder(StakeholderCompanion data) =>
      into(stakeholder).insert(data);

  /// 更新相关方
  Future<bool> updateStakeholder(StakeholderData data) =>
      update(stakeholder).replace(data);

  /// 删除相关方
  Future<int> deleteStakeholder(int id) =>
      (delete(stakeholder)..where((t) => t.stakeholderId.equals(id))).go();

  // ============================================
  // 项目相关CRUD操作
  // ============================================

  /// 获取所有项目
  Future<List<ProjectData>> getAllProjects() => select(project).get();

  /// 根据ID获取项目
  Future<ProjectData?> getProjectById(int id) =>
      (select(project)..where((t) => t.projectId.equals(id))).getSingleOrNull();

  /// 根据账本ID获取项目
  Future<List<ProjectData>> getProjectsByLedgerId(int ledgerId) =>
      (select(project)..where((t) => t.ledgerId.equals(ledgerId))).get();

  /// 获取未归档的项目
  Future<List<ProjectData>> getActiveProjects() =>
      (select(project)..where((t) => t.archived.equals(0))).get();

  /// 插入项目
  Future<int> insertProject(ProjectCompanion data) =>
      into(project).insert(data);

  /// 更新项目
  Future<bool> updateProject(ProjectData data) => update(project).replace(data);

  /// 删除项目
  Future<int> deleteProject(int id) =>
      (delete(project)..where((t) => t.projectId.equals(id))).go();

  // ============================================
  // 交易相关CRUD操作
  // ============================================

  /// 获取所有交易
  Future<List<TransactionData>> getAllTransactions() =>
      select(transactions).get();

  /// 根据ID获取交易
  Future<TransactionData?> getTransactionById(int id) =>
      (select(transactions)..where((t) => t.transactionId.equals(id)))
          .getSingleOrNull();

  /// 根据账本ID获取交易
  Future<List<TransactionData>> getTransactionsByLedgerId(int ledgerId) =>
      (select(transactions)..where((t) => t.ledgerId.equals(ledgerId))).get();

  /// 根据类型获取交易
  Future<List<TransactionData>> getTransactionsByType(String type) =>
      (select(transactions)..where((t) => t.type.equals(type))).get();

  /// 根据时间范围获取交易
  Future<List<TransactionData>> getTransactionsByTimeRange(
    int startTimestamp,
    int endTimestamp,
  ) =>
      (select(transactions)
            ..where(
              (t) =>
                  t.timestamp.isBiggerOrEqualValue(startTimestamp) &
                  t.timestamp.isSmallerOrEqualValue(endTimestamp),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
          .get();

  /// 插入交易
  Future<int> insertTransaction(TransactionsCompanion data) =>
      into(transactions).insert(data);

  /// 更新交易
  Future<bool> updateTransaction(TransactionData data) =>
      update(transactions).replace(data);

  /// 删除交易
  Future<int> deleteTransaction(int id) =>
      (delete(transactions)..where((t) => t.transactionId.equals(id))).go();

  // ============================================
  // 交易明细相关CRUD操作
  // ============================================

  /// 根据交易ID获取交易明细
  Future<List<TransactionItemData>> getTransactionItemsByTransactionId(
    int transactionId,
  ) =>
      (select(transactionItem)
            ..where((t) => t.transactionId.equals(transactionId)))
          .get();

  /// 插入交易明细
  Future<int> insertTransactionItem(TransactionItemCompanion data) =>
      into(transactionItem).insert(data);

  /// 更新交易明细
  Future<bool> updateTransactionItem(TransactionItemData data) =>
      update(transactionItem).replace(data);

  /// 删除交易明细
  Future<int> deleteTransactionItem(int id) =>
      (delete(transactionItem)..where((t) => t.transactionItemId.equals(id)))
          .go();

  // ============================================
  // 报销相关CRUD操作
  // ============================================

  /// 获取所有报销计划
  Future<List<ReimbursementData>> getAllReimbursements() =>
      select(reimbursement).get();

  /// 根据ID获取报销计划
  Future<ReimbursementData?> getReimbursementById(int id) =>
      (select(reimbursement)..where((t) => t.reimbursementId.equals(id)))
          .getSingleOrNull();

  /// 获取未归档的报销计划
  Future<List<ReimbursementData>> getActiveReimbursements() =>
      (select(reimbursement)..where((t) => t.archived.equals(0))).get();

  /// 插入报销计划
  Future<int> insertReimbursement(ReimbursementCompanion data) =>
      into(reimbursement).insert(data);

  /// 更新报销计划
  Future<bool> updateReimbursement(ReimbursementData data) =>
      update(reimbursement).replace(data);

  /// 删除报销计划
  Future<int> deleteReimbursement(int id) =>
      (delete(reimbursement)..where((t) => t.reimbursementId.equals(id))).go();

  // ============================================
  // 借贷计划相关CRUD操作
  // ============================================

  /// 根据账户ID获取借贷计划
  Future<List<LoanPlanData>> getLoanPlansByAccountId(int accountId) =>
      (select(loanPlan)..where((t) => t.accountId.equals(accountId))).get();

  /// 插入借贷计划
  Future<int> insertLoanPlan(LoanPlanCompanion data) =>
      into(loanPlan).insert(data);

  /// 更新借贷计划
  Future<bool> updateLoanPlan(LoanPlanData data) =>
      update(loanPlan).replace(data);

  /// 删除借贷计划
  Future<int> deleteLoanPlan(int id) =>
      (delete(loanPlan)..where((t) => t.loanPlanId.equals(id))).go();

  // ============================================
  // 借贷实况相关CRUD操作
  // ============================================

  /// 根据账户ID获取借贷实况
  Future<List<LoanRecordData>> getLoanRecordsByAccountId(int accountId) =>
      (select(loanRecord)..where((t) => t.accountId.equals(accountId))).get();

  /// 插入借贷实况
  Future<int> insertLoanRecord(LoanRecordCompanion data) =>
      into(loanRecord).insert(data);

  /// 更新借贷实况
  Future<bool> updateLoanRecord(LoanRecordData data) =>
      update(loanRecord).replace(data);

  /// 删除借贷实况
  Future<int> deleteLoanRecord(int id) =>
      (delete(loanRecord)..where((t) => t.loanRecordId.equals(id))).go();

  // ============================================
  // 关联表相关CRUD操作
  // ============================================

  /// 添加账户与账本的关联
  Future<int> addAccountToLedger(int accountId, int ledgerId) =>
      into(relationAccountLedger).insert(
        RelationAccountLedgerCompanion.insert(
          accountId: accountId,
          ledgerId: ledgerId,
        ),
      );

  /// 删除账户与账本的关联
  Future<int> removeAccountFromLedger(int accountId, int ledgerId) =>
      (delete(relationAccountLedger)
            ..where(
              (t) =>
                  t.accountId.equals(accountId) & t.ledgerId.equals(ledgerId),
            ))
          .go();

  /// 获取账本下的所有账户ID
  Future<List<int>> getAccountIdsByLedgerId(int ledgerId) async {
    final relations = await (select(relationAccountLedger)
          ..where((t) => t.ledgerId.equals(ledgerId)))
        .get();
    return relations.map((r) => r.accountId).toList();
  }

  /// 添加分类与账本的关联
  Future<int> addCategoryToLedger(int categoryId, int ledgerId) =>
      into(relationCategoryLedger).insert(
        RelationCategoryLedgerCompanion.insert(
          categoryId: categoryId,
          ledgerId: ledgerId,
        ),
      );

  /// 删除分类与账本的关联
  Future<int> removeCategoryFromLedger(int categoryId, int ledgerId) =>
      (delete(relationCategoryLedger)
            ..where(
              (t) =>
                  t.categoryId.equals(categoryId) &
                  t.ledgerId.equals(ledgerId),
            ))
          .go();

  /// 获取账本下的所有分类ID
  Future<List<int>> getCategoryIdsByLedgerId(int ledgerId) async {
    final relations = await (select(relationCategoryLedger)
          ..where((t) => t.ledgerId.equals(ledgerId)))
        .get();
    return relations.map((r) => r.categoryId).toList();
  }

  /// 添加交易与项目的关联
  Future<int> addTransactionToProject(int transactionId, int projectId) =>
      into(relationProjectTransaction).insert(
        RelationProjectTransactionCompanion.insert(
          transactionId: transactionId,
          projectId: projectId,
        ),
      );

  /// 删除交易与项目的关联
  Future<int> removeTransactionFromProject(int transactionId, int projectId) =>
      (delete(relationProjectTransaction)
            ..where(
              (t) =>
                  t.transactionId.equals(transactionId) &
                  t.projectId.equals(projectId),
            ))
          .go();
}

/// 打开数据库连接
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'track_expenses.db'));
    return NativeDatabase.createInBackground(file);
  });
}
