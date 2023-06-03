import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ifm/styles/CommonSize.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../service/adminImageRegistrySelect.dart';
import '../../service/trackView.dart';
import '../../styles/CommonTextStyle.dart';
import '../../styles/Responsive.dart';
import '../../styles/common Color.dart';
import '../../widgets/divider.dart';

class RequestDetails extends StatefulWidget {
  final dynamic getFunc;
  const RequestDetails({Key? key, this.getFunc}) : super(key: key);

  @override
  State<RequestDetails> createState() => _RequestDetailsState();
}

class _RequestDetailsState extends State<RequestDetails> {
  final TrackViewControl _trackViewControl = Get.find<TrackViewControl>();
  final AdminImageRegistrySelectControl _adminImageSelectControl =
      Get.find<AdminImageRegistrySelectControl>();
  final controller = CarouselController();
  int imagePageIndex = 0;
  void previous() =>
      controller.previousPage(duration: const Duration(milliseconds: 500));
  void next() =>
      controller.nextPage(duration: const Duration(milliseconds: 500));

  List<dynamic> trackVale = [], imageData = [];
  void animateToSlide(int index) => controller.animateToPage(index);
  @override
  void initState() {
    requestDetails();
    super.initState();
  }

  Future<void> requestDetails() async {
    final response = _trackViewControl.trackViewData;
    final imageRes = _adminImageSelectControl.value;
    setState(() {
      trackVale = response;
      imageData = imageRes;
    });
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
          'Track Request',
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
                                const Text('*', style: TextStyle(color: red))
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
                                const Text('*', style: TextStyle(color: red))
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
                  SizedBox(
                    height: displayHeight(context) * 0.72,
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context)
                          .copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Card(
                                  elevation: 1,
                                  shadowColor: Colors.grey.shade50,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 8.0, bottom: 8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: const [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 8.0,
                                              ),
                                              child: Text(
                                                "Primary Details",
                                                style: cardHeading,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 8.0),
                                              child: Text(
                                                'Contract ',
                                                style: cardTitle,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: SizedBox(
                                                width: displayWidth(context) *
                                                    0.42,
                                                child: Text(
                                                  ': ',
                                                  style: cardValue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 8.0),
                                              child: Text(
                                                'Spot ',
                                                style: cardTitle,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: SizedBox(
                                                width: displayWidth(context) *
                                                    0.42,
                                                child: Text(
                                                  ': ${trackVale[0]['SpotName'] ?? ''}',
                                                  style: cardValue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 8.0),
                                              child: Text(
                                                'Location(Site)  ',
                                                style: cardTitle,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: SizedBox(
                                                width: displayWidth(context) *
                                                    0.42,
                                                child: Text(
                                                  ': ${trackVale[0]['LocalityName'] ?? ''}',
                                                  style: cardValue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 8.0),
                                              child: Text(
                                                'Division ',
                                                style: cardTitle,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: SizedBox(
                                                width: displayWidth(context) *
                                                    0.42,
                                                child: Text(
                                                  ': ${trackVale[0]['DivisionName'] ?? ''}',
                                                  style: cardValue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 8.0),
                                              child: Text(
                                                'Building ',
                                                style: cardTitle,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: SizedBox(
                                                width: displayWidth(context) *
                                                    0.42,
                                                child: Text(
                                                  ': ${trackVale[0]['BuildingNo'] ?? ''}',
                                                  style: cardValue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 8.0),
                                              child: Text(
                                                'Discipline ',
                                                style: cardTitle,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: SizedBox(
                                                width: displayWidth(context) *
                                                    0.42,
                                                child: Text(
                                                  ': ',
                                                  style: cardValue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 8.0),
                                              child: Text(
                                                'Floor ',
                                                style: cardTitle,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: SizedBox(
                                                width: displayWidth(context) *
                                                    0.42,
                                                child: Text(
                                                  ': ${trackVale[0]['FloorName'] ?? ''}',
                                                  style: cardValue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Card(
                                  elevation: 1,
                                  shadowColor: Colors.grey.shade50,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 8.0, bottom: 8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: const [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 8.0,
                                              ),
                                              child: Text(
                                                "Request Details",
                                                style: cardHeading,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 8.0),
                                              child: Text(
                                                'Nature of Service Request :',
                                                style: cardTitle,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: SizedBox(
                                                width: displayWidth(context) *
                                                    0.42,
                                                child: Text(
                                                  '${trackVale[0]['ComplaintNatureName'] ?? ''}',
                                                  style: cardValue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: const [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 8.0),
                                              child: Text(
                                                "Description",
                                                style: cardHeading,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: SizedBox(
                                                width: displayWidth(context) *
                                                    0.42,
                                                child: Text(
                                                  'DescriptionEmpty',
                                                  style: cardValue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Card(
                                  elevation: 1,
                                  shadowColor: Colors.grey.shade50,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 8.0, bottom: 8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: const [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 8.0,
                                              ),
                                              child: Text(
                                                "Request By",
                                                style: cardHeading,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 8.0),
                                              child: Text(
                                                'Name ',
                                                style: cardTitle,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: SizedBox(
                                                width: displayWidth(context) *
                                                    0.42,
                                                child: Text(
                                                  ': ',
                                                  style: cardValue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 8.0),
                                              child: Text(
                                                'Contact No ',
                                                style: cardTitle,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: SizedBox(
                                                width: displayWidth(context) *
                                                    0.42,
                                                child: Text(
                                                  ': ',
                                                  style: cardValue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 8.0),
                                              child: Text(
                                                'E-Mail-ID  ',
                                                style: cardTitle,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: SizedBox(
                                                width: displayWidth(context) *
                                                    0.42,
                                                child: Text(
                                                  ': ',
                                                  style: cardValue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 8.0),
                                              child: Text(
                                                'CC E-Mail-ID ',
                                                style: cardTitle,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: SizedBox(
                                                width: displayWidth(context) *
                                                    0.42,
                                                child: Text(
                                                  ': ',
                                                  style: cardValue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 8.0),
                                              child: Text(
                                                'Department ',
                                                style: cardTitle,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: SizedBox(
                                                width: displayWidth(context) *
                                                    0.42,
                                                child: Text(
                                                  ': ',
                                                  style: cardValue,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: const [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 8.0,
                                              ),
                                              child: Text(
                                                "Attachment",
                                                style: cardHeading,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width:
                                                  displayWidth(context) * 0.28,
                                              height: 90,
                                              child: GridView.builder(
                                                itemCount: imageData.length,
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 1,
                                                ),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 5.0),
                                                    child: Container(
                                                      width: 150,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1,
                                                            color:
                                                                secondaryColor),
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    12)),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    12.0)),
                                                        child: imageData.isEmpty
                                                            ? Image.network(
                                                                imageData[index]
                                                                    ['ImgPath'],
                                                                fit:
                                                                    BoxFit.fill,
                                                              )
                                                            : const Center(
                                                                child: Icon(
                                                                    Icons
                                                                        .image_rounded,
                                                                    color:
                                                                        secondaryColor)),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        widget.getFunc('ticket', null);
                      },
                      child: const Icon(Icons.arrow_back),
                    ),
                    Text('Request Details - (W.O.No - ${trackVale[0]['ComplaintNo'] ?? ''})', style: pageHeaderWeb),
                    Row(
                      children: [
                        Text('Status: ', style: pageHeaderWeb),
                        Chip(
                          backgroundColor: trackVale[0]['WoStatus'] == 'Open'
                              ? Colors.red.shade200
                              : trending17.withOpacity(0.5),
                          label: Text(
                            "${trackVale[0]['WoStatus'] ?? ''}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: displayHeight(context) * 0.84,
            child: ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('From Date', style: tileHeader),
                                    const Text('*',
                                        style: TextStyle(color: red))
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Icon(Icons.event_note_rounded,
                                              color: secondaryColor),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('Time', style: tileHeader),
                                    const Text('*',
                                        style: TextStyle(color: red))
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Icon(
                                              Icons.watch_later_outlined,
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
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Primary Details",
                                  style: tileHeader,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: displayWidth(context) * 0.08,
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        child: Text(
                                          "Contract",
                                          style: cardTitle,
                                        ),
                                      ),
                                      Text(
                                        "Location(Site)",
                                        style: cardTitle,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: displayWidth(context) * 0.16,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          child: Text(
                                            ":",
                                            style: cardSubTitle,
                                          )),
                                      Text(
                                        ": ${trackVale[0]['LocalityName'] ?? ''}",
                                        style: cardSubTitle,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: displayWidth(context) * 0.08,
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        child: Text(
                                          "Building",
                                          style: cardTitle,
                                        ),
                                      ),
                                      Text(
                                        "Floor",
                                        style: cardTitle,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: displayWidth(context) * 0.16,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          child: Text(
                                            ": ",
                                            style: cardSubTitle,
                                          )),
                                      Text(
                                        ": ${trackVale[0]['FloorName'] ?? ''}",
                                        style: cardSubTitle,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: displayWidth(context) * 0.08,
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        child: Text(
                                          "Spot",
                                          style: cardTitle,
                                        ),
                                      ),
                                      Text(
                                        "Division",
                                        style: cardTitle,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: displayWidth(context) * 0.15,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          child: Text(
                                            ": ${trackVale[0]['SpotName'] ?? ''}",
                                            style: cardSubTitle,
                                          )),
                                      Text(
                                        ": ${trackVale[0]['DivisionName'] ?? ''}",
                                        style: cardSubTitle,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: displayWidth(context) * 0.08,
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        child: Text(
                                          "Discipline",
                                          style: cardTitle,
                                        ),
                                      ),
                                      Text(
                                        "",
                                        style: cardTitle,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: displayWidth(context) * 0.1,
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          child: Text(
                                            ":",
                                            style: cardSubTitle,
                                          )),
                                      Text(
                                        "",
                                        style: cardSubTitle,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Request Details",
                                  style: tileHeader,
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 22.0),
                              child: Row(
                                children: [
                                  const Text(
                                    "Nature of Service Request  ",
                                    style: cardTitle,
                                  ),
                                  Text(
                                    ": ${trackVale[0]['ComplaintNatureName'] ?? ''}",
                                    style: cardSubTitle,
                                  )
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 22.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Description",
                                    style: cardTitle,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: SizedBox(
                                      width: displayWidth(context) * 0.4,
                                      child: Text(
                                        " ${trackVale[0]['CCMDescription'] ?? ''}",
                                        style: cardSubTitle,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Requested By",
                                  style: tileHeader,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: displayWidth(context) * 0.08,
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        child: Text(
                                          "Requested By",
                                          style: cardTitle,
                                        ),
                                      ),
                                      Text(
                                        "Contact No",
                                        style: cardTitle,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: displayWidth(context) * 0.16,
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          child: Text(
                                            ":",
                                            style: cardSubTitle,
                                          )),
                                      Text(
                                        ":",
                                        style: cardSubTitle,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: displayWidth(context) * 0.08,
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        child: Text(
                                          "E-Mail-ID",
                                          style: cardTitle,
                                        ),
                                      ),
                                      Text(
                                        "CC E-Mail-ID",
                                        style: cardTitle,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: displayWidth(context) * 0.25,
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          child: Text(
                                            ":",
                                            style: cardSubTitle,
                                          )),
                                      Text(
                                        ":",
                                        style: cardSubTitle,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: displayWidth(context) * 0.08,
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        child: Text(
                                          "Department",
                                          style: cardTitle,
                                        ),
                                      ),
                                      Text(
                                        "",
                                        style: cardTitle,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: displayWidth(context) * 0.15,
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16.0),
                                          child: Text(
                                            ": ",
                                            style: cardSubTitle,
                                          )),
                                      Text(
                                        "",
                                        style: cardSubTitle,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Attachment",
                                    style: tileHeader,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 90,
                              child: GridView.builder(
                                itemCount: imageData.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: InkWell(
                                      onTap: attachPreview,
                                      child: Container(
                                        width: 150,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: secondaryColor),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12.0)),
                                          child: imageData.isEmpty
                                              ? const Center(
                                                  child: Icon(
                                                      Icons.image_rounded,
                                                      color: secondaryColor))
                                              : Image.network(
                                                  imageData[index]['ImgPath']
                                                ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  attachPreview() {
    showDialog(
        context: context,
        builder: (ctx) => ElasticIn(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Dialog(
                    elevation: 13,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                const Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.collections,
                                        color: Colors.white,
                                        size: 19,
                                      ),
                                      SizedBox(width: 10),
                                      Text('Attachment Details',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
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
                                        color: Colors.white, size: 19),
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                  ),
                                ),
                              ],
                            )),
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            width: double.infinity,
                            child: CarouselSlider.builder(
                              carouselController: controller,
                              options: CarouselOptions(
                                  viewportFraction: 1,
                                  enableInfiniteScroll: false,
                                  // height: 500,
                                  enlargeCenterPage: true,
                                  onPageChanged: (index, reason) => {
                                        setState(() => imagePageIndex = index),
                                      }),
                              itemCount: imageData.length,
                              itemBuilder: (context, index, realIndex) {
                                final img = imageData[index]['ImgPath'];
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, top: 8.0, bottom: 8.0),
                                      child: Row(
                                        children: [
                                          const Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Attachment Name',
                                                  style: cardBody),
                                              Text('Attachment Type',
                                                  style: cardBody),
                                              Text('Remarks', style: cardBody),
                                            ],
                                          ),
                                          const SizedBox(width: 20),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  ': ${imageData[index]['ImageName'] ?? ''}',
                                                  style: tableCardTextLeft),
                                              Text(
                                                  ': ${imageData[index]['ImgType'] ?? ''}',
                                                  style: tableCardTextLeft),
                                              Text(
                                                  ': ${imageData[index]['Remarks'] ?? ''}',
                                                  style: tableCardTextLeft),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: [
                                          IconButton(
                                              color: Colors.grey,
                                              hoverColor: Colors.transparent,
                                              onPressed: previous,
                                              icon: const Icon(
                                                  Icons.chevron_left)),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Image.network(
                                                  img,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                              hoverColor: Colors.transparent,
                                              color: Colors.grey,
                                              onPressed: next,
                                              icon: const Icon(
                                                  Icons.navigate_next)),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: AnimatedSmoothIndicator(
                              onDotClicked: animateToSlide,
                              effect: ExpandingDotsEffect(
                                  activeDotColor: trending10,
                                  dotColor: Colors.grey.shade300),
                              activeIndex: imagePageIndex,
                              count: imageData.length),
                        )
                      ],
                    ),
                  );
                },
              ),
            ));
  }
}
