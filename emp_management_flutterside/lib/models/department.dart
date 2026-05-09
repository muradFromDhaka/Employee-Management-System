class DepartmentRequestDto {
  final String depName;
  final String? location;

  DepartmentRequestDto({required this.depName, this.location});

  Map<String, dynamic> toJson() {
    return {'depName': depName, 'location': location};
  }
}

class DepartmentResponseDto {
  int id;
  String depName;
  String location;

  DepartmentResponseDto({
    required this.id,
    required this.depName,
    required this.location,
  });

  factory DepartmentResponseDto.fromJson(Map<String, dynamic> json) {
    return DepartmentResponseDto(
      id: json['id'],
      depName: json['depName'],
      location: json['location'],
    );
  }
}
