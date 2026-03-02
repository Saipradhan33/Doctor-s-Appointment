import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'specialist_page.dart';

class AllSpecialistPage extends StatelessWidget {
  const AllSpecialistPage({super.key});

  final List<Map<String, dynamic>> specialties = const [
    {
      "name": "Root Canal Treatment",
      "price": "₹2,999",
      "icon": Icons.medical_services,
      "color": Color(0xFFE3F2FD),
    },
    {
      "name": "Dental Implants",
      "price": "₹24,999",
      "icon": Icons.health_and_safety,
      "color": Color(0xFFE8F5E9),
    },
    {
      "name": "Teeth Whitening",
      "price": "₹4,499",
      "icon": Icons.auto_awesome,
      "color": Color(0xFFFFF8E1),
    },
    {
      "name": "Child Dentistry",
      "price": "₹1,499",
      "icon": Icons.child_care,
      "color": Color(0xFFFFEBEE),
    },
    {
      "name": "Orthodontics",
      "price": "₹19,999",
      "icon": Icons.straighten,
      "color": Color(0xFFEDE7F6),
    },
    {
      "name": "Crown And Bridges",
      "price": "₹6,999",
      "icon": Icons.build_circle,
      "color": Color(0xFFE0F7FA),
    },
    {
      "name": "Laser Dentistry",
      "price": "₹5,999",
      "icon": Icons.flash_on,
      "color": Color(0xFFFFF3E0),
    },
    {
      "name": "Dentures",
      "price": "₹8,999",
      "icon": Icons.mood,
      "color": Color(0xFFF3E5F5),
    },
  ];
  final List<String> bannerImages = const[
    "assets/images/image1.png",
    "assets/images/image2.png",
    "assets/images/image1.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("25+ Specialities"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // 🔥 Carousel Banner
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: true,
                  ),
                  items: bannerImages.map((imagePath) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [

                        // Background Image
                        Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                        ),

                        // Dark overlay
                        Container(
                          color: Colors.black.withOpacity(0.3),
                        ),

                        // Text + Button
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Skip the travel!",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Online consultation starting ₹199",
                                style: TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 15),
                              ElevatedButton(
                                onPressed: () {},
                                child: const Text("Consult Now"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                )
              )
            ),
                  const SizedBox(height: 20),

            // 🔹 Grid of Specialities
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                shrinkWrap: true,
                physics:
                const NeverScrollableScrollPhysics(),
                itemCount: specialties.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  final item = specialties[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SpecialistPage(
                                specialistName:
                                item["name"],
                              ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: item["color"],
                        borderRadius:
                        BorderRadius.circular(16),
                      ),
                      padding:
                      const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor:
                            Colors.white,
                            child: Icon(
                              item["icon"],
                              size: 30,
                              color: Colors.cyan,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            item["name"],
                            textAlign:
                            TextAlign.center,
                            style: const TextStyle(
                                fontWeight:
                                FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item["price"],
                            style: const TextStyle(
                                color:
                                Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}