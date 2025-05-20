import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';
import 'package:admin_bicopi/models/order_detail_model.dart';

class OrderService {
  final supabase = Supabase.instance.client;

  Future<List<OrderModel>> fetchOrdersByStatus(String status) async {
    final response = await supabase
        .from('pesanan')
        .select()
        .eq('status', status)
        .order('created_at', ascending: false);
    return (response as List)
        .map((item) => OrderModel.fromJson(item))
        .toList();
  }

  Future<List<OrderDetailModel>> fetchOrderDetails(String pesananId) async {
    final response = await supabase
        .from('detail_pesanan')
        .select()
        .eq('pesanan_id', pesananId);

    return (response as List)
        .map((item) => OrderDetailModel.fromJson(item))
        .toList();
  }

  Future<void> updateOrderStatus(String id, String newStatus) async {
    await supabase.from('pesanan').update({
      'status': newStatus,
    }).eq('id', id);
  }
}