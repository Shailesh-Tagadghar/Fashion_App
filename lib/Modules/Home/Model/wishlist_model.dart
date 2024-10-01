class WishlistModel {
  int? status;
  String? message;
  List<Data>? data;

  WishlistModel({this.status, this.message, this.data});

  WishlistModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  ProductId? productId;
  CategoryId? categoryId;
  String? userId;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.sId,
      this.productId,
      this.categoryId,
      this.userId,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    productId = json['product_id'] != null
        ? ProductId.fromJson(json['product_id'])
        : null;
    categoryId = json['category_id'] != null
        ? CategoryId.fromJson(json['category_id'])
        : null;
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    if (productId != null) {
      data['product_id'] = productId!.toJson();
    }
    if (categoryId != null) {
      data['category_id'] = categoryId!.toJson();
    }
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ProductId {
  String? sId;
  String? name;
  int? price;
  double? rating;
  String? description;
  List<String>? sizechart;
  List<String>? colorchart;
  List<String>? image;
  String? categoryId;
  String? salecategoryId;
  String? gender;
  String? createdAt;
  String? updatedAt;

  ProductId(
      {this.sId,
      this.name,
      this.price,
      this.rating,
      this.description,
      this.sizechart,
      this.colorchart,
      this.image,
      this.categoryId,
      this.salecategoryId,
      this.gender,
      this.createdAt,
      this.updatedAt});

  ProductId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    price = json['price'];
    rating = json['rating'];
    description = json['description'];
    sizechart = json['sizechart'].cast<String>();
    colorchart = json['colorchart'].cast<String>();
    image = json['image'].cast<String>();
    categoryId = json['category_id'];
    salecategoryId = json['salecategory_id'];
    gender = json['gender'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['name'] = name;
    data['price'] = price;
    data['rating'] = rating;
    data['description'] = description;
    data['sizechart'] = sizechart;
    data['colorchart'] = colorchart;
    data['image'] = image;
    data['category_id'] = categoryId;
    data['salecategory_id'] = salecategoryId;
    data['gender'] = gender;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class CategoryId {
  String? sId;
  String? name;

  CategoryId({this.sId, this.name});

  CategoryId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = sId;
    data['name'] = name;
    return data;
  }
}
