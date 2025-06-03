import '../../models/car.dart';
import '../../services/car_service.dart';
import 'package:flutter/material.dart';

class CarFormWidget extends StatefulWidget {
  @override
  _CarFormWidgetState createState() => _CarFormWidgetState();
}

class _CarFormWidgetState extends State<CarFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _vinController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Добавить автомобиль')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(labelText: 'Год выпуска'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              TextFormField(
                controller: _vinController,
                decoration: InputDecoration(labelText: 'VIN'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Цена'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  if (_formKey.currentState!.validate()) {
                    // Submit form
                  }
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newCar = Car(
                      id: DateTime.now().millisecondsSinceEpoch,
                      vin: _vinController.text,
                      year: _yearController.text,
                      idModel: 1,
                      color: 'Не указан',
                      price: double.parse(_priceController.text),
                    );
                    try {
                      await CarService.addCar(newCar);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Автомобиль успешно добавлен')),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ошибка при добавлении автомобиля: $e')),
                      );
                    }
                  }
                },
                child: Text('Добавить автомобиль'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
