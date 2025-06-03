class Client {
  final int id;
  final String fullName;
  final String phone;
  final String email;
  final String address;

  Client({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.address,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id_client'] ?? 0, // 🔥 здесь может быть null
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_client': id,
      'full_name': fullName,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }
}
