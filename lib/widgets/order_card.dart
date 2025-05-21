import 'package:flutter/material.dart';
import 'package:admin_bicopi/models/order_model.dart';
import 'package:admin_bicopi/pages/order/order_detail_page.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
// Navigasi ke halaman detail
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OrderDetailPage(order: order),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
// Baris atas: Nomor Pesanan dan Tanggal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.orderNo}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  order.createdAt != null
                      ? order.createdAt!.toLocal().toString().split('.').first
                      : '',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
// Info pelanggan
            Text('Nama: ${order.namaPelanggan}'),
            Text('Meja: ${order.nomorMeja}'),
            const SizedBox(height: 8),
// Ringkasan item pesanan
            Text(
              _buildItemSummary(order),
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 8),
// Total item & total harga
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total item: ${order.totalItem}'),
                Text('Rp${order.totalHarga.toStringAsFixed(0)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _buildItemSummary(OrderModel order) {
// Ambil 2 menu pertama sebagai ringkasan
    final items = order.items;
    if (items.isEmpty) return 'Tidak ada item';
    final summary = items.take(2).map((e) => '${e.qty}x ${e.menu}').join(', ');
    if (items.length > 2) {
      return '$summary, dll.';
    } else {
      return summary;
    }
  }
}