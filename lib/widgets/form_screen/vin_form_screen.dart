import 'package:flutter/material.dart';
import '../../models/vin_model.dart';
import '../../services/vin_service.dart';

class VinFormScreen extends StatefulWidget {
  @override
  _VinFormScreenState createState() => _VinFormScreenState();
}

class _VinFormScreenState extends State<VinFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vinController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _countryController = TextEditingController();
  final _engineController = TextEditingController();
  final TextEditingController _bodyTypeController = TextEditingController();
  String? _selectedConfiguration;
  String? _selectedBodyType;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final vin = VinData(
        vin: _vinController.text.trim(),
        brand: _brandController.text.trim(),
        model: _modelController.text.trim(),
        country: _countryController.text.trim(),
        engineCapacity: _engineController.text.trim(),
        configuration: _selectedConfiguration ?? '',
        bodyType: _selectedBodyType ?? '',
      );

      VinService.addVin(vin);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('VIN добавлен')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить VIN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _vinController,
                decoration: InputDecoration(labelText: 'VIN'),
                textCapitalization: TextCapitalization.characters,
                validator: (value) => value == null || value.isEmpty ? 'Введите VIN' : null,
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                controller: _brandController,
                decoration: InputDecoration(labelText: 'Марка'),
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                controller: _modelController,
                decoration: InputDecoration(labelText: 'Модель'),
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                controller: _countryController,
                decoration: InputDecoration(labelText: 'Страна'),
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
              ),
              DropdownButtonFormField<String>(
                value: _selectedBodyType,
                decoration: InputDecoration(labelText: 'Тип кузова'),
                items: [
                  'Седан',
                  'Хэтчбек',
                  'Универсал',
                  'Кроссовер',
                  'Купе',
                  'Кабриолет',
                  'Минивэн',
                  'Пикап',
                  'Лифтбэк',
                ].map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBodyType = value!;
                  });
                },
                validator: (value) => value == null || value.isEmpty ? 'Выберите тип кузова' : null,
              ),
              TextFormField(
                controller: _engineController,
                decoration: InputDecoration(labelText: 'Мощность л/c'),
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
              ),
              DropdownButtonFormField<String>(
                value: _selectedConfiguration,
                decoration: InputDecoration(labelText: 'Комплектация'),
                items: [
                  'Стандарт',
                  'Купе',
                  'Люкс',
                  'Спорт',
                ].map((config) {
                  return DropdownMenuItem<String>(
                    value: config,
                    child: Text(config),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedConfiguration = value!;
                  });
                },
                validator: (value) =>
                    value == null || value.isEmpty ? 'Выберите комплектацию' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Добавить VIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
