import 'package:admin_bicopi/pages/stock/stock_page.dart';
import 'package:flutter/material.dart';
import 'order/order_page.dart';
import 'menu/menu_page.dart';
import 'option/option_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const OrderPage(),
    const MenuPage(),
    const StockPage(),
    const OptionPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Order'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_basket), label: 'Stock'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Option'),
        ],
      ),
    );
  }
}
