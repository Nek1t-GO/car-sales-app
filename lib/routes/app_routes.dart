import '../screens/home_screen.dart';
import '../screens/cars_screen.dart';
import '../screens/clients_screen.dart';
import '../screens/sales_screen.dart';
import '../widgets/form_screen/car_form_screen.dart';
import '../screens/employees_screen.dart';
import '../screens/add_vin_screen.dart';

class AppRoutes {
  static const home = '/';
  static const cars = '/cars';
  static const clients = '/clients';
  static const sales = '/sales';
  static const employees = '/employees';
  static const addCar = '/add-car';
  static const addEmployee = '/add-employee';
  static const addVinScreen = '/add-vin';

  static final routes = {
    home: (context) => HomeScreen(),
    cars: (context) => CarsScreen(),
    clients: (context) => ClientsScreen(),
    sales: (context) => SalesScreen(),
    employees: (context) => EmployeesScreen(),
    addCar: (context) => CarFormScreen(),
    addVinScreen: (context) => AddVinScreen(),
  };
}
