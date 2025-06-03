import 'package:flutter/material.dart';
import '../models/vin_model.dart';
import '../services/vin_service.dart';

class AddVinScreen extends StatefulWidget {
  @override
  _AddVinScreenState createState() => _AddVinScreenState();
}

class _AddVinScreenState extends State<AddVinScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vinController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _engineController = TextEditingController();
  String? _selectedBodyType;
  String? _selectedConfiguration;
  String? _selectedCountry;

  final List<String> bodyTypes = [
    'Седан',
    'Хэтчбек',
    'Универсал',
    'Кроссовер',
    'Купе',
    'Кабриолет',
    'Минивэн',
    'Пикап',
    'Лифтбэк',
  ];

  final List<String> configurations = [
    'Стандарт',
    'Купе',
    'Люкс',
    'Спорт',
  ];

  final List<String> countryList = [
    'Россия',
    'Германия',
    'Япония',
    'США',
    'Франция',
    'Италия',
    'Южная Корея',
    'Китай',
    'Великобритания',
    'Швеция',
  ];

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newVin = VinData(
        vin: _vinController.text.trim(),
        brand: _brandController.text.trim(),
        model: _modelController.text.trim(),
        country: _selectedCountry ?? '',
        engineCapacity: _engineController.text.trim(),
        bodyType: _selectedBodyType ?? '',
        configuration: _selectedConfiguration ?? '',
      );

      VinService.addVin(newVin);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('VIN добавлен')),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _vinController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _engineController.dispose();
    super.dispose();
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool required = false, TextCapitalization capitalization = TextCapitalization.none}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        textCapitalization: capitalization,
        validator: required
            ? (value) => (value == null || value.trim().isEmpty) ? 'Обязательное поле' : null
            : null,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Добавить VIN')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_vinController, 'VIN (17 символов)',
                  required: true, capitalization: TextCapitalization.characters),
              _buildTextField(_brandController, 'Марка',
                  capitalization: TextCapitalization.sentences),
              _buildTextField(_modelController, 'Модель',
                  capitalization: TextCapitalization.sentences),
              _buildTextField(_engineController, 'Мощность л/c',
                  capitalization: TextCapitalization.sentences),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Страна'),
                value: _selectedCountry,
                items: countryList.map((country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value;
                  });
                },
                validator: (value) => value == null || value.isEmpty ? 'Выберите страну' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Тип кузова'),
                value: _selectedBodyType,
                items: bodyTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBodyType = value;
                  });
                },
                validator: (value) => value == null || value.isEmpty ? 'Выберите тип кузова' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Комплектация'),
                value: _selectedConfiguration,
                items: configurations.map((config) {
                  return DropdownMenuItem<String>(
                    value: config,
                    child: Text(config),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedConfiguration = value;
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
