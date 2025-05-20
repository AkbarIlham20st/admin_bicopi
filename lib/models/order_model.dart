class OrderModel {
  final String id;
  final String imageUrl;
  final String name;
  final String detail;
  final double price;
  final String status; // 'in_order', 'in_process', 'complete'

  OrderModel({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.detail,
    required this.price,
    required this.status,
  });
}

// models/menu_model.dart
class MenuModel {
  final String id;
  final String imageUrl;
  final String title;
  final String description;
  final double price;
  final String category; // 'food', 'drink', 'snack'

  MenuModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
  });
}