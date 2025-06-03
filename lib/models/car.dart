class Car {
  final int id;
  final String year;
  final int idModel;
  final String color;
  final String vin;
  final double price;
  final String? imagePath;

  Car({
    required this.id,
    required this.year,
    required this.idModel,
    required this.color,
    required this.vin,
    required this.price,
    this.imagePath,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id_car'],
      year: json['year'],
      idModel: json['id_model'],
      color: json['color'],
      vin: json['vin'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      imagePath: json['image_path']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_car': id,
      'year': year,
      'id_model': idModel,
      'color': color,
      'vin': vin,
      'price': price,
      'image_path': imagePath,
    };
  }
}
