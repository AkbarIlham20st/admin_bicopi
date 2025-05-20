import 'package:flutter/material.dart';
import 'order_tab.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Orders"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "In Order"),
              Tab(text: "In Process"),
              Tab(text: "Complete"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            OrderTab(status: 'In Order'),
            OrderTab(status: 'In Process'),
            OrderTab(status: 'Complete'),
          ],
        ),
      ),
    );
  }
}