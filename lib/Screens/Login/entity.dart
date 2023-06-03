import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config.dart';
import '../../service/branding.dart';
import '../../styles/CommonTextStyle.dart';
import '../../styles/Responsive.dart';
import '../../styles/common Color.dart';
import '../../widgets/toaster.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

class EntityPage extends StatefulWidget {
  EntityPage({Key? key, this.name, this.pass}) : super(key: key);
  String? name, pass;

  @override
  State<EntityPage> createState() => _EntityPageState();
}

class _EntityPageState extends State<EntityPage> {
  TextEditingController entityNameController = TextEditingController();
  final BrandingControl _brandingControl = Get.find<BrandingControl>();
  final _formKey = GlobalKey<FormState>();
  String? datas, ip;
  List<dynamic> brandingData = [];

  @override
  void initState() {
    super.initState();
    brandingFunc();
    if (kIsWeb) {
      webIp();
    }
  }

  Future<void> brandingFunc() async {
    final response = _brandingControl.brandingData;
    setState(() {
      brandingData = response;
    });
  }

  Future<void> serviceApi(String val) async {
    final service = val;
    String Url = ApiConfig.entityUrl;
    final url = Uri.parse('${Url}ProjectKey=$service');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'text/plain'
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 400) {
      String msg = 'something went wrong!';
      toaster(context, msg, red, Icons.error);
    } else {
      datas = (response.body);
      var res = datas?.trim();
      String res1 = res.toString();
      if (res1 == "0") {
        String msg = 'Invalid Key';
        toaster(context, msg, red, Icons.error);
      } else {
        final String jsonString = jsonEncode(res1);
        var decodedJson = jsonDecode(jsonString);
        Map<String, dynamic> map = jsonDecode(decodedJson);
        String result = map['ReleaseName'];
        setState(() {
          ip = result;
        });
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('ip', ip!);
        route();
      }
    }
  }

  Future<void> webIp() async {
    final prefs = await SharedPreferences.getInstance();
    String api = ApiConfig.service;
    await prefs.setString('ip', api);
  }

  void route() {
    Navigator.pushReplacement(
        context,
        PageTransition(
            ctx: context,
            inheritTheme: true,
            type: PageTransitionType.fade,
            child: Login(redirect: false)));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: mobile(),
      desktop: Scaffold(body: web()),
    );
  }

  Widget web() {
    return Login(
      un: widget.name,
      pass: widget.pass,
      redirect: false,
    );
  }

  Widget mobile() {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 35.0),
              child: Hero(
                tag: 'login',
                child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 110,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        width: 150,
                        'assets/images/loginPage.jpg',
                        fit: BoxFit.fill,
                      ),
                    )),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: SizedBox(
              height: 450,
              child: SizedBox.expand(
                child: (DraggableScrollableSheet(
                  snap: false,
                  minChildSize: 0.75,
                  initialChildSize: 0.75,
                  maxChildSize: 1.0,
                  builder: (BuildContext context,
                          ScrollController scrollController) =>
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(40),
                                topLeft: Radius.circular(40)),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 20.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    child: Text('Getting Started',
                                        style: headerStyle),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    child: Text(
                                        'Please enter your entity to explore our app',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  key(),
                                  submitBtn(110, 15.0)
                                ]),
                          )),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget logo() {
    double logoHeight = MediaQuery.of(context).size.height * 0.15;
    double logoWidth = MediaQuery.of(context).size.width / 4.0;
    return SizedBox(
        width: logoWidth,
        height: logoHeight,
        child: Center(
            child: Image.network(brandingData[0]['LoginPageClientLogoPath'])));
  }

  Widget key() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Entity Key*',
                  style: TextStyle(
                      color: secondaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ),
            SizedBox(
              height: 75,
              child: TextFormField(
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Contact your admin if you don't have the entity key";
                  } else {
                    return null;
                  }
                },
                onFieldSubmitted: (value) {
                  if (_formKey.currentState!.validate()) {
                    serviceApi(entityNameController.text.toString());
                  }
                },
                cursorColor: secondaryColor,
                controller: entityNameController,
                decoration: InputDecoration(
                  fillColor: primaryColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hoverColor: lightShade,
                  focusColor: secondaryColor,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  labelStyle: const TextStyle(color: grey100),
                  labelText: 'Enter your entity key',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget submitBtn(double val, double radius) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(val, 50),
            // maximumSize: const Size(110, 45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            primary: secondaryColor,
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              serviceApi(entityNameController.text.toString());
            }
          },
          icon: const Icon(Icons.login, size: 18),
          label: const Text("Submit"),
        ),
      ),
    );
  }
}
