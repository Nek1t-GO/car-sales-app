class Sale {
  final int id;
  final int idClient;
  final int idCar;
  final int idEmployee;
  final DateTime saleDate;
  final double finalPrice;
  String clientName = '';
  String carName = '';
  String employeeName = '';
  final String? imagePath;

  Sale({
    required this.id,
    required this.idClient,
    required this.idCar,
    required this.idEmployee,
    required this.saleDate,
    required this.finalPrice,
    this.imagePath,
  });

  // Метод для создания объекта из JSON
  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id_sale'] ?? 0,
      idClient: json['id_client'] ?? 0,
      idCar: json['id_car'] ?? 0,
      idEmployee: json['id_employee'] ?? 0,
      saleDate: DateTime.tryParse(json['sale_date'] ?? '') ?? DateTime.now(),
      finalPrice: (json['final_price'] != null)
          ? double.tryParse(json['final_price'].toString()) ?? 0.0
          : 0.0,
      imagePath: json['image_path'] ?? json['imagePath'],
    );
  }

  // Метод для преобразования объекта в JSON
  Map<String, dynamic> toJson() {
    return {
      'id_sale': id,
      'id_client': idClient,
      'id_car': idCar,
      'id_employee': idEmployee,
      'sale_date': saleDate.toIso8601String().split('T').first,
      'final_price': finalPrice,
      'image_path': imagePath,
    };
  }

  void setClientName(String name) => clientName = name;
  void setCarName(String name) => carName = name;
  void setEmployeeName(String name) => employeeName = name;
}
