import 'package:flutter/material.dart';
import 'package:flutter_e_commerce_app_with_backend/pages/account/account_page.dart';
import 'package:flutter_e_commerce_app_with_backend/pages/cart_page/cart_history.dart';
import 'package:flutter_e_commerce_app_with_backend/pages/home/main_food_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List page = [
    const MainFoodPage(),
    // ignore: avoid_unnecessary_containers
    Container(child: const Text("Histrory Page")),
    const CartHistory(),
    const AccountPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page[_selectedIndex],
      //bottomNavigationBAr
      bottomNavigationBar: BottomNavigationBar(
        //type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.amber,
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (value) {
          _selectedIndex = value;
          setState(() {});
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
          BottomNavigationBarItem(icon: Icon(Icons.archive), label: "history"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "home"),
        ],
      ),
    );
  }
}
