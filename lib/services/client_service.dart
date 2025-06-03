import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/client.dart';

class ClientService {
  static const String _baseUrl = 'http://localhost:3000/api/clients';
  //static const String _baseUrl = 'http://192.168.0.10:3000/api/sales'; // вместо localhost

  // Получить список клиентов
  static Future<List<Client>> fetchClients() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      print('ClientService response: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Client.fromJson(json)).toList();
      } else {
        throw Exception('Ошибка загрузки клиентов: ${response.statusCode}');
      }
    } catch (e) {
      print('ClientService error: $e');
      throw Exception('Ошибка при загрузке клиентов: $e');
    }
  }

  // Добавить клиента
  static Future<Client> addClient(Client client) async {
    print('Отправляем в API: ${client.toJson()}');
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(client.toJson()),
    );
    if (response.statusCode == 201) {
      return Client.fromJson(json.decode(response.body));
    } else {
      throw Exception('Ошибка при добавлении клиента');
    }
  }

  // Обновить клиента
  static Future<void> updateClient(Client client) async {
    final url = '$_baseUrl/${client.id}';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(client.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Ошибка при обновлении клиента');
    }
  }

  // Удалить клиента
  static Future<void> deleteClient(int id) async {
    final url = '$_baseUrl/$id';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Ошибка при удалении клиента');
    }
  }
}
