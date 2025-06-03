class Employee {
  final int? id;
  final String fullName;
  final String position;

  Employee({
    this.id,
    required this.fullName,
    required this.position,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id_employee'],
      fullName: json['full_name'],
      position: json['position'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'position': position,
    };
  }

  Map<String, dynamic> toJsonWithId() {
    return {
      'id_employee': id,
      'full_name': fullName,
      'position': position,
    };
  }
}
