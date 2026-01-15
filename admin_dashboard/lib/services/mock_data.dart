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

