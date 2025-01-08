import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imageList = [
      'assets/images/donor2.png',
      'assets/images/donor2.png',
      'assets/images/donor2.png',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Blood Bond',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carousel Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                ),
                items: imageList.map((imagePath) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            // Description Section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Welcome to Blood Bond',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Blood Bond is a life-saving platform connecting donors with those in need of blood. '
                    'Our mission is to make blood donation simple, transparent, and accessible for everyone.',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    'Key Features:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '- Search for blood donors near you.\n'
                    '- Register as a donor and save lives.\n'
                    '- Manage donation requests effortlessly.\n'
                    '- Stay informed with our helpful guides and tips.',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Together, we can make a difference!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
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
}
