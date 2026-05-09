class Role {
  final String roleName;

  Role({required this.roleName});

  factory Role.fromJson(Map<String, dynamic> toJson) {
    return Role(
      roleName: toJson['roleName'] ?? '',
    );
  }
}