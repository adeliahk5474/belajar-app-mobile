import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/inventory_controller.dart';
import 'controllers/order_controller.dart';
import 'controllers/employee_controller.dart';

import 'screens/login_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Inventory harus dibuat lebih dulu
        ChangeNotifierProvider(create: (_) => InventoryController()),

        // OrderController butuh InventoryController di constructor
        ChangeNotifierProvider(
          create: (ctx) => OrderController(ctx.read<InventoryController>()),
        ),

        ChangeNotifierProvider(create: (_) => EmployeeController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UMKM App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
