import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/language_provider.dart';
import '../pages/product_page.dart';
import '../pages/home_page.dart'; // allProducts

class CatalogPage extends StatefulWidget {
  final String? preselectedCategory;

  const CatalogPage({super.key, this.preselectedCategory});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late String _selectedCategory;

  final List<String> categoriesRu = [
    'Текстиль',
    'Термо винил',
    'DTF материалы',
    'Сублимационные кружки',
    'Оборудование',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.preselectedCategory ?? 'Текстиль';
  }

  String tr(BuildContext context, String ru, String uz, String en) {
    final lang = context.watch<LanguageProvider>().localeCode;
    if (lang == 'ru') return ru;
    if (lang == 'uz') return uz;
    return en;
  }

  String trCategory(BuildContext context, String ru) {
    return {
      "Текстиль": tr(context, "Текстиль", "Tekstil", "Textile"),
      "Термо винил": tr(context, "Термо винил", "Termo vinil", "Heat vinyl"),
      "DTF материалы": tr(context, "DTF материалы", "DTF materiallari", "DTF materials"),
      "Сублимационные кружки":
          tr(context, "Сублимационные кружки", "Sublimatsiya krujkalar", "Sublimation mugs"),
      "Оборудование": tr(context, "Оборудование", "Uskunalar", "Equipment"),
    }[ru] ?? ru;
  }

  String trName(BuildContext context, Map product) {
    final lang = context.watch<LanguageProvider>().localeCode;
    final obj = product['name'];
    if (obj is Map) return obj[lang] ?? obj['ru'];
    return obj.toString();
  }

  @override
  Widget build(BuildContext context) {
    const redColor = Color(0xFFE53935);
    final appBarTitle = tr(context, 'Каталог', 'Katalog', 'Catalog');

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
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text(
          appBarTitle,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Column(
        children: [

          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: categoriesRu.map((catRu) {
                final selected = catRu == _selectedCategory;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(trCategory(context, catRu)),
                    selected: selected,
                    onSelected: (_) => setState(() => _selectedCategory = catRu),
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

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.70, // 🔥 идеально под карточку
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

  // -----------------------------------------------
  // 🔥 КАРТОЧКА ТОВАРА — БЕЗ OVERFLOW НАВСЕГДА
  // -----------------------------------------------
  Widget _productCard(BuildContext context, Map<String, dynamic> product) {
    const redColor = Color(0xFFE53935);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProductPage(product: product)),
      ),

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
          children: [

            /// 🔥 Фото — в безопасной зоне, нигде не обрезается
            Container(
              height: 140,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: Image.asset(
                product['images'][0],
                fit: BoxFit.contain,
              ),
            ),

            /// 🔥 Основной блок — в Expanded (overflow невозможен)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// Название
                    Text(
                      trName(context, product),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    ),

                    const SizedBox(height: 4),

                    /// Цена
                    Text(
                      '${NumberFormat('#,###', 'ru').format(product['price'])} UZS',
                      style: const TextStyle(
                        color: redColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    const Spacer(),

                    /// Кнопка
                    Container(
                      height: 34,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: redColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tr(context, 'Подробнее', 'Batafsil', 'More'),
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
