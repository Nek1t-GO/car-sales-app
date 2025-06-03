import 'package:flutter/material.dart';
import '../../models/sale.dart';
import '../../services/sale_service.dart';
import '../form_screen/sale_form_screen.dart';

class SaleListWidget extends StatelessWidget {
  final List<Sale> sales;
  final Function(Sale) onEdit;
  final Function(Sale) onDelete;

  const SaleListWidget(
      {Key? key, required this.sales, required this.onEdit, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sales.length,
      itemBuilder: (context, index) {
        final sale = sales[index];
        return ListTile(
          title: Text('Продажа ID: ${sale.id}'),
          subtitle: Text(
              'Дата: ${sale.saleDate.toLocal().toString().split(' ')[0]} | Цена: ${sale.finalPrice} ₽'),
          trailing: PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'edit') {
                final updatedSale = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SaleFormScreen(sale: sale)),
                );
                if (updatedSale != null && updatedSale is Sale) {
                  await SaleService.updateSale(updatedSale);
                  onEdit(updatedSale);
                }
              } else if (value == 'delete') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Подтвердите удаление'),
                    content: Text('Вы уверены, что хотите удалить эту продажу?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('Отмена'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Удалить'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await SaleService.deleteSale(sale.id);
                  onDelete(sale);
                }
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'edit', child: Text('Редактировать')),
              PopupMenuItem(value: 'delete', child: Text('Удалить')),
            ],
          ),
        );
      },
    );
  }
}
