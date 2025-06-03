class VinData {
  final String vin;
  final String brand;
  final String model;
  final String country;
  final String engineCapacity;
  final String configuration;
  final String bodyType;

  VinData({
    required this.vin,
    required this.brand,
    required this.model,
    required this.country,
    required this.engineCapacity,
    required this.configuration,
    required this.bodyType,
  });

  factory VinData.fromJson(Map<String, dynamic> json) {
    return VinData(
      vin: json['vin'],
      brand: json['brand'],
      model: json['model'],
      country: json['country'],
      engineCapacity: json['engineCapacity'],
      configuration: json['configuration'],
      bodyType: json['bodyType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vin': vin,
      'brand': brand,
      'model': model,
      'country': country,
      'engineCapacity': engineCapacity,
      'configuration': configuration,
      'bodyType': bodyType,
    };
  }

  @override
  String toString() => '$vin ($bodyType)';
}
