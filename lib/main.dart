import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const BanyuGrowthApp());
}

class BanyuGrowthApp extends StatelessWidget {
  const BanyuGrowthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BanyuGrowth',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

// =================== SPLASH SCREEN ===================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        // Pastikan memanggil HomePage yang benar (Stateful)
        MaterialPageRoute(builder: (context) => const HomePage()), 
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6CD5A4), Color(0xFF4BA6D1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage('assets/Logo.png'),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(height: 20),
              Text(
                "BANYU GROWTH",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =================== HOME PAGE (STATEFUL DENGAN SEARCH/FILTER) ===================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> allProducts = [];
  List<Map<String, String>> filteredProducts = [];

  // Data produk inisial
  void _initializeProducts() {
    allProducts = [
      {'image': 'assets/flatshoes.jpg', 'nama': 'Flat Shoes Batik', 'harga': 'Rp123.000', 'penjual': 'Anaya Fashion', 'kategori': 'Fashion'},
      {'image': 'assets/jamu.png', 'nama': 'Jamu Kunyit Asem', 'harga': 'Rp10.000', 'penjual': 'Jamu Bu Nur', 'kategori': 'Minuman'},
      {'image': 'assets/vas_bunga.png', 'nama': 'Dekorasi Bunga', 'harga': 'Rp25.000', 'penjual': 'Toko Florist', 'kategori': 'Dekorasi'},
      {'image': 'assets/kemeja_batik.png', 'nama': 'Kemeja Batik', 'harga': 'Rp89.000', 'penjual': 'Batik Lestari', 'kategori': 'Fashion'},
      {'image': 'assets/vas_botol_rajut.png', 'nama': 'Botol Vas Rajut', 'harga': 'Rp40.000', 'penjual': 'Rajut Indah', 'kategori': 'Dekorasi'},
      {'image': 'assets/keripik_kelapa.png', 'nama': 'Keripik Kelapa Panggang ', 'harga': 'Rp25.000', 'penjual': 'JD Sehat', 'kategori': 'Makanan'},
      {'image': 'assets/wedang_jahe.png', 'nama': 'Wedang Jahe', 'harga': 'Rp17.500', 'penjual': 'Amera Tradisional', 'kategori': 'Minuman'},
      {'image': 'assets/ganci_wayang.png', 'nama': 'Ganci Wayang', 'harga': 'Rp30.000', 'penjual': 'Wayang Kulit', 'kategori': 'Lainnya'},
      // Tambahkan produk yang dicari ('celana') agar muncul!
      {'image': 'assets/celana_batik.jpg', 'nama': 'Celana Sarung Batik', 'harga': 'Rp95.000', 'penjual': 'Batik Njawani', 'kategori': 'Fashion'}, 
    ];
    filteredProducts = List.from(allProducts);
  }

  @override
  void initState() {
    super.initState();
    _initializeProducts();
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = List.from(allProducts);
      } else {
        filteredProducts = allProducts
            .where((produk) =>
                produk['nama']!.toLowerCase().contains(query.toLowerCase()) ||
                produk['penjual']!.toLowerCase().contains(query.toLowerCase()) ||
                (produk['kategori']?.toLowerCase().contains(query.toLowerCase()) ?? false))
            .toList();
      }
    });
  }
  
  // Data untuk Kategori (agar sesuai screenshot)
  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.checkroom, 'label': 'Fashion'},
    {'icon': Icons.fastfood, 'label': 'Makanan'},
    {'icon': Icons.local_drink, 'label': 'Minuman'},
    {'icon': Icons.local_florist, 'label': 'Dekorasi'},
    {'icon': Icons.work_outline, 'label': 'Jasa'},
    {'icon': Icons.grid_view_rounded, 'label': 'Lainnya'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Pencarian"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Favorit"),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔍 Search bar (TERHUBUNG KE STATE)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _filterProducts, // Filter saat mengetik
                        onSubmitted: _filterProducts, // Filter saat Enter ditekan
                        decoration: const InputDecoration(
                          hintText: "Cari produk...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        _filterProducts(''); // Reset filter
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 🐔 Banner Diskon
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: AssetImage("assets/Header_Diskon.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 🧭 Kategori
              const Text("Kategori", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((cat) => KategoriItem(icon: cat['icon'] as IconData, label: cat['label'] as String)).toList(),
                ),
              ),

              const SizedBox(height: 24),

              // ⭐ Rekomendasi / Hasil Pencarian
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  _searchController.text.isEmpty ? "Rekomendasi" : "Hasil Pencarian",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              // Tampilan Produk (Menggunakan filteredProducts)
              filteredProducts.isEmpty
                  ? Center(child: Text("Produk tidak ditemukan untuk '${_searchController.text}'"))
                  : GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.75,
                      children: filteredProducts
                          .map((produk) => ProdukCard(
                                image: produk['image']!,
                                nama: produk['nama']!,
                                harga: produk['harga']!,
                                penjual: produk['penjual']!,
                              ))
                          .toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// =================== FAVORIT PAGE ===================
class FavoritPage extends StatelessWidget {
  const FavoritPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> favoritList = [
      {"image": "assets/batagor.jpg", "nama": "Batagor", "harga": "Rp12.000", "penjual": "Batagor Sehat"},
      {"image": "assets/celana_batik.jpg", "nama": "Celana Batik", "harga": "Rp89.000", "penjual": "Batik Lestari"},
      {"image": "assets/vas_bunga.png", "nama": "Dekorasi Bunga", "harga": "Rp19.900", "penjual": "Nerra Craft"},
      {"image": "assets/totebag_rajut.png", "nama": "Totebag Rajut", "harga": "Rp175.000", "penjual": "Rajut Kreatif"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorit"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: favoritList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final produk = favoritList[index];
            return ProdukCard(
              image: produk["image"]!,
              nama: produk["nama"]!,
              harga: produk["harga"]!,
              penjual: produk["penjual"]!,
            );
          },
        ),
      ),
    );
  }
}

