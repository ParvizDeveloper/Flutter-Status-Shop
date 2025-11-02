import 'package:flutter/material.dart';
import 'home_page.dart';
import 'catalog_page.dart';
import 'cart_page.dart';
import '../components/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // Страницы создаются один раз и хранятся в памяти (IndexedStack)
  final List<Widget> _pages = const [
    HomePage(),
    CatalogPage(),
    CartPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const redColor = Color(0xFFE53935);

    return Scaffold(
      backgroundColor: Colors.white,
      // Используем IndexedStack, чтобы не пересоздавать страницы при переключении
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),

      // Нижняя панель — постоянная, как в Uzum Market
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          currentIndex: _selectedIndex,
          selectedItemColor: redColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          elevation: 5,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Главная',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              activeIcon: Icon(Icons.category),
              label: 'Каталог',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Корзина',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Профиль',
            ),
          ],
        ),
      ),
    );
  }
}
