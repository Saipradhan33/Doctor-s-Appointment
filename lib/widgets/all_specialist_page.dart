import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'specialist_page.dart';

class AllSpecialistPage extends StatelessWidget {
  const AllSpecialistPage({super.key});

  final List<Map<String, dynamic>> specialties = const [
    {
      "name": "Gynaecology",
      "price": "₹499",
      "icon": Icons.pregnant_woman,
      "color": Color(0xFFE8F4FD),
    },
    {
      "name": "Sexology",
      "price": "₹499",
      "icon": Icons.favorite,
      "color": Color(0xFFFFE8F1),
    },
    {
      "name": "General physician",
      "price": "₹399",
      "icon": Icons.medical_services,
      "color": Color(0xFFE8F8F5),
    },
    {
      "name": "Dermatology",
      "price": "₹449",
      "icon": Icons.face,
      "color": Color(0xFFFFF4E6),
    },
    {
      "name": "Psychiatry",
      "price": "₹499",
      "icon": Icons.psychology,
      "color": Color(0xFFF3E5F5),
    },
    {
      "name": "Stomach & digestion",
      "price": "₹399",
      "icon": Icons.monitor_heart,
      "color": Color(0xFFFFF8E1),
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