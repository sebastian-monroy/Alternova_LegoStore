class Product {
  final int id;
  final String name;
  final double unitPrice;
  int stock;
  final String image;
  final String? description;

  Product({
    required this.id,
    required this.name,
    required this.unitPrice,
    required this.stock,
    required this.image,
    this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        unitPrice: json['unit_price'].toDouble(),
        stock: json['stock'],
        image: json['image'],
        description: json['description'],
      );
}
