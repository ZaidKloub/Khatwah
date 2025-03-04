import 'package:flutter/material.dart';

class GoldZakat extends StatefulWidget {
  const GoldZakat({super.key});

  @override
  State<GoldZakat> createState() => _GoldZakatState();
}

class _GoldZakatState extends State<GoldZakat> {
  final TextEditingController _weightController = TextEditingController();
  double? _zakatAmount;

  // Assuming the Nisab (minimum amount for Zakat to be due) is 85 grams of gold,
  // and the Zakat rate is 2.5% of the total gold weight above Nisab
  void _calculateZakat() {
    double weight = double.tryParse(_weightController.text) ?? 0;
    setState(() {
      if (weight >= 85) {
        _zakatAmount = (weight - 85) * 0.025;  // Zakat is 2.5% of the weight above 85 grams
      } else {
        _zakatAmount = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCBC3BD),
      appBar: AppBar(
        title: Text('Gold Zakat Calculator', style: TextStyle(color: Colors.white)),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset("asset/zakat/Gold.png"), // Assuming you have a gold image
              TextField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText: 'Enter your total gold weight in grams',
                  hintText: 'E.g., 100',
                  prefixIcon: Icon(Icons.balance),  // Icon representing weight
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
                  ),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculateZakat,
                child: Text(
                  'Calculate Zakat',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Color(0xFF416C77),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
              SizedBox(height: 20),
              if (_zakatAmount != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Your Zakat amount is: ${_zakatAmount!.toStringAsFixed(2)} grams',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF416C77),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
