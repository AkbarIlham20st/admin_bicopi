class OrderItem {
  final int qty;
  final String menu;
  final double price;

  OrderItem({required this.qty, required this.menu, required this.price});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      qty: json['qty'],
      menu: json['menu'],
      price: (json['price'] as num).toDouble(),
    );
  }
}

class OrderModel {
  final int id;
  final String orderNo;
  final String nomorMeja;
  final String namaPelanggan;
  final String catatan;
  final List<OrderItem> items;
  final int totalItem;
  final double totalHarga;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.orderNo,
    required this.nomorMeja,
    required this.namaPelanggan,
    required this.catatan,
    required this.items,
    required this.totalItem,
    required this.totalHarga,
    required this.createdAt,
  });

// Getter tambahan sebagai alias catatan
  String get status => catatan;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>;
    final items = itemsJson.map((e) => OrderItem.fromJson(e)).toList();
    return OrderModel(
      id: json['id'],
      orderNo: json['order_no'],
      nomorMeja: json['nomor_meja'],
      namaPelanggan: json['nama_pelanggan'],
      catatan: json['catatan'],
      items: items,
      totalItem: json['total_item'],
      totalHarga: (json['total_harga'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}