import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/employee.dart';

class EmployeeService {
  static const String _baseUrl = 'http://localhost:3000/api/employees';
  //static const String _baseUrl = 'http://192.168.0.10:3000/api/sales'; // вместо localhost
  static Future<List<Employee>> fetchEmployees() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Employee.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка загрузки сотрудников');
    }
  }

  // Исправленный метод addEmployee
  static Future<Employee> addEmployee(Employee employee) async {
    print('Отправляем в API: ${employee.toJson()}');
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(employee.toJson()),
    );
    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      return Employee(
        id: responseData['id'],
        fullName: employee.fullName,
        position: employee.position,
      );
    } else {
      throw Exception('Ошибка при добавлении сотрудника');
    }
  }

  static Future<void> updateEmployee(Employee employee) async {
    final url = '$_baseUrl/${employee.id}';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(employee.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Ошибка при обновлении сотрудника');
    }
  }

  static Future<void> deleteEmployee(Employee employee) async {
    final url = '$_baseUrl/${employee.id}';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Ошибка при удалении сотрудника');
    }
  }
}
