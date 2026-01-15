import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../models/driver_model.dart';
import '../services/mock_data.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Orders")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mockOrders.length,
        itemBuilder: (context, index) {
          final order = mockOrders[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Order ID: ${order.id}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("Customer: ${order.customerName}"),
                  Text("Restaurant: ${mockRestaurants.firstWhere((r) => r.id == order.restaurantId).name}"),
                  Text("Status: ${order.status}"),
                  Text("Total: ${order.totalPrice}₮"),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text("Assign Driver: "),
                      DropdownButton<String>(
                        value: order.driverId.isEmpty ? null : order.driverId,
                        hint: const Text("Select driver"),
                        items: mockDrivers.map((driver) {
                          return DropdownMenuItem(
                            value: driver.id,
                            child: Text(driver.name),
                          );
                        }).toList(),
                        onChanged: (driverId) {
                          setState(() {
                            order.driverId = driverId!;
                          });
                        },
                      ),
                    ],
                  ),
                  if (order.driverId.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        "Assigned Driver: ${mockDrivers.firstWhere((d) => d.id == order.driverId).name}",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
