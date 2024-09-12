class UserListModel {
  final int id;
  final String firstName;
  final String lastName;

  UserListModel(
      {required this.id, required this.firstName, required this.lastName});

  factory UserListModel.fromJson(Map<String, dynamic> json) {
    return UserListModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}
