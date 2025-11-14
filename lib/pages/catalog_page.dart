import 'package:flutter/material.dart';
import '../pages/product_page.dart';
import '../pages/home_page.dart'; // чтобы получить allProducts
import 'package:intl/intl.dart';


class CatalogPage extends StatefulWidget {
  final String? preselectedCategory;   // ← ДОБАВЛЕН ПАРАМЕТР

  const CatalogPage({super.key, this.preselectedCategory});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late String _selectedCategory;

  final List<String> categories = [
    'Текстиль',
    'Термо винил',
    'DTF материалы',
    'Сублимационные кружки',
    'Оборудование',
  ];

  @override
  void initState() {
    super.initState();

    // Если категория пришла из HomePage → используем её
    _selectedCategory = widget.preselectedCategory ?? 'Текстиль';
  }

  @override
  Widget build(BuildContext context) {
    const redColor = Color(0xFFE53935);

    // Фильтр товаров в зависимости от категории
    List<Map<String, dynamic>> filtered = allProducts.where((p) {
      switch (_selectedCategory) {
        case 'Текстиль':
          return p['type'] == 'clothes' || p['type'] == 'oversize';
        case 'Термо винил':
          return p['type'] == 'vinil';
        case 'DTF материалы':
          return p['type'] == 'dtf';
        case 'Сублимационные кружки':
          return p['type'] == 'cups';
        case 'Оборудование':
          return p['type'] == 'equipment';
        default:
          return true;
      }
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Каталог',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Column(
        children: [
          // 🔘 Категории
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: categories.map((cat) {
                final selected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: selected,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                    selectedColor: redColor,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : Colors.black,
                      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: selected ? redColor : Colors.grey.shade300,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // 📦 Товары
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 260,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final product = filtered[index];
                return _productCard(context, product);
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Карточка товара
  Widget _productCard(BuildContext context, Map<String, dynamic> product) {
    const redColor = Color(0xFFE53935);

    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => ProductPage(product: product))),
      child: Container(
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
                product['images'][0],
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
                  Text(product['name'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 14)),
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
      ),
    );
  }
}
