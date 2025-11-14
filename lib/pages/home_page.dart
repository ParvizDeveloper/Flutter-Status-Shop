import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../pages/product_page.dart';
import '../pages/catalog_page.dart';

/// ---------------------------------------------
///  ВСЕ ТОВАРЫ
/// ---------------------------------------------
final List<Map<String, dynamic>> allProducts = [
  // 🧥 --- ТЕКСТИЛЬ ---
  {
    'name': 'Футболка Статус',
    'price': 95000,
    'images': ['assets/images/product_sample.png'],
    'description': 'Футболка из плотного хлопка премиум-класса.',
    'characteristics': {'Материал': 'Хлопок 100%', 'Размеры': 'S–XXL'},
    'type': 'clothes',
  },
  {
    'name': 'Футболка Классик',
    'price': 90000,
    'images': ['assets/images/product_sample.png'],
    'description': 'Лёгкая и удобная футболка классического кроя.',
    'characteristics': {'Материал': 'Хлопок', 'Размеры': 'S–XXL'},
    'type': 'clothes',
  },
  {
    'name': 'Кепка',
    'price': 80000,
    'images': ['assets/images/product_sample.png'],
    'description': 'Универсальная кепка с регулировкой.',
    'characteristics': {'Материал': 'Хлопок'},
    'type': 'clothes',
  },
  {
    'name': 'Худи',
    'price': 175000,
    'images': ['assets/images/product_sample.png'],
    'description': 'Мягкий худи с начёсом.',
    'characteristics': {'Материал': 'Флис', 'Размеры': 'M–XL'},
    'type': 'oversize',
  },
  {
    'name': 'Свитшот',
    'price': 160000,
    'images': ['assets/images/product_sample.png'],
    'description': 'Свитшот из футера.',
    'characteristics': {'Материал': 'Футер', 'Размеры': 'S–XXL'},
    'type': 'clothes',
  },
  {
    'name': 'ЭКО сумка',
    'price': 55000,
    'images': ['assets/images/product_sample.png'],
    'description': 'Эко-сумка 40×35 см.',
    'characteristics': {'Материал': 'Спанбонд'},
    'type': 'clothes',
  },

  // 🎨 --- ТЕРМО ВИНИЛ ---
  {
    'name': 'PU Flex',
    'price': 140000,
    'images': List.generate(41, (i) => 'assets/vinill/pu/pu_${i + 1}.png'),
    'description': 'PU Flex — премиальный термовинил.',
    'characteristics': {'Ширина': '50см', 'Температура': '150°C'},
    'type': 'vinil',
  },
  {'name': 'PVC Flex', 'price': 120000, 'images': ['assets/vinill/pvc.png'], 'description': 'Плотный винил.', 'characteristics': {'Ширина': '50см'}, 'type': 'vinil'},
  {'name': 'Flock', 'price': 130000, 'images': ['assets/vinill/flock.png'], 'description': 'Бархатный эффект.', 'characteristics': {'Ширина': '50см'}, 'type': 'vinil'},
  {'name': 'Stretch Foil', 'price': 160000, 'images': ['assets/vinill/stretch.png'], 'description': 'Металлик с растяжением.', 'characteristics': {'Ширина': '50см'}, 'type': 'vinil'},
  {'name': 'Metalic Flex', 'price': 150000, 'images': ['assets/vinill/metallic.png'], 'description': 'Глянцевый металлик.', 'characteristics': {'Ширина': '50см'}, 'type': 'vinil'},
  {'name': 'Фосфор Flex', 'price': 170000, 'images': ['assets/vinill/phosphor.png'], 'description': 'Светится в темноте.', 'characteristics': {'Ширина': '50см'}, 'type': 'vinil'},
  {'name': 'Рефлектор Flex', 'price': 155000, 'images': ['assets/vinill/reflector.png'], 'description': 'Светоотражающий.', 'characteristics': {'Ширина': '50см'}, 'type': 'vinil'},
  {'name': 'Silicon Flex', 'price': 180000, 'images': ['assets/vinill/silicon.png'], 'description': '3D силикон.', 'characteristics': {'Ширина': '50см'}, 'type': 'vinil'},

  // ☕ КРУЖКИ
  {'name': 'Сублимационная кружка', 'price': 25000, 'images': ['assets/images/product_sample.png'], 'description': 'Кружка 330 мл.', 'characteristics': {}, 'type': 'cups'},
  {'name': 'Термос для сублимации', 'price': 70000, 'images': ['assets/images/product_sample.png'], 'description': 'Термос 500 мл.', 'characteristics': {}, 'type': 'cups'},

  // ⚙️ ОБОРУДОВАНИЕ
  {'name': 'Плоттер Teneth 70см', 'price': 6800000, 'images': ['assets/images/product_sample.png'], 'description': 'Плоттер 70см.', 'characteristics': {}, 'type': 'equipment'},
  {'name': 'Cameo 5', 'price': 5800000, 'images': ['assets/images/product_sample.png'], 'description': 'Компактный плоттер.', 'characteristics': {}, 'type': 'equipment'},
  {'name': 'Термопресс 38×38', 'price': 3500000, 'images': ['assets/images/product_sample.png'], 'description': 'Надёжный пресс.', 'characteristics': {}, 'type': 'equipment'},
  {'name': 'Термопресс 60×40', 'price': 4200000, 'images': ['assets/images/product_sample.png'], 'description': 'Большой пресс.', 'characteristics': {}, 'type': 'equipment'},
  {'name': 'Термопресс для кепок', 'price': 2200000, 'images': ['assets/images/product_sample.png'], 'description': 'Пресс для кепок.', 'characteristics': {}, 'type': 'equipment'},
  {'name': 'Термопресс для кружек', 'price': 1500000, 'images': ['assets/images/product_sample.png'], 'description': 'Пресс под кружки.', 'characteristics': {}, 'type': 'equipment'},
  {'name': 'Мини-пресс', 'price': 1200000, 'images': ['assets/images/product_sample.png'], 'description': 'Компактный пресс.', 'characteristics': {}, 'type': 'equipment'},

  // 🖨️ DTF
  {'name': 'DTF краска', 'price': 250000, 'images': ['assets/images/product_sample.png'], 'description': 'Краска для DTF.', 'characteristics': {}, 'type': 'dtf'},
  {'name': 'DTF плёнка', 'price': 120000, 'images': ['assets/images/product_sample.png'], 'description': 'DTF плёнка 60см.', 'characteristics': {}, 'type': 'dtf'},
  {'name': 'DTF клей', 'price': 85000, 'images': ['assets/images/product_sample.png'], 'description': 'Клей порошковый.', 'characteristics': {}, 'type': 'dtf'},
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  String formatPrice(num price) {
    final formatter = NumberFormat('#,###', 'ru');
    return '${formatter.format(price)} UZS';
  }

  @override
  Widget build(BuildContext context) {
    const redColor = Color(0xFFE53935);

    final featured = allProducts.take(6).toList();
    final recommended = allProducts.skip(6).take(6).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            /// 🔍 Верхняя панель
            SliverAppBar(
              backgroundColor: Colors.white,
              floating: true,
              elevation: 1,
              titleSpacing: 10,
              title: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: const [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 6),
                          Text("Поиск...", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.favorite_border, color: redColor),
                  const SizedBox(width: 8),
                  Icon(Icons.notifications_none, color: redColor),
                ],
              ),
            ),

            /// Основной контент
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🔷 Логотип — теперь по центру
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 90,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  /// 🔵 Категории
                  _sectionTitle("Категории"),
                  SizedBox(
                    height: 110,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 16),
                      children: [
                        _category(context, Icons.checkroom, "Текстиль", "Текстиль"),
                        _category(context, Icons.layers, "Термо винил", "Термо винил"),
                        _category(context, Icons.print, "DTF материалы", "DTF материалы"),
                        _category(context, Icons.coffee, "Кружки", "Сублимационные кружки"),
                        _category(context, Icons.precision_manufacturing, "Оборудование", "Оборудование"),
                      ],
                    ),
                  ),

                  /// 🟥 SALE BANNNER — уменьшенный, как ранее
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/sale_banner.png',
                        height: 150,             // 🔥 уменьшенный
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  /// ⭐ Популярное
                  _sectionTitle("Популярное"),
                  SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: featured.length,
                      itemBuilder: (c, i) => _productCard(c, featured[i]),
                    ),
                  ),

                  /// 💡 Рекомендуем
                  _sectionTitle("Рекомендуем"),
                  SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: recommended.length,
                      itemBuilder: (c, i) => _productCard(c, recommended[i]),
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// 🧾 О НАС — минимализм
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: const [
                          SizedBox(height: 10),
                          Text(
                            "Status Shop\n"
                            "г. Ташкент, Чиланзар 1-й квартал, 59\n"
                            "+998 90 176 01 04\n"
                            "Пн-Сб: 10:00–19:00",
                            style: TextStyle(fontSize: 14, height: 1.5),
                            textAlign: TextAlign.center,   // ✔ центрирование
                          ),
                        ],
                      ),
                    ),
                  ),
                  

                  const SizedBox(height: 40),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Заголовок секции
  Widget _sectionTitle(String t) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Text(
          t,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );

  /// КАТЕГОРИЯ (кнопка Uzum-стиля)
  Widget _category(BuildContext ctx, IconData icon, String label, String category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          ctx,
          MaterialPageRoute(
            builder: (_) => CatalogPage(preselectedCategory: category),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 14),
        child: Column(
          children: [
            Container(
              height: 62,
              width: 62,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Icon(icon, color: Color(0xFFE53935), size: 30),
            ),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  /// Карточка товара
  Widget _productCard(BuildContext ctx, Map<String, dynamic> product) {
    const redColor = Color(0xFFE53935);

    return GestureDetector(
      onTap: () =>
          Navigator.push(ctx, MaterialPageRoute(builder: (_) => ProductPage(product: product))),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
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
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
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
                  Text(
                    product['name'],
                    maxLines: 2,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${NumberFormat('#,###', 'ru').format(product['price'])} UZS",
                    style: const TextStyle(
                      color: redColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}