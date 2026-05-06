
import 'package:emp_management_flutterside/models/auth/role.dart';

class User {
  final String userName;
  final String? userFirstName;
  final String? userLastName;
  final String? email;
  final bool? enabled;
  final List<Role>? roles;

  User({
    required this.userName,
    this.userFirstName,
    this.userLastName,
    this.email,
    this.enabled,
    this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userName: json['userName'],
      userFirstName: json['userFirstName'],
      userLastName: json['userLastName'],
      email: json['email'],
      enabled: json['enabled'],
      roles: json['roles'] != null
          ? (json['roles'] as List).map((e) => Role.fromJson(e)).toList()
          : null,
    );
  }
}
