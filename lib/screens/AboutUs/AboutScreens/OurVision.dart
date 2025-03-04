import 'package:flutter/material.dart';

class OurVision extends StatefulWidget {
  const OurVision({super.key});

  @override
  State<OurVision> createState() => _OurVisionState();
}

class _OurVisionState extends State<OurVision> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDEDED),
      appBar: AppBar(
        title: Text(
          'Our Vision',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Color(0xFF1A3C40),
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("asset/شعار-خطوة-بنج2.png", width: 36),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset('asset/vision_assets/our_vision (2).png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Our Vision",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A3C40)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "At Khatwah, our vision is to transform charitable giving by connecting compassionate individuals and organizations with those in need through an intuitive platform. We aim to make philanthropy accessible and effective, fostering a world where every act of generosity has a profound impact.",
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Empowering Communities",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A3C40)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "We believe in empowering communities by leveraging technology to create a seamless giving experience. Our platform is designed to bring together donors and recipients, ensuring that every contribution reaches its intended goal.",
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Creating Impact",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A3C40)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Our vision extends beyond simply connecting donors and recipients. We strive to create a lasting impact by supporting initiatives that promote education, healthcare, and sustainable development. By fostering a culture of giving, we aim to build a better future for all.",
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Join Us",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A3C40)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Together, we can make a difference. Join us on our journey to transform lives and create a world where generosity knows no bounds. With Khatwah, every step you take brings hope and opportunity to those in need.",
                    style: TextStyle(fontSize: 16, height: 1.5),
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
