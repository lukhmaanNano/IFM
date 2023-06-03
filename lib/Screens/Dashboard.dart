import 'dart:convert';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../service/advertisement.dart';
import '../service/branding.dart';
import '../service/count.dart';
import '../styles/CommonSize.dart';
import '../styles/CommonTextStyle.dart';
import '../styles/Responsive.dart';
import '../styles/common Color.dart';
import '../widgets/shimmer.dart';
import '../widgets/toaster.dart';
import 'Login/login.dart';
import 'Rate/feedback.dart';
import 'Rate/rateServiceMain.dart';
import 'ServiceRequest/serviceRequest.dart';
import 'Ticket/requestDetails.dart';
import 'Ticket/ticketRequestMain.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DraggableScrollableController scrollController =
      DraggableScrollableController();
  final AdvertisementControl _advControl = Get.find<AdvertisementControl>();
  bool _isPressed = false, profile = false, count = false;
  final CountControl _countControl = Get.find<CountControl>();
  final BrandingControl _brandingControl = Get.find<BrandingControl>();
  String? userName, pageName = 'home', ip;
  int? sessionId, comID;
  List filterList = [
        'Purchase Order No',
        'Purchase Order Date',
        'Delivery Place',
        'Reference Number',
        'Grand Total',
        'Action'
      ],
      images = [
        {
          'img': 'assets/images/ad1.jpg',
          'id': 'Header',
          'content': 'Advertisement Content'
        },
        {
          'img': 'assets/images/ad2.jpg',
          'id': 'Header',
          'content': 'Advertisement Content'
        },
        {
          'img': 'assets/images/ad3.jpg',
          'id': 'Header',
          'content': 'Advertisement Content'
        },
        {
          'img': 'assets/images/ad4.jpg',
          'id': 'Header',
          'content': 'Advertisement Content'
        },
        {
          'img': 'assets/images/ad5.jpg',
          'id': 'Header',
          'content': 'Advertisement Content'
        }
      ];
  List adData = [], brandingData = [], countData = [];

  @override
  void initState() {
    super.initState();
    local();
    countFunc();
    brandingFunc();
  }

  countFunc() async {
    final response = await _countControl.countApi(context);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final data = (json['Output']['data']);
      setState(() {
        countData = data;
      });
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
      userName = prefs.getString('UserName')!;
      sessionId = prefs.getInt('SessionId')!;
    });
    final response = await _advControl.advertisementApi(context);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final data = (json['Output']['data']);
      setState(() {
        adData = data;
      });
    }
  }

  Future<void> logOutFunction() async {
    String service = ApiConfig.service;
    String api = ApiConfig.logOutService;
    final url = Uri.parse("$service$api");
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    };
    final json = '{"data": {"SessionID": "$sessionId"}}';
    final response =
        await http.post(url, headers: headers, body: json.toString());
    if (response.statusCode == 400) {
      String err = 'something went wrong!';
      toaster(context, err, red, Icons.error);
    } else {
      final datas = jsonDecode(response.body);
      var statusVal = ('${datas['Output']['status']['code']}');
      if (statusVal == "200") {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('SessionId');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Login(
                    un: 'null',
                    pass: 'null',
                    redirect: true,
                  )),
        );
      } else {
        final datas = jsonDecode(response.body);
        String error = ('${datas['Output']['status']['code']['message']}');
        toaster(context, error, red, Icons.error);
      }
    }
  }

  void refresh(String? getString, int? val) {
    setState(() {
      pageName = getString;
      comID = val;
    });
  }

  Widget routing() {
    switch (pageName) {
      case 'dashboard':
        {
          return webDashboard();
        }
      case 'ticket':
        {
          return TicketRequestMain(getFunc: refresh);
        }
      case 'serviceRequest':
        {
          return const ServiceRequest();
        }
      case 'requestDetails':
        {
          return RequestDetails(getFunc: refresh);
        }
      case 'rate':
        {
          return RateServiceMain(getFunc: refresh);
        }
      case 'feedback':
        {
          return FeedbackScreen(
            getFunc: refresh,
            complaintIDPK: comID,
          );
        }
      default:
        {
          return webDashboard();
        }
    }
  }

  void scrollToProfile() {
    if (profile == false) {
      setState(() {
        _isPressed = false;
      });
      scrollController.animateTo(
        0.75,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      scrollController.animateTo(
        0.98,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void scrollToStatus() {
    if (count == false) {
      setState(() {
        _isPressed = true;
      });
      scrollController.animateTo(
        0.75,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      scrollController.animateTo(
        0.98,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  List unreadNumbers = ['23', '245', '5', '43'];

  @override
  Widget build(BuildContext context) {
    return Responsive(mobile: mobile(), desktop: web());
  }

  Widget mobile() {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: secondaryColor,
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 60,
        backgroundColor: secondaryColor,
        leading: const Icon(
          Icons.headset_mic_outlined,
          color: Colors.white,
          size: 40,
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/man.jpg'),
            ),
          )
        ],
        title: Text('Smart Helpdesk',
            style: GoogleFonts.ubuntu(
                textStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600))),
      ),
      body: Stack(children: [
        // renderMethod(),
        SizedBox.expand(
          child: (DraggableScrollableSheet(
            minChildSize: 0.75,
            initialChildSize: 0.98,
            maxChildSize: 0.98,
            controller: scrollController,
            builder: (BuildContext context, scrollController) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
                  color: Colors.white,
                ),
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    scrollbars: false,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30)),
                    child: Column(children: [
                      Expanded(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.84,
                          child: ListView(shrinkWrap: true, children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 36.0, left: 10),
                              child: Text(
                                'Dashboard',
                                style: cardHeading,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 10),
                              child: Card(
                                  color: Colors.white,
                                  elevation: 2,
                                  shadowColor: Colors.grey.shade300,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 39, horizontal: 23),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 76,
                                          height: 56,
                                          child: Column(
                                            children: [
                                              Text(
                                                  '${countData.isEmpty ? 0 : countData[0]['TotalRequests']}',
                                                  style: dCardHead),
                                              const Text(
                                                "Raised Requests",
                                                style: dCardContent,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 76,
                                          height: 56,
                                          child: Column(
                                            children: [
                                              Text(
                                                  '${countData.isEmpty ? 0 : countData[0]['OpenRequests']}',
                                                  style: dCardHead),
                                              const Text(
                                                "Open Requests",
                                                style: dCardContent,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 76,
                                          height: 56,
                                          child: Column(
                                            children: [
                                              Text(
                                                '${countData.isEmpty ? 0 : countData[0]['ClosedRequests']}',
                                                style: dCardHead,
                                              ),
                                              const Text(
                                                "Closed Request",
                                                style: dCardContent,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 120,
                                      child: InkWell(
                                          hoverColor: Colors.transparent,
                                          splashColor: secondaryColor,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            Get.to(const ServiceRequest());
                                          },
                                          child: submitCard()),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                      flex: 1,
                                      child: SizedBox(
                                          width: double.infinity,
                                          height: 120,
                                          child: InkWell(
                                              hoverColor: Colors.transparent,
                                              splashColor: secondaryColor,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () {
                                                Get.to(
                                                    const TicketRequestMain());
                                              },
                                              child: trackCard())))
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 120,
                                      child: InkWell(
                                          hoverColor: Colors.transparent,
                                          splashColor: secondaryColor,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            Get.to(const RateServiceMain());
                                          },
                                          child: rateCard()),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                      flex: 1,
                                      child: SizedBox(
                                          width: double.infinity,
                                          height: 120,
                                          child: InkWell(
                                              hoverColor: Colors.transparent,
                                              splashColor: secondaryColor,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () {
                                                // Navigator.push(
                                                //     context,
                                                //     PageTransition(
                                                //         ctx: context,
                                                //         inheritTheme: true,
                                                //         type: PageTransitionType
                                                //             .rightToLeftWithFade,
                                                //         child:
                                                //             const SubmitQuotation()));
                                              },
                                              child: settingsCard())))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.40,
                                width: double.infinity,
                                child: ScrollConfiguration(
                                  behavior: ScrollConfiguration.of(context)
                                      .copyWith(scrollbars: false),
                                  child: GridView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: images.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: 0.8,
                                            crossAxisCount: 1,
                                            crossAxisSpacing: 4.0),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Card(
                                        elevation: 2,
                                        shadowColor: Colors.grey.shade300,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Stack(
                                              children: [
                                                Image.asset(
                                                    images[index]['img'],
                                                    fit: BoxFit.fill),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Container(
                                                      height: 60,
                                                      width: double.infinity,
                                                      color: Colors.white,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    8.0),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Flexible(
                                                                flex: 1,
                                                                child: Text(
                                                                    images[index]
                                                                        ['id'],
                                                                    style: const TextStyle(
                                                                        color:
                                                                            black,
                                                                        fontSize:
                                                                            16))),
                                                            const SizedBox(
                                                                height: 5),
                                                            Flexible(
                                                              flex: 1,
                                                              child: Text(
                                                                  images[index][
                                                                      'content'],
                                                                  style: const TextStyle(
                                                                      color:
                                                                          grey100,
                                                                      fontSize:
                                                                          14)),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            )),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            )
                          ]),
                        ),
                      ),
                    ]),
                  ),
                )),
          )),
        ),
      ]),
    );
  }

  Widget web() {
    String name = utf8.decode(base64.decode(userName!));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: primaryColor,
            width: 50,
            height: double.infinity,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: 350,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: pageName == 'home'
                                    ? Colors.white
                                    : primaryColor,
                              ),
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      pageName = 'home';
                                    });
                                    countFunc();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(
                                      'assets/images/menuHome.svg',
                                      color: secondaryColor,
                                    ),
                                  )),
                            ),
                            const Text('Home', style: menuStyle)
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: pageName == 'serviceRequest'
                                    ? Colors.white
                                    : primaryColor,
                              ),
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      pageName = 'serviceRequest';
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(
                                      'assets/images/serviceRequest.svg',
                                      color: secondaryColor,
                                    ),
                                  )),
                            ),
                            const SizedBox(
                                width: 42,
                                child: Text('ServiceRequest', style: menuStyle))
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: pageName == 'ticket'
                                    ? Colors.white
                                    : primaryColor,
                              ),
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      pageName = 'ticket';
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(
                                      'assets/images/trackMenu.svg',
                                      color: secondaryColor,
                                    ),
                                  )),
                            ),
                            const SizedBox(
                                width: 42,
                                child: Text('Track Request', style: menuStyle))
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: pageName == 'rate'
                                    ? Colors.white
                                    : primaryColor,
                              ),
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      pageName = 'rate';
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(
                                      'assets/images/rateMenu.svg',
                                      color: secondaryColor,
                                    ),
                                  )),
                            ),
                            const SizedBox(
                                width: 42,
                                child:
                                    Text('RateOur Service', style: menuStyle))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                      height: 60,
                      child: IconButton(
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        color: secondaryColor,
                        icon: const Icon(Icons.logout),
                        onPressed: () {
                          logOutAlert();
                        },
                      )),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(
                              width: 1.0, color: Colors.grey.shade300))),
                  height: 50,
                  child: Stack(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Helpdesk',
                            style: GoogleFonts.ubuntu(
                                textStyle: const TextStyle(
                                    fontSize: 22,
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w600))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 180,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 35,
                                height: 35,
                                decoration: const BoxDecoration(
                                  color: primaryColor,
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/man.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Text(' $name',
                                  style: GoogleFonts.roboto(
                                      textStyle: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.black54,
                                          fontSize: 18,
                                          fontFamily: 'roboto',
                                          letterSpacing: 0.25,
                                          fontWeight: FontWeight.w400))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
                Expanded(child: routing()),
              ],
            ),
          )
        ],
      ),
    );
  }

  logOutAlert() {
    double passwordWidth = MediaQuery.of(context).size.width * 0.08;
    showDialog(
      context: context,
      builder: (ctx) => ElasticIn(
        child: Dialog(
          backgroundColor: primaryColor,
          elevation: 13,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SizedBox(
            height: 200,
            width: passwordWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.logout, color: secondaryColor),
                const SizedBox(height: 10),
                const Text("Confirmation !",
                    style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 0.4,
                        fontWeight: FontWeight.w300,
                        color: black)),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                  child: Text("Are you sure you want to logout",
                      style: TextStyle(
                          fontSize: 13,
                          letterSpacing: 0.3,
                          fontWeight: FontWeight.w400,
                          color: black)),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        style: const ButtonStyle(
                          overlayColor:
                              MaterialStatePropertyAll(Colors.transparent),
                        ),
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
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          primary: secondaryColor,
                        ),
                        onPressed: () {
                          logOutFunction();
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

  Widget webDashboard() {
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              height: mediaHeight * 0.20,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: mediaWidth * 0.25,
                      height: mediaHeight * 0.19,
                      child: raisedCard(),
                    ),
                    const SizedBox(width: 5),
                    SizedBox(
                        width: mediaWidth * 0.25,
                        height: mediaHeight * 0.19,
                        child: acknowledgedCard()),
                    const SizedBox(width: 5),
                    SizedBox(
                        width: mediaWidth * 0.25,
                        height: mediaHeight * 0.19,
                        child: closedCard()),
                  ],
                ),
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.54,
            width: double.infinity,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: images.isEmpty
                  ? webShimmer(double.infinity)
                  : GridView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 0.7,
                              crossAxisCount: 1,
                              crossAxisSpacing: 2.0),
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 2,
                          shadowColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Stack(
                                children: [
                                  Image.asset(images[index]['img'],
                                      fit: BoxFit.fill),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                        height: 60,
                                        width: double.infinity,
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                  flex: 1,
                                                  child: Text(
                                                      images[index]['id'],
                                                      style: const TextStyle(
                                                          color: black,
                                                          fontSize: 16))),
                                              const SizedBox(height: 5),
                                              Flexible(
                                                flex: 1,
                                                child: Text(
                                                    images[index]['content'],
                                                    style: const TextStyle(
                                                        color: grey100,
                                                        fontSize: 14)),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                ],
                              )),
                        );
                      },
                    ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                brandingData[0]['LoginFooterLogoPath'] != null
                    ? Image.network(
                        brandingData[0]['LoginFooterLogoPath'],
                        height: 50,
                        width: 100,
                      )
                    : const Icon(Icons.image),
                brandingData[0]['MenuIconLogoPath'] != null
                    ? Image.network(brandingData[0]['MenuIconLogoPath'],
                        height: 50, width: 100)
                    : const Icon(Icons.image),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget raisedCard() {
    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.grey.shade300,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 12.0, bottom: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: primaryColor,
              radius: 20,
              child: SvgPicture.asset(
                'assets/images/up-arrow.svg',
                color: secondaryColor,
                height: 28,
                width: 28,
              ),
            ),
            SizedBox(height: displayHeight(context) * 0.01),
            Text('${countData.isEmpty ? 0 : countData[0]['AllCount']}',
                style: commonRoboto),
            Text('Raised Requests', style: textInputHeader)
          ],
        ),
      ),
    );
  }

  Widget acknowledgedCard() {
    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.grey.shade300,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 12.0, bottom: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: primaryColor,
              radius: 20,
              child: SvgPicture.asset(
                'assets/images/open-source.svg',
                color: secondaryColor,
                height: 28,
                width: 28,
              ),
            ),
            SizedBox(height: displayHeight(context) * 0.01),
            Text('${countData.isEmpty ? 0 : countData[0]['OpenCount']}',
                style: commonRoboto),
            Text('Acknowledged Requests', style: textInputHeader)
          ],
        ),
      ),
    );
  }

  Widget closedCard() {
    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.grey.shade300,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 12.0, bottom: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: primaryColor,
              radius: 20,
              child: SvgPicture.asset(
                'assets/images/verify.svg',
                color: secondaryColor,
                height: 28,
                width: 28,
              ),
            ),
            SizedBox(height: displayHeight(context) * 0.01),
            Text('${countData.isEmpty ? 0 : countData[0]['ClosedCount']}',
                style: commonRoboto),
            Text('Closed Requests', style: textInputHeader)
          ],
        ),
      ),
    );
  }

  Widget submitCard() {
    final scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.grey.shade300,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 12.0, bottom: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset('assets/images/submit.svg'),
                ),
                const SizedBox(
                    width: 110,
                    child: Text('Service Request Registration',
                        style: cardHeader2)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget trackCard() {
    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.grey.shade300,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 12.0, bottom: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset('assets/images/track.svg'),
                ),
                const SizedBox(
                    width: 80,
                    child: Text('Track Request', style: cardHeader2)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget rateCard() {
    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.grey.shade300,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 12.0, bottom: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset('assets/images/rate.svg'),
                ),
                const SizedBox(
                    width: 60,
                    child: Text('Rate Our Services', style: cardHeader2)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget settingsCard() {
    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.grey.shade300,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 12.0, bottom: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: SvgPicture.asset('assets/images/setting.svg'),
                ),
                const SizedBox(
                    width: 70, child: Text('App Settings', style: cardHeader2)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
