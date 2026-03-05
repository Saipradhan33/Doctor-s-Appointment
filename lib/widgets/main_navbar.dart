import 'package:doct_appointment/home_page.dart';
import 'package:flutter/material.dart';
class MainNavBar extends StatelessWidget implements PreferredSizeWidget {
  const MainNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        height: 80,
        padding: EdgeInsets.symmetric(
          horizontal: width < 600 ? 16 : 40,
          vertical: 12,
        ),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            /// 🔵 Logo Section (Flexible to avoid overflow)
            Flexible(
              child: InkWell(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => false,);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_hospital,
                        color: Colors.blue,
                        size: width < 600 ? 26 : 32),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        "Dental Hospital",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width < 600 ? 15 : 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// 📞 Phone Section
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: width < 600 ? 16 : 18,
                  backgroundColor: Color(0xFF5A54E8),
                  child: Icon(Icons.phone,
                      color: Colors.white,
                      size: width < 600 ? 16 : 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80);
}

Widget navItem(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Text(title),
  );
}