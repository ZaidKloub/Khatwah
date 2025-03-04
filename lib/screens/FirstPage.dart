import 'package:flutter/material.dart';
import 'package:khatwah/screens/HomeScreen.dart';

import 'DrawerScreen.dart';

void main() {
  runApp(MaterialApp(
    home: FirstPage(),
  ));
}


class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DrawerScreen(),
          HomeScreen(),
        ],
      ),
    );
  }
}



