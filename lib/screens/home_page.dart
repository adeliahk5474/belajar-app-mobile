import 'package:aplikasipertama/screens/employee_page.dart';
import 'package:flutter/material.dart';

import '../screens/inventory_page.dart';
import '../screens/order_page.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UMKM App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed:
                () => showDialog(
                  context: context,
                  builder:
                      (_) => AlertDialog(
                        title: const Text('User Info'),
                        content: Text('Logged in as: ${widget.username}'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                ),
          ),
        ],
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(icon: Icon(Icons.inventory), text: 'Inventori'),
            Tab(icon: Icon(Icons.point_of_sale), text: 'Order'),
            Tab(icon: Icon(Icons.people), text: 'Karyawan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: const [InventoryPage(), OrderPage(), EmployeePage()],
      ),
    );
  }
}
