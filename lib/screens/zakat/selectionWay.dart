import 'package:flutter/material.dart';

import 'GoldZakat.dart';
import 'moneyZakat.dart';

class selectWay extends StatefulWidget {
  const selectWay({super.key});

  @override
  State<selectWay> createState() => _selectWayState();
}

class _selectWayState extends State<selectWay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCBC3BD),
      appBar:  AppBar(
        title: Text('Calculate Zakat', style: TextStyle(color: Colors.white)),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("asset/zakat/zakat photo (1).png"),
            Image.asset("asset/zakat/zakat text3.png", scale: 4.5),
            SizedBox(height: 20), // Add some space between the image and the button
            Container(
              width: MediaQuery.of(context).size.width * 0.87, // Adjusts the width to be 80% of the screen width
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MoneyZakat()),
                  );
                },
                child: Text('Money Zakat Calculator' , style: TextStyle(fontSize: 17),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF416C77),
                  minimumSize: Size.fromHeight(50),
                ),
              ),
            ),
            SizedBox(height: 20), // Space between two buttons
            Container(
              width: MediaQuery.of(context).size.width * 0.87, // Adjusts the width to be 80% of the screen width
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GoldZakat()),
                  );
                },
                child: Text('Gold Zakat Calculator' , style: TextStyle(fontSize: 17),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF416C77), // Change this to your desired color for Button 2
                  minimumSize: Size.fromHeight(50), // Minimum height of the button
                ),
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
