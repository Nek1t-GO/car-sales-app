import 'package:flutter/material.dart';
import '../../models/car.dart';
import '../../models/vin_model.dart';
import '../../services/car_service.dart';
import '../../services/vin_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CarFormScreen extends StatefulWidget {
  final Car? car; // Передаем сюда машину для редактирования

  const CarFormScreen({Key? key, this.car}) : super(key: key);

  @override
  _CarFormScreenState createState() => _CarFormScreenState();
}

class _CarFormScreenState extends State<CarFormScreen> {
  List<VinData> _vins = [];

  final _formKey = GlobalKey<FormState>();

  final _vinController = TextEditingController();
  final _yearController = TextEditingController();
  final _colorController = TextEditingController();
  final _priceController = TextEditingController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadVins();
    if (widget.car != null) {
      _vinController.text = widget.car!.vin;
      _yearController.text = widget.car!.year;
      _colorController.text = widget.car!.color;
      _priceController.text = widget.car!.price.toString();
      if (widget.car!.imagePath != null) {
        _imageFile = File(widget.car!.imagePath!);
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      } else {
        // Пользователь отменил выбор
        print('Выбор изображения отменён');
      }
    } catch (e) {
      print('Ошибка при выборе изображения: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось выбрать изображение')),
      );
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final editedCar = Car(
        id: widget.car?.id ?? 0, // 0 вместо DateTime.now — ID задаёт БД
        vin: _vinController.text,
        year: _yearController.text,
        idModel: 1, // пока заглушка, позже можно сделать выбор из списка
        color: _colorController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        imagePath: _imageFile?.path,
      );

      try {
        if (widget.car != null) {
          // Если машина уже существует, обновляем её
          await CarService.updateCar(editedCar);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Автомобиль обновлен')),
          );
        } else {
          // Если новая машина, добавляем её
          print('Добавление авто: ${editedCar.toJson()}');
          await CarService.addCar(editedCar);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Автомобиль добавлен')),
          );
        }

        Navigator.pop(context, editedCar); // Возвращаем добавленную или обновленную машину
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при сохранении автомобиля: $e')),
        );
      }
    }
  }

  Future<void> _loadVins() async {
    final vins = await VinService.loadVins();
    setState(() {
      _vins = vins;
    });
  }

  void _deleteVin(String code) async {
    await VinService.deleteVin(code);
    await _loadVins();
    if (_vinController.text == code) {
      _vinController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.car != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Редактировать автомобиль' : 'Добавить автомобиль'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'Обновить VIN',
            onPressed: () {
              _loadVins();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Данные обновлены')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: _vinController.text.isNotEmpty ? _vinController.text : null,
                decoration: InputDecoration(labelText: 'VIN'),
                items: _vins.map<DropdownMenuItem<String>>((VinData vin) {
                  return DropdownMenuItem<String>(
                    value: vin.vin,
                    child: Row(
                      children: [
                        Expanded(child: Text(vin.vin)),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteVin(vin.vin);
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
                selectedItemBuilder: (BuildContext context) {
                  return _vins.map<Widget>((VinData vin) {
                    return Text(vin.vin);
                  }).toList();
                },
                onChanged: (selectedVin) {
                  setState(() {
                    _vinController.text = selectedVin ?? '';
                  });
                },
                validator: (value) => value == null || value.isEmpty ? 'Выберите VIN' : null,
              ),
              SizedBox(height: 8),
              TextButton.icon(
                onPressed: () async {
                  final result = await Navigator.pushNamed(context, '/add-vin');
                  if (result is String) {
                    setState(() {
                      _vinController.text = result;
                    });
                  }
                },
                icon: Icon(Icons.add),
                label: Text('Добавить VIN'),
              ),
              Column(
                children: [
                  _imageFile != null
                      ? Image.file(_imageFile!,
                          height: 200, width: double.infinity, fit: BoxFit.cover)
                      : Container(
                          height: 120,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: Icon(Icons.directions_car, size: 100, color: Colors.grey[600]),
                        ),
                  TextButton.icon(
                    icon: Icon(Icons.photo_library),
                    label: Text('Выбрать изображение'),
                    onPressed: _pickImage,
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(labelText: 'Год выпуска'),
                validator: (value) => value == null || value.isEmpty ? 'Введите год' : null,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _colorController,
                decoration: InputDecoration(labelText: 'Цвет'),
                validator: (value) => value == null || value.isEmpty ? 'Введите цвет' : null,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Цена'),
                validator: (value) => value == null || value.isEmpty ? 'Введите цену' : null,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submit,
                child: Text(isEditing ? 'Сохранить изменения' : 'Добавить автомобиль'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
