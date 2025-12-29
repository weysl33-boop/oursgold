import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Forex page - Currency calculator and pairs
class ForexPage extends ConsumerStatefulWidget {
  const ForexPage({super.key});

  @override
  ConsumerState<ForexPage> createState() => _ForexPageState();
}

class _ForexPageState extends ConsumerState<ForexPage> {
  final TextEditingController _amountController = TextEditingController(text: '1000');
  String _fromCurrency = 'USD';
  String _toCurrency = 'CNY';
  double _exchangeRate = 7.2358;
  final List<String> _currencies = ['USD', 'CNY', 'EUR', 'GBP', 'JPY', 'HKD'];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
      _exchangeRate = 1 / _exchangeRate;
    });
  }

  double _calculateConversion() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    return amount * _exchangeRate;
  }

  String _getCurrencyFlag(String currency) {
    const flags = {
      'USD': '🇺🇸',
      'CNY': '🇨🇳',
      'EUR': '🇪🇺',
      'GBP': '🇬🇧',
      'JPY': '🇯🇵',
      'HKD': '🇭🇰',
    };
    return flags[currency] ?? '🏳️';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('外汇'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('货币转换器', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: '金额',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      prefixText: '${_getCurrencyFlag(_fromCurrency)} $_fromCurrency ',
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: IconButton(
                      icon: const Icon(Icons.swap_vert, size: 32),
                      onPressed: _swapCurrencies,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('结果', style: TextStyle(fontSize: 14)),
                        Text(
                          '${_getCurrencyFlag(_toCurrency)} $_toCurrency ${_calculateConversion().toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
