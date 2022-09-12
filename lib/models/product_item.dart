class ProductItem {
  int productItemID;
  String? category;
  String? name;
  double retailPrice;
  int? quantity;

  ProductItem({
    required this.productItemID,
    this.category,
    this.name,
    required this.retailPrice,
    this.quantity,
  });

  void increment() {
    quantity = quantity! + 1;
  }

  @override
  String toString() {
    return 'ProductItem(productItemID: $productItemID, name: $name)';
  }

  factory ProductItem.fromJson(Map<String, dynamic> json) => ProductItem(
        productItemID: json['productItemID'] as int,
        category: json['category'] as String?,
        name: json['name'] as String?,
        retailPrice: json['retailPrice'] as double,
      );

  Map<String, dynamic> toJson() => {
        'ProductItemID': productItemID,
        'Quantity': quantity,
        'Price': retailPrice,
      };
}