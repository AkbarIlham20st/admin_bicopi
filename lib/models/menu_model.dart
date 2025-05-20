class MenuModel {
  final String? id;
  final String title;
  final String imageUrl;
  final String description;
  final double price;
  final String category;
  final int categoryId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MenuModel({
    this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.category,
    required this.categoryId,
    this.createdAt,
    this.updatedAt,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['id_menu'],
      imageUrl: json['foto_menu'],
      title: json['nama_menu'],
      description: json['deskripsi_menu'],
      price: (json['harga_menu'] as num).toDouble(),
      category: json['kategori'],
      categoryId: json['id_kategori_menu'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_menu': id,
      'foto_menu': imageUrl,
      'nama_menu': title,
      'deskripsi_menu': description,
      'harga_menu': price,
      'kategori': category,
      'id_kategori_menu': categoryId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}