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
            final menu = items[index];

            // Hitung stok minimal dari menuStok
            final stokMinimum = menu.menuStok.isNotEmpty
                ? menu.menuStok.map((item) => item.totalItem).reduce((a, b) => a < b ? a : b)
                : null;

            return Card(
              child: ListTile(
                title: Text(menu.name),
                subtitle: Text('Kategori: ${menu.category}'),
                trailing: Text('Stok: ${stokMinimum?.toString() ?? "-"}'),
              ),
            );

          },
        );

      },
    );
  }
}
