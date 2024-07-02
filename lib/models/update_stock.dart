class ProductData {
  final String ysdmorg;
  final String ysdmemp;
  final String id;
  final List<Product> table;

  ProductData({
    required this.ysdmorg,
    required this.ysdmemp,
    required this.id,
    required this.table,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    var tableFromJson = json['table'] as List<dynamic>;
    List<Product> tableList = tableFromJson.isNotEmpty
        ? tableFromJson.map((i) => Product.fromJson(i as Map<String, dynamic>)).toList()
        : []; // Handle case where 'table' is empty

    return ProductData(
      ysdmorg: json['ysdmorg'].toString(),
      ysdmemp: json['ysdmemp'].toString(),
      id: json['id'].toString(),
      table: tableList,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> products = table.map((i) => i.toJson()).toList();
    return {
      'ysdmorg': ysdmorg,
      'ysdmemp': ysdmemp,
      'id': id,
      'table': products,
    };
  }
}
class Product {
  final String yprodsuch;
  final String yprodnummer;
  final String yproddesc;
  final double ycurstoc;

  Product({
    required this.yprodsuch,
    required this.yprodnummer,
    required this.yproddesc,
    required this.ycurstoc,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      yprodsuch: json['yprodsuch'],
      yprodnummer: json['yprodnummer'].toString(),
      yproddesc: json['yproddesc'],
      ycurstoc:json['ycurstoc']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'yprodsuch': yprodsuch,
      'yprodnummer': yprodnummer,
      'yproddesc': yproddesc,
      'ycurstoc': ycurstoc,
    };
  }
}
