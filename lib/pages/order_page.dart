import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../base/local_storage.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class OrderPage extends StatefulWidget {
  final double totalAmount;
  final List<Map<String, dynamic>> cartItems;

  const OrderPage({
    super.key,
    required this.totalAmount,
    required this.cartItems,
  });

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedBranch;
  String _paymentMethod = "cash";

  /// Филиалы (RU смысл — но сами города переводятся в UI)
  final branches = {
    "Ташкент": "Чиланзар, 1-й квартал 59",
    "Самарканд": "ул. Ибн Сино, 24",
    "Бухара": "ул. Б.Накшбандиддин, 12",
  };

  bool loading = true;

  /// --- Удобная функция перевода ---
  String tr(String ru, String uz, String en) {
    final lang = Provider.of<LanguageProvider>(context).localeCode;
    if (lang == "ru") return ru;
    if (lang == "uz") return uz;
    return en;
  }

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final user = await LocalStorage.getUserData();

    _nameController.text = "${user['name'] ?? ''} ${user['surname'] ?? ''}";
    _phoneController.text = user['phone'] ?? '';

    final city = user['city'] ?? "Ташкент";

    _selectedBranch = branches.containsKey(city) ? city : "Ташкент";

    setState(() => loading = false);
  }

  Future<void> submitOrder() async {
    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr(
          "Пожалуйста, заполните все поля",
          "Barcha maydonlarni to‘ldiring",
          "Please fill in all fields",
        ))),
      );
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr(
          "Необходимо войти в аккаунт",
          "Akkauntga kirish kerak",
          "You must be logged in",
        ))),
      );
      return;
    }

    final orderId = "${uid}_${DateTime.now().millisecondsSinceEpoch}";
    final order = {
      "orderId": orderId,
      "uid": uid,
      "name": _nameController.text.trim(),
      "phone": _phoneController.text.trim(),
      "branch": _selectedBranch,
      "address": branches[_selectedBranch],
      "payment_method": _paymentMethod,
      "total": widget.totalAmount,
      "items": widget.cartItems,
      "createdAt": FieldValue.serverTimestamp(),
    };

    final db = FirebaseFirestore.instance;

    await db.collection("orders").doc(orderId).set(order);

    await db
        .collection("users")
        .doc(uid)
        .collection("orders")
        .doc(orderId)
        .set(order);

    // очистка корзины
    for (var item in widget.cartItems) {
      await db
          .collection("users")
          .doc(uid)
          .collection("cart")
          .doc(item['tag'])
          .delete();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(tr(
        "Заказ оформлен!",
        "Buyurtma rasmiylashtirildi!",
        "Order placed!",
      ))),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const redColor = Color(0xFFE53935);

    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text(
          tr("Оформление заказа", "Buyurtmani rasmiylashtirish", "Checkout"),
          style: const TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: tr("Имя и фамилия", "Ism va familiya", "Full name"),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: tr("Номер телефона", "Telefon raqami", "Phone number"),
              ),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _selectedBranch,
              items: branches.keys
                  .map((city) => DropdownMenuItem(
                      value: city, child: Text(tr(city, city, city))))
                  .toList(),
              onChanged: (v) => setState(() => _selectedBranch = v),
              decoration: InputDecoration(
                labelText: tr("Выберите филиал", "Filialni tanlang", "Select branch"),
              ),
            ),
            const SizedBox(height: 10),

            Text(
              branches[_selectedBranch]!,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            Text(
              tr("Способ оплаты", "To‘lov turi", "Payment method"),
              style: const TextStyle(fontSize: 16),
            ),

            Row(
              children: [
                Radio(
                  value: "cash",
                  groupValue: _paymentMethod,
                  onChanged: (v) => setState(() => _paymentMethod = v!),
                ),
                Text(tr("Наличные", "Naqd", "Cash")),
              ],
            ),
            Row(
              children: [
                Radio(
                  value: "card",
                  groupValue: _paymentMethod,
                  onChanged: (v) {
                    setState(() => _paymentMethod = v!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(tr(
                          "Оплата картой — в разработке",
                          "Karta orqali to‘lov — ishlab chiqilmoqda",
                          "Card payment — coming soon",
                        )),
                      ),
                    );
                  },
                ),
                Text(tr("Карта", "Karta", "Card")),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: redColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  "${tr("Оформить заказ", "Buyurtma berish", "Place order")} (${widget.totalAmount.toStringAsFixed(0)} UZS)",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
