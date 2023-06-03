import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pinput/pinput.dart';
import '../../service/branding.dart';
import '../../service/verifyOtp.dart';
import '../../styles/CommonSize.dart';
import '../../styles/CommonTextStyle.dart';
import '../../styles/Responsive.dart';
import '../../styles/common Color.dart';
import '../../widgets/toaster.dart';
import 'changePassword.dart';
import 'package:get/get.dart';

class OtpScreen extends StatefulWidget {
  String? email;
  OtpScreen({Key? key, this.email}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final BrandingControl _brandingControl = Get.find<BrandingControl>();
  final OTPController _otpController = Get.find<OTPController>();
  final focusNode = FocusNode();
  String? otp;
  final _formKey = GlobalKey<FormState>();
  final controller = TextEditingController();
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

  Future<void> opt() async {
    final response = await _otpController.otpApi(context, widget.email, otp);
    if (response.statusCode == 200) {
      changePass();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> changePass() async {
    Navigator.push(
        context,
        PageTransition(
            ctx: context,
            inheritTheme: true,
            type: PageTransitionType.fade,
            child: const ChangePassword()));
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
                        'assets/images/otp.png',
                        fit: BoxFit.fill,
                      )),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
                child: Text('2.Enter OTP', style: headerStyle),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
                child: Text(
                    'Please enter the 6 digit code sent to your email address.',
                    style: secondaryHeader),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, top: 15.0, bottom: 10.0),
                child: otpField(Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, right: 10.0),
                child: verifyBtn(110, 15.0),
              ),
            ],
          ),
        ));
  }

  Widget web() {
    return Scaffold(
      body: Container(
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
                                        Image.asset('assets/images/otp.png'))),
                            const SizedBox(height: 15),
                            const Text('2.Enter OTP', style: headerStyle),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                                'Please enter the 6 digit code sent to your email address.',
                                style: secondaryHeader),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(child: otpField(primaryColor)),
                            const SizedBox(height: 15),
                            verifyBtn(double.infinity, 8.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget otpField(Color color) {
    const length = 4;
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 55,
      margin: const EdgeInsets.all(3.0),
      textStyle: GoogleFonts.poppins(
        fontSize: 22,
        color: const Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 6.0,
            spreadRadius: 0.2,
            offset: const Offset(
              3.0,
              5.0,
            ),
          )
        ],
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.transparent),
      ),
    );
    return Form(
      key: _formKey,
      child: Pinput(
        length: length,
        controller: controller,
        focusNode: focusNode,
        defaultPinTheme: defaultPinTheme,
        onCompleted: (pin) {
          setState(() => otp = pin);
        },
        focusedPinTheme: defaultPinTheme.copyWith(
          height: 68,
          width: 64,
          decoration: defaultPinTheme.decoration!.copyWith(
            border: Border.all(color: secondaryColor),
          ),
        ),
        errorPinTheme: defaultPinTheme.copyWith(
          decoration: BoxDecoration(
            color: red,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget verifyBtn(double width, double radius) {
    return Align(
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
            opt();
          }
        },
        child: const Text("Verify OTP"),
      ),
    );
  }
}
