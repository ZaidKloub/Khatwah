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
              'aseet/fooq3.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(child: Image.asset("aseet/شعار-خطوة-بنج.png")),
          Center(child: Image.asset("aseet/سلوجن-بنج.png")),
          SafeArea(
            child: child!,
          ),
        ],
      ),
    );
  }
}
