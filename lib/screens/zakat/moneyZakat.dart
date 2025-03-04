import 'package:flutter/material.dart';

class MoneyZakat extends StatefulWidget {
  const MoneyZakat({super.key});

  @override
  State<MoneyZakat> createState() => _MoneyZakatState();
}

class _MoneyZakatState extends State<MoneyZakat> {
  final TextEditingController _amountController = TextEditingController();
  double? _zakatAmount;

  // Zakat calculation function (typically 2.5% of the total amount)
  void _calculateZakat() {
    double amount = double.tryParse(_amountController.text) ?? 0;
    setState(() {
      _zakatAmount = amount * 0.025;  // Zakat is usually 2.5% of the total amount
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCBC3BD),
      appBar:  AppBar(
        title: Text('Money Zakat Calculator', style: TextStyle(color: Colors.white)),
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
              Image.asset("asset/zakat/money.png"),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Enter your total money',
                  hintText: 'E.g., 1000',
                  prefixIcon: Icon(Icons.monetization_on),  // Icon inside the TextField
                  filled: true,  // Adds a fill color
                  fillColor: Colors.white,  // Background color of the TextField
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),  // Rounded corners
                    borderSide: BorderSide.none,  // Removes the default border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),  // Blue border when focused
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),  // Grey border when not focused
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
                    fontSize: 16, // Text size
                    fontWeight: FontWeight.bold, // Text weight
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Color(0xFF416C77), // Text color
                  elevation: 5, // Shadow depth
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Padding inside the button
                ),
              ),
              SizedBox(height: 20),
              if (_zakatAmount != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Your Zakat amount is: \$${_zakatAmount!.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20, // Larger font size for better readability
                      fontWeight: FontWeight.bold, // Bold font weight for emphasis
                      color: Color(0xFF416C77), // A vibrant color for the text
                      fontFamily: 'Roboto', // Optionally set a font family
                    ),
                  ),
                )          ],
          ),
        ),
      ),
    );
  }
}
