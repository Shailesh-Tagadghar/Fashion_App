class CartModel {
  int? status;
  String? message;
  Data? data;
  int? total;
  int? subtotal;
  int? discount;
  int? deliveryfee;

  CartModel(
      {this.status,
      this.message,
      this.data,
      this.total,
      this.subtotal,
      this.discount,
      this.deliveryfee});

  CartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    total = json['total'];
    subtotal = json['subtotal'];
    discount = json['discount'];
    deliveryfee = json['deliveryfee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['total'] = total;
    data['subtotal'] = subtotal;
    data['discount'] = discount;
    data['deliveryfee'] = deliveryfee;
    return data;
  }
}

class Data {
  String? sId;
  List<Product>? product;
  String? userId;
  String? createdAt;
  String? updatedAt;

  Data({this.sId, this.product, this.userId, this.createdAt, this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['product'] != null) {
      product = <Product>[];
      json['product'].forEach((v) {
        product!.add(Product.fromJson(v));
      });
    }
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    if (product != null) {
      data['product'] = product!.map((v) => v.toJson()).toList();
    }
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Product {
  ProductId? productId;
  int? qty;
  String? size;
  String? sId;

  Product({this.productId, this.qty, this.size, this.sId});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'] != null
        ? ProductId.fromJson(json['product_id'])
        : null;
    qty = json['qty'];
    size = json['size'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (productId != null) {
      data['product_id'] = productId!.toJson();
    }
    data['qty'] = qty;
    data['size'] = size;
    data['_id'] = sId;
    return data;
  }
}

class ProductId {
  String? sId;
  String? name;
  int? price;
  List<String>? image;
  String? gender;

  ProductId({this.sId, this.name, this.price, this.image, this.gender});

  ProductId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    price = json['price'];
    image = json['image'].cast<String>();
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['name'] = name;
    data['price'] = price;
    data['image'] = image;
    data['gender'] = gender;
    return data;
  }
}
