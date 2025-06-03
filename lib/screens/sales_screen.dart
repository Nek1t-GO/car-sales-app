import 'package:flutter/material.dart';
import '../models/sale.dart';
import '../services/sale_service.dart';
import '../widgets/search_widget.dart';
import 'sale_detail_screen.dart';
import '../widgets/form_screen/sale_form_screen.dart';

class SalesScreen extends StatefulWidget {
  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  List<Sale> _allSales = [];
  List<Sale> _filteredSales = [];
  String _searchQuery = '';

  bool _sortByPrice = true;
  bool _ascending = true;
  DateTimeRange? _selectedDateRange;
  String? _selectedCarName;

  @override
  void initState() {
    super.initState();
    _loadSales();
  }

  void _loadSales() async {
    try {
      final sales = await SaleService.fetchSales();
      setState(() {
        _allSales = sales;
        _filteredSales = _applySearch(_searchQuery);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки продаж: $e')),
      );
    }
  }

  List<Sale> _applySearch(String query) {
    var filtered = _allSales.where((sale) {
      final lower = query.toLowerCase();
      final matchesQuery = sale.id.toString().contains(lower) ||
          sale.finalPrice.toString().contains(lower) ||
          sale.saleDate.toIso8601String().contains(lower);
      final matchesCar = _selectedCarName == null || sale.carName == _selectedCarName;
      final matchesDate = _selectedDateRange == null ||
          (sale.saleDate.isAfter(_selectedDateRange!.start.subtract(Duration(days: 1))) &&
              sale.saleDate.isBefore(_selectedDateRange!.end.add(Duration(days: 1))));
      return matchesQuery && matchesCar && matchesDate;
    }).toList();

    filtered.sort((a, b) {
      int compare;
      if (_sortByPrice) {
        compare = a.finalPrice.compareTo(b.finalPrice);
      } else {
        compare = a.id.compareTo(b.id);
      }
      return _ascending ? compare : -compare;
    });

    return filtered;
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query.trim();
      _filteredSales = _applySearch(_searchQuery);
    });
  }

  void _goToDetail(Sale sale) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SaleDetailScreen(sale: sale)),
    );
  }

  void _addSale() async {
    final newSale = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SaleFormScreen()),
    );

    if (newSale != null && newSale is Sale) {
      _loadSales();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Продажа добавлена')));
    }
  }

  void _deleteSale(Sale saleToDelete) async {
    try {
      await SaleService.deleteSale(saleToDelete.id);
      _loadSales();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Продажа удалена')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ошибка удаления: $e')));
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: Text('Сортировка и фильтры'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  value: _selectedCarName,
                  hint: Text('Выберите автомобиль'),
                  isExpanded: true,
                  items: _allSales.map((sale) => sale.carName).toSet().map((name) {
                    return DropdownMenuItem(value: name, child: Text(name));
                  }).toList(),
                  onChanged: (val) => setDialogState(() => _selectedCarName = val),
                ),
                SwitchListTile(
                  title: Text(_sortByPrice ? 'Сортировка по цене' : 'Сортировка по ID'),
                  value: _sortByPrice,
                  onChanged: (val) => setDialogState(() => _sortByPrice = val),
                ),
                SwitchListTile(
                  title: Text(_ascending ? 'По возрастанию' : 'По убыванию'),
                  value: _ascending,
                  onChanged: (val) => setDialogState(() => _ascending = val),
                ),
                TextButton(
                  onPressed: () async {
                    final range = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    if (range != null) {
                      setDialogState(() => _selectedDateRange = range);
                    }
                  },
                  child: Text(_selectedDateRange == null
                      ? 'Выбрать диапазон дат'
                      : '${_selectedDateRange!.start.toLocal().toString().split(' ')[0]} — ${_selectedDateRange!.end.toLocal().toString().split(' ')[0]}'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setDialogState(() {
                    _selectedCarName = null;
                    _selectedDateRange = null;
                    _sortByPrice = true;
                    _ascending = true;
                    _searchQuery = '';
                  });
                  Navigator.pop(context);
                  setState(() {
                    _filteredSales = _applySearch('');
                  });
                },
                child: Text('Сбросить'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _filteredSales = _applySearch(_searchQuery);
                  });
                },
                child: Text('Применить'),
              )
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Продажи'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            tooltip: 'Сортировка и фильтры',
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'Обновить список',
            onPressed: () {
              _loadSales();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Данные обновлены')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Поиск + фильтр
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: SearchWidget(
                    hintText: 'Поиск по дате, цене',
                    onChanged: _updateSearchQuery,
                  ),
                ),
              ],
            ),
          ),
          // Список продаж
          Expanded(
            child: ListView.builder(
              itemCount: _filteredSales.length,
              itemBuilder: (context, index) {
                final sale = _filteredSales[index];
                return ListTile(
                  title: Text('№${sale.id} — ${sale.carName}'),
                  subtitle: Text(
                      '${sale.saleDate.toLocal().toString().split(' ')[0]} · ${sale.finalPrice} ₽'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                  ),
                  onTap: () => _goToDetail(sale),
                );
              },
            ),
          ),
          // Статус строка
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 10, 30),
            color: Colors.black12,
            width: double.infinity,
            child: Center(child: Text('Всего записей: ${_filteredSales.length}')),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSale,
        tooltip: 'Добавить продажу',
        child: Icon(Icons.add),
      ),
    );
  }
}
