import 'package:flutter/material.dart';
import 'package:khatwah/screens/signin_screen.dart';
import 'package:khatwah/screens/signup_screen.dart';

import '../theme/theme.dart';
import '../widgets/custom_scaffold.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});
  final Color customButtonColor = Color(0xFFCBC3BD);
  final Color customButtonColor2 = Color(0xFF416C77);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFCBC3BD), // Scaffold background color
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.7), // Shadow color
            spreadRadius: 5, // Spread radius
            blurRadius: 7, // Blur radius
            offset: Offset(0, 3), // Shadow offset
          ),
        ],
      ),
      child: CustomScaffold(
        child: Column(
          children: [
            Flexible(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 40.0,
                ),
                // Add your content here
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                color: Color(0xFFCBC3BD), // Column background color
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25 , bottom: 13),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignInScreen()),
                              );                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(customButtonColor2),
                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.only(right: 50 , left: 50 , top: 20 , bottom: 20), // Adjust padding as needed
                              ),
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                TextStyle(
                                  color: lightColorScheme.primary, // Text color
                                  fontSize: 18.0, // Text size
                                ),
                              ),
                            ),
                            child: Text('Sign in'), // Button text
                          ),
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40, bottom: 13),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SignUpScreen()),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.grey, // Change to green color
                            ),
                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.only(right: 50 , left: 50 , top: 20 , bottom: 20), // Adjust padding as needed
                              ),
                              textStyle: MaterialStateProperty.all<TextStyle>(
                                TextStyle(
                                  color: Colors.white, // Text color
                                  fontSize: 18.0, // Text size
                                ),
                              ),
                            ),
                            child: Text('Sign up'), // Button text
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
