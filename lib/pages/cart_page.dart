import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // 🧩 В будущем это будет заменено на данные из Firestore
  List<Map<String, dynamic>> cartItems = [];

  // 🧱 Пример популярных товаров
  final List<Map<String, String>> popularProducts = [
    {'name': 'Футболка Статус', 'price': '95 000 UZS'},
    {'name': 'Худи Oversize', 'price': '175 000 UZS'},
    {'name': 'Термо винил PU', 'price': '45 000 UZS'},
    {'name': 'DTF краска', 'price': '250 000 UZS'},
    {'name': 'ЭКО сумка', 'price': '55 000 UZS'},
  ];

  // 🔢 Подсчёт общей суммы
  int get totalPrice {
    return cartItems.fold(
      0,
      (sum, item) => sum + (item['price'] as int) * (item['count'] as int),
    );
  }

  @override
  Widget build(BuildContext context) {
    const redColor = Color(0xFFE53935);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Корзина',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: cartItems.isEmpty
          ? _buildEmptyCart(context, redColor)
          : _buildCartWithItems(context, redColor),
    );
  }

  // 🛍️ Если корзина ПУСТАЯ
  Widget _buildEmptyCart(BuildContext context, Color redColor) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.shopping_cart_outlined,
              size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Ваша корзина пуста',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Добавьте товары, чтобы оформить заказ.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: redColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () => Navigator.pushNamed(context, '/mainpage'),
            child: const Text('Вернуться на главную',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
          const SizedBox(height: 40),
          _sectionTitle('Популярные товары'),
          _buildPopularProducts(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // 🧺 Если корзина С ТОВАРАМИ
  Widget _buildCartWithItems(BuildContext context, Color redColor) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return _cartItemCard(item, index);
            },
          ),
        ),
        _buildCheckoutSection(redColor),
      ],
    );
  }

  // 🔹 Оформление заказа
  Widget _buildCheckoutSection(Color redColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border:
            Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Итого:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Text(
                '${totalPrice.toString()} UZS',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(11, 255, 0, 0)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Функция оформления скоро будет доступна.')));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: redColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Оформить заказ',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Один товар в корзине
  Widget _cartItemCard(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(12)),
            child: Image.asset(
              'assets/images/product_sample.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['name'],
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('${item['price']} UZS',
                      style: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          if (item['count'] > 1) {
                            setState(() => item['count']--);
                          }
                        },
                      ),
                      Text('${item['count']}',
                          style: const TextStyle(fontSize: 16)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          setState(() => item['count']++);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.grey),
            onPressed: () => setState(() => cartItems.removeAt(index)),
          ),
        ],
      ),
    );
  }

  // 🔹 Заголовок
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // 🔹 Популярные товары
  Widget _buildPopularProducts() {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: popularProducts.length,
        itemBuilder: (context, index) {
          final product = popularProducts[index];
          return Container(
            width: 160,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(14)),
                  child: Image.asset(
                    'assets/images/product_sample.png',
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product['name']!,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(product['price']!,
                          style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
