import 'package:flutter/material.dart';
import '../../models/car.dart';
import '../form_screen/car_form_screen.dart';
import '../../services/car_service.dart';

class CarListWidget extends StatelessWidget {
  final List<Car> cars;
  final Function(Car updatedCar) onEdit;
  final Function(Car carToDelete) onDelete;

  const CarListWidget({
    Key? key,
    required this.cars,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cars.length,
      itemBuilder: (context, index) {
        final car = cars[index];
        return ListTile(
          title: Text('${car.vin}'),
          subtitle: Text('${car.year} | ${car.color}'),
          trailing: PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'edit') {
                final updatedCar = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarFormScreen(car: car),
                  ),
                );
                if (updatedCar != null && updatedCar is Car) {
                  await CarService.updateCar(updatedCar);
                  onEdit(updatedCar);
                }
              } else if (value == 'delete') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Удалить автомобиль'),
                    content: Text('Вы уверены, что хотите удалить этот автомобиль?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text('Нет'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text('Да'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await CarService.deleteCar(car.id);
                  onDelete(car);
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
