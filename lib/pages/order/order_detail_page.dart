import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order_model.dart';
import '../../providers/order_provider.dart';

class OrderDetailPage extends StatefulWidget {
  final OrderModel order;

  const OrderDetailPage({super.key, required this.order});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<OrderProvider>(context, listen: false)
        .fetchOrderDetails(widget.order.id);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderProvider>(context);
    final details = provider.details;
    String getNextStatus(String current) {
      switch (current) {
        case 'In Order':
          return 'In Process';
        case 'In Process':
          return 'Complete';
        default:
          return '';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Pesanan: ${widget.order.nomorPesanan}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Customer: ${widget.order.customerName}", style: const TextStyle(fontSize: 16)),
            Text("Total: Rp${widget.order.total}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text("Detail Pesanan:", style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: details.isEmpty
                  ? const Center(child: Text("Tidak ada data."))
                  : ListView.builder(
                itemCount: details.length,
                itemBuilder: (context, index) {
                  final item = details[index];
                  return ListTile(
                    title: Text(item.itemName),
                    subtitle: Text("Qty: ${item.quantity} - Rp${item.subTotal}"),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            if (widget.order.status != 'Complete')
              ElevatedButton(
                onPressed: () async {
                  final nextStatus = getNextStatus(widget.order.status);
                  if (nextStatus.isNotEmpty) {
                    await Provider.of<OrderProvider>(context, listen: false)
                        .updateOrderStatus(widget.order.id, nextStatus);

                    if (!mounted) return;
                    Navigator.pop(context);
                  }
                },
                child: Text("Ubah status ke ${getNextStatus(widget.order.status)}"),
              ),
          ],
        ),
      ),
    );
  }
}