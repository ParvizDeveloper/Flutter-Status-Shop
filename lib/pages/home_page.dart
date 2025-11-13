import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../pages/product_page.dart';

/// ✅ Единая база всех товаров
final List<Map<String, dynamic>> allProducts = [
  // 🧥 --- ТЕКСТИЛЬ ---
  {
    'name': 'Футболка Статус',
    'price': 95000,
    'images': ['assets/images/product_sample.png'],
    'description': 'Футболка из плотного хлопка премиум-класса. Подходит для термопереноса.',
    'characteristics': {'Материал': 'Хлопок 100%', 'Размеры': 'S, M, L, XL, XXL'},
    'type': 'clothes',
  },
  {
    'name': 'Футболка Классик',
    'price': 90000,
    'images': ['assets/images/product_sample.png'],
    'description': 'Лёгкая и удобная футболка классического кроя.',
    'characteristics': {'Материал': 'Хлопок', 'Размеры': 'S, M, L, XL, XXL'},
    'type': 'clothes',
  },
  {
    'name': 'Кепка',
    'price': 80000,
    'images': ['assets/images/product_sample.png'],
    'description': 'Универсальная кепка с возможностью нанесения логотипа.',
    'characteristics': {'Материал': 'Хлопок', 'Тип застёжки': 'Регулируемая'},
    'type': 'clothes',
  },
  {
    'name': 'Худи',
    'price': 175000,
    'images': ['assets/images/product_sample.png'],
    'description': 'Мягкий худи с начёсом для повседневного ношения.',
    'characteristics': {'Материал': 'Флис', 'Размеры': 'M, L, XL'},
    'type': 'oversize',
  },
  {
    'name': 'Свитшот',
    'price': 160000,
    'images': ['assets/images/product_sample.png'],
    'description': 'Свитшот с плотной резинкой, идеально подходит для нанесения дизайнов.',
    'characteristics': {'Материал': 'Футер', 'Размеры': 'S, M, L, XL, XXL'},
    'type': 'clothes',
  },
  {
    'name': 'ЭКО сумка',
    'price': 55000,
    'images': ['assets/images/product_sample.png'],
    'description': 'ЭКО сумка из нетканого материала с короткими ручками.',
    'characteristics': {'Материал': 'Спанбонд', 'Размер': '40×35 см'},
    'type': 'clothes',
  },

  // 🎨 --- ТЕРМО ВИНИЛ ---
  {
    'name': 'PU Flex',
    'price': 140000,
    'images': List.generate(41, (i) => 'assets/vinill/pu/pu_${i + 1}.png'),
    'description': 'PU Flex — термотрансферная плёнка премиум-класса для текстиля.',
    'characteristics': {'Ширина рулона': '50 см', 'Температура': '150°C', 'Время': '10 сек'},
    'type': 'vinil',
  },
  {
    'name': 'PVC Flex',
    'price': 120000,
    'images': ['assets/vinill/pvc.png'],
    'description': 'PVC Flex — плотная термоплёнка для любых тканей.',
    'characteristics': {'Ширина рулона': '50 см', 'Температура': '155°C'},
    'type': 'vinil',
  },
  {
    'name': 'Flock',
    'price': 130000,
    'images': ['assets/vinill/flock.png'],
    'description': 'Мягкий бархатистый винил для дизайнов с текстурой.',
    'characteristics': {'Ширина рулона': '50 см', 'Температура': '160°C'},
    'type': 'vinil',
  },
  {
    'name': 'Stretch Foil',
    'price': 160000,
    'images': ['assets/vinill/stretch.png'],
    'description': 'Металлизированный винил с эффектом растяжения.',
    'characteristics': {'Ширина рулона': '50 см', 'Температура': '145°C'},
    'type': 'vinil',
  },
  {
    'name': 'Metalic Flex',
    'price': 150000,
    'images': ['assets/vinill/metallic.png'],
    'description': 'Глянцевый металлизированный винил для ярких надписей.',
    'characteristics': {'Ширина рулона': '50 см', 'Температура': '150°C'},
    'type': 'vinil',
  },
  {
    'name': 'Фосфор Flex',
    'price': 170000,
    'images': ['assets/vinill/phosphor.png'],
    'description': 'Винил, светящийся в темноте. Эффект “Glow in the Dark”.',
    'characteristics': {'Ширина рулона': '50 см', 'Температура': '150°C'},
    'type': 'vinil',
  },
  {
    'name': 'Рефлектор Flex',
    'price': 155000,
    'images': ['assets/vinill/reflector.png'],
    'description': 'Светоотражающий винил для спортивной и рабочей одежды.',
    'characteristics': {'Ширина рулона': '50 см', 'Температура': '150°C'},
    'type': 'vinil',
  },
  {
    'name': 'Silicon Flex',
    'price': 180000,
    'images': ['assets/vinill/silicon.png'],
    'description': 'Объёмная силиконовая термоплёнка. Эффект 3D.',
    'characteristics': {'Ширина рулона': '50 см', 'Температура': '155°C'},
    'type': 'vinil',
  },

  // ☕ --- КРУЖКИ, ТЕРМОСЫ ---
  {
    'name': 'Сублимационная кружка',
    'price': 25000,
    'images': ['assets/images/product_sample.png'],
    'description': 'Белая кружка для сублимационной печати 330 мл.',
    'characteristics': {'Материал': 'Керамика', 'Объём': '330 мл'},
    'type': 'equipment',
  },
  {
    'name': 'Термос для сублимации',
    'price': 70000,
    'images': ['assets/images/product_sample.png'],
    'description': 'Металлический термос под сублимацию, 500 мл.',
    'characteristics': {'Материал': 'Нержавеющая сталь', 'Объём': '500 мл'},
    'type': 'equipment',
  },

  // ⚙️ --- ОБОРУДОВАНИЕ ---
  {
    'name': 'Плоттер Teneth 70см',
    'price': 6800000,
    'images': ['assets/images/product_sample.png'],
    'description': 'Профессиональный режущий плоттер шириной 70 см.',
    'characteristics': {'Точность': '0.1 мм', 'Ширина резки': '70 см'},
    'type': 'equipment',
  },
  {
    'name': 'Cameo 5',
    'price': 5800000,
    'images': ['assets/images/product_sample.png'],
    'description': 'Плоттер Cameo 5 — компактный резчик для винила и текстиля.',
    'characteristics': {'Ширина резки': '30 см', 'Точность': '0.1 мм'},
    'type': 'equipment',
  },
  {
    'name': 'Термопресс 38×38',
    'price': 3500000,
    'images': ['assets/images/product_sample.png'],
    'description': 'Надёжный термопресс для переноса изображений.',
    'characteristics': {'Температура': '180°C', 'Время нагрева': '15 сек'},
    'type': 'equipment',
  },
  {
    'name': 'Термопресс 60×40',
    'price': 4200000,
    'images': ['assets/images/product_sample.png'],
    'description': 'Большой термопресс для промышленного использования.',
    'characteristics': {'Температура': '180°C', 'Мощность': '2.2 кВт'},
    'type': 'equipment',
  },
  {
    'name': 'Термопресс для кепок',
    'price': 2200000,
    'images': ['assets/images/product_sample.png'],
    'description': 'Термопресс для нанесения изображений на кепки.',
    'characteristics': {'Температура': '150°C', 'Размер пластины': '15×8 см'},
    'type': 'equipment',
  },
  {
    'name': 'Термопресс для кружек',
    'price': 1500000,
    'images': ['assets/images/product_sample.png'],
    'description': 'Специальный термопресс для кружек 330 мл.',
    'characteristics': {'Температура': '170°C', 'Размер': '330 мл'},
    'type': 'equipment',
  },
  {
    'name': 'Мини-пресс',
    'price': 1200000,
    'images': ['assets/images/product_sample.png'],
    'description': 'Компактный мини-пресс для мелких изделий.',
    'characteristics': {'Температура': '150°C', 'Мощность': '800 Вт'},
    'type': 'equipment',
  },

  // 🖨️ --- DTF материалы ---
  {
    'name': 'DTF краска',
    'price': 250000,
    'images': ['assets/images/product_sample.png'],
    'description': 'Краска для DTF принтеров CMYK + White.',
    'characteristics': {'Объём': '1 л', 'Тип': 'Пигментная'},
    'type': 'dtf',
  },
  {
    'name': 'DTF плёнка',
    'price': 120000,
    'images': ['assets/images/product_sample.png'],
    'description': 'Матовая DTF плёнка для принтеров любого типа.',
    'characteristics': {'Ширина': '60 см', 'Длина': '100 м'},
    'type': 'dtf',
  },
  {
    'name': 'DTF клей',
    'price': 85000,
    'images': ['assets/images/product_sample.png'],
    'description': 'Порошковый клей для переноса DTF отпечатков.',
    'characteristics': {'Тип': 'Термопорошок', 'Вес': '1 кг'},
    'type': 'dtf',
  },
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
    final List<Map<String, dynamic>> featured = allProducts.take(6).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 🔍 Верхняя панель
            SliverAppBar(
              backgroundColor: Colors.white,
              floating: true,
              elevation: 1,
              title: const Text('Status Shop',
                  style: TextStyle(color: redColor, fontWeight: FontWeight.bold)),
              centerTitle: true,
            ),

            // 🧱 Контент
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🖼️ Логотип
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset('assets/images/logo.png', height: 100),
                    ),
                  ),

                  // 🔥 Популярные товары
                  _sectionTitle('Популярное'),
                  SizedBox(
                    height: 270,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: featured.length,
                      itemBuilder: (context, index) {
                        final product = featured[index];
                        return _productCard(context, product);
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                  _sectionTitle('Рекомендуем'),
                  SizedBox(
                    height: 270,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        final product = allProducts[index + 6];
                        return _productCard(context, product);
                      },
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

  static Widget _sectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child:
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      );

  Widget _productCard(BuildContext context, Map<String, dynamic> product) {
    const redColor = Color(0xFFE53935);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProductPage(product: product)),
      ),
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
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(formatPrice(product['price']),
                      style: const TextStyle(
                          color: redColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  const SizedBox(height: 6),
                  Container(
                    alignment: Alignment.center,
                    height: 34,
                    decoration: BoxDecoration(
                      color: redColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Подробнее',
                        style: TextStyle(color: Colors.white, fontSize: 14)),
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
