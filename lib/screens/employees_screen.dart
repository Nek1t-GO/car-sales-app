import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../services/employee_service.dart';
import '../widgets/search_widget.dart';
import '../widgets/list_widget/employee_list_widget.dart';
import '../widgets/form_screen/employee_form_screen.dart';

class EmployeesScreen extends StatefulWidget {
  @override
  _EmployeesScreenState createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  List<Employee> _allEmployees = [];
  List<Employee> _filteredEmployees = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  void _loadEmployees() async {
    try {
      final employees = await EmployeeService.fetchEmployees();
      setState(() {
        _allEmployees = employees;
        _filteredEmployees = _applySearch(_searchQuery);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки сотрудников: $e')),
      );
    }
  }

  List<Employee> _applySearch(String query) {
    return _allEmployees.where((emp) {
      final q = query.toLowerCase();
      return emp.fullName.toLowerCase().contains(q) || emp.position.toLowerCase().contains(q);
    }).toList();
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query.trim();
      _filteredEmployees = _applySearch(_searchQuery);
    });
  }

  Future<void> _addEmployee() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EmployeeFormScreen()),
    );

    if (result != null && result is Employee) {
      setState(() {
        _allEmployees.add(result);
        _filteredEmployees = _applySearch(_searchQuery);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Сотрудник добавлен')),
      );
    }
  }

  void _editEmployee(Employee emp) async {
    final edited = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EmployeeFormScreen(employee: emp)),
    );

    if (edited != null && edited is Employee) {
      try {
        await EmployeeService.updateEmployee(edited);
        _loadEmployees();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Сотрудник обновлён')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при обновлении: $e')),
        );
      }
    }
  }

  void _deleteEmployee(Employee emp) async {
    try {
      await EmployeeService.deleteEmployee(emp);
      _loadEmployees();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Сотрудник удалён')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка удаления: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Сотрудники'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'Обновить список',
            onPressed: () {
              _loadEmployees();
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
            hintText: 'Поиск по имени или должности',
            onChanged: _updateSearchQuery,
          ),
          Expanded(
            child: EmployeeListWidget(
              employees: _filteredEmployees,
              onEdit: _editEmployee,
              onDelete: _deleteEmployee,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 10, 30),
            color: Colors.black12,
            width: double.infinity,
            child: Center(child: Text('Всего записей: ${_filteredEmployees.length}')),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEmployee,
        tooltip: 'Добавить сотрудника',
        child: Icon(Icons.person_add_alt),
      ),
    );
  }
}
