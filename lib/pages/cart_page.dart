import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  String formatPrice(num value) {
    final formatter = NumberFormat('#,###', 'ru');
    return '${formatter.format(value)} UZS';
  }

  @override
  Widget build(BuildContext context) {
    const redColor = Color(0xFFE53935);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Войдите в аккаунт, чтобы просмотреть корзину')),
      );
    }

    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .orderBy('createdAt', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      backgroundColor: Colors.grey.shade100,
      body: StreamBuilder<QuerySnapshot>(
        stream: cartRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return _emptyCart(context);
          }

          double total = 0;
          for (var doc in docs) {
            total += (doc['total'] as num).toDouble();
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final item = docs[index].data() as Map<String, dynamic>;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              item['image'],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),

                                // 🟢 Динамический вывод параметров товара
                                _buildItemDetails(item),

                                const SizedBox(height: 4),

                                Text(
                                  formatPrice(item['total']),
                                  style: const TextStyle(
                                    color: redColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .collection('cart')
                                  .doc(item['tag'])
                                  .delete();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // ---------- TOTAL & ORDER ----------
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Итого:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          formatPrice(total),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: redColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Оформление заказов будет доступно позже!'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: redColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Оформить заказ',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ---------- EMPTY CART ----------
  Widget _emptyCart(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/empty_cart.png',
                width: 180, height: 180, fit: BoxFit.contain),
            const SizedBox(height: 20),
            const Text(
              'Ваша корзина пуста',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Добавьте товары, чтобы оформить заказ.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/mainpage'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Вернуться на главную',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- NEW: dynamic product info ----------
  Widget _buildItemDetails(Map<String, dynamic> item) {
    final type = item['type'];

    if (type == 'vinil') {
      return Text(
        'Метры: ${item['meters']} м',
        style: const TextStyle(color: Colors.grey, fontSize: 13),
      );
    }

    if (type == 'clothes' || type == 'oversize') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Размер: ${item['size']}',
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            'Количество: ${item['quantity']} шт',
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      );
    }

    // equipment, dtf, cups
    return Text(
      'Количество: ${item['quantity']} шт',
      style: const TextStyle(color: Colors.grey, fontSize: 13),
    );
  }
}
