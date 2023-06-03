import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifm/service/adminImageRegistry.dart';
import 'package:ifm/service/adminImageRegistrySelect.dart';
import 'package:ifm/service/advertisement.dart';
import 'package:ifm/service/asset.dart';
import 'package:ifm/service/branding.dart';
import 'package:ifm/service/building.dart';
import 'package:ifm/service/changePassword.dart';
import 'package:ifm/service/contract.dart';
import 'package:ifm/service/count.dart';
import 'package:ifm/service/department.dart';
import 'package:ifm/service/discipline.dart';
import 'package:ifm/service/division.dart';
import 'package:ifm/service/emailService.dart';
import 'package:ifm/service/feedbakRating.dart';
import 'package:ifm/service/floor.dart';
import 'package:ifm/service/getxListener.dart';
import 'package:ifm/service/location.dart';
import 'package:ifm/service/loginService.dart';
import 'package:ifm/service/name.dart';
import 'package:ifm/service/natureOfComplaint.dart';
import 'package:ifm/service/registerSave.dart';
import 'package:ifm/service/servicePageInitState.dart';
import 'package:ifm/service/serviceRequest.dart';
import 'package:ifm/service/spot.dart';
import 'package:ifm/service/trackTable.dart';
import 'package:ifm/service/trackView.dart';
import 'package:ifm/service/verifyOtp.dart';
import 'package:ifm/splash.dart';
import 'package:ifm/styles/common%20Color.dart';
import 'Screens/Login/login.dart';

void main() {
  Get.put(EmailController());
  Get.put(LoginController());
  Get.put(OTPController());
  Get.put(ChangePasswordController());
  Get.put(AdvertisementControl());
  Get.put(ContractControl());
  Get.put(LocationControl());
  Get.put(BuildingControl());
  Get.put(ServiceRequestInitStateControl());
  Get.put(ServiceRequestControl());
  Get.put(FloorControl());
  Get.put(SpotControl());
  Get.put(DepartmentControl());
  Get.put(DisciplineControl());
  Get.put(DivisionControl());
  Get.put(RegisterSaveControl());
  Get.put(NatureOfComplaintControl());
  Get.put(ListenerControl());
  Get.put(AssetControl());
  Get.put(TrackTableControl());
  Get.put(TrackViewControl());
  Get.put(BrandingControl());
  Get.put(AdminImageRegistrySaveControl());
  Get.put(AdminImageRegistrySelectControl());
  Get.put(CountControl());
  Get.put(NameControl());
  Get.put(FeedbackRating());
  String? un = Uri.base.queryParameters["un"].toString();
  String? pass = Uri.base.queryParameters["pd"].toString();
  runApp(MyApp(
    un: un,
    pass: pass,
  ));
}

class MyApp extends StatelessWidget {
  String? un, pass;
  MyApp({super.key, this.un, this.pass});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      routes: {
        '/login': (context) => Login(redirect: false),
      },
      debugShowCheckedModeBanner: false,
      // themeMode: ThemeMode.dark,
      scrollBehavior: const ScrollBehavior(
          androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        appBarTheme: AppBarTheme(
            backgroundColor: Styles.scaffoldBackgroundColor,
            titleTextStyle:
                const TextStyle(fontFamily: 'Eras Demi', fontSize: 20)),
        buttonTheme: const ButtonThemeData(
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        checkboxTheme: CheckboxThemeData(
          shape: const CircleBorder(),
          checkColor: MaterialStateProperty.all(Colors.white),
          fillColor: MaterialStateProperty.all(const Color(0xFF21446F)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
          ),
        ),
        dividerColor: buttonForeground,
        primaryColor: const Color(0xFF21446F),
        scaffoldBackgroundColor: Styles.scaffoldBackgroundColor,
        scrollbarTheme: Styles.scrollbarTheme,
      ),
      title: 'HELPDESK',
      home: Splash(un: un, pass: pass),
    );
  }
}
