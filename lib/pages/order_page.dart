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
  final _deliveryAddressController = TextEditingController();

  String? _selectedBranch;
  String _paymentMethod = "cash";
  String _deliveryType = "pickup";

  /// Многоязычные города + адреса
  final Map<String, Map<String, Map<String, String>>> branches = {
    "tashkent": {
      "name": {"ru": "Ташкент", "uz": "Toshkent", "en": "Tashkent"},
      "address": {
        "ru": "Чиланзар, 1-й квартал 59",
        "uz": "Chilonzor, 1-kvartal 59",
        "en": "Chilanzar, Block 1, 59"
      }
    },
    "samarkand": {
      "name": {"ru": "Самарканд", "uz": "Samarqand", "en": "Samarkand"},
      "address": {
        "ru": "ул. Ибн Сино, 24",
        "uz": "Ibn Sino ko‘chasi, 24",
        "en": "Ibn Sino street, 24"
      }
    },
    "bukhara": {
      "name": {"ru": "Бухара", "uz": "Buxoro", "en": "Bukhara"},
      "address": {
        "ru": "ул. Б.Накшбандиддин, 12",
        "uz": "B. Naqshbandi ko‘chasi, 12",
        "en": "B. Naqshbandi street, 12"
      }
    },
  };

  bool loading = true;

  /// Перевод
  String tr(String ru, String uz, String en) {
    final lang = Provider.of<LanguageProvider>(context, listen: false).localeCode;
    if (lang == "ru") return ru;
    if (lang == "uz") return uz;
    return en;
  }

  String trCity(String key) {
    final lang = Provider.of<LanguageProvider>(context, listen: false).localeCode;
    return branches[key]!["name"]![lang] ?? branches[key]!["name"]!["ru"]!;
  }

  String trAddress(String key) {
    final lang = Provider.of<LanguageProvider>(context, listen: false).localeCode;
    return branches[key]!["address"]![lang] ?? branches[key]!["address"]!["ru"]!;
  }

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  /// Генерация короткого красивого ID как в Uzum
  String generateShortId() {
    final t = DateTime.now().millisecondsSinceEpoch;
    final hex = t.toRadixString(16).toUpperCase();
    return hex.substring(hex.length - 6); // последние 6 символов
  }

  Future<void> loadUser() async {
    final user = await LocalStorage.readUserFromTxt();

    _nameController.text = "${user['name'] ?? ''} ${user['surname'] ?? ''}".trim();
    _phoneController.text = user['phone'] ?? '';

    final cityRu = user['city'] ?? "Ташкент";

    if (cityRu == "Ташкент") _selectedBranch = "tashkent";
    else if (cityRu == "Самарканд") _selectedBranch = "samarkand";
    else if (cityRu == "Бухара") _selectedBranch = "bukhara";
    else _selectedBranch = "tashkent";

    setState(() => loading = false);
  }

  Future<void> submitOrder() async {
    // Validation
    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr(
          "Пожалуйста, заполните имя и телефон",
          "Iltimos, ism va telefonni kiriting",
          "Please provide name and phone",
        ))),
      );
      return;
    }

    if (_deliveryType == "delivery" &&
        _deliveryAddressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr(
          "Укажите адрес доставки",
          "Yetkazib berish manzilini kiriting",
          "Please enter delivery address",
        ))),
      );
      return;
    }

    final current = FirebaseAuth.instance.currentUser;
    if (current == null) return;

    final uid = current.uid;
    final email = current.email ?? "";

    /// короткий ID (красивый)
    final shortId = generateShortId();

    /// длинный ID (для БД)
    final orderId = "${uid}_${DateTime.now().millisecondsSinceEpoch}";

    final List<Map<String, dynamic>> items = widget.cartItems.map((item) {
      return {
        "name": item["name"], // Map of ru/uz/en
        "price": item["price"],
        "quantity": item["quantity"],
        "meters": item["meters"],
        "size": item["size"],
        "image": item["image"],
        "type": item["type"],
        "tag": item["tag"],
        "total": item["total"],
      };
    }).toList();

    final order = {
      "orderId": orderId,
      "shortId": shortId,
      "uid": uid,
      "email": email,
      "name": _nameController.text.trim(),
      "phone": _phoneController.text.trim(),

      "branch_key": _selectedBranch,
      "branch": trCity(_selectedBranch!),
      "branch_address": trAddress(_selectedBranch!),

      "delivery_type": _deliveryType,
      "delivery_address":
          _deliveryType == "delivery" ? _deliveryAddressController.text.trim() : null,

      "payment_method": _paymentMethod,
      "total": widget.totalAmount,
      "items": items,
      "createdAt": FieldValue.serverTimestamp(),
    };

    final db = FirebaseFirestore.instance;

    try {
      await db.collection("orders").doc(orderId).set(order);
      await db.collection("users").doc(uid).collection("orders").doc(orderId).set(order);

      // clear cart
      for (var item in widget.cartItems) {
        await db
            .collection("users")
            .doc(uid)
            .collection("cart")
            .doc(item["tag"])
            .delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr(
          "Заказ оформлен!",
          "Buyurtma rasmiylashtirildi!",
          "Order placed!",
        ))),
      );

      Navigator.pushReplacementNamed(context, "/my_orders");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr(
          "Ошибка при оформлении заказа",
          "Buyurtma berishda xato",
          "Order failed",
        ))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const redColor = Color(0xFFE53935);

    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr("Оформление заказа", "Buyurtma berish", "Checkout"),
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
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
            const SizedBox(height: 12),

            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: tr("Номер телефона", "Telefon raqami", "Phone number"),
              ),
            ),
            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                tr("Тип получения", "Qabul turi", "Pickup method"),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),

            Row(
              children: [
                Radio<String>(
                  value: "pickup",
                  groupValue: _deliveryType,
                  onChanged: (v) => setState(() => _deliveryType = v!),
                ),
                Text(tr("Самовывоз", "Olib ketish", "Pickup")),
                const SizedBox(width: 16),
                Radio<String>(
                  value: "delivery",
                  groupValue: _deliveryType,
                  onChanged: (v) => setState(() => _deliveryType = v!),
                ),
                Text(tr("Доставка до дома", "Uyga yetkazish", "Home delivery")),
              ],
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: _selectedBranch,
              decoration: InputDecoration(
                labelText: tr("Выберите филиал", "Filialni tanlang", "Choose branch"),
              ),
              items: branches.keys
                  .map((k) => DropdownMenuItem(value: k, child: Text(trCity(k))))
                  .toList(),
              onChanged: (v) => setState(() => _selectedBranch = v),
            ),

            const SizedBox(height: 6),

            if (_selectedBranch != null)
              Text(
                trAddress(_selectedBranch!),
                style: const TextStyle(color: Colors.grey),
              ),

            if (_deliveryType == "delivery") ...[
              const SizedBox(height: 16),
              TextField(
                controller: _deliveryAddressController,
                decoration: InputDecoration(
                  labelText: tr(
                    "Адрес доставки (город, улица, квартал, дом)",
                    "Manzil (shahar, ko‘cha, mahalla, uy)",
                    "Delivery address (city, street, block, house)",
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                tr("Способ оплаты", "To'lov turi", "Payment method"),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Row(
              children: [
                Radio<String>(
                  value: "cash",
                  groupValue: _paymentMethod,
                  onChanged: (v) => setState(() => _paymentMethod = v!),
                ),
                Text(tr("Наличные", "Naqd", "Cash")),
              ],
            ),

            Row(
              children: [
                Radio<String>(
                  value: "card",
                  groupValue: _paymentMethod,
                  onChanged: (v) {
                    setState(() => _paymentMethod = v!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(tr(
                          "Оплата картой — в разработке",
                          "Karta bilan to‘lov ishlab chiqilmoqda",
                          "Card payment in development",
                        )),
                      ),
                    );
                  },
                ),
                Text(tr("Карта", "Karta", "Card")),
              ],
            ),

            const SizedBox(height: 24),

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
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
