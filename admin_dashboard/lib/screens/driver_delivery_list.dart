import 'package:flutter/material.dart';
import '../services/mock_data.dart';

class DriverDeliveryListPage extends StatelessWidget {
  const DriverDeliveryListPage({super.key});

  int get totalWeekly =>
      drivers.fold(0, (sum, d) => sum + d.weekly);

  int get totalMonthly =>
      drivers.fold(0, (sum, d) => sum + d.monthly);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver Delivery Status"),
      ),
      body: Column(
        children: [
          /// TOTAL CARD
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 5,
            color: Colors.green,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _totalItem("Нийт 7 хоног", totalWeekly),
                  _totalItem("Нийт сар", totalMonthly),
                ],
              ),
            ),
          ),

          /// DRIVER LIST
          Expanded(
            child: ListView.builder(
              itemCount: drivers.length,
              itemBuilder: (context, index) {
                final driver = drivers[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(driver.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("7 хоног: ${driver.weekly}"),
                        Text("Сар: ${driver.monthly}"),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalItem(String title, int value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
              color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 6),
        Text(
          value.toString(),
          style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
