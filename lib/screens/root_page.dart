import 'package:flutter/material.dart';
import 'inventory_page.dart';
import 'order_page.dart';
import 'employee_page.dart';

class RootPage extends StatefulWidget {
  final String username;

  const RootPage({super.key, required this.username});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _index = 0;

  static const _titles = ['Inventori', 'Penjualan', 'Karyawan'];

  final List<Widget> _pages = const [
    InventoryPage(),
    OrderPage(),
    EmployeePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UMKM - ${_titles[_index]}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              showDialog(
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
              );
            },
          ),
        ],
      ),
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventori',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.point_of_sale),
            label: 'Penjualan',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Karyawan'),
        ],
      ),
    );
  }
}
