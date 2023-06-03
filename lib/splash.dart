import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ifm/service/branding.dart';
import 'package:ifm/styles/common%20Color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'Screens/Dashboard.dart';
import 'Screens/Login/entity.dart';
import 'Screens/Login/login.dart';
import 'config.dart';

class Splash extends StatefulWidget {
  Splash({Key? key, this.un, this.pass}) : super(key: key);
  String? un, pass;

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final BrandingControl _brandingControl = Get.find<BrandingControl>();
  String? ip;
  List<dynamic> brandingData = [];

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      webIp();
    }
    splashFunction();
    brandingFunc();
  }

  Future<void> brandingFunc() async {
    await _brandingControl.brandingApi(context);
    final response = _brandingControl.brandingData;
    setState(() {
      brandingData = response;
    });
  }

  Future<void> webIp() async {
    final prefs = await SharedPreferences.getInstance();
    String api = ApiConfig.service;
    await prefs.setString('ip', api);
  }

  Future<void> splashFunction() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      ip = prefs.getString('ip');
    });
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ip == null
                    ? EntityPage(name: widget.un, pass: widget.pass)
                    : SessionCheck(name: widget.un, pass: widget.pass))));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Hero(
          tag: 'login',
          child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 60,
              child: Image.asset('assets/images/ifm.png')),
        ));
  }
}

class SessionCheck extends StatefulWidget {
  SessionCheck({Key? key, required this.name, required this.pass})
      : super(key: key);
  String? name, pass;

  @override
  State<SessionCheck> createState() => _SessionCheckState();
}

class _SessionCheckState extends State<SessionCheck> {
  int? sessionId;

  @override
  void initState() {
    super.initState();
    splashFunction();
  }

  Future<void> splashFunction() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      sessionId = prefs.getInt('SessionId');
    });
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => sessionId == null
                    ? Login(
                        un: widget.name,
                        pass: widget.pass,
                        redirect: false,
                      )
                    : const Dashboard())));
  }

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [secondaryColor, primaryColor];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText('IFM',
                textStyle: GoogleFonts.inter(
                    textStyle: const TextStyle(
                        color: secondaryColor,
                        fontSize: 25,
                        fontWeight: FontWeight.w300)),
                colors: colorizeColors)
          ],
        ),
      ),
    );
  }
}
