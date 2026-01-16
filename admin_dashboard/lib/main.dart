import 'package:flutter/material.dart';
import 'screens/dashboard_page.dart';
import 'screens/admin_login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DashboardPage(),
    initialRoute: '/login',
    routes: {
      '/login': (context) => const AdminLoginPage(),
      '/dashboard': (context) => const DashboardPage(),
},
    );
  }
}
