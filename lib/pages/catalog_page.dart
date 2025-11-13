import 'package:flutter/material.dart';
import '../pages/product_page.dart';
import 'home_page.dart'; // общий список товаров
import 'package:intl/intl.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  String _selectedCategory = 'Текстиль';

  // 📦 Категории
  final Map<String, List<String>> categoryMap = {
    'Текстиль': [
      'Футболка Статус',
      'Футболка Классик',
      'Кепка',
      'Худи',
      'Свитшот',
      'ЭКО сумка',
    ],
    'Термо винил': [
      'PU Flex',
      'PVC Flex',
      'Flock',
      'Stretch Foil',
      'Metalic Flex',
      'Фосфор Flex',
      'Рефлектор Flex',
      'Silicon Flex',
    ],
    'Оборудование': [
      'Плоттер Teneth 70см',
      'Cameo 5',
      'Термопресс 38×38',
      'Термопресс 60×40',
      'Термопресс для кепок',
      'Термопресс для кружек',
      'Мини-пресс',
    ],
    'DTF материалы': [
      'DTF краска',
      'DTF плёнка',
      'DTF клей',
    ],
    'Кружки и термосы': [
      'Сублимационная кружка',
      'Термос для сублимации',
    ],
  };

  @override
  Widget build(BuildContext context) {
    const redColor = Color(0xFFE53935);

    // 🧩 Отбор товаров по категории
    final items = allProducts
        .where((p) =>
            categoryMap[_selectedCategory]?.contains(p['name']) ?? false)
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Каталог',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 🔘 Список категорий
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: categoryMap.keys.map((cat) {
                final isSelected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                    backgroundColor: Colors.white,
                    selectedColor: redColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? redColor : Colors.grey.shade300,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // 🛍️ Сетка товаров
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Text(
                      'Товары не найдены 😕',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 250,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final product = items[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 300),
                              pageBuilder: (_, __, ___) =>
                                  ProductPage(product: product),
                              transitionsBuilder:
                                  (_, animation, __, child) => FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            ),
                          );
                        },
                        child: _productCard(product),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // 🔹 Виджет карточки товара
  Widget _productCard(Map<String, dynamic> product) {
    const redColor = Color(0xFFE53935);
    return Container(
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
          // 🖼️ Изображение
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(14)),
            child: Image.asset(
              product['images'][0],
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // 📝 Информация
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '${NumberFormat('#,###', 'ru').format(product['price'])} UZS',
                  style: const TextStyle(
                      color: redColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                const SizedBox(height: 8),
                Container(
                  alignment: Alignment.center,
                  height: 34,
                  decoration: BoxDecoration(
                    color: redColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Подробнее',
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
