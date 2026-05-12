import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final _symbols = <String, String>{
    'PHP': '₱',
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    'SGD': 'S\$',
    'AUD': 'A\$',
  };

  static String format(double amount, String currency) {
    final symbol = _symbols[currency] ?? currency;
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return '$symbol ${formatter.format(amount)}';
  }

  static String symbol(String currency) => _symbols[currency] ?? currency;

  static List<String> get supportedCurrencies => _symbols.keys.toList();
}
