import 'dart:convert';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:number_paginator/number_paginator.dart';
import '../../service/adminImageRegistrySelect.dart';
import '../../service/trackTable.dart';
import '../../service/trackView.dart';
import '../../styles/CommonSize.dart';
import '../../styles/CommonTextStyle.dart';
import '../../styles/Responsive.dart';
import '../../styles/common Color.dart';
import '../../widgets/divider.dart';
import '../../widgets/mobileShimmer.dart';
import '../../widgets/shimmer.dart';
import 'feedback.dart';

class RateServiceMain extends StatefulWidget {
  final dynamic getFunc;
  const RateServiceMain({Key? key, this.getFunc}) : super(key: key);

  @override
  State<RateServiceMain> createState() => _RateServiceMainState();
}

class _RateServiceMainState extends State<RateServiceMain> {
  ScrollController draggableController = ScrollController();
  ScrollController draggableController1 = ScrollController();
  int? complaintIDPK;
  List trackData = [];
  int rowPerPage = 10, pageIndex = 1, initialPage = 0;
  DateTime selectedFromDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime selectedToDate = DateTime.now();
  final TrackTableControl _trackControl = Get.find<TrackTableControl>();
  final TrackViewControl _trackViewControl = Get.find<TrackViewControl>();
  final AdminImageRegistrySelectControl _adminImageSelectControl =
      Get.find<AdminImageRegistrySelectControl>();

  @override
  void initState() {
    draggableController1.addListener(() {
      if (draggableController1.offset != draggableController.offset) {
        draggableController.jumpTo(draggableController1.offset);
      }
    });
    rateFunc();
    super.initState();
  }

