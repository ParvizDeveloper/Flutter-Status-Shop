import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // ✅ импорт для форматирования чисел

class ProductPage extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductPage({super.key, required this.product});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _quantity = 1;
  int _selectedColorIndex = 0;

  // ✅ Функция форматирования цены
  String formatPrice(num value) {
    final formatter = NumberFormat('#,###', 'ru');
    return '${formatter.format(value)} UZS';
  }

  // ✅ Вычисление общей суммы
  double get totalPrice {
    final price = widget.product['price'];
    if (price is num) {
      return price.toDouble() * _quantity;
    } else if (price is String) {
      return double.tryParse(price.replaceAll(' ', ''))! * _quantity;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    const redColor = Color(0xFFE53935);

    final List<String> images = List<String>.from(product['images'] ?? []);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          product['name'],
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ Галерея картинок
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  images[_selectedColorIndex],
                  height: 260,
                  width: 260,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🎨 Цвета (если есть)
            if (images.length > 1) ...[
              const Text(
                'Выберите цвет:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 100,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisExtent: 80,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final isSelected = index == _selectedColorIndex;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColorIndex = index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? Colors.redAccent : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.asset(images[index], fit: BoxFit.cover),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],

            // 📏 Количество
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Количество:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (_quantity > 1) {
                            setState(() => _quantity--);
                          }
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text('$_quantity', style: const TextStyle(fontSize: 18)),
                      IconButton(
                        onPressed: () => setState(() => _quantity++),
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 📄 Характеристики
            if (product['characteristics'] != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Характеристики',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 10),
                    ...product['characteristics'].entries.map((e) => Text(
                          '• ${e.key}: ${e.value}',
                          style: const TextStyle(fontSize: 14),
                        )),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // 💬 Описание
            if (product['description'] != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Описание',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 8),
                    Text(product['description'],
                        style: const TextStyle(fontSize: 14, height: 1.5)),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // 💰 Цена
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Итого:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Text(
                    formatPrice(totalPrice), // ✅ красиво отформатированная цена
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: redColor),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🛒 Добавить в корзину
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                label: const Text('Добавить в корзину',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: redColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  _addToCart(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Товар добавлен в корзину')));
                },
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // 🧩 Добавление товара в корзину
  void _addToCart(Map<String, dynamic> product) {
    final item = {
      'name': product['name'],
      'quantity': _quantity,
      'price': product['price'],
      'total': totalPrice,
      'image': product['images'][_selectedColorIndex],
      'tag': '${product['type']}_${_selectedColorIndex + 1}',
    };

    print('Добавлено в корзину: $item');
    // TODO: добавить в Firestore или локальную корзину
  }
}
