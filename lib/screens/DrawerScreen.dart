import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khatwah/screens/zakat/selectionWay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AboutUs/AboutKhatwah.dart';
import 'CharitiesScreen.dart';
import 'MyProfileScreen.dart';
import 'SavedScreen.dart';
import 'chatscreen.dart';

const defaultFontSize = 16.0;
const defaultLanguage = 'English';

void main() => runApp(MyApp());

class AppSettings {
  bool darkMode;
  double fontSize;
  String language;

  AppSettings({
    required this.darkMode,
    required this.fontSize,
    required this.language,
  });

  AppSettings.defaultSettings()
      : darkMode = false,
        fontSize = defaultFontSize,
        language = defaultLanguage;
}

class MyApp extends StatelessWidget {
  static ThemeData appTheme = ThemeData.light();

  static void setAppTheme(ThemeData newTheme) {
    appTheme = newTheme;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App',
      theme: appTheme,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Drawer Example'),
        ),
        body: Center(
          child: Text('Home Screen'),
        ),
        drawer: DrawerScreen(),
      ),
    );
  }
}

class DrawerScreen extends StatelessWidget {
  final String? imageUrl;

  DrawerScreen({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Drawer(
          child: Container(
            width: double.infinity,
            color: Colors.blueGrey,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "asset/شعار-خطوة-بنج.png",
                        width: 90,
                        height: 90,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'KHATWAH',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text('Profile'),
                  leading: Icon(Icons.person_outline),
                  onTap: () async {
                    // Get the current user from Firebase Authentication
                    var currentUser = FirebaseAuth.instance.currentUser;

                    // Check if the user is not null
                    if (currentUser != null) {
                      // Use the user ID from the current user
                      String userId = currentUser.uid;

                      // Navigate to the MyProfileScreen with the user ID
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyProfileScreen(
                            userID: userId,
                          ),
                        ),
                      );
                    } else {
                      // Handle the case where there is no user logged in
                      print("No user is logged in.");
                    }
                  },
                ),
                ListTile(
                  title: Text('Settings'),
                  leading: Icon(Icons.settings),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsScreen(),
                      ),
                    );
                  },
                ),

                ListTile(
                  title: Text('My Posts'),
                  leading: Icon(Icons.bookmark_border),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SavedScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text('Messages'),
                  leading: Icon(Icons.message),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text('Zakat Calculator'),
                  leading: Icon(Icons.calculate_rounded),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => selectWay()));
                  },
                ),
                ListTile(
                  title: Text('Charities'),
                  leading: Icon(Icons.holiday_village),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CharitiesScreen()));
                  },
                ),
                ListTile(
                  title: Text('About Us'),
                  leading: Icon(Icons.quiz_sharp),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AboutKhatwah()));
                  },
                ),
                ListTile(
                  title: Text('Log out'),
                  leading: Icon(Icons.logout),
                  onTap: () {
                    Navigator.of(context).popUntil(ModalRoute.withName('/'));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Logout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log out'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Log out and exit the application completely
            SystemNavigator.pop();
          },
          child: Text('Log out'),
        ),

      ),
    );
  }
}


class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late AppSettings _appSettings;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool darkMode = prefs.getBool('darkMode') ?? false;
    double fontSize = prefs.getDouble('fontSize') ?? defaultFontSize;
    String language = prefs.getString('language') ?? defaultLanguage;

    setState(() {
      _appSettings = AppSettings(
        darkMode: darkMode,
        fontSize: fontSize,
        language: language,
      );
    });
  }

  Future<void> _saveSettings(AppSettings settings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', settings.darkMode);
    await prefs.setDouble('fontSize', settings.fontSize);
    await prefs.setString('language', settings.language);
  }

  void _updateTheme(bool darkMode) {
    final themeData = darkMode ? ThemeData.dark() : ThemeData.light();
    MyApp.setAppTheme(themeData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text(' Settings ', style: TextStyle(color: Colors.white)),
        elevation: 0,
        backgroundColor: Color(0xFF416C77),
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[

        ],
      ),
      body: _appSettings != null
          ? ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: Text('Dark Mode'),
            value: _appSettings.darkMode,
            onChanged: (value) {
              setState(() {
                _appSettings.darkMode = value;
              });
              _saveSettings(_appSettings);
              _updateTheme(value);
            },
          ),
          ListTile(
            title: Text('Font Size'),
            trailing: DropdownButton<double>(
              value: _appSettings.fontSize,
              onChanged: (value) {
                setState(() {
                  _appSettings.fontSize = value!;
                });
                _saveSettings(_appSettings);
              },
              items: [
                DropdownMenuItem(value: 16.0, child: Text('Small')),
                DropdownMenuItem(value: 20.0, child: Text('Medium')),
                DropdownMenuItem(value: 24.0, child: Text('Large')),
              ],
            ),
          ),
          ListTile(
            title: Text('Language'),
            trailing: DropdownButton<String>(
              value: _appSettings.language,
              onChanged: (value) {
                setState(() {
                  _appSettings.language = value!;
                });
                _saveSettings(_appSettings);
              },
              items: [
                DropdownMenuItem(value: 'English', child: Text('English')),
                DropdownMenuItem(value: 'Spanish', child: Text('Spanish')),
                DropdownMenuItem(value: 'French', child: Text('French')),
              ],
            ),
          ),
        ],
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
