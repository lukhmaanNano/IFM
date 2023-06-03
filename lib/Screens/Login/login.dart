import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:ifm/Screens/Login/registerScreen.dart';
import 'package:ifm/styles/CommonSize.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config.dart';
import '../../service/branding.dart';
import '../../service/loginService.dart';
import '../../styles/CommonTextStyle.dart';
import '../../styles/Responsive.dart';
import '../../styles/common Color.dart';
import '../../widgets/snackBar.dart';
import '../../widgets/toaster.dart';
import '../Dashboard.dart';
import 'forgotPassword.dart';

class Login extends StatefulWidget {
  String? un, pass;
  bool redirect;
  Login({Key? key, this.un, this.pass, required this.redirect})
      : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final BrandingControl _brandingControl = Get.find<BrandingControl>();
  final LoginController _loginControl = Get.find<LoginController>();
  final _formKey = GlobalKey<FormState>();
  String? ip;
  bool _isObscure = true, remember = false;
  List<dynamic> brandingData = [];

  @override
  void initState() {
    super.initState();
    brandingFunc();
    local();
    directLogin(widget.un!, widget.pass);
    if (widget.redirect == true) {
      html.window.open('http://adibv5.smartfmb2c.com/login.php', '_self');
    }
  }

  Future<void> brandingFunc() async {
    final response = _brandingControl.brandingData;
    setState(() {
      brandingData = response;
    });
  }

