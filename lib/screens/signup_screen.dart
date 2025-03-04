
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../theme/theme.dart';
import '../widgets/custom_scaffold.dart';
import 'DrawerScreen.dart';
import 'signin_screen.dart'; // Assuming this import is valid

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formSignupKey = GlobalKey<FormState>();
  bool agreePersonalData = true;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _imageUrl;

  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Full name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Email';
    }
    final emailRegExp =
    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  Future<void> _registerUser() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    String fullName = _fullNameController.text;

    try {
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = credential.user;
      await user?.updateDisplayName(fullName);
      await user?.reload();
      user = FirebaseAuth.instance.currentUser;

      if (user != null && !user.emailVerified) {
        var actionCodeSettings = ActionCodeSettings(
            url: 'https://www.example.com/?email',
            handleCodeInApp: true,
            iOSBundleId: 'com.example.ios',
            androidPackageName: 'com.example.android',
            androidInstallApp: true,
            androidMinimumVersion: '12');
        await user.sendEmailVerification(actionCodeSettings);
        await _saveDataToFirestore(user); // Pass user
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'A verification email has been sent. Please check your email.')));
      }
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => SignInScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('The password provided is too weak.')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('The account already exists for that email.')));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('An error occurred. Please try again later.')));
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      if (loginResult.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
        return await FirebaseAuth.instance.signInWithCredential(
            facebookAuthCredential);
      } else {
        throw Exception('Facebook Login Failed: ${loginResult.status}');
      }
    } catch (e) {
      // Handle any errors here
      throw Exception('Facebook Login Error: $e');
    }
  }

  Future<void> signInWithApple() async {
    try {
      final appleIdCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.example.your.client.id.web',
          redirectUri: Uri.parse(
              'https://your.domain.com/callbacks/sign_in_with_apple'),
        ),
      );

      final OAuthCredential appleCredential = OAuthProvider("apple.com")
          .credential(
        idToken: appleIdCredential.identityToken,
        accessToken: appleIdCredential.authorizationCode,
      );

      await FirebaseAuth.instance.signInWithCredential(appleCredential);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => SignInScreen()));
    } catch (error) {
      print('Sign in with Apple failed: $error');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign in with Apple failed: $error')));
    }
  }

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
                  key: _formSignupKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      TextFormField(
                        controller: _fullNameController,
                        validator: _validateFullName,
                        decoration: InputDecoration(
                          label: const Text('Full Name'),
                          hintText: 'Enter Full Name',
                          hintStyle: TextStyle(color: Colors.grey[700]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      TextFormField(
                        controller: _emailController,
                        validator: _validateEmail,
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          hintText: 'Enter Email',
                          hintStyle: TextStyle(color: Colors.grey[700]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        obscuringCharacter: '*',
                        validator: _validatePassword,
                        decoration: InputDecoration(
                          label: const Text('Password'),
                          hintText: 'Enter Password',
                          hintStyle: const TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        children: [
                          Checkbox(
                            value: agreePersonalData,
                            onChanged: (bool? value) {
                              setState(() {
                                agreePersonalData = value!;
                              });
                            },
                            activeColor: lightColorScheme.primary,
                          ),
                          const Text('I agree to the processing of '),
                          Text(
                            'Personal data',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFD9D1CC)),
                          onPressed: _registerUser,
                          child: const Text('Sign up'),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                                color: Colors.grey[700], thickness: 0.7),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text('Sign up with',
                                style: TextStyle(color: Colors.black45)),
                          ),
                          Expanded(
                            child: Divider(
                                color: Colors.grey[700], thickness: 0.7),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              signInWithFacebook();
                            },
                            child: Icon(FontAwesomeIcons.facebookF, size: 40.0,
                                color: Colors.blue[800]),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Icon(FontAwesomeIcons.twitter, size: 40.0,
                                color: Colors.lightBlue),
                          ),
                          InkWell(
                            onTap: () {
                              signInWithGoogle();
                            },
                            child: Icon(FontAwesomeIcons.google, size: 40.0,
                                color: Colors.red),
                          ),
                          InkWell(
                            onTap: () {
                              signInWithApple();
                            },
                            child: Icon(FontAwesomeIcons.apple, size: 40.0,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                              'Already have an account? ', style: TextStyle(
                              color: Colors.grey)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (e) => const SignInScreen()));
                            },
                            child: Text('Sign in', style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700])),
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

  Future<void> _saveDataToFirestore(User? user) async {
    if (user != null) {
      // Save data to Firestore with auto-generated document ID
      Map<String, dynamic> map = {
        "UserID": user.uid, // Include user ID
        "FullName": _fullNameController.text, // Change key to 'fullName'
        "Email": _emailController.text, // Change key to 'email'
        "isVerify": false,
        "Profile Image": _imageUrl ?? '', // Include profile image URL
      };
      await FirebaseFirestore.instance.collection("Users").doc(user.uid).set(map);

      // Navigate to the profile screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DrawerScreen(imageUrl: _imageUrl ?? ''), // Pass _imageUrl or empty string if null
        ),
      );
    }
  }
}
