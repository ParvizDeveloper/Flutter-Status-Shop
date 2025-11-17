import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';

class ProductPage extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductPage({super.key, required this.product});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  double _meters = 1.0;
  int _quantity = 1;
  String? _selectedSize;
  int _selectedColorIndex = 0;
  final _controller = TextEditingController(text: '1');

  // ---------------------------------------------------------
  //  Local getters
  // ---------------------------------------------------------
  String get lang =>
      Provider.of<LanguageProvider>(context, listen: false).localeCode;

  String pName() => widget.product['name'][lang] ?? widget.product['name']['ru'];
  String pDesc() =>
      widget.product['description'][lang] ?? widget.product['description']['ru'];

  String tr(String ru, String uz, String en) {
    if (lang == 'ru') return ru;
    if (lang == 'uz') return uz;
    return en;
  }

  // ---------- FORMAT PRICE ----------
  String formatPrice(num value) {
    final formatter = NumberFormat('#,###', 'ru');
    return '${formatter.format(value)} UZS';
  }

  // ---------- TOTAL ----------
  double get totalPrice {
    final price = widget.product['price'];
    final basePrice = (price is num)
        ? price.toDouble()
        : double.tryParse(price.toString().replaceAll(' ', '')) ?? 0;

    if (widget.product['type'] == 'vinil') {
      return basePrice * _meters;
    } else {
      return basePrice * _quantity;
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    const redColor = Color(0xFFE53935);

    final List<String> images = List<String>.from(product['images'] ?? []);
    final type = product['type'];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          pName(),
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

            // ---------- IMAGE ----------
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

            // ---------- COLORS ----------
            if (images.length > 1) ...[
              Text(
                tr("Выберите цвет:", "Rangni tanlang:", "Choose color:"),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    final isSelected = index == _selectedColorIndex;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColorIndex = index),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? Colors.redAccent : Colors.grey.shade300,
                            width: isSelected ? 2.5 : 1.5,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.asset(
                            images[index],
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],

            // ---------- METERS / QUANTITY / SIZE ----------
            if (type == 'vinil') _buildMetersInput(),
            if (type == 'clothes' || type == 'oversize') _buildClothesInput(type),
            if (type == 'equipment' || type == 'dtf' || type == 'cups')
              _buildQuantityInput(),

            const SizedBox(height: 20),

            // ---------- CHARACTERISTICS ----------
            _buildCharacteristicsBlock(product['characteristics']),
            const SizedBox(height: 16),

            // ---------- DESCRIPTION ----------
            _buildDescription(pDesc()),
            const SizedBox(height: 20),

            // ---------- TOTAL ----------
            _buildTotal(redColor),

            const SizedBox(height: 30),

            // ---------- ADD TO CART BUTTON ----------
            _buildAddToCartButton(redColor, product),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //        CHARACTERISTICS WITH TRANSLATION
  // ---------------------------------------------------------------------------
  Widget _buildCharacteristicsBlock(Map? data) {
    if (data == null || data.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr("Характеристики", "Xususiyatlar", "Specifications"),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),

          ...data.entries.map((e) {
            final key = e.key;
            final v = e.value;

            // Правильное извлечение значения
            String value;
            if (v is Map) {
              value = v[lang] ?? v['ru'] ?? v.values.first;
            } else {
              value = v.toString();
            }

            return Text(
              "• ${_translateCharacteristicKey(key)}: $value",
              style: const TextStyle(fontSize: 14),
            );
          }),
        ],
      ),
    );
  }

  // Подписи характеристик (ключей)
  String _translateCharacteristicKey(String key) {
    const map = {
      'material': {'ru':'Материал','uz':'Material','en':'Material'},
      'weight': {'ru':'Плотность / Вес','uz':'Zichlik / Og‘irlik','en':'Density / Weight'},
      'sizes': {'ru':'Размеры','uz':'O‘lchamlar','en':'Sizes'},
      'suitable': {'ru':'Подходит для','uz':'Mos keladi','en':'Suitable for'},
      'adjustment': {'ru':'Регулировка','uz':'Sozlash','en':'Adjustment'},
      'uses': {'ru':'Использование','uz':'Qo‘llanilishi','en':'Usage'},
      'width': {'ru':'Ширина','uz':'Eni','en':'Width'},
      'temp': {'ru':'Температура','uz':'Harorat','en':'Temperature'},
      'time': {'ru':'Время','uz':'Vaqt','en':'Time'},
      'plate': {'ru':'Размер пластины','uz':'Plita o‘lchami','en':'Plate size'},
      'power': {'ru':'Мощность','uz':'Quvvat','en':'Power'},
      'volume': {'ru':'Объём','uz':'Hajm','en':'Volume'},
      'cut_width': {'ru':'Ширина резки','uz':'Kesish eni','en':'Cut width'},
      'precision': {'ru':'Точность','uz':'Aniqlik','en':'Precision'},
      'type': {'ru':'Тип','uz':'Turi','en':'Type'},
    };

    return map[key]?[lang] ?? key;
  }

  // ---------------------------------------------------------------------------
  // DESCRIPTION
  // ---------------------------------------------------------------------------
  Widget _buildDescription(String desc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr("Описание", "Tavsif", "Description"),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),

          Text(desc, style: const TextStyle(fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // METERS
  // ---------------------------------------------------------------------------
  Widget _buildMetersInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr("Метры:", "Metrlar:", "Meters:"),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),

          TextField(
            controller: _controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (val) {
              setState(() => _meters = double.tryParse(val.replaceAll(",", ".")) ?? 1);
            },
            decoration: InputDecoration(
              hintText: tr("Введите количество метров", "Metr miqdorini kiriting", "Enter meters"),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),

          const SizedBox(height: 8),
          Text(
            tr("Цена за 1 метр", "1 metr narxi", "Price per 1 meter") + ": 140 000 UZS",
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CLOTHES
  // ---------------------------------------------------------------------------
  Widget _buildClothesInput(String type) {
    final sizes = type == 'oversize'
        ? ['M', 'L', 'XL']
        : ['S', 'M', 'L', 'XL', 'XXL'];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr("Выберите размер:", "O‘lchamni tanlang:", "Choose size:"),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),

          Wrap(
            spacing: 10,
            children: sizes.map((s) {
              final selected = s == _selectedSize;
              return ChoiceChip(
                label: Text(s),
                selected: selected,
                onSelected: (_) => setState(() => _selectedSize = s),
                selectedColor: Colors.redAccent,
                labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
              );
            }).toList(),
          ),

          const SizedBox(height: 12),
          _buildQuantityInput(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // QUANTITY
  // ---------------------------------------------------------------------------
  Widget _buildQuantityInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          tr("Количество:", "Soni:", "Quantity:"),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),

        Row(
          children: [
            IconButton(
              onPressed: () {
                if (_quantity > 1) setState(() => _quantity--);
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
    );
  }

  // ---------------------------------------------------------------------------
  // TOTAL
  // ---------------------------------------------------------------------------
  Widget _buildTotal(Color redColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            tr("Итого:", "Jami:", "Total:"),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          Text(
            formatPrice(totalPrice),
            style: TextStyle(
                color: redColor, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ADD TO CART
  // ---------------------------------------------------------------------------
  Widget _buildAddToCartButton(Color redColor, Map<String, dynamic> product) {
    return SizedBox(
      width: double.infinity,

      child: ElevatedButton.icon(
        icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),

        label: Text(
          tr("Добавить в корзину", "Savatchaga qo‘shish", "Add to cart"),
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),

        style: ElevatedButton.styleFrom(
          backgroundColor: redColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),

        onPressed: () async {
          if (product['type'] == 'clothes' && _selectedSize == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(tr("Выберите размер", "O‘lcham tanlang", "Select size"))),
            );
            return;
          }

          final user = FirebaseAuth.instance.currentUser;

          if (user == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(tr("Войдите в аккаунт", "Akkauntga kiring", "Sign in first"))),
            );
            return;
          }

          final itemId = '${product['type']}_${DateTime.now().millisecondsSinceEpoch}';

          final item = {
            'name': pName(), // localized name saved to cart
            'type': product['type'],
            'image': product['images'][_selectedColorIndex],
            'price': product['price'],
            'quantity': _quantity,
            'meters': _meters,
            'size': _selectedSize,
            'total': totalPrice,
            'tag': itemId,
            'createdAt': FieldValue.serverTimestamp(),
          };

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('cart')
              .doc(itemId)
              .set(item);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(tr("🛒 Товар добавлен в корзину", "🛒 Tovar savatchaga qo‘shildi", "🛒 Added to cart"))),
          );
        },
      ),
    );
  }
}
