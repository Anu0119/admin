import '../models/driver_model.dart';
import '../models/restaurant_model.dart';
import '../models/order_model.dart';

List<Driver> mockDrivers = [
  Driver(id: 'D1', name: 'Jolooch 1', phone: '99112233'),
  Driver(id: 'D2', name: 'Jolooch 2', phone: '99114455'),
];

List<Restaurant> mockRestaurants = [
  Restaurant(id: 'R1', name: 'Pizza Hut', address: 'UB, Mongolia'),
  Restaurant(id: 'R2', name: 'Burger House', address: 'UB, Mongolia'),
];

List<Order> mockOrders = [
  Order(id: 'O1', restaurantId: 'R1', driverId: '', customerName: 'Anu', status: 'pending', totalPrice: 25000),
  Order(id: 'O2', restaurantId: 'R2', driverId: '', customerName: 'Baatar', status: 'pending', totalPrice: 18000),
];

class DriverStats {
  final String name;
  final int weekly;
  final int monthly;

  DriverStats({
    required this.name,
    required this.weekly,
    required this.monthly,
  });
}

final List<DriverStats> drivers = [
  DriverStats(name: "Driver A", weekly: 25, monthly: 110),
  DriverStats(name: "Driver B", weekly: 18, monthly: 85),
  DriverStats(name: "Driver C", weekly: 32, monthly: 140),
];
