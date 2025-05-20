import 'package:flutter/material.dart';
import 'in_order_tab.dart';
import 'in_process_tab.dart';
import 'complete_tab.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Orders'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'In Order'),
              Tab(text: 'In Process'),
              Tab(text: 'Complete'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search orders...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  InOrderTab(),
                  InProcessTab(),
                  CompleteTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}