import 'package:flutter/material.dart';
import '../../models/stock_model.dart';

class StockDetailPage extends StatelessWidget {
  final StockModel item;

  const StockDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nama: ${item.name}", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Kategori: ${item.category}"),
            const SizedBox(height: 8),
            Text("Stok tersedia: ${item.menuStok}"),
          ],
        ),
      ),
    );
  }
}
