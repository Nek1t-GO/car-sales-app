import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  final List<_HomeBlock> blocks = [
    _HomeBlock(
      title: 'Автомобили',
      icon: Icons.directions_car,
      description: 'Просмотр и управление автомобилями.',
      route: AppRoutes.cars,
      buttonText: 'Перейти',
    ),
    _HomeBlock(
      title: 'Клиенты',
      icon: Icons.person,
      description: 'Список и информация о клиентах.',
      route: AppRoutes.clients,
      buttonText: 'Перейти',
    ),
    _HomeBlock(
      title: 'Продажи',
      icon: Icons.shopping_cart,
      description: 'История и оформление продаж.',
      route: AppRoutes.sales,
      buttonText: 'Перейти',
    ),
    _HomeBlock(
      title: 'Сотрудники',
      icon: Icons.people,
      description: 'Данные о сотрудниках компании.',
      route: AppRoutes.employees,
      buttonText: 'Перейти',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Главное меню')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7, // Было 0.85, стало 0.7 — карточки станут шире
          children: blocks.map((block) {
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(block.icon, size: 48, color: Theme.of(context).primaryColor),
                          SizedBox(height: 12),
                          Text(
                            block.title,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            block.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, block.route),
                      child: Text(block.buttonText),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 40),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _HomeBlock {
  final String title;
  final IconData icon;
  final String description;
  final String route;
  final String buttonText;

  _HomeBlock({
    required this.title,
    required this.icon,
    required this.description,
    required this.route,
    required this.buttonText,
  });
}
