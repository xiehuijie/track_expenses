import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 货币选择器组件
class CurrencyPickerDemo extends StatefulWidget {
  const CurrencyPickerDemo({super.key});

  @override
  State<CurrencyPickerDemo> createState() => _CurrencyPickerDemoState();
}

class _CurrencyPickerDemoState extends State<CurrencyPickerDemo> {
  Currency? _selectedCurrency;
  String _searchQuery = '';

  final List<Currency> _currencies = [
    Currency(code: 'CNY', name: '人民币', symbol: '¥', flag: '🇨🇳'),
    Currency(code: 'USD', name: '美元', symbol: '\$', flag: '🇺🇸'),
    Currency(code: 'EUR', name: '欧元', symbol: '€', flag: '🇪🇺'),
    Currency(code: 'GBP', name: '英镑', symbol: '£', flag: '🇬🇧'),
    Currency(code: 'JPY', name: '日元', symbol: '¥', flag: '🇯🇵'),
    Currency(code: 'HKD', name: '港币', symbol: 'HK\$', flag: '🇭🇰'),
    Currency(code: 'KRW', name: '韩元', symbol: '₩', flag: '🇰🇷'),
    Currency(code: 'SGD', name: '新加坡元', symbol: 'S\$', flag: '🇸🇬'),
    Currency(code: 'AUD', name: '澳元', symbol: 'A\$', flag: '🇦🇺'),
    Currency(code: 'CAD', name: '加元', symbol: 'C\$', flag: '🇨🇦'),
    Currency(code: 'CHF', name: '瑞士法郎', symbol: 'CHF', flag: '🇨🇭'),
    Currency(code: 'SEK', name: '瑞典克朗', symbol: 'kr', flag: '🇸🇪'),
    Currency(code: 'NZD', name: '新西兰元', symbol: 'NZ\$', flag: '🇳🇿'),
    Currency(code: 'THB', name: '泰铢', symbol: '฿', flag: '🇹🇭'),
    Currency(code: 'RUB', name: '卢布', symbol: '₽', flag: '🇷🇺'),
    Currency(code: 'INR', name: '印度卢比', symbol: '₹', flag: '🇮🇳'),
    Currency(code: 'BRL', name: '巴西雷亚尔', symbol: 'R\$', flag: '🇧🇷'),
    Currency(code: 'ZAR', name: '南非兰特', symbol: 'R', flag: '🇿🇦'),
    Currency(code: 'MXN', name: '墨西哥比索', symbol: 'Mex\$', flag: '🇲🇽'),
    Currency(code: 'TRY', name: '土耳其里拉', symbol: '₺', flag: '🇹🇷'),
  ];

  List<Currency> get _filteredCurrencies {
    if (_searchQuery.isEmpty) {
      return _currencies;
    }
    return _currencies.where((currency) {
      return currency.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          currency.code.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('货币选择'), backgroundColor: colorScheme.surfaceContainer),
      body: Column(
        children: [
          // 搜索栏
          Container(
            padding: const EdgeInsets.all(16),
            color: colorScheme.surfaceContainerHighest,
            child: TextField(
              decoration: InputDecoration(
                hintText: '搜索货币...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: colorScheme.surface,
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),

          // 当前选中货币
          if (_selectedCurrency != null)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Text(_selectedCurrency!.flag, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '当前选中',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onPrimaryContainer.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          '${_selectedCurrency!.name} (${_selectedCurrency!.code})',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          _selectedCurrency!.symbol,
                          style: TextStyle(fontSize: 14, color: colorScheme.onPrimaryContainer),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // 货币列表
          Expanded(
            child: _filteredCurrencies.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: colorScheme.onSurfaceVariant),
                        const SizedBox(height: 16),
                        Text('未找到货币', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredCurrencies.length,
                    itemBuilder: (context, index) {
                      final currency = _filteredCurrencies[index];
                      final isSelected = _selectedCurrency?.code == currency.code;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        color: isSelected
                            ? colorScheme.secondaryContainer
                            : colorScheme.surfaceContainerHighest,
                        child: ListTile(
                          leading: Text(currency.flag, style: const TextStyle(fontSize: 32)),
                          title: Text(
                            currency.name,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? colorScheme.onSecondaryContainer : null,
                            ),
                          ),
                          subtitle: Text(
                            '${currency.code} • ${currency.symbol}',
                            style: TextStyle(
                              color: isSelected
                                  ? colorScheme.onSecondaryContainer.withOpacity(0.7)
                                  : null,
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(Icons.check_circle, color: colorScheme.onSecondaryContainer)
                              : null,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() {
                              _selectedCurrency = currency;
                            });
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class Currency {
  final String code;
  final String name;
  final String symbol;
  final String flag;

  Currency({required this.code, required this.name, required this.symbol, required this.flag});
}
