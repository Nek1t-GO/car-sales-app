import 'package:flutter/material.dart';
import '../../models/employee.dart';
import '../../services/employee_service.dart';

class EmployeeFormScreen extends StatefulWidget {
  final Employee? employee;

  const EmployeeFormScreen({Key? key, this.employee}) : super(key: key);

  @override
  _EmployeeFormScreenState createState() => _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends State<EmployeeFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _positionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _nameController.text = widget.employee!.fullName;
      _positionController.text = widget.employee!.position;
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final emp = Employee(
        id: widget.employee?.id ?? 0,
        fullName: _nameController.text,
        position: _positionController.text,
      );
      print('📤 Отправляем в API: ${emp.toJson()}');
      try {
        if (widget.employee == null) {
          final newEmployee = await EmployeeService.addEmployee(emp);
          Navigator.pop(context, newEmployee); // Возвращаем нового сотрудника
        } else {
          // Если сотрудник редактируется, обновляем его
          await EmployeeService.updateEmployee(emp);
          Navigator.pop(context, true); // Возвращаем флаг успешного обновления
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.employee != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Редактировать сотрудника' : 'Добавить сотрудника'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'ФИО'),
                validator: (v) => v == null || v.isEmpty ? 'Введите имя' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _positionController,
                decoration: InputDecoration(labelText: 'Должность'),
                validator: (v) => v == null || v.isEmpty ? 'Введите должность' : null,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submit,
                child: Text(isEditing ? 'Сохранить' : 'Добавить'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
