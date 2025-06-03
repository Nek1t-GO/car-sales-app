import 'package:flutter/material.dart';
import 'dart:io';
import '../models/sale.dart';
import '../widgets/form_screen/sale_form_screen.dart';
import '../services/sale_service.dart';

class SaleDetailScreen extends StatelessWidget {
  final Sale sale;

  const SaleDetailScreen({Key? key, required this.sale}) : super(key: key);

  void _editSale(BuildContext context) async {
    final updatedSale = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SaleFormScreen(sale: sale),
      ),
    );

    if (updatedSale != null && updatedSale is Sale) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Продажа обновлена')),
      );
      Navigator.pop(context); // Вернуться назад после редактирования
    }
  }

  void _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Удалить продажу'),
        content: Text('Вы уверены, что хотите удалить продажу №${sale.id}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await SaleService.deleteSale(sale.id);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Продажа удалена')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при удалении: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = sale.saleDate.toLocal().toString().split(' ')[0];
    return Scaffold(
      appBar: AppBar(title: Text('Продажа №${sale.id}')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sale.imagePath != null && sale.imagePath!.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(sale.imagePath!),
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            Text('Автомобиль: ${sale.carName}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Покупатель: ${sale.clientName}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Сотрудник: ${sale.employeeName}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Дата продажи: $date', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Цена: ${sale.finalPrice} ₽', style: TextStyle(fontSize: 18)),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _editSale(context),
                  icon: Icon(Icons.edit),
                  label: Text('Редактировать'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _confirmDelete(context),
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Удалить',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
