import 'package:flutter/material.dart';
import 'package:admin_bicopi/models/order_model.dart';
import 'package:admin_bicopi/services/order_service.dart';

class OrderDetailPage extends StatelessWidget {
  final OrderModel order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order No: ${order.orderNo}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Meja: ${order.nomorMeja}', style: TextStyle(fontSize: 16)),
            Text('Status: ${order.status}', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            ...order.items.map((item) => Text(
              '- ${item['qty']}x ${item['nama_menu']} @Rp${item['harga']} = Rp${item['subtotal']}',
            )),
            const Spacer(),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await OrderService().updateOrderStatus(order.id, 'In Process');
                    Navigator.pop(context, true); // Return to refresh
                  },
                  child: const Text('Set to In Process'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    debugPrint('=== CETAK STRUK ===');
                    debugPrint('Order No: ${order.orderNo}');
                    debugPrint('Meja: ${order.nomorMeja}');
                    for (var item in order.items) {
                      debugPrint('${item['qty']}x ${item['nama_menu']} @${item['harga']} = ${item['subtotal']}');
                    }
                    debugPrint('Total: Rp${order.totalHarga.toStringAsFixed(0)}');
                  },
                  child: const Text('Cetak Struk'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
