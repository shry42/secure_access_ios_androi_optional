class UserByNumberModel {
  final String fullName;
  final String email;
  final String company;

  UserByNumberModel(
      {required this.fullName, required this.email, required this.company});

  factory UserByNumberModel.fromJson(Map<String, dynamic> json) {
    return UserByNumberModel(
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      company: json['company'] as String,
    );
  }
}
