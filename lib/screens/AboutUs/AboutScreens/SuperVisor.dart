import 'package:flutter/material.dart';

class SuperVisor extends StatefulWidget {
  const SuperVisor({super.key});

  @override
  State<SuperVisor> createState() => _SuperVisorState();
}

class _SuperVisorState extends State<SuperVisor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Supervisor',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Color(0xFF1A3C40),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
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
                  child: Image.asset('asset/vision_assets/الدكتور محمد ريالات.png'),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Dr. Mohammad Hashem Ryalat",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A3C40)),
              ),
              SizedBox(height: 10),
              Text(
                "Appointment and Achievements",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A3C40)),
              ),
              SizedBox(height: 10),
              Text(
                "Dr. Mohammad Hashem Ryalat was appointed as a lecturer at Al-Balqa Applied University in September 2005 and won a British Council competition to pursue his PhD in 2014 in the United Kingdom. He was awarded a PhD titled: \"Automatic Construction of Immobilisation Masks for use in Radiotherapy Treatment of Head-and-Neck Cancer\" in 2017.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 20),
              Text(
                "Research Interests",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A3C40)),
              ),
              SizedBox(height: 10),
              Text(
                "Ryalat's research interests include biomedical engineering, computer graphics, artificial intelligence, machine learning, and data science.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 20),
              Text(
                "Current Role",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A3C40)),
              ),
              SizedBox(height: 10),
              Text(
                "He is currently an associate professor and the head of the Computer Information Systems department at Prince Abdullah bin Ghazi Faculty of ICT, working with different research teams and committees.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
