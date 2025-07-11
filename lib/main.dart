import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/inventory_controller.dart';
import 'controllers/order_controller.dart';
import 'controllers/employee_controller.dart';

import 'screens/login_page.dart';
import 'screens/inventory_page.dart';
import 'screens/order_page.dart';
import 'screens/employee_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InventoryController()),
        ChangeNotifierProvider(create: (_) => OrderController()),
        ChangeNotifierProvider(create: (_) => EmployeeController()),
      ],
      child: MaterialApp(
        title: 'UMKM App',
        theme: ThemeData(useMaterial3: true),
        home: const LoginPage(),
      ),
    );
  }
}
