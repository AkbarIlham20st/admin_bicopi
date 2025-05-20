import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';

class OrderProvider with ChangeNotifier {
  final OrderService _orderService = OrderService();
  List<OrderModel> _orders = [];

  List<OrderModel> get orders => _orders;

  Future<void> loadOrders() async {
    _orders = await _orderService.fetchOrders();
    notifyListeners();
  }

  Future<void> addOrder(OrderModel order) async {
    await _orderService.insertOrder(order);
    await loadOrders();
  }
}