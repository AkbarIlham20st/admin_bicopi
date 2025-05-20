import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../models/order_model.dart';
import 'order_detail_page.dart';

class OrderTab extends StatefulWidget {
  final String status;

  const OrderTab({super.key, required this.status});

  @override
  State<OrderTab> createState() => _OrderTabState();
}

class _OrderTabState extends State<OrderTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<OrderProvider>(context, listen: false)
          .fetchOrders(widget.status);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderProvider>(context);
    final orders = provider.orders;
    return provider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(order.nomorPesanan),
            subtitle: Text("${order.customerName} - Rp${order.total}"),
            trailing: Text(order.status),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderDetailPage(order: order),
                ),
              );
            },
          ),
        );
      },
    );
  }
}