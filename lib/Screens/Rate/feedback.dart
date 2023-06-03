import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../service/adminImageRegistrySelect.dart';
import '../../service/feedbakRating.dart';
import '../../service/trackView.dart';
import '../../styles/CommonSize.dart';
import '../../styles/CommonTextStyle.dart';
import '../../styles/Responsive.dart';
import '../../styles/common Color.dart';
import '../../widgets/divider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../widgets/toaster.dart';

class FeedbackScreen extends StatefulWidget {
  final dynamic getFunc;
  int? complaintIDPK;
  FeedbackScreen({Key? key, this.getFunc, this.complaintIDPK})
      : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TrackViewControl _trackViewControl = Get.find<TrackViewControl>();
  final AdminImageRegistrySelectControl _adminImageSelectControl =
      Get.find<AdminImageRegistrySelectControl>();
  List<dynamic> trackVale = [], imageData = [];
  final TextEditingController _feedbackController = TextEditingController();
  final FeedbackRating _feedbackApiRating = Get.find<FeedbackRating>();
  double rating = 0;
  final controller = CarouselController();
  int imagePageIndex = 0;
  bool submitButton=false;

  @override
  void initState() {
    feedbackView();
    super.initState();
    _feedbackController.text = trackVale[0]['CCMOccupantRemarks'];
    rating= trackVale[0]['CCMRatings']!= "" ? trackVale[0]['CCMRatings'] : 0;
    if(trackVale[0]['CCMFeedBack'] != ""){
      setState(() {
        submitButton = true;
      });
    }
  }

  Future<void> feedbackRatingFun() async {
    _feedbackApiRating.feedbackRatingApi(
        context, widget.complaintIDPK, rating, _feedbackController.text);
    if(_feedbackApiRating.status == 0){
      setState(() {
        submitButton = true;
      });
    }
  }

  Future<void> feedbackView() async {
    final response = _trackViewControl.trackViewData;
    final imageRes = _adminImageSelectControl.value;
    setState(() {
      trackVale = response;
      imageData = imageRes;
    });
  }

  void previous() =>
      controller.previousPage(duration: const Duration(milliseconds: 500));
  void next() =>
      controller.nextPage(duration: const Duration(milliseconds: 500));
  void animateToSlide(int index) => controller.animateToPage(index);

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
                                        const Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 12),
                                              child: Text(
                                                "How would you rate our Service ?",
                                                style: cardHeading,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 8.0, left: 12),
                                              child: Text(
                                                'Ratings ',
                                                style: cardHeading,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12.0, bottom: 8),
                                          child: RatingBar.builder(
                                            initialRating: 0,
                                            minRating: 0,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 4.0),
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              print(rating);
                                            },
                                          ),
                                        ),
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 8.0, left: 12),
                                              child: Text(
                                                'Feedback ',
                                                style: cardHeading,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: SizedBox(
                                                width:
                                                    displayWidth(context) * 0.8,
                                                height: displayHeight(context) *
                                                    0.2,
                                                child: TextFormField(
                                                  minLines: 6,
                                                  maxLines: 6,
                                                  decoration: InputDecoration(
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                          borderSide: BorderSide(
                                                              width: 1,
                                                              color: Colors.grey
                                                                  .shade300)),
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                          borderSide: BorderSide(
                                                              width: 1,
                                                              color: Colors.grey
                                                                  .shade300))),
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
                                                  // final img =
                                                  //     image[index]['img'].sublist(0, 4);
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 5.0),
                                                    child: SizedBox(
                                                      width: 150,
                                                      height: 50,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    8.0)),
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
                        widget.getFunc('rate', null);
                      },
                      child: const Icon(Icons.arrow_back),
                    ),
                    Text('Provide us with a feedback - (W.O.No - ${trackVale[0]['ComplaintNo'] ?? ''})', style: pageHeaderWeb),
                    Row(
                      children: [
                        Text('Status: ', style: pageHeaderWeb),
                        Chip(
                          backgroundColor: trackVale[0]['WoStatus'] == 'Open'
                              ? Colors.red.shade200
                              : trending17.withOpacity(0.5),
                          label: Text(
                            '${trackVale[0]['WoStatus'] ?? ''}',
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
            height: displayHeight(context) * 0.83,
            child: ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: displayWidth(context) * 0.35,
                      child: Column(
                        children: [
                          SizedBox(
                            width: displayWidth(context) * 0.35,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12.0),
                                      child: Text(
                                        'How would you rate our Service ?',
                                        style: tileHeaderBlack,
                                      ),
                                    ),
                                    Text(
                                      "Ratings",
                                      style: tileHeader,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12.0, bottom: 8),
                                      child: IgnorePointer(
                                        ignoring:trackVale[0]['CCMRatings'] != "" ? true:false,
                                        child: RatingBar.builder(
                                          initialRating: rating,
                                          minRating: 0,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 24,
                                          itemPadding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (val) {
                                            setState(() {
                                              rating = val;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Text('Feedback', style: tileHeader),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0),
                                      child: TextFormField(
                                        readOnly:submitButton,
                                        controller: _feedbackController,
                                        minLines: 6,
                                        maxLines: 6,
                                        decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color:
                                                        Colors.grey.shade300)),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color:
                                                        Colors.grey.shade300))),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(90, 40),
                                              maximumSize: const Size(90, 40),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              primary: secondaryColor,
                                            ),
                                            onPressed: () {
                                              if (_feedbackController
                                                  .text.isEmpty) {
                                                toaster(
                                                    context,
                                                    'Please Enter The Feedback',
                                                    trending3,
                                                    Icons.warning);
                                              } else {
                                                feedbackRatingFun();
                                              }
                                            },
                                            child: const Text('Submit'))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Serviced By',
                                    style: tileHeader,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Technician Name',
                                          style: cardTitle,
                                        ),
                                        Text(
                                          ': ${trackVale[0]['TechnicianName'] ?? ''}',
                                          style: cardSubTitle,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0),
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
                                    width: displayWidth(context) * 0.28,
                                    height: 90,
                                    child: GridView.builder(
                                      itemCount: imageData.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1,
                                      ),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: InkWell(
                                            onTap: attachPreview,
                                            child: SizedBox(
                                              width: 150,
                                              height: 50,
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(8.0)),
                                                child: imageData.isEmpty
                                                    ? const Center(
                                                        child: Icon(
                                                            Icons.image_rounded,
                                                            color:
                                                                secondaryColor))
                                                    : Image.network(
                                                        imageData[index]
                                                            ['ImgPath'],
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
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: displayWidth(context) * 0.58,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                    width: displayWidth(context) * 0.56,
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text('From Date',
                                                    style: tileHeader),
                                                const Text('*',
                                                    style:
                                                        TextStyle(color: red))
                                              ],
                                            ),
                                            Card(
                                              elevation: 2,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0)),
                                              shadowColor: Colors.grey.shade300,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Text('12.12.2023',
                                                        style: cardValue),
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8.0),
                                                      child: Icon(
                                                          Icons
                                                              .event_note_rounded,
                                                          color:
                                                              secondaryColor),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text('Time', style: tileHeader),
                                                const Text('*',
                                                    style:
                                                        TextStyle(color: red))
                                              ],
                                            ),
                                            Card(
                                              elevation: 2,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0)),
                                              shadowColor: Colors.grey.shade300,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Text('14:03:00',
                                                        style: cardValue),
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8.0),
                                                      child: Icon(
                                                          Icons
                                                              .watch_later_outlined,
                                                          color:
                                                              secondaryColor),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    )),
                              ],
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 16.0),
                                                child: Text(
                                                  "Building",
                                                  style: cardTitle,
                                                ),
                                              ),
                                              Text(
                                                "Discipline",
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
                                                ),
                                              ),
                                              Text(
                                                ": ${trackVale[0]['LocalityName'] ?? ''}",
                                                style: cardSubTitle,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 16.0),
                                                child: Text(
                                                  ":",
                                                  style: cardSubTitle,
                                                ),
                                              ),
                                              const Text(
                                                ": ",
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
                                                  "Floor",
                                                  style: cardTitle,
                                                ),
                                              ),
                                              Text(
                                                "Spot",
                                                style: cardTitle,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 16.0),
                                                child: Text(
                                                  "Division",
                                                  style: cardTitle,
                                                ),
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
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16.0),
                                                child: Text(
                                                  ": ${trackVale[0]['FloorName'] ?? ''}",
                                                  style: cardSubTitle,
                                                ),
                                              ),
                                              Text(
                                                ": ${trackVale[0]['SpotName'] ?? ''}",
                                                style: cardSubTitle,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 16.0),
                                                child: Text(
                                                  ": ${trackVale[0]['DivisionName'] ?? ''}",
                                                  style: cardSubTitle,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
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
                                            "Nature of Service Request",
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 22.0),
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
                                          Text(
                                            " ${trackVale[0]['CCMDescription'] ?? ''}",
                                            style: cardSubTitle,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 16.0),
                                                child: Text(
                                                  "E-Mail-ID",
                                                  style: cardTitle,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: displayWidth(context) * 0.18,
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
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 16.0),
                                                  child: Text(
                                                    ": ",
                                                    style: cardSubTitle,
                                                  )),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: displayWidth(context) * 0.08,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: const [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 16.0),
                                                child: Text(
                                                  "CC E-Mail-ID",
                                                  style: cardTitle,
                                                ),
                                              ),
                                              Text(
                                                "Department",
                                                style: cardTitle,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: displayWidth(context) * 0.1,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: const [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 16.0),
                                                child: Text(
                                                  ":",
                                                  style: cardSubTitle,
                                                ),
                                              ),
                                              Text(
                                                ": ",
                                                style: cardSubTitle,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
          )
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
                                                  ': ${imageData[index]['ImgType'] ??''}',
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
