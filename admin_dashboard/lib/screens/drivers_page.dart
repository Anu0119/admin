import 'package:flutter/material.dart';
import '../services/mock_data.dart';

class DriversPage extends StatelessWidget {
  const DriversPage({super.key});

  int get totalWeekly =>
      drivers.fold(0, (sum, d) => sum + d.weekly);

  int get totalMonthly =>
      drivers.fold(0, (sum, d) => sum + d.monthly);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Drivers Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// TOTAL
            _totalCard(),

            const SizedBox(height: 20),

            /// DRIVERS LIST
            Expanded(
              child: GridView.builder(
                itemCount: drivers.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.3,
                ),
                itemBuilder: (context, index) {
                  return _driverCard(drivers[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Нийт бүх хүргэлт
  Widget _totalCard() {
    return Card(
      elevation: 5,
      color: Colors.indigo,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _totalItem("7 хоног", totalWeekly),
            _totalItem("Сар", totalMonthly),
          ],
        ),
      ),
    );
  }

  Widget _totalItem(String title, int value) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.white70, fontSize: 14)),
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

  /// Driver card
  Widget _driverCard(DriverStats driver) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              driver.name,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),

            _statRow("7 хоног", driver.weekly),
            const SizedBox(height: 8),
            _statRow("Сар", driver.monthly),
          ],
        ),
      ),
    );
  }

  Widget _statRow(String title, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(color: Colors.grey)),
        Text(
          value.toString(),
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}
