class DeliverModel {
  final int? id;
  final int? deliverId;
  final String? name;

  DeliverModel({this.id, this.deliverId, this.name});

  factory DeliverModel.fromJson(Map<String, dynamic> json) {
    return DeliverModel(
      id: json['id'],
      deliverId: json['driver_id'],
      name: json['delivery_name'],
    );
  }
}
