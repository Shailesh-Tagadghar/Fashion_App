class CouponModel {
  int status;
  String message;
  List<Datum> data;

  CouponModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      status: json['status'],
      message: json['message'],
      data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
    );
  }
}

class Datum {
  String id;
  String title;
  String subtitle;
  String descreption;
  int amount;
  String createdBy;
  DateTime createdAt;
  DateTime updatedAt;

  Datum({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.descreption,
    required this.amount,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json['id'] ?? '', // Use default value if null
      title: json['title'] ?? 'No Title', // Use default value if null
      subtitle: json['subtitle'] ?? 'No Subtitle', // Use default value if null
      descreption:
          json['descreption'] ?? 'No Description', // Use default value if null
      amount: json['amount'] ?? 0, // Use default value if null
      createdBy: json['createdBy'] ?? 'Unknown', // Use default value if null
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(), // Use current time if null
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(), // Use current time if null
    );
  }
}
