import 'package:flutter/material.dart';
import '../widgets/list_widget/car_list_widget.dart';
import '../widgets/search_widget.dart';
import '../services/car_service.dart';
import '../models/car.dart';
import '../widgets/form_screen/car_form_screen.dart';

class CarsScreen extends StatefulWidget {
  @override
  _CarsScreenState createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  List<Car> _allCars = [];
  List<Car> _filteredCars = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  // Загрузка автомобилей с сервера
  void _loadCars() async {
    try {
      final cars = await CarService.fetchCars();
      setState(() {
        _allCars = cars;
        _filteredCars = List.from(_allCars);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при загрузке автомобилей: $e')),
      );
    }
  }

  List<Car> _applySearch(String query) {
    return _allCars.where((car) {
      return car.vin.toLowerCase().startsWith(query.toLowerCase()) || car.year.startsWith(query);
    }).toList();
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query.trim().toLowerCase();
      _filteredCars = _applySearch(_searchQuery);
    });
  }

  Future<void> _addCar() async {
    final newCar = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CarFormScreen()),
    );

    if (newCar != null && newCar is Car) {
      setState(() {
        _allCars.add(newCar);
        _filteredCars = _applySearch(_searchQuery);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Автомобиль успешно добавлен!')),
      );
    }
  }

  void _editCar(Car updatedCar) {
    setState(() {
      final index = _allCars.indexWhere((c) => c.id == updatedCar.id);
      if (index != -1) {
        _allCars[index] = updatedCar;
        _filteredCars = _applySearch(_searchQuery);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Автомобиль успешно обновлен!')),
    );
  }

  // Удаление автомобиля
  void _deleteCar(Car carToDelete) async {
    try {
      await CarService.deleteCar(carToDelete.id);
      setState(() {
        _allCars.removeWhere((c) => c.id == carToDelete.id);
        _filteredCars = _applySearch(_searchQuery);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Автомобиль удалён')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при удалении автомобиля: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Автомобили'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'Обновить список',
            onPressed: () {
              _loadCars();
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
            hintText: 'Поиск по VIN или году выпуска',
            onChanged: _updateSearchQuery,
          ),
          Expanded(
            child: CarListWidget(
              cars: _filteredCars,
              onEdit: _editCar,
              onDelete: _deleteCar,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 10, 30),
            color: Colors.black12,
            width: double.infinity,
            child: Center(child: Text('Всего записей: ${_filteredCars.length}')),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCar,
        tooltip: 'Добавить автомобиль',
        child: Icon(Icons.add),
      ),
    );
  }
}
