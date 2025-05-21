import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  final SupabaseClient supabase = Supabase.instance.client;

  List<OrderModel> _orders = [];

  List<OrderModel> get orders => _orders;

  Future<void> fetchOrders() async {
    final response = await supabase
        .from('orderkasir_history')
        .select()
        .order('created_at', ascending: false);
    _orders = (response as List)
        .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();

    notifyListeners();
  }

  Future<List<OrderModel>> fetchOrdersByStatus(String status) async {
    final response = await supabase
        .from('orderkasir_history')
        .select()
        .eq('catatan', status)
        .order('created_at', ascending: false);

    final List<OrderModel> orders = (response as List)
        .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return orders;
  }

  List<OrderModel> getByStatus(String status) {
    return _orders.where((order) => order.status == status).toList();
  }

  Future<void> updateOrderStatus(int id, String nextStatus) async {
    await supabase.from('orderkasir_history').update({
      'catatan': nextStatus,
    }).eq('id', id);
    await fetchOrders(); // Refresh list
  }
}