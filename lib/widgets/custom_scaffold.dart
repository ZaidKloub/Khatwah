import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned(
            child: Image.asset(
              'asset/fooq3.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(child: Image.asset("asset/شعار-خطوة-بنج.png")),
          Center(child: Image.asset("asset/سلوجن-بنج.png")),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Transform.scale(
              scale: 1.5, // Adjust the scale factor as needed
              child: Image.asset("asset/Quraan.png"), // Adjust the path as needed
            ),          ),
          SafeArea(
            child: child!,
          ),
        ],
      ),
    );
  }
}
