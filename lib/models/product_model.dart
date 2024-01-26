class Product {
  int? _totalSize;
  int? _typeId;
  int? _offset;
  late List<ProductModel>? _products;
  //create list get for ui get values
  List<ProductModel> get products => _products!;

  Product(
      {required totalSize,
      required typeId,
      required offset,
      required products}) {
    //pass value in private memeber to contructor initialize
    // ignore: unnecessary_this
    this._totalSize = totalSize;
    // ignore: unnecessary_this
    this._typeId = typeId;
    // ignore: unnecessary_this
    this._offset = offset;
    // ignore: unnecessary_this
    this._products = products;
  }

  Product.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _typeId = json['type_id'];
    _offset = json['offset'];
    if (json['products'] != null) {
      _products = <ProductModel>[];
      json['products'].forEach((v) {
        _products!.add(ProductModel.fromJson(v));
      });
    }
  }
}

class ProductModel {
  int? id;
  String? name;
  String? description;
  int? price;
  int? stars;
  String? img;
  String? location;
  String? createdAt;
  String? updatedAt;
  int? typeId;

  ProductModel(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.stars,
      this.img,
      this.location,
      this.createdAt,
      this.updatedAt,
      this.typeId});

  //convert map or json to obj
  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    stars = json['stars'];
    img = json['img'];
    location = json['location'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    typeId = json['type_id'];
  }

  //convert obj to map
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "stars": stars,
      "img": img,
      "location": location,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "typeId": typeId,
    };
  }
}
