import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const redColor = Color(0xFFE53935);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 🔍 Верхняя панель поиска
            SliverAppBar(
              backgroundColor: Colors.white,
              floating: true,
              elevation: 1,
              titleSpacing: 12,
              title: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 42,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            'Поиск по товарам...',
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.favorite_border, color: redColor),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none, color: redColor),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // 📦 Основной контент
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🖼️ Баннер
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                        height: 100,
                        width: double.infinity,
                      ),
                    ),
                  ),

                  // 🔘 Категории
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: const Text(
                      'Категории',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 90,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 16),
                      children: [
                        _categoryItem(Icons.checkroom_outlined, 'Футболки'),
                        _categoryItem(Icons.hiking_outlined, 'Худи'),
                        _categoryItem(Icons.shopping_bag_outlined, 'ЭКО сумка'),
                        _categoryItem(Icons.face_retouching_natural_outlined, 'Кепки'),
                        _categoryItem(Icons.layers_outlined, 'Термо винил'),
                        _categoryItem(Icons.local_drink_outlined, 'Кружки'),
                        _categoryItem(Icons.print_outlined, 'DTF материалы'),
                        _categoryItem(Icons.precision_manufacturing_outlined, 'Оборудование'),
                      ],
                    ),
                  ),


                  // 🔥 Акции / баннеры
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/sale_banner.png',
                        fit: BoxFit.cover,
                        height: 100,
                        width: double.infinity,
                      ),
                    ),
                  ),

                  // ⭐ Популярные товары
                  _sectionTitle('Популярное'),
                  SizedBox(
                    height: 270,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        final product = [
                          {'name': 'Футболка Статус', 'price': '95 000 UZS'},
                          {'name': 'Худи Oversize', 'price': '175 000 UZS'},
                          {'name': 'ЭКО сумка', 'price': '55 000 UZS'},
                          {'name': 'Термо винил PU', 'price': '45 000 UZS'},
                          {'name': 'Кепка Classic', 'price': '80 000 UZS'},
                          {'name': 'DTF Пленка', 'price': '120 000 UZS'},
                        ][index];

                        return _productCard(
                          product['name']!,
                          product['price']!,
                        );
                      },
                    ),
                  ),

                  // 💡 Рекомендованные
                  _sectionTitle('Рекомендуем'),
                  SizedBox(
                    height: 270,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        final product = [
                          {'name': 'Плоттер Cameo 5', 'price': '5 800 000 UZS'},
                          {'name': 'Термопресс 38×38', 'price': '3 500 000 UZS'},
                          {'name': 'DTF краска', 'price': '250 000 UZS'},
                          {'name': 'Флекс Metallic', 'price': '70 000 UZS'},
                          {'name': 'Сублимационная кружка', 'price': '25 000 UZS'},
                          {'name': 'Мини-пресс', 'price': '1 200 000 UZS'},
                        ][index];

                        return _productCard(
                          product['name']!,
                          product['price']!,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Виджет категории
  static Widget _categoryItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.redAccent, size: 28),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  // 🔹 Заголовок секции
  static Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // 🔹 Карточка товара
  static Widget _productCard(String name, String price) {
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
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 14)),
                const SizedBox(height: 4),
                Text(price,
                    style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                const SizedBox(height: 6),
                Container(
                  alignment: Alignment.center,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'В корзину',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
