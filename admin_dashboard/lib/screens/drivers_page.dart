import 'package:flutter/material.dart';
import 'driver_delivery_list.dart';

class DriversPage extends StatelessWidget {
  const DriversPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Drivers Page")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const DriverDeliveryListPage(),
              ),
            );
          },
          child: const Text("Driver Status"),
        ),
      ),
    );
  }
}
