import 'dart:convert';

class UserDetails {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? mobileNo;
  final String? role;
  final int? isVerified;
  final int? isManager;

  UserDetails({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobileNo,
    required this.role,
    required this.isVerified,
    required this.isManager,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      mobileNo: json['mobileNo'],
      role: json['role'],
      isVerified: json['isVerified'],
      isManager: json['isManager'],
    );
  }
}
