import 'package:flutter/material.dart';

import 'AboutScreens/OurCollage.dart';
import 'AboutScreens/OurVision.dart';
import 'AboutScreens/SuperVisor.dart';
import 'AboutScreens/Team.dart';

class AboutKhatwah extends StatefulWidget {
  const AboutKhatwah({Key? key}) : super(key: key);

  @override
  State<AboutKhatwah> createState() => _AboutKhatwahState();
}

class _AboutKhatwahState extends State<AboutKhatwah> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCBC3BD),
      appBar: AppBar(
        title: Text('About Us', style: TextStyle(color: Colors.white)),
        elevation: 0,
        backgroundColor: Color(0xFF416C77),
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("asset/شعار-خطوة-بنج2.png"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                // Navigate to another page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OurCollege()), // Replace 'AnotherPage' with your target page class
                );
              },
              child: Container(
                margin: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  // Add border, shadow, etc.
                  border: Border.all(color: Color(0xFF416C77), width: 2.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10), // Optional, for rounded corners
                ),
                child: Image.asset('asset/vision_assets/our_collage.png'),
              ),
            ),
            InkWell(
              onTap: () {
                // Navigate to another page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OurVision()), // Replace 'AnotherPage' with your target page class
                );
              },
              child: Container(
                margin: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  // Add border, shadow, etc.
                  border: Border.all(color: Color(0xFF416C77), width: 2.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10), // Optional, for rounded corners
                ),
                child: Image.asset('asset/vision_assets/our_vision (2).png'),
              ),
            ),
            InkWell(
              onTap: () {
                // Navigate to another page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SuperVisor()), // Replace 'AnotherPage' with your target page class
                );
              },
              child: Container(
                margin: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  // Add border, shadow, etc.
                  border: Border.all(color: Color(0xFF416C77), width: 2.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10), // Optional, for rounded corners
                ),
                child: Image.asset('asset/vision_assets/Supervisor.png'),
              ),
            ),
            InkWell(
              onTap: () {
                // Navigate to another page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Team()), // Replace 'AnotherPage' with your target page class
                );
              },
              child: Container(
                margin: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  // Add border, shadow, etc.
                  border: Border.all(color: Color(0xFF416C77), width: 2.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10), // Optional, for rounded corners
                ),
                child: Image.asset('asset/vision_assets/Team (1).png'),
              ),
            ),
          ],
        )
      )
    );
  }
}