import 'package:flutter/material.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  String _selectedCategory = 'Текстиль';

  final Map<String, List<Map<String, String>>> categories = {
    'Текстиль': [
      {'name': 'Футболка Статус', 'price': '95 000 UZS'},
      {'name': 'Футболка Классик', 'price': '90 000 UZS'},
      {'name': 'Худи', 'price': '175 000 UZS'},
      {'name': 'Свитшот', 'price': '160 000 UZS'},
      {'name': 'ЭКО сумка', 'price': '55 000 UZS'},
      {'name': 'Кепка', 'price': '80 000 UZS'},
    ],
    'Термо винил': [
      {'name': 'PU Flex', 'price': '45 000 UZS'},
      {'name': 'PVC Flex', 'price': '40 000 UZS'},
      {'name': 'Flock', 'price': '65 000 UZS'},
      {'name': 'Stretch Foil', 'price': '70 000 UZS'},
      {'name': 'Metalic', 'price': '75 000 UZS'},
      {'name': 'Фосфор', 'price': '90 000 UZS'},
      {'name': 'Рефлектор', 'price': '85 000 UZS'},
      {'name': 'Silicon', 'price': '95 000 UZS'},
    ],
    'Оборудование': [
      {'name': 'Плоттер Teneth 70см', 'price': '6 800 000 UZS'},
      {'name': 'Cameo 5', 'price': '5 500 000 UZS'},
      {'name': 'Термопресс 38×38', 'price': '3 500 000 UZS'},
      {'name': 'Термопресс 60×40', 'price': '4 200 000 UZS'},
      {'name': 'Термопресс для кружек', 'price': '1 500 000 UZS'},
      {'name': 'Мини-пресс', 'price': '1 200 000 UZS'},
    ],
    'DTF материалы': [
      {'name': 'DTF краска', 'price': '250 000 UZS'},
      {'name': 'DTF плёнка', 'price': '120 000 UZS'},
      {'name': 'DTF клей', 'price': '85 000 UZS'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    const redColor = Color(0xFFE53935);

    final items = categories[_selectedCategory]!;

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
              children: categories.keys.map((cat) {
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

          // 📦 Сетка товаров
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 250,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return _productCard(item['name']!, item['price']!);
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Карточка товара
  Widget _productCard(String name, String price) {
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
              'assets/images/product_sample.png',
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
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                const SizedBox(height: 8),
                Container(
                  alignment: Alignment.center,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
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
