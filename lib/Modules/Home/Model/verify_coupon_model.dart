class VerifyCouponModel {
  int? status;
  String? message;
  VerifyCouponData? data;

  VerifyCouponModel({this.status, this.message, this.data});

  VerifyCouponModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? new VerifyCouponData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class VerifyCouponData {
  int? subtotal;
  int? deliveryfee;
  int? discount;
  int? total;

  VerifyCouponData(
      {this.subtotal, this.deliveryfee, this.discount, this.total});

  VerifyCouponData.fromJson(Map<String, dynamic> json) {
    subtotal = json['subtotal'];
    deliveryfee = json['deliveryfee'];
    discount = json['discount'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subtotal'] = this.subtotal;
    data['deliveryfee'] = this.deliveryfee;
    data['discount'] = this.discount;
    data['total'] = this.total;
    return data;
  }
}
