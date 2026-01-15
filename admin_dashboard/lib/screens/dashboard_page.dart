import 'package:flutter/material.dart';
import 'orders_page.dart';
import 'drivers_page.dart';
import 'restaurants_page.dart';
import '../services/mock_data.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InfoCard(title: 'Orders', count: mockOrders.length),
                InfoCard(title: 'Drivers', count: mockDrivers.length),
                InfoCard(title: 'Restaurants', count: mockRestaurants.length),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OrdersPage(), // const ашиглаж байна
                      ),
                    );
                  },
                  child: const Text('Orders'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DriversPage(), // const ашиглаж байна
                      ),
                    );
                  },
                  child: const Text('Drivers'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RestaurantsPage(), // const ашиглаж байна
                      ),
                    );
                  },
                  child: const Text('Restaurants'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final int count;
  const InfoCard({super.key, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 100,
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(count.toString(), style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
