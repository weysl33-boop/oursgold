import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Detail page - Symbol detail with chart and data
class DetailPage extends ConsumerStatefulWidget {
  final String symbolCode;

  const DetailPage({
    super.key,
    required this.symbolCode,
  });

  @override
  ConsumerState<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  String _selectedPeriod = '1D';
  bool _isFavorite = false;

  final List<String> _periods = ['1D', '5D', '1M', '6M', '1Y', 'All'];

  // Mock data
  Map<String, dynamic> get _mockData {
    return {
      'XAUUSD': {
        'name': '伦敦金',
        'price': 2658.50,
        'change': 28.30,
        'changePercent': 1.08,
        'open': 2630.20,
        'high': 2665.00,
        'low': 2640.00,
        'close': 2658.50,
        'volume': 125000,
        'avgVolume': 98000,
      },
      'XAGUSD': {
        'name': '伦敦银',
        'price': 31.25,
        'change': -0.52,
        'changePercent': -1.64,
        'open': 31.77,
        'high': 31.95,
        'low': 31.15,
        'close': 31.25,
        'volume': 85000,
        'avgVolume': 72000,
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    final data = _mockData[widget.symbolCode] ?? _mockData['XAUUSD']!;
    final isPositive = data['change'] >= 0;
    final priceColor = isPositive ? Colors.red : Colors.green;

    return Scaffold(
      appBar: AppBar(
        title: Text(data['name']),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.star : Icons.star_border,
              color: _isFavorite ? Colors.amber : null,
            ),
            onPressed: () {
              setState(() => _isFavorite = !_isFavorite);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Price Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.symbolCode,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      data['price'].toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: priceColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isPositive
                                  ? Icons.arrow_drop_up
                                  : Icons.arrow_drop_down,
                              color: priceColor,
                            ),
                            Text(
                              '${data['change'].toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                color: priceColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${data['changePercent'].abs().toStringAsFixed(2)}%',
                          style: TextStyle(
                            fontSize: 14,
                            color: priceColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Data Grid
          Container(
            padding: const EdgeInsets.all(16),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 2,
              children: [
                _buildDataItem('开盘', data['open'].toStringAsFixed(2)),
                _buildDataItem('最高', data['high'].toStringAsFixed(2)),
                _buildDataItem('最低', data['low'].toStringAsFixed(2)),
                _buildDataItem('收盘', data['close'].toStringAsFixed(2)),
                _buildDataItem('成交量', _formatVolume(data['volume'])),
                _buildDataItem('平均量', _formatVolume(data['avgVolume'])),
              ],
            ),
          ),

          const Divider(height: 1),

          // Period Selector
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _periods.map((period) {
                final isSelected = period == _selectedPeriod;
                return InkWell(
                  onTap: () => setState(() => _selectedPeriod = period),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      period,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Chart Placeholder
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.candlestick_chart,
                      size: 64,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'TradingView 图表',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '周期: $_selectedPeriod',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataItem(String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatVolume(int volume) {
    if (volume >= 1000000) {
      return '${(volume / 1000000).toStringAsFixed(1)}M';
    } else if (volume >= 1000) {
      return '${(volume / 1000).toStringAsFixed(1)}K';
    }
    return volume.toString();
  }
}
