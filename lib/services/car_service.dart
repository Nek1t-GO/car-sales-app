import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/car.dart';

class CarService {
  static const String _baseUrl = 'http://localhost:3000/api/cars';
  //static const String _baseUrl = 'http://192.168.0.57:3000/api/cars'; // вместо localhost

  static Future<List<Car>> fetchCars() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      print('CarService response: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Car.fromJson(json)).toList();
      } else {
        throw Exception('Ошибка загрузки автомобилей: ${response.statusCode}');
      }
    } catch (e) {
      print('CarService error: $e');
      throw Exception('Ошибка при загрузке автомобилей: $e');
    }
  }

  static Future<void> addCar(Car car) async {
    final jsonBody = car.toJson();
    print('Отправляем в API: $jsonBody');

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(jsonBody),
    );

    print('Ответ от API: ${response.statusCode} ${response.body}');

    if (response.statusCode != 201) {
      throw Exception('Ошибка при добавлении автомобиля: ${response.body}');
    }
  }

  static Future<void> updateCar(Car car) async {
    final url = '$_baseUrl/${car.id}';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(car.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Ошибка при обновлении автомобиля');
    }
  }

  static Future<void> deleteCar(int id) async {
    final url = '$_baseUrl/$id';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Ошибка при удалении автомобиля');
    }
  }
}
