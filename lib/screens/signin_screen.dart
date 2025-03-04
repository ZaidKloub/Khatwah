import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/custom_scaffold.dart';
import 'FirstPage.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  bool rememberPassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();




  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(height: 10),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter Email',
                          hintStyle: const TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter Password',
                          hintStyle: const TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: rememberPassword,
                                onChanged: (bool? value) {
                                  setState(() {
                                    rememberPassword = value!;
                                  });
                                },
                                activeColor: Theme.of(context).primaryColor,
                              ),
                              const Text('Remember me'),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              // Implement password recovery functionality
                            },
                            child: const Text(
                              'Forget password?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Color(0xFFD9D1CC), // Using your color
                          ),
                          onPressed: () {
                            if (_formSignInKey.currentState!.validate()) {
                              FirebaseFirestore.instance
                                  .collection("Users")
                                  .where("Email",
                                      isEqualTo: _emailController.text.trim())
                                  .get()
                                  .then((databaseResult) {
                                if (databaseResult.docs.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'No user found with that email.')));
                                  return;
                                }
                                String email = databaseResult.docs.first
                                    .data()["Email"];
                                FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: email,
                                  password: _passwordController.text.trim(),
                                )
                                    .then((credential) {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => FirstPage()));
                                }).catchError((e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Failed to sign in: $e')));
                                });
                              }).catchError((e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'An unexpected error occurred. Please try again.')));
                                print(e
                                    .toString()); // Print the error to the console for debugging
                              });
                            }
                          },
                          child: const Text('Sign in'),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text('Sign in with'),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(FontAwesomeIcons.facebookF,
                              size: 40.0, color: Colors.blue[800]),
                          Icon(FontAwesomeIcons.twitter,
                              size: 40.0, color: Colors.lightBlue),
                          Icon(FontAwesomeIcons.google,
                              size: 40.0, color: Colors.red),
                          Icon(FontAwesomeIcons.apple,
                              size: 40.0, color: Colors.black),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account? ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FirstPage()),
                              );
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