  rateFunc() async {
    final response = await _trackControl.trackTableApi(
        context, rowPerPage, pageIndex, 10, '', '');
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final data = (json['Output']['data']);
      setState(() {
        trackData = data;
      });
    }
  }

  dateFun(String? val) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: secondaryColor,
              onPrimary: buttonForeground,
              onSurface: secondaryColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: secondaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (val == "from") {
        setState(() {
          selectedFromDate = picked;
        });
      } else {
        setState(() {
          selectedToDate = picked;
        });
      }
    }
  }

  void feedbackFun(int? val) async {
    setState(() {
      complaintIDPK = val;
    });
    final response =
        await _trackViewControl.trackViewApi(context, complaintIDPK);
    await _adminImageSelectControl.adminImageSelectApi(context, complaintIDPK);

    if (response.statusCode == 200) {
      if (kIsWeb) {
        widget.getFunc('feedback', complaintIDPK);
      } else {
        Get.to(FeedbackScreen(complaintIDPK: complaintIDPK));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(mobile: mobile(), desktop: web());
  }

  Widget mobile() {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: secondaryColor,
        centerTitle: true,
        leading: IconButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(primaryColor),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            color: primaryColor,
            Icons.arrow_back,
            size: 30,
          ),
        ),
        title: const Text(
          'Rate Our Services',
          style: appBar,
        ),
      ),
      body: DraggableScrollableSheet(
        snap: false,
        minChildSize: 0.75,
        initialChildSize: 1,
        maxChildSize: 1.0,
        builder: (BuildContext context, ScrollController scrollController) =>
            Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
                  color: Colors.white,
                ),
                child: Column(children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 25.0),
                    child: DividerWidget(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Date', style: tileHeader),
                                const Text('', style: TextStyle(color: red))
                              ],
                            ),
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              shadowColor: Colors.grey.shade300,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text('12.12.2023', style: cardValue),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Icon(Icons.event_note_rounded,
                                          color: secondaryColor),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Time', style: tileHeader),
                                const Text('', style: TextStyle(color: red))
                              ],
                            ),
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              shadowColor: Colors.grey.shade300,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text('14:03:00', style: cardValue),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Icon(Icons.schedule_rounded,
                                          color: secondaryColor),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const DividerWidget(),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.72,
                      width: double.infinity,
                      child: trackData.isEmpty
                          ? mobileShimmer(300)
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: trackData.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: SizedBox(
                                    height: 120,
                                    width: double.infinity,
                                    child: InkWell(
                                      onTap: () {
                                        feedbackFun;
                                      },
                                      child: Card(
                                          elevation: 1,
                                          shadowColor: Colors.grey.shade50,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0,
                                                left: 8.0,
                                                bottom: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: const [
                                                    Text('Date & Time',
                                                        style: cardTitle),
                                                    Text('W.O.No',
                                                        style: cardTitle),
                                                    Text('Priority',
                                                        style: cardTitle),
                                                    Text('Progress',
                                                        style: cardTitle),
                                                  ],
                                                ),
                                                const SizedBox(width: 25),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      ': ${trackData[index]['ComplainedDateTime'] ?? ''}',
                                                      style: cardValue,
                                                    ),
                                                    Text(
                                                      ': ${trackData[index]['ComplaintNo'] ?? ''}',
                                                      style: cardValue,
                                                    ),
                                                    Text(
                                                      ': ${trackData[index]['PriorityName'] ?? ''}',
                                                      style: cardValue,
                                                    ),
                                                    Text(
                                                      ': ${trackData[index]['FloorName'] ?? ''}',
                                                      style: cardValue,
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Color(
                                                              0xff149200)),
                                                  width: 38,
                                                  height: 16,
                                                  child: Center(
                                                    child: Text(
                                                      '${trackData[index]['WoStatus'] ?? ''}',
                                                      style: columnStyle,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                    ),
                                  ),
                                );
                              }),
                    ),
                  )
                ])),
      ),
    );
  }

  Widget web() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 45,
            child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                shadowColor: Colors.grey.shade300,
                color: primaryColor,
                child: Center(
                    child: Text('Rate Our Service', style: pageHeaderWeb))),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [fromDate(), toDate(), searchBtn(), search()],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                color: primaryColor,
              ),
              height: 35,
              // width: displayWidth(context) * 1.04,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 67, child: Text('Action', style: tileHeader)),
                    SizedBox(
                        width: displayWidth(context) * 0.05,
                        child: Text('Status', style: tileHeader)),
                    SizedBox(
                        width: displayWidth(context) * 0.07,
                        child: Text('Date & Time', style: tileHeader)),
                    SizedBox(
                        width: displayWidth(context) * 0.06,
                        child: Text('ETA', style: tileHeader)),
                    SizedBox(
                        width: displayWidth(context) * 0.09,
                        child: Text('W.O.No', style: tileHeader)),
                    SizedBox(
                        width: displayWidth(context) * 0.18,
                        child: Text('Nature Of Service Request',
                            style: tileHeader)),
                    SizedBox(
                        width: displayWidth(context) * 0.13,
                        child: Text('Description', style: tileHeader)),
                    SizedBox(
                        width: displayWidth(context) * 0.11,
                        child: Text('Location(Site)', style: tileHeader)),
                    SizedBox(
                        width: displayWidth(context) * 0.08,
                        child: Text('Building', style: tileHeader)),
                    SizedBox(
                        width: displayWidth(context) * 0.08,
                        child: Text('Priority', style: tileHeader)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.68,
                // width: MediaQuery.of(context).size.width * 1.04,
                child: trackData.isEmpty
                    ? webShimmer(double.infinity)
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: trackData.length,
                        itemBuilder: (BuildContext Context, index) {
                          return ElasticInRight(
                              child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0, vertical: 12.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 40,
                                          child: InkWell(
                                            onTap: () {
                                              feedbackFun(trackData[index]
                                                  ['ComplaintIDPK']);
                                            },
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            child: const Icon(
                                                Icons.remove_red_eye,
                                                size: 14,
                                                color: secondaryColor),
                                          ),
                                        ),
                                        SizedBox(
                                          width: displayWidth(context) * 0.07,
                                          child: Chip(
                                            backgroundColor: trackData[index]
                                                        ['WoStatus'] ==
                                                    'Open'
                                                ? Colors.red.shade200
                                                : trending17.withOpacity(0.5),
                                            label: Text(
                                              '${trackData[index]['WoStatus'] ?? ''}',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: displayWidth(context) * 0.06,
                                          child: Text(
                                            '${trackData[index]['ComplainedDateTime'] ?? ''}',
                                            style: cardValue,
                                          ),
                                        ),
                                        SizedBox(
                                          width: displayWidth(context) * 0.06,
                                          child: Text(
                                            '${trackData[index]['ETADate'] ?? ''}',
                                            style: cardValue,
                                          ),
                                        ),
                                        SizedBox(
                                          width: displayWidth(context) * 0.09,
                                          child: Text(
                                            '${trackData[index]['ComplaintNo'] ?? ''}',
                                            style: cardValue,
                                          ),
                                        ),
                                        SizedBox(
                                          width: displayWidth(context) * 0.12,
                                          child: Text(
                                            '${trackData[index]['ComplaintNatureName'] ?? ''}',
                                            style: cardValue,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 220,
                                          child: Text(
                                            '${trackData[index]['CCMDescription'] ?? ''}',
                                            style: cardValue,
                                          ),
                                        ),
                                        const SizedBox(width: 40),
                                        SizedBox(
                                          width: displayWidth(context) * 0.11,
                                          child: Text(
                                            '${trackData[index]['LocalityName'] ?? ''}',
                                            style: cardValue,
                                          ),
                                        ),
                                        SizedBox(
                                          width: displayWidth(context) * 0.08,
                                          child: Text(
                                            '${trackData[index]['BuildingName'] ?? ''}',
                                            style: cardValue,
                                          ),
                                        ),
                                        SizedBox(
                                          width: displayWidth(context) * 0.07,
                                          child: Text(
                                            '${trackData[index]['PriorityName'] ?? ''}',
                                            style: cardValue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )));
                        }),
              ),
            ),
          ),
          Container(
            color: primaryColor,
            height: 35,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                PopupMenuButton(
                  constraints:
                      const BoxConstraints.expand(width: 55, height: 200),
                  child: Row(
                    children: [
                      Text('Row Per Page ', style: tileHeader),
                      const Icon(Icons.arrow_drop_down, color: secondaryColor),
                      if (trackData.isNotEmpty)
                        Text('$rowPerPage/${trackData[0]['TotalCount'] ?? 0}',
                            style: const TextStyle(color: Colors.black)),
                      if (trackData.isEmpty)
                        Text('$rowPerPage/ No Record ',
                            style: const TextStyle(color: Colors.black)),
                    ],
                  ),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem(
                        child: const Text('10', style: cardBody),
                        onTap: () => {
                              setState(() {
                                rowPerPage = 10;
                              }),
                              rateFunc()
                            }),
                    PopupMenuItem(
                        child: const Text('20', style: cardBody),
                        onTap: () => {
                              setState(() {
                                rowPerPage = 20;
                              }),
                              rateFunc()
                            }),
                    PopupMenuItem(
                        child: const Text('50', style: cardBody),
                        onTap: () => {
                              setState(() {
                                rowPerPage = 50;
                              }),
                              rateFunc()
                            }),
                    PopupMenuItem(
                        child: const Text('100', style: cardBody),
                        onTap: () => {
                              setState(() {
                                rowPerPage = 100;
                              }),
                              rateFunc()
                            }),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SizedBox(
                      height: 45,
                      width: displayWidth(context) * 0.25,
                      child: NumberPaginator(
                        numberPages: 10,
                        onPageChange: (int index) {
                          setState(() {
                            pageIndex = index;
                          });
                          if (pageIndex != 0) {
                            pageIndex++;
                          } else {
                            pageIndex = 1;
                          }
                          rateFunc();
                        },
                        initialPage: initialPage,
                        config: NumberPaginatorUIConfig(
                          buttonSelectedForegroundColor: Colors.white,
                          buttonUnselectedForegroundColor: secondaryColor,
                          buttonSelectedBackgroundColor: secondaryColor,
                          buttonShape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget fromDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('From', style: tileHeader),
            const Text('*', style: TextStyle(color: red))
          ],
        ),
        InkWell(
          onTap: () {
            dateFun("from");
          },
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            shadowColor: Colors.grey.shade300,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(DateFormat('dd/MM/yyyy').format(selectedFromDate),
                      style: cardValue),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child:
                        Icon(Icons.event_note_rounded, color: secondaryColor),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget toDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('To', style: tileHeader),
            const Text('*', style: TextStyle(color: red))
          ],
        ),
        InkWell(
          onTap: () {
            dateFun("to");
          },
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            shadowColor: Colors.grey.shade300,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(DateFormat('dd/MM/yyyy').format(selectedToDate),
                      style: cardValue),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child:
                        Icon(Icons.event_note_rounded, color: secondaryColor),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget searchBtn() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 6.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(140, 45),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          primary: secondaryColor,
        ),
        onPressed: () {},
        icon: const Icon(Icons.search),
        label: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text("Search", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget search() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: SizedBox(
        height: 45,
        width: 350,
        child: Container(
            decoration: const BoxDecoration(
                color: Color(0xffAAAAAA),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            padding: const EdgeInsets.all(4.5),
            child: Container(
              padding: EdgeInsets.zero,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white, blurRadius: 10, spreadRadius: 10)
                  ]),
              width: double.infinity,
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Center(
                      child: Icon(
                        Icons.search,
                        size: 25,
                        color: grey100,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 7.0, left: 8.0),
                      child: TextFormField(
                        inputFormatters: [LengthLimitingTextInputFormatter(80)],
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: grey100),
                          border: InputBorder.none,
                          hintText: 'Search',
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
