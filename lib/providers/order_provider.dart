import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';
import 'package:admin_bicopi/models/order_detail_model.dart';

class OrderProvider with ChangeNotifier {
  List<OrderDetailModel> _details = [];

  List<OrderDetailModel> get details => _details;

  Future<void> fetchOrderDetails(String pesananId) async {
    try {
      _details = await _orderService.fetchOrderDetails(pesananId);
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching details: $e");
    }
  }

  Future<void> updateOrderStatus(String id, String newStatus) async {
    await _orderService.updateOrderStatus(id, newStatus);
    await fetchOrders(newStatus);
  }
  final OrderService _orderService = OrderService();
  List<OrderModel> _orders = [];

  List<OrderModel> get orders => _orders;
  bool isLoading = false;

  Future<void> fetchOrders(String status) async {
    isLoading = true;
    notifyListeners();
    try {
      _orders = await _orderService.fetchOrdersByStatus(status);
    } catch (e) {
      debugPrint("Error fetching orders: $e");
      _orders = [];
    }

    isLoading = false;
    notifyListeners();
  }
}