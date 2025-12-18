/// 账户类型枚举
enum AccountType {
  /// 储值账户
  balance('balance'),

  /// 信用账户
  credit('credit'),

  /// 借贷账户
  loan('loan'),

  /// 投资账户
  invest('invest'),

  /// 预付账户
  prepaid('prepaid'),

  /// 赠送金账户
  bonus('bonus');

  const AccountType(this.value);
  final String value;

  static AccountType fromValue(String value) {
    return AccountType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AccountType.balance,
    );
  }
}

/// 账户元数据作用域枚举
enum AccountMetaScope {
  /// 系统级元数据
  system('system'),

  /// 用户自定义元数据
  custom('custom');

  const AccountMetaScope(this.value);
  final String value;

  static AccountMetaScope fromValue(String value) {
    return AccountMetaScope.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AccountMetaScope.custom,
    );
  }
}

/// 借贷类型枚举
enum AccountLoanType {
  /// 借出
  lend('lend'),

  /// 借入
  borrow('borrow');

  const AccountLoanType(this.value);
  final String value;

  static AccountLoanType fromValue(String value) {
    return AccountLoanType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AccountLoanType.borrow,
    );
  }
}

/// 货币来源枚举
enum CurrencySource {
  /// 系统内置货币
  system('system'),

  /// 用户自定义货币
  custom('custom');

  const CurrencySource(this.value);
  final String value;

  static CurrencySource fromValue(String value) {
    return CurrencySource.values.firstWhere(
      (e) => e.value == value,
      orElse: () => CurrencySource.system,
    );
  }
}

/// 货币符号位置枚举
enum CurrencyPosition {
  /// 货币符号在金额前面
  prefix('prefix'),

  /// 货币符号在金额后面
  suffix('suffix');

  const CurrencyPosition(this.value);
  final String value;

  static CurrencyPosition fromValue(String value) {
    return CurrencyPosition.values.firstWhere(
      (e) => e.value == value,
      orElse: () => CurrencyPosition.prefix,
    );
  }
}

/// 分类类型枚举
enum CategoryType {
  /// 支出
  expense('expense'),

  /// 收入
  income('income'),

  /// 折扣/优惠
  discount('discount'),

  /// 税收/手续费
  cost('cost');

  const CategoryType(this.value);
  final String value;

  static CategoryType fromValue(String value) {
    return CategoryType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => CategoryType.expense,
    );
  }
}

/// 相关方类型枚举
enum StakeholderType {
  /// 个人
  person('person'),

  /// 商户
  merchant('merchant'),

  /// 公司/企业
  company('company'),

  /// 其他实体
  other('other');

  const StakeholderType(this.value);
  final String value;

  static StakeholderType fromValue(String value) {
    return StakeholderType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => StakeholderType.other,
    );
  }
}

/// 交易类型枚举
enum TransactionType {
  /// 支出
  expense('expense'),

  /// 收入
  income('income'),

  /// 转账
  transfer('transfer');

  const TransactionType(this.value);
  final String value;

  static TransactionType fromValue(String value) {
    return TransactionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TransactionType.expense,
    );
  }
}

/// 交易关联类型枚举
enum TransactionRelationType {
  /// 后续交易
  afterwards('afterwards'),

  /// 前置交易
  forwards('forwards'),

  /// 子交易
  children('children'),

  /// 父交易
  parent('parent'),

  /// 存在某种关联，但不属于上述之一
  related('related');

  const TransactionRelationType(this.value);
  final String value;

  static TransactionRelationType fromValue(String value) {
    return TransactionRelationType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TransactionRelationType.related,
    );
  }
}
