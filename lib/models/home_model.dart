// List<Product> productFromJson(String str) =>
//     List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));
//
// String productToJson(List<Product> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  var id;

  var brand;

  var name;

  Product({
    this.id,
    this.brand,
    this.name,
  });
}
