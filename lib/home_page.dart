import 'package:doct_appointment/widgets/appt.dart';
import 'package:doct_appointment/widgets/app_form.dart';
import 'package:doct_appointment/widgets/oral_health_progress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:doct_appointment/widgets/location.dart';
import 'package:doct_appointment/widgets/specialist_page.dart';
import 'package:geocoding/geocoding.dart';
import 'package:doct_appointment/widgets/all_specialist_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  final border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)));

  // Controllers and focus nodes
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _locationController = TextEditingController();
  double? _lat;
  double? _lng;


  // Search dropdown state
  bool _showDropdown = false;
  List<String> _filteredSpecialists = [];

  // Specialists list for search dropdown
  final List<String> _allSpecialists = [
    'Dentist',
    'Gynecologist/obstetrician',
    'General Physician',
    'Dermatologist',
    'Ear-nose-throat (ent) Specialist',
    'Homoeopath',
    'Ayurveda',
    'Cardiologist',
    'Orthopedic',
    'Neurologist',
    'Psychiatrist',
    'Pediatrician',
    'Ophthalmologist',
    'Urologist',
    'Radiologist',
  ];

  // Health concerns data for the row
  final List<HealthConcern> _healthConcerns = [
    HealthConcern(
      title: 'Tooth pain or\nsensitivity',
      icon: Icons.sick,
      color: Color(0xFFE3F2FD),
      iconColor: Color(0xFF1976D2),
    ),
    HealthConcern(
      title: 'Cavities or\nbleeding gums',
      icon: Icons.medical_services,
      color: Color(0xFFE8F5E9),
      iconColor: Color(0xFF2E7D32),
    ),
    HealthConcern(
      title: 'Teeth whitening\nor smile design',
      icon: Icons.auto_awesome,
      color: Color(0xFFFFF8E1),
      iconColor: Color(0xFFF9A825),
    ),
    HealthConcern(
      title: 'Braces or teeth\nalignment',
      icon: Icons.straighten,
      color: Color(0xFFEDE7F6),
      iconColor: Color(0xFF6A1B9A),
    ),
    HealthConcern(
      title: 'Missing tooth or\nimplants',
      icon: Icons.health_and_safety,
      color: Color(0xFFE0F7FA),
      iconColor: Color(0xFF00838F),
    ),
    HealthConcern(
      title: 'Same day crown\nor emergency',
      icon: Icons.flash_on,
      color: Color(0xFFFFEBEE),
      iconColor: Color(0xFFC62828),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        _showDropdown = _searchFocusNode.hasFocus;
      });
    });
    _filteredSpecialists = _allSpecialists;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _filterSpecialists(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSpecialists = _allSpecialists;
      } else {
        _filteredSpecialists = _allSpecialists
            .where((specialist) =>
            specialist.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _selectSpecialist(String specialist) {
    setState(() {
      _showDropdown = false;
    });

    _searchFocusNode.unfocus();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SpecialistPage(specialistName: specialist),
      ),
    ).then((_) {
      // Clear search when coming back
      _searchController.clear();
    });
  }

  signout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MedPlan'),
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu),
          ),
        ),
      ),
      drawerEnableOpenDragGesture: true,
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('${user?.displayName}'),
              accountEmail: Text('${user?.email}'),
              currentAccountPicture: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    FirebaseAuth.instance.currentUser?.photoURL ?? ''),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text("Appointment"),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Appt())),
            ),
            ListTile(
              leading: Icon(Icons.logout_rounded),
              title: Text("Log out"),
              onTap: () => signout(),
            ),
            ListTile(
              leading: Icon(Icons.app_registration),
              title: Text("Book an appointment"),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => App_form())),
            )
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {
            _showDropdown = false;
          });
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [

                      const ToothProgress(),
                      SizedBox(height: 20,),

                      // 🔥 Modern Search Container
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [

                            // 📍 Location Field
                            GestureDetector(
                              onTap: () async {
                                try {
                                  final position = await LocationService.getCurrentLocation();

                                  List<Placemark> placemarks = await placemarkFromCoordinates(
                                    position!.latitude,
                                    position.longitude,
                                  );

                                  Placemark place = placemarks[0];

                                  setState(() {
                                    _lat = position.latitude;
                                    _lng = position.longitude;

                                    _locationController.text =
                                    "${place.locality}, ${place.administrativeArea}";
                                  });

                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Location Permission Denied")),
                                  );
                                }
                              }
                              ,
                              child: AbsorbPointer(
                                child: TextField(
                                  controller: _locationController,
                                  decoration: InputDecoration(
                                    hintText: "Select Location",
                                    prefixIcon:
                                    Icon(Icons.location_on, color: Colors.redAccent),
                                    suffixIcon: Icon(Icons.my_location,
                                        color: Colors.grey.shade600),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                            Divider(height: 10,),

                            // 🔍 Search Field
                            TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              onChanged: _filterSpecialists,
                              decoration: InputDecoration(
                                hintText: "Search doctors & treatments...",
                                prefixIcon: Icon(Icons.search, color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),

                      // 🔽 Dropdown
                      if (_showDropdown && _filteredSpecialists.isNotEmpty)
                        Container(
                          constraints: BoxConstraints(maxHeight: 200),
                          margin: EdgeInsets.only(top: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _filteredSpecialists.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Icon(Icons.medical_services,
                                    color: Colors.cyan),
                                title: Text(_filteredSpecialists[index]),
                                onTap: () =>
                                    _selectSpecialist(_filteredSpecialists[index]),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),


                const SizedBox(height: 30),

                // Header Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Consult top doctors online for any health concern',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Private online consultations with verified doctors in all specialists',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                        onPressed: () {
                          // Handle view all specialities
                          Navigator.push(context, MaterialPageRoute(
                              builder:(context) => const AllSpecialistPage(),),);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.cyan,
                          side: const BorderSide(color: Colors.cyan),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('View All Specialities'),
                      ),
                  ],
                ),

                const SizedBox(height: 20),

                // Health Concerns Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _healthConcerns.map((concern) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: _buildHealthConcernCard(concern),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHealthConcernCard(HealthConcern concern) {
    return GestureDetector(
      onTap: () {
        // Handle concern tap
        print('Tapped on: ${concern.title}');
      },
      child: Container(
        width: 160,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: concern.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                concern.icon,
                color: concern.iconColor,
                size: 30,
              ),
            ),
            SizedBox(height: 12),
            Text(
              concern.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                height: 1.2,
              ),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => App_form())
                );
              },
              child: Text(
              'CONSULT NOW',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.cyan,
                letterSpacing: 0.5,
              ),
              )
            ),
          ],
        ),
      ),
    );
  }
}

class HealthConcern {
  final String title;
  final IconData icon;
  final Color color;
  final Color iconColor;

  HealthConcern({
    required this.title,
    required this.icon,
    required this.color,
    required this.iconColor,
  });
}