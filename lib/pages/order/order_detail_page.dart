import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admin_bicopi/models/order_model.dart';
import 'package:admin_bicopi/providers/order_provider.dart';

class OrderDetailPage extends StatelessWidget {
  final OrderModel order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderProvider>(context, listen: false);
    final nextStatus = _getNextStatus(order.status);
    return Scaffold(
      appBar: AppBar(title: Text('Detail Pesanan #${order.orderNo}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: ${order.namaPelanggan}', style: const TextStyle(fontSize: 16)),
            Text('Meja: ${order.nomorMeja}'),
            const SizedBox(height: 12),
            const Text('Item Pesanan:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...order.items.map((item) => ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(item.menu),
              subtitle: Text('Qty: ${item.qty}'),
              trailing: Text('Rp${item.price.toStringAsFixed(0)}'),
            )),
            const Spacer(),
            if (nextStatus != null)
              ElevatedButton(
                onPressed: () async {
                  await provider.updateOrderStatus(order.id, nextStatus);
                  Navigator.pop(context);
                },
                child: Text('Pindahkan ke "$nextStatus"'),
              ),
          ],
        ),
      ),
    );
  }

  String? _getNextStatus(String current) {
    if (current == 'In Order') return 'In Process';
    if (current == 'In Process') return 'Complete';
    return null;
  }
}