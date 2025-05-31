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
            Text("Nama: ${item.name}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Kategori: ${item.category}"),
            const SizedBox(height: 16),
            const Text("Detail Stok:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: item.menuStok.length,
                itemBuilder: (context, index) {
                  final stok = item.menuStok[index];
                  return ListTile(
                    title: Text(stok.namaItem),
                    trailing: Text('Jumlah: ${stok.totalItem}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