  Future<void> local() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      ip = prefs.getString('ip');
    });
  }

  Future<void> login(String userName, password) async {
    final response = await _loginControl.loginApi(context, userName, password);
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
      String val = ('Success');
      StackDialog.show(val, 'You are successfully logged in',
          Icons.verified_outlined, trending4);
    } else {
      // user already logged in
      _loginControl.loggedID;
    }
  }

  directLogin(String userName, password) async {
    if (userName != 'null') {
      String service = ApiConfig.service;
      String api = ApiConfig.loginService;
      // final url = Uri.parse('$service$api');
      final url = Uri.parse('$service$api');
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };
      final json =
          '{"data": {"username": "$userName","password": "$password","type": "WebPortal","ServcerIP": "","AppCategoryID": "1","LoginType": "login"}}';
      final response =
          await http.post(url, headers: headers, body: json.toString());
      final value = jsonDecode(response.body);
      if (response.statusCode == 400) {
        String err = 'something went wrong!';
        StackDialog.show(err, 'Please check the network', Icons.error, red);
      }
      if ('${value['Output']['status']['code']}' == '400') {
        String error = ('Invalid UserName are Password');
        StackDialog.show(error, 'Please check', Icons.error, red);
      }
      if ('${value['Output']['status']['message']}' ==
          'User already logged in') {
        String loggedID = (value['Output']['error']['data']);
      }
      if (response.statusCode == 200) {
        String name = ('${value['Output']['data']['username']}');
        String password = ('${value['Output']['data']['password']}');
        int userID = (value['Output']['data']['userid']);
        int userGroupID = (value['Output']['data']['UserGroupID']);
        int sessionId = (value['Output']['data']['sessionid']);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('UserName', name);
        await prefs.setString('Password', password);
        await prefs.setInt('UserID', userID);
        await prefs.setInt('UserGroupID', userGroupID);
        await prefs.setInt('SessionId', sessionId);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
        String val = ('Success');
        StackDialog.show(val, 'You are successfully logged in',
            Icons.verified_outlined, trending4);
        return response;
      } else {
        throw Exception('Error');
      }
    } else {
      throw Exception('Login Service');
    }
  }

  sessionAlert(alreadyLoggedUserID) {
    double passwordWidth = MediaQuery.of(context).size.width * 0.2;
    showDialog(
      context: context,
      builder: (ctx) => ElasticIn(
        child: Dialog(
          elevation: 13,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            height: 150,
            width: passwordWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    decoration: const BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0))),
                    width: double.infinity,
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.person_remove,
                                color: Colors.white,
                                size: 15,
                              ),
                              SizedBox(width: 10),
                              Text('Remove Session',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: IconButton(
                            hoverColor: primaryColor,
                            splashRadius: 16,
                            icon: const Icon(Icons.close_rounded,
                                color: Colors.white, size: 15),
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                          ),
                        ),
                      ],
                    )),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                  child: Text("Do You Want Remove A Session",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: secondaryColor)),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          Navigator.of(ctx).pop();
                        },
                        child: const Text("No",
                            style: TextStyle(color: secondaryColor)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(90, 40),
                          maximumSize: const Size(90, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          primary: secondaryColor,
                        ),
                        onPressed: () {
                          removeSession(alreadyLoggedUserID);
                          Navigator.of(ctx).pop();
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  removeSession(alreadyLoggedUserID) async {
    String ip = 'http://13.235.45.82:5020/';
    String URL = 'NewCommonSelect_API/';
    final url = Uri.parse('$ip$URL');
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    final json =
        '{"data": {"p1": $alreadyLoggedUserID,"p2": null,"p3": null,"p4": null,"p5": null,"p6": null,"p7": null,"p8": null,"p9": null,"p10": null,"PageIndex_int": 1,"PageSize_int": 10,"Type_varchar": "USERSESSIONREMOVE","UserGroupKey": null,"UserAccessKey": null}}';

    final response =
        await http.post(url, headers: headers, body: json.toString());

    if (response.statusCode == 400) {
      String Err = 'something went wrong!';
      toaster(context, Err, red, Icons.error);
    } else {
      final datas = jsonDecode(response.body);
      successAlert();
    }
  }

  successAlert() {
    var snackBar = SnackBar(
        backgroundColor: Colors.white,
        content: Row(
          children: [
            SizedBox(
                height: 60,
                width: 100,
                child: Image.asset('assets/images/success1.gif')),
            const Text('Session Removed Successfully!',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w600)),
          ],
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: mobile(),
      desktop: Scaffold(body: webView()),
    );
  }

  Widget mobile() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: primaryColor,
        ),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, left: 16.0, right: 16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 180,
                            child: Center(
                                child: Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 60,
                                    child: Image.asset(
                                      width: 100,
                                      'assets/images/loginPage.jpg',
                                      fit: BoxFit.fill,
                                    )),
                                const Text('Welcome', style: headerStyle),
                                const Text('Login to your account',
                                    style: secondaryHeader)
                              ],
                            )),
                          ),
                          userName(Colors.white),
                          password(Colors.white),
                          const SizedBox(height: 10),
                          forgotBtn(),
                          Align(
                              alignment: Alignment.centerRight,
                              child: loginBtn(110, 15.0)),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset('assets/images/lognano.png'),
                      Image.asset('assets/images/logosmart.png'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget webView() {
    return Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: brandingData[0]['WebLoginSlide1Path'] != null
              ? DecorationImage(
                  image: NetworkImage(brandingData[0]['WebLoginSlide1Path']),
                  fit: BoxFit.fill,
                )
              : const DecorationImage(
                  image: AssetImage('assets/images/loginScreen.png')),
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
                          child: brandingData[0]['WebLoginSlide1Path'] != null
                              ? FittedBox(
                                  fit: BoxFit.fill,
                                  child: Image.network(
                                      brandingData[0]['WebLoginSlide1Path']),
                                )
                              : const Icon(Icons.image),
                        )),
                  ),
                  SizedBox(width: displayWidth(context) * 0.05),
                  SizedBox(
                    width: displayWidth(context) * 0.28,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 25),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: displayWidth(context) / 4.0,
                                height: displayHeight(context) * 0.15,
                                child: Center(
                                    child: brandingData[0]
                                                ['LoginPageClientLogoPath'] !=
                                            null
                                        ? Image.network(brandingData[0]
                                            ['LoginPageClientLogoPath'])
                                        : const Icon(Icons.image))),
                            Text('Welcome', style: styledHeader),
                            const Text('Login to your account',
                                style: secondaryHeader),
                            const SizedBox(height: 10),
                            userName(primaryColor),
                            password(primaryColor),
                            forgotBtn(),
                            loginBtn(double.infinity, 8.0),
                            register(),
                            detailsBox()
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget userName(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Username', style: inputHeader),
        ),
        TextFormField(
          // inputFormatters: [
          //   FilteringTextInputFormatter.allow(
          //     RegExp(r"[a-zA-Z]+|\s"),
          //   )
          // ],
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return "Username should not be empty";
            } else {
              return null;
            }
          },
          cursorColor: secondaryColor,
          controller: userNameController,
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
            labelText: 'Enter your username',
            suffixIcon: const Icon(Icons.person, color: grey100),
          ),
        ),
      ],
    );
  }

  Widget password(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Password', style: inputHeader),
        ),
        TextFormField(
          validator: (String? value) {
            if (value != null && value.isEmpty) {
              return "Password should not be empty";
            } else {
              return null;
            }
          },
          onFieldSubmitted: (value) {
            if (_formKey.currentState!.validate()) {
              login(userNameController.text.toString(),
                  passwordController.text.toString());
            }
          },
          cursorColor: secondaryColor,
          controller: passwordController,
          obscureText: _isObscure,
          decoration: InputDecoration(
            fillColor: color,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            hoverColor: lightShade,
            filled: true,
            focusColor: secondaryColor,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            labelText: 'Enter your password.',
            labelStyle: const TextStyle(color: grey100),
            suffixIcon: IconButton(
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.white,
              splashColor: Colors.transparent,
              icon: Icon(
                _isObscure ? Icons.visibility_off : Icons.visibility,
                color: grey100,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });

                setState(() {
                  _isObscure;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget forgotBtn() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: Checkbox(
                    value: remember,
                    onChanged: (value) => setState(() {
                          remember = !remember;
                        })),
              ),
              Text('Remember Me',
                  style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                      overflow: TextOverflow.clip,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        Flexible(
          flex: 2,
          child: TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        ctx: context,
                        inheritTheme: true,
                        type: PageTransitionType.fade,
                        child: const ForgotPassword()));
              },
              child: const Text('Forgot Password',
                  style: TextStyle(
                      color: secondaryColor, fontWeight: FontWeight.w600))),
        ),
      ],
    );
  }

  Widget loginBtn(double val, double radius) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(val, 45),
          // maximumSize: const Size(110, 45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          primary: secondaryColor,
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            login(userNameController.text.toString(),
                passwordController.text.toString());
          }
        },
        icon: const Icon(Icons.login, size: 18),
        label: const Text("Login"),
      ),
    );
  }

  Widget register() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Don’t have a account ?', style: txtBtn1),
          InkWell(
              onTap: () => Get.to(const RegisterScreen()),
              child: const Text('Register', style: textBtn))
        ],
      ),
    );
  }

  Widget detailsBox() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            // width:90,
            height: 42,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Contact Us",
                  style: styledHeading,
                ),
                Text(
                  "${brandingData[0]['WMContactNo1'] ?? ''}",
                  style: cardValue,
                )
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                border: Border(
              right: BorderSide(color: Colors.grey, width: 1),
              left: BorderSide(color: Colors.grey, width: 1),
            )),
            // width:90,
            height: 42,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Email Us ",
                    style: styledHeading,
                  ),
                  Text(
                    '${brandingData[0]['WMEmailAddress1'] ?? ''}',
                    style: cardValue,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            // width:90,
            height: 42,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Timing",
                  style: styledHeading,
                ),
                Text(
                  '${brandingData[0]['WorkingHours'] ?? '__'}',
                  style: cardValue,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
