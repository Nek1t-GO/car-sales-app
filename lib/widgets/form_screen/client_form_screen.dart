import 'package:flutter/material.dart';
import '../../models/client.dart';
import '../../services/client_service.dart';

class ClientFormScreen extends StatefulWidget {
  final Client? client;

  const ClientFormScreen({Key? key, this.client}) : super(key: key);

  @override
  _ClientFormScreenState createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends State<ClientFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.client != null) {
      _nameController.text = widget.client!.fullName;
      _phoneController.text = widget.client!.phone;
      _emailController.text = widget.client!.email;
      _addressController.text = widget.client!.address;
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final edited = Client(
        id: widget.client?.id ?? 0,
        fullName: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        address: _addressController.text,
      );

      try {
        if (widget.client == null) {
          final newClient = await ClientService.addClient(edited);
          Navigator.pop(context, newClient);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Клиент добавлен')));
        } else {
          await ClientService.updateClient(edited);
          Navigator.pop(context, edited);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Клиент обновлён')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.client != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Редактировать клиента' : 'Добавить клиента'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'ФИО'),
                validator: (val) => val == null || val.isEmpty ? 'Введите имя' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Телефон'),
                validator: (val) => val == null || val.isEmpty ? 'Введите телефон' : null,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (val) => val == null || val.isEmpty ? 'Введите email' : null,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Адрес'),
                validator: (val) => val == null || val.isEmpty ? 'Введите адрес' : null,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submit,
                child: Text(isEditing ? 'Сохранить изменения' : 'Добавить клиента'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
