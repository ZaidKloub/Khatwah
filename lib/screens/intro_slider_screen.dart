import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:khatwah/screens/welcome_screen.dart';

class OnBoarding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: OnBoardingPage(),
    );
  }
}

class OnBoardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      headerBackgroundColor: Color(0xFF416C77),
      finishButtonText: 'Register',
      finishButtonStyle: FinishButtonStyle(
        backgroundColor: Color(0xFF416C77),
      ),
      skipTextButton: Text(
        'Skip',
        style: TextStyle(color: Colors.white),
      ),
      trailing: Text('Login' , style: TextStyle(color: Colors.white),),
      onFinish: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WelcomeScreen()),
        );
      },
      background: [
        Image.asset(
          'asset/intro_slides/intro12.png',
          width: 400,
          height: 400,
        ),
        Image.asset(
          'asset/intro_slides/intro22.png',
          width: 400,
          height: 400,
        ),
        Image.asset(
          'asset/intro_slides/intro23.png',
          width: 400,
          height: 400,
        ),
      ],
      controllerColor: Color(0xFF416C77),
      totalPage: 3,
      speed: 1.8,
      pageBodies: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 480,
              ),
              Text(
                'كُنْ عَوْنًا',
                style: TextStyle(
                  fontSize: 80,
                  fontFamily: 'MyCustomFont',
                  color: Color(0xFF416C77),
                ),
              ),
              Text(
                'كن عونا للناس و ساعد عبر تطبيق خطوة',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'MyCustomFont',
                  color: Color(0xFF416C77),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 480,
              ),
              Text(
                'قَدِّمْ الْمُسَاعَدَةَ',
                style: TextStyle(
                  fontSize: 60,
                  fontFamily: 'MyCustomFont',
                  color: Color(0xFF416C77),
                ),
              ),
              Text(
                'تعاون مع الاخرين و ابدأ',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'MyCustomFont',
                  color: Color(0xFF416C77),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 480,
              ),
              Text(
                'ابدأ',
                style: TextStyle(
                  fontSize: 80,
                  fontFamily: 'MyCustomFont',
                  color: Color(0xFF416C77),
                ),
              ),
              Text(
                ' خطواتك نحو الخير مع خطوة',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'MyCustomFont',
                  color: Color(0xFF416C77),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Page'),
      ),
      body: Center(
        child: Text('This is the next page!'),
      ),
    );
  }
}
