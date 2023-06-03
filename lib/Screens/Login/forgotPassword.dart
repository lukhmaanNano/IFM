import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../../service/branding.dart';
import '../../service/emailService.dart';
import '../../styles/CommonSize.dart';
import '../../styles/CommonTextStyle.dart';
import '../../styles/Responsive.dart';
import '../../styles/common Color.dart';
import '../../widgets/snackBar.dart';
import 'otpScreen.dart';
import 'package:get/get.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  final BrandingControl _brandingControl = Get.find<BrandingControl>();
  final EmailController _emailController = Get.find<EmailController>();
  final _formKey = GlobalKey<FormState>();
  List<dynamic> brandingData = [];

  @override
  void initState() {
    super.initState();
    brandingFunc();
  }

  Future<void> brandingFunc() async {
    final response = _brandingControl.brandingData;
    setState(() {
      brandingData = response;
    });
  }

  Future<void> mail() async {
    final response =
        await _emailController.emailApi(context, emailController.text);

    print(response);
    if (response.statusCode == 200) {
      print(response);
      Navigator.push(
          context,
          PageTransition(
              ctx: context,
              inheritTheme: true,
              type: PageTransitionType.fade,
              child: OtpScreen(email: emailController.text)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(mobile: mobile(), desktop: web());
  }

  Widget mobile() {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(size: 32, Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 160,
              child: Center(
                child: CircleAvatar(
                    backgroundColor: secondaryColor,
                    radius: 60,
                    child: Image.asset(
                      width: 80,
                      'assets/images/forgot.png',
                      fit: BoxFit.fill,
                    )),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 10.0),
              child: Text('1.Forgot Password', style: headerStyle),
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                  'Please enter the email address associated whit you account.',
                  style: secondaryHeader),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: mailId(Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, right: 16.0),
              child: otpBtn(110, 15.0),
            )
          ],
        ),
      ),
    );
  }

  Widget web() {
    return Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(brandingData[0]['WebLoginSlide1Path']),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: SizedBox(
            height: displayHeight(context) * 0.80,
            width: displayWidth(context) * 0.90,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                        height: double.infinity,
                        width: displayWidth(context) / 1.9,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Image.network(
                                brandingData[0]['WebLoginSlide1Path']),
                          ),
                        )),
                  ),
                  SizedBox(width: displayWidth(context) * 0.05),
                  SizedBox(
                    width: displayWidth(context) * 0.28,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              icon: const Icon(
                                  size: 32,
                                  Icons.arrow_back,
                                  color: Colors.black),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          SizedBox(
                              width: displayWidth(context) / 4.0,
                              height: displayHeight(context) * 0.15,
                              child: Center(
                                  child:
                                      Image.asset('assets/images/forgot.png'))),
                          const SizedBox(height: 15),
                          const Text('1.Forgot Password', style: headerStyle),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                              'Please enter the email address associated whit you account.',
                              style: secondaryHeader),
                          mailId(primaryColor),
                          const SizedBox(height: 15),
                          otpBtn(double.infinity, 8.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget mailId(Color color) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Email id', style: inputHeader),
          ),
          TextFormField(
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "Email should not be empty";
              } else {
                return null;
              }
            },
            cursorColor: secondaryColor,
            controller: emailController,
            decoration: InputDecoration(
              fillColor: color,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              hoverColor: lightShade,
              focusColor: secondaryColor,
              floatingLabelBehavior: FloatingLabelBehavior.never,
              filled: true,
              labelStyle: const TextStyle(color: grey100),
              labelText: 'Enter your email address',
              suffixIcon: const Icon(Icons.mail, color: grey100),
            ),
          ),
        ],
      ),
    );
  }

  Widget otpBtn(double width, double radius) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(width, 45),
            // maximumSize: const Size(110, 45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            primary: secondaryColor,
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // getOtp(emailController.text.toString());
              mail();
            }
          },
          child: const Text("Get OTP"),
        ),
      ),
    );
  }
}
