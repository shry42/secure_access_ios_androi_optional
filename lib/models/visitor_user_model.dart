class VistorUserModel {
  final int id;
  final String fullName;

  VistorUserModel({
    required this.id,
    required this.fullName,
  });

  factory VistorUserModel.fromJson(Map<String, dynamic> json) {
    return VistorUserModel(
      id: json['id'],
      fullName: json['fullName'],
    );
  }
}