// =================== WIDGET TAMBAHAN ===================
class KategoriItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const KategoriItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: () {
          if (label == "Lainnya") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SemuaKategoriPage()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => KategoriPage(kategori: label)),
            );
          }
        },
        child: Column(
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange),
              ),
              child: Icon(icon, color: Colors.orange, size: 32),
            ),
            const SizedBox(height: 6),
            Text(label,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class ProdukCard extends StatelessWidget {
  final String image, nama, harga, penjual;
  const ProdukCard({
    super.key,
    required this.image,
    required this.nama,
    required this.harga,
    required this.penjual,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, blurRadius: 6, offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(image, fit: BoxFit.scaleDown, height: 120, width: double.infinity),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(harga, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 4),
                Text(penjual, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class KategoriPage extends StatelessWidget {
  final String kategori;
  const KategoriPage({super.key, required this.kategori});

  @override
  Widget build(BuildContext context) {
    // Data produk berdasarkan kategori
    final Map<String, List<Map<String, String>>> kategoriProduk = {
      "Fashion": [
        {"image": "assets/flatshoes.jpg", "nama": "Flat Shoes Batik", "harga": "Rp123.000", "penjual": "Anaya Fashion"},
        {"image": "assets/celana_batik.jpg", "nama": "Celana Sarung Batik Banyumasan", "harga": "Rp95.000", "penjual": "Batik Njawani"},
        {"image": "assets/ganci_wayang.png", "nama": "Ganci Wayang Kulit Batik", "harga": "Rp7.000", "penjual": "Aksesoris Tradisional"},
        {"image": "assets/totebag_rajut.png", "nama": "Totebag Rajut", "harga": "Rp175.000", "penjual": "Rajut Kreatif"},
      ],
      "Makanan": [
        {"image": "assets/keripik_kelapa.png", "nama": "Keripik Kelapa Panggang ", "harga": "Rp25.000", "penjual": "JD Sehat"},
        {"image": "assets/keripik.jpg", "nama": "Keripik Tempe", "harga": "Rp15.000", "penjual": "Top's Snack"},
        {"image": "assets/batagor.jpg", "nama": "Batagor Crispy", "harga": "Rp17.500", "penjual": "Khyar Food"},
        {"image": "assets/plintir.png", "nama": "Plintir Coklat", "harga": "Rp19.000", "penjual": "Mak Cinov"},
      ],
      "Minuman": [
        {"image": "assets/jamu.png", "nama": "Jamu Kunyit Asem", "harga": "Rp10.000", "penjual": "Jamu Bu Nur"},
        {"image": "assets/wedang_jahe.png", "nama": "Wedang Jahe", "harga": "Rp17.500", "penjual": "Amera Tradisional"},
        {"image": "assets/kopi_mbekayu.png", "nama": "Kopi Mbekayu", "harga": "Rp27.500", "penjual": "Mbekayu"},
        {"image": "assets/kopi_mas.png", "nama": "Kopi Mas", "harga": "Rp17.000", "penjual": "TKM Wajada"},
      ],
      "Dekorasi": [
        {"image": "assets/vas_bunga.png", "nama": "Vas Bunga Keramik", "harga": "Rp25.000", "penjual": "Toko Florist"},
        {"image": "assets/vas_botol_rajut.png", "nama": "Botol Vas Rajut", "harga": "Rp40.000", "penjual": "Dekor Rumahku"},
        {"image": "assets/hiasan_dinding_bunga.png", "nama": "Hiasan Dinding Bunga", "harga": "Rp30.000", "penjual": "Artsy Decor"},
        {"image": "assets/hiasan_dinding_wayang.png", "nama": "Hiasan Dinding Wayang", "harga": "Rp60.000", "penjual": "Tradisi Dekor"},
      ],
      "Jasa": [
        {"image": "assets/jasa_cuci_motor.jpg", "nama": "Jasa Cuci Motor", "harga": "Rp12.500", "penjual": "Daecan Motor"},
        {"image": "assets/laundry.jpg", "nama": "Laundry Service", "harga": "Rp4.000/kg", "penjual": "Clean Laundry"},
        {"image": "assets/percetakan.jpg", "nama": "Jasa Percetakan Sapanduk Elektronik", "harga": "Rp120.000", "penjual": "Mika Print"},
        {"image": "assets/potong_rambut.jpg", "nama": "Baber Shop", "harga": "Rp45.000", "penjual": "Babeh Cuts"},
      ],
    };

    final produkList = kategoriProduk[kategori] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(kategori),
        backgroundColor: Colors.white,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: produkList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          final produk = produkList[index];
          return ProdukCard(
            image: produk["image"]!,
            nama: produk["nama"]!,
            harga: produk["harga"]!,
            penjual: produk["penjual"]!,
          );
        },
      ),
    );
  }
}

class SemuaKategoriPage extends StatelessWidget {
  const SemuaKategoriPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> semuaKategori = [
      "Fashion",
      "Makanan",
      "Minuman",
      "Dekorasi",
      "Jasa",
      "Lainnya",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kategori"),
        backgroundColor: Colors.white,
      ),
      body: ListView.separated(
        itemCount: semuaKategori.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final kategori = semuaKategori[index];
          return ListTile(
            title: Text(
              kategori,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => KategoriPage(kategori: kategori),
                ),
              );
            },
          );
        },
      ),
    );
  }
}