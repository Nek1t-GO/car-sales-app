import 'package:flutter/material.dart';
import '../../models/employee.dart';
import '../form_screen/employee_form_screen.dart';
import '../../services/employee_service.dart';

class EmployeeListWidget extends StatelessWidget {
  final List<Employee> employees;
  final Function(Employee) onEdit;
  final Function(Employee) onDelete;

  const EmployeeListWidget({
    Key? key,
    required this.employees,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  void _confirmDelete(BuildContext context, Employee emp) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Удалить сотрудника'),
        content: Text('Удалить ${emp.fullName}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Нет')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Да'),
          ),
        ],
      ),
    ).then((confirm) async {
      if (confirm == true) {
        await EmployeeService.deleteEmployee(emp);
        onDelete(emp);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: employees.length,
      itemBuilder: (context, index) {
        final emp = employees[index];
        return ListTile(
          title: Text(emp.fullName),
          subtitle: Text(emp.position),
          trailing: PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'edit') {
                final updatedEmployee = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmployeeFormScreen(employee: emp)),
                );
                if (updatedEmployee != null && updatedEmployee is Employee) {
                  await EmployeeService.updateEmployee(updatedEmployee);
                  onEdit(updatedEmployee);
                }
              } else if (value == 'delete') {
                _confirmDelete(context, emp);
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'edit', child: Text('Редактировать')),
              PopupMenuItem(value: 'delete', child: Text('Удалить')),
            ],
          ),
        );
      },
    );
  }
}
