import 'package:flutter/material.dart';
import '../../models/sale.dart';
import '../../models/car.dart';
import '../../models/client.dart';
import '../../models/employee.dart';
import '../../services/car_service.dart';
import '../../services/client_service.dart';
import '../../services/employee_service.dart';
import '../../services/sale_service.dart';

class SaleFormScreen extends StatefulWidget {
  final Sale? sale;

  const SaleFormScreen({Key? key, this.sale}) : super(key: key);

  @override
  _SaleFormScreenState createState() => _SaleFormScreenState();
}

class _SaleFormScreenState extends State<SaleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _saleDate;
  double? _finalPrice;
  Car? _selectedCar;
  Client? _selectedClient;
  Employee? _selectedEmployee;

  List<Car> _cars = [];
  List<Client> _clients = [];
  List<Employee> _employees = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final cars = await CarService.fetchCars();
    final clients = await ClientService.fetchClients();
    final employees = await EmployeeService.fetchEmployees();

    setState(() {
      _cars = cars;
      _clients = clients;
      _employees = employees;

      if (widget.sale != null) {
        _saleDate = widget.sale!.saleDate;
        _finalPrice = widget.sale!.finalPrice;
        _selectedCar =
            _cars.firstWhere((car) => car.id == widget.sale!.idCar, orElse: () => _cars.first);
        _selectedClient = _clients.firstWhere((client) => client.id == widget.sale!.idClient,
            orElse: () => _clients.first);
        _selectedEmployee = _employees.firstWhere(
            (employee) => employee.id == widget.sale!.idEmployee,
            orElse: () => _employees.first);
      }
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate() &&
        _saleDate != null &&
        _selectedCar != null &&
        _selectedClient != null &&
        _selectedEmployee != null) {
      final newSale = Sale(
        id: widget.sale?.id ?? 0,
        idCar: _selectedCar!.id,
        idClient: _selectedClient!.id,
        idEmployee: _selectedEmployee?.id ?? 0,
        saleDate: _saleDate!,
        finalPrice: _finalPrice!,
      );

      try {
        if (widget.sale == null) {
          final createdSale = await SaleService.addSale(newSale);
          Navigator.pop(context, createdSale);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Продажа добавлена')));
        } else {
          await SaleService.updateSale(newSale);
          Navigator.pop(context, newSale);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Продажа обновлена')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
      }
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _saleDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _saleDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.sale != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Редактировать продажу' : 'Добавить продажу'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Дата продажи
              ListTile(
                title: Text(_saleDate == null
                    ? 'Выберите дату'
                    : 'Дата продажи: ${_saleDate!.toLocal().toString().split(' ')[0]}'),
                trailing: Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              SizedBox(height: 16),

              // Цена
              TextFormField(
                controller: TextEditingController(
                    text: _finalPrice != null ? _finalPrice!.toStringAsFixed(2) : ''),
                decoration: InputDecoration(labelText: 'Финальная цена'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return 'Введите корректную цену';
                  }
                  return null;
                },
                onChanged: (value) => _finalPrice = double.tryParse(value),
              ),
              SizedBox(height: 16),

              // Автомобиль
              DropdownButtonFormField<Car>(
                value: _selectedCar,
                items: _cars
                    .map((car) => DropdownMenuItem(
                          value: car,
                          child: Text(car.vin),
                        ))
                    .toList(),
                decoration: InputDecoration(labelText: 'Автомобиль'),
                onChanged: (value) => setState(() => _selectedCar = value),
                validator: (value) => value == null ? 'Выберите авто' : null,
              ),
              SizedBox(height: 16),

              // Клиент
              DropdownButtonFormField<Client>(
                value: _selectedClient,
                items: _clients
                    .map((client) => DropdownMenuItem(
                          value: client,
                          child: Text(client.fullName),
                        ))
                    .toList(),
                decoration: InputDecoration(labelText: 'Клиент'),
                onChanged: (value) => setState(() => _selectedClient = value),
                validator: (value) => value == null ? 'Выберите клиента' : null,
              ),
              SizedBox(height: 16),

              // Сотрудник
              DropdownButtonFormField<Employee>(
                value: _selectedEmployee,
                items: _employees
                    .map((emp) => DropdownMenuItem(
                          value: emp,
                          child: Text(emp.fullName),
                        ))
                    .toList(),
                decoration: InputDecoration(labelText: 'Сотрудник'),
                onChanged: (value) => setState(() => _selectedEmployee = value),
                validator: (value) => value == null ? 'Выберите сотрудника' : null,
              ),
              SizedBox(height: 32),

              ElevatedButton(
                onPressed: _submit,
                child: Text(isEditing ? 'Сохранить' : 'Добавить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
