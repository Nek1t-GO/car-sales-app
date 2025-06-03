import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sale.dart';
import '../models/car.dart';
import '../models/client.dart';
import '../models/employee.dart';
import 'car_service.dart';
import 'client_service.dart';
import 'employee_service.dart';

class SaleService {
  static const String _baseUrl = 'http://localhost:3000/api/sales';
  // static const String _baseUrl = 'http://192.168.0.10:3000/api/sales'; // вместо localhost
  static Future<List<Sale>> fetchSales() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      print('SaleService response: ${response.body}');
      if (response.statusCode != 200) {
        throw Exception('Ошибка загрузки продаж: ${response.statusCode}');
      }

      final List<dynamic> data = json.decode(response.body);

      // Параллельная загрузка данных
      final clientsFuture = ClientService.fetchClients();
      final carsFuture = CarService.fetchCars();
      final employeesFuture = EmployeeService.fetchEmployees();

      final results = await Future.wait([clientsFuture, carsFuture, employeesFuture]);

      final clients = results[0] as List<Client>;
      final cars = results[1] as List<Car>;
      final employees = results[2] as List<Employee>;

      return data.map((json) {
        final sale = Sale.fromJson(json);

        // Ищем соответствующие данные для клиента, автомобиля и сотрудника
        final client = clients.firstWhere((c) => c.id == sale.idClient,
            orElse: () => Client(id: 0, fullName: '', phone: '', email: '', address: ''));
        final car = cars.firstWhere((c) => c.id == sale.idCar,
            orElse: () => Car(id: 0, year: '', idModel: 0, color: '', vin: '', price: 0));
        final employee = employees.firstWhere((e) => e.id == sale.idEmployee,
            orElse: () => Employee(id: 0, fullName: '', position: ''));

        // Устанавливаем имена для отображения
        sale.setClientName(client.fullName);
        sale.setCarName(car.vin);
        sale.setEmployeeName(employee.fullName);

        return sale;
      }).toList();
    } catch (e) {
      print('SaleService fetchSales error: $e');
      throw Exception('Ошибка при загрузке продаж: $e');
    }
  }

  static Future<Sale> addSale(Sale sale) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(sale.toJson()),
      );
      print('addSale response: ${response.body}');
      if (response.statusCode == 201) {
        return Sale.fromJson(json.decode(response.body));
      } else {
        throw Exception('Ошибка при добавлении продажи: ${response.statusCode}');
      }
    } catch (e) {
      print('SaleService addSale error: $e');
      throw Exception('Ошибка при добавлении продажи: $e');
    }
  }

  static Future<void> updateSale(Sale sale) async {
    try {
      final url = '$_baseUrl/${sale.id}';
      print('📝 Обновляем продажу: ${sale.toJson()}');
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(sale.toJson()),
      );
      print('updateSale response: ${response.body}');
      if (response.statusCode != 200) {
        throw Exception('Ошибка при обновлении продажи: ${response.statusCode}');
      }
    } catch (e) {
      print('SaleService updateSale error: $e');
      throw Exception('Ошибка при обновлении продажи: $e');
    }
  }

  static Future<void> deleteSale(int id) async {
    try {
      final url = Uri.parse('$_baseUrl/$id');
      final response = await http.delete(url);
      print('deleteSale response: ${response.body}');
      if (response.statusCode != 200) {
        throw Exception('Ошибка при удалении продажи: ${response.statusCode}');
      }
    } catch (e) {
      print('SaleService deleteSale error: $e');
      throw Exception('Ошибка при удалении продажи: $e');
    }
  }
}
