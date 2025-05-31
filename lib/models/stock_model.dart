class StockItem {
  final int idStok;
  final String namaItem;
  final int totalItem;

  StockItem({
    required this.idStok,
    required this.namaItem,
    required this.totalItem,
  });

  factory StockItem.fromJson(Map<String, dynamic> json) {
    return StockItem(
      idStok: json['id_stok'] as int,
      namaItem: json['nama_item'] as String,
      totalItem: json['total_item'] as int,
    );
  }
}

class StockModel {
  final String idMenu;
  final String name;
  final String category;
  final List<StockItem> menuStok;

  StockModel({
    required this.idMenu,
    required this.name,
    required this.category,
    required this.menuStok,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    final stokList = json['stok_items'] as List<dynamic>? ?? [];

    return StockModel(
      idMenu: json['id_menu'].toString(),
      name: json['nama_menu'] as String,
      category: json['kategori'] as String,
      menuStok: stokList.map((e) => StockItem.fromJson(e)).toList(),
    );
  }
}
