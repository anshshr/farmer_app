import 'package:flutter/material.dart';

// Dummy Model for Scheme
class Scheme {
  final String name;
  final String description;
  final String imageUrl;

  Scheme({
    required this.name,
    required this.description,
    required this.imageUrl,
  });
}

// Main Page Showing List of Schemes
class SchemeListPage extends StatelessWidget {
  SchemeListPage({super.key});

  // Dummy data list
  final List<Scheme> schemes = [
    Scheme(
      name: 'PM-Kisan Yojana',
      description:
          'Provides income support of ₹6000/year to farmers in 3 installments.',
      imageUrl:
          'https://img.naidunia.com/naidunia/ndnimg/06102024/06_10_2024-pmkisan18insatllment.webp',
    ),
    Scheme(
      name: 'Startup India',
      description:
          'Encourages startups and entrepreneurs with benefits and support.',
      imageUrl:
          'https://aatmnirbharsena.org/blog/wp-content/uploads/2020/11/Startup-India-Scheme.jpg',
    ),
    Scheme(
      name: 'Beti Bachao Beti Padhao',
      description: 'Promotes welfare and education of girl child.',
      imageUrl:
          'https://m.media-amazon.com/images/I/61UemQD+1ZL._AC_UF894,1000_QL80_.jpg',
    ),
    Scheme(
      name: 'Ayushman Bharat',
      description:
          'Provides health insurance up to ₹5 lakh/year to poor families.',
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTizjUsdANMmc1UNiVIdQIG9tZ42nE_XwKCDg&s',
    ),
    Scheme(
      name: 'Digital India',
      description: 'Focuses on digital literacy and promoting online services.',
      imageUrl:
          'https://static.toiimg.com/imagenext/toiblogs/photo/blogs/wp-content/uploads/2018/05/DigitalIndia.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Government Schemes'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: schemes.length,
        itemBuilder: (context, index) {
          final scheme = schemes[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  scheme.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                scheme.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                scheme.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                // Navigate to detail page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SchemeDetailPage(scheme: scheme),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Detail Page for each Scheme
class SchemeDetailPage extends StatelessWidget {
  final Scheme scheme;

  const SchemeDetailPage({super.key, required this.scheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(scheme.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  scheme.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              scheme.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(scheme.description, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
