

import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash/components/Reusable_button.dart';
class WelcomeScreen extends StatefulWidget {
  static String id='Welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController controller;
 late Animation animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller=AnimationController(
        vsync:this,duration: Duration(seconds: 1));
    animation=ColorTween(begin: Colors.blueGrey,end: Colors.white).animate(controller);
    controller.forward();

    controller.addListener(() {
      setState(() {
        print(animation.value);
      });

    });
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(

                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                TypewriterAnimatedTextKit(
               text:['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Reusable(colors:Colors.lightBlueAccent,text:'Login In',onPressed: ()
              {
                Navigator.pushNamed(context, LoginScreen.id);
              },),
           Reusable(colors: Colors.blueAccent,  text:'Registration ',onPressed: ()
           {
             Navigator.pushNamed(context, RegistrationScreen.id);
           },)
          ],
        ),
      ),
    );
  }
}

