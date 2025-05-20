import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_model.dart';

class OrderService {
  final supabase = Supabase.instance.client;

  Future<List<OrderModel>> fetchOrders() async {
    final response = await supabase
        .from('orders')
        .select()
        .order('created_at', ascending: false);

    return (response as List).map((json) => OrderModel(
      id: json['id'],
      imageUrl: json['image_url'],
      name: json['name'],
      detail: json['detail'],
      price: (json['price'] as num).toDouble(),
      status: json['status'],
    )).toList();
  }

  Future<void> insertOrder(OrderModel order) async {
    await supabase.from('orders').insert({
      'image_url': order.imageUrl,
      'name': order.name,
      'detail': order.detail,
      'price': order.price,
      'status': order.status,
    });
  }
}