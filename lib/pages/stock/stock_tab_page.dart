import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/stock_model.dart';
import '../../providers/stock_provider.dart';
import 'stock_detail_page.dart';

class StockTabPage extends StatefulWidget {
  final String category;

  const StockTabPage({super.key, required this.category});

  @override
  State<StockTabPage> createState() => _StockTabPageState(); // ✅ INI YANG HARUS ADA
}

class _StockTabPageState extends State<StockTabPage> {
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      Provider.of<StockProvider>(context, listen: false).fetchStocks();
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StockProvider>(
      builder: (context, provider, _) {
        final items = provider.getItemsByCategory(widget.category);

        if (items.isEmpty) {
          return const Center(child: Text('Tidak ada data.'));
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final hasStock = item.menuStok.isNotEmpty;
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(item.name),
                subtitle: Text(
                  hasStock
                      ? 'Stok tersedia: ${item.menuStok.first.totalItem}'
                      : 'Belum ada stok',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: hasStock
                    ? () async {
                  final shouldRefresh = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StockDetailPage(item: item),
                    ),
                  );

                  if (shouldRefresh == true) {
                    provider.fetchStocks();
                  }
                }
                    : null, // Tidak bisa ditekan kalau tidak ada stok
              ),
            );
          },
        );
      },
    );
  }
}
