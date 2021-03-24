
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/buttonComponent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

import 'login_screen.dart';
import 'registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  SequenceAnimation sequenceAnimation;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    //animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    // animation = ColorTween(begin: Colors.deepPurpleAccent, end: Colors.deepPurpleAccent)
    //     .animate(controller);
    sequenceAnimation =  SequenceAnimationBuilder()
        .addAnimatable(
        animatable:  ColorTween(begin: Colors.deepPurpleAccent, end: Colors.deepPurpleAccent),
        from:   Duration(seconds: 0),
        to:  Duration(seconds: 2),
        tag: "color"
    ).addAnimatable(
        animatable:  ColorTween(begin: Colors.lightGreen, end: Colors.blueAccent),
        from:   Duration(seconds: 2),
        to:  Duration(seconds: 4),
        tag: "color",

    ).addAnimatable(
        animatable:  ColorTween(begin: Colors.blueGrey, end: Colors.lightBlueAccent),
        //  animatable: new Tween<double>(begin: 200.0, end: 40.0),
        from:   Duration(seconds: 5),
        to:  Duration(seconds: 6),
        tag: "color",

    ).animate(controller);


    super.initState();
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sequenceAnimation["color"].value,
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
                    height: 60.0,
                  ),
                ),
                //text: 'Flash Chat',
                ColorizeAnimatedTextKit(
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                  repeatForever: true,
                  colors: [
                    Colors.black38,
                    Colors.grey,
                    Colors.blueGrey,
                    Colors.grey,
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              Colour: Colors.lightBlue,
              lable: 'Log In',
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              Colour: Colors.blueAccent,
              lable: "Register",
            )
          ],
        ),
      ),
    );
  }
}
