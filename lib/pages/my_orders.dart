import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  String tr(BuildContext context, String ru, String uz, String en) {
    final lang = Provider.of<LanguageProvider>(context).localeCode;
    if (lang == "ru") return ru;
    if (lang == "uz") return uz;
    return en;
  }

  String formatDate(Timestamp ts) {
    final date = ts.toDate();
    return DateFormat('dd.MM.y HH:mm').format(date);
  }

  String formatPrice(num value) {
    final formatter = NumberFormat('#,###', 'ru');
    return "${formatter.format(value)} UZS";
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            tr(
              context,
              "Войдите, чтобы посмотреть заказы",
              "Buyurtmalarni ko‘rish uchun tizimga kiring",
              "Login to view orders",
            ),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    final ordersRef = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("orders")
        .orderBy("createdAt", descending: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr(context, "Мои заказы", "Buyurtmalarim", "My Orders"),
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: ordersRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs;

          if (orders.isEmpty) {
            return Center(
              child: Text(
                tr(
                  context,
                  "У вас пока нет заказов",
                  "Sizda hali buyurtmalar yo‘q",
                  "You have no orders yet",
                ),
                style: const TextStyle(fontSize: 17, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            itemBuilder: (context, i) {
              final order = orders[i].data() as Map<String, dynamic>;
              return _orderCard(context, order);
            },
          );
        },
      ),
    );
  }

  Widget _orderCard(BuildContext context, Map<String, dynamic> order) {
    const redColor = Color(0xFFE53935);

    final created = order["createdAt"] as Timestamp?;
    final items = List<Map<String, dynamic>>.from(order["items"] ?? []);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER: only date
          Text(
            created != null ? formatDate(created) : "",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 10),

          // Items preview
          ...items.take(2).map((item) => _itemRow(context, item)),

          if (items.length > 2)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                "+${items.length - 2} ещё",
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),

          const SizedBox(height: 10),

          // TOTAL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tr(context, "Итого:", "Jami:", "Total:"),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                formatPrice(order["total"]),
                style: const TextStyle(
                  fontSize: 16,
                  color: redColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // DELIVERY TYPE
          Text(
            "${tr(context, "Тип получения", "Olish turi", "Receive method")}: "
            "${order["delivery_type"] == "pickup"
                ? tr(context, "Самовывоз", "Olib ketish", "Pickup")
                : tr(context, "Доставка", "Yetkazib berish", "Delivery")}",
            style: const TextStyle(fontSize: 14),
          ),

          // Branch
          if (order["delivery_type"] == "pickup")
            Text(
              "${tr(context, "Филиал", "Filial", "Branch")}: ${order["branch"]}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),

          // Delivery address
          if (order["delivery_type"] == "delivery")
            Text(
              "${tr(context, "Адрес доставки", "Yetkazish manzili", "Delivery address")}: "
              "${order["delivery_address"]}",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
        ],
      ),
    );
  }

  Widget _itemRow(BuildContext context, Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              item["image"],
              width: 55,
              height: 55,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item["name"] is Map
                  ? item["name"][Provider.of<LanguageProvider>(context).localeCode]
                  ?? item["name"]["ru"]
                  : item["name"],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
