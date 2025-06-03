import 'package:flutter/material.dart';
import '../models/client.dart';
import '../services/client_service.dart';
import '../widgets/search_widget.dart';
import '../widgets/list_widget/client_list_widget.dart';
import '../widgets/form_screen/client_form_screen.dart';

class ClientsScreen extends StatefulWidget {
  @override
  _ClientsScreenState createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  List<Client> _allClients = [];
  List<Client> _filteredClients = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  void _loadClients() {
    ClientService.fetchClients().then((clients) {
      setState(() {
        _allClients = clients;
        _filteredClients = _applySearch(_searchQuery);
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки клиентов: $error')),
      );
    });
  }

  List<Client> _applySearch(String query) {
    return _allClients.where((client) {
      final q = query.toLowerCase();
      return client.fullName.toLowerCase().contains(q) ||
          client.phone.contains(q) ||
          client.email.toLowerCase().contains(q);
    }).toList();
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query.trim();
      _filteredClients = _applySearch(_searchQuery);
    });
  }

  Future<void> _addClient() async {
    final newClient = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ClientFormScreen()),
    );

    if (newClient != null && newClient is Client) {
      try {
        await ClientService.addClient(newClient);
        _loadClients(); // перезагрузка данных с сервера
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Клиент успешно добавлен!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при добавлении клиента: $e')),
        );
      }
    }
  }

  void _editClient(Client target) async {
    final editedClient = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ClientFormScreen(client: target)),
    );

    if (editedClient != null && editedClient is Client) {
      try {
        await ClientService.updateClient(editedClient);
        _loadClients();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Клиент обновлён')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при обновлении клиента: $e')),
        );
      }
    }
  }

  void _deleteClient(Client target) async {
    try {
      await ClientService.deleteClient(target.id);
      _loadClients(); // перезагрузка после удаления
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Клиент удалён')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при удалении клиента: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Клиенты'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'Обновить список',
            onPressed: () {
              _loadClients();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Данные обновлены')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SearchWidget(
            hintText: 'Поиск по имени, телефону или email',
            onChanged: _updateSearchQuery,
          ),
          Expanded(
            child: ClientListWidget(
              clients: _filteredClients,
              onEdit: _editClient,
              onDelete: _deleteClient,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 10, 30),
            color: Colors.black12,
            width: double.infinity,
            child: Center(child: Text('Всего записей: ${_filteredClients.length}')),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addClient,
        tooltip: 'Добавить клиента',
        child: Icon(Icons.person_add),
      ),
    );
  }
}
