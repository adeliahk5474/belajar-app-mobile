import 'package:flutter/material.dart';
import 'inventory_page.dart';
import 'order_page.dart';
import 'employee_page.dart';

class RootPage extends StatefulWidget {
  final String username:
  const Rootpage({super.key, required this.username});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _index = 0;
  
  late final _pages = [
    const InventoryPage(),
    const OrderPage(),
    const EmployeePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UMKM - ${_titles[_index]}'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                    title: const Text('User  Info'),
                    content: Text('Logged in as: ${widget.username}'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Ok'),),],
                  ),
              );
          ),
        ],
      ),
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: comst [
          BottomNavigationBarItem(icon: icon(Icons.inventory), label: 'Invetori'),
          BottomNavigationBarItem(icon: icon(Icons.point_of_sale), label: 'Penjualan'),
          BottomNavigationBarItem(icon: icon(Icons.people), label: 'Karyawan'),
        ],
      ),
    );
  }

  static const _titles = ['Inventori', 'Penjualan', 'Karyawan'];
}