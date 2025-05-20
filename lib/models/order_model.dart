class OrderModel {
  final String id;
  final String nomorPesanan;
  final String customerName;
  final double total;
  final String status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.nomorPesanan,
    required this.customerName,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      nomorPesanan: json['nomor_pesanan'],
      customerName: json['customer_name'],
      total: (json['total'] as num).toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}