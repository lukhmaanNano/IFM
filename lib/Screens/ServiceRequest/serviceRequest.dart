import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../service/adminImageRegistry.dart';
import '../../service/asset.dart';
import '../../service/building.dart';
import '../../service/contract.dart';
import '../../service/department.dart';
import '../../service/discipline.dart';
import '../../service/division.dart';
import '../../service/floor.dart';
import '../../service/getxListener.dart';
import '../../service/location.dart';
import '../../service/name.dart';
import '../../service/natureOfComplaint.dart';
import '../../service/registerSave.dart';
import '../../service/servicePageInitState.dart';
import '../../service/serviceRequest.dart';
import '../../service/spot.dart';
import '../../styles/CommonSize.dart';
import '../../styles/CommonTextStyle.dart';
import '../../styles/Responsive.dart';
import '../../styles/common Color.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../../styles/entryDropDownStyles.dart';
import '../../widgets/divider.dart';
import '../../widgets/snackBar.dart';
import '../../widgets/toaster.dart';

class ServiceRequest extends StatefulWidget {
  const ServiceRequest({Key? key}) : super(key: key);

  @override
  State<ServiceRequest> createState() => _ServiceRequestState();
}

class _ServiceRequestState extends State<ServiceRequest> {
  bool assetRelated = false;
  final ContractControl _contractController = Get.find<ContractControl>();
  final LocationControl _locationControl = Get.find<LocationControl>();
  final BuildingControl _buildingControl = Get.find<BuildingControl>();
  final FloorControl _floorControl = Get.find<FloorControl>();
  final SpotControl _spotControl = Get.find<SpotControl>();
  final NatureOfComplaintControl _natureOfComplaintControl =
      Get.find<NatureOfComplaintControl>();
  final AssetControl _assetControl = Get.find<AssetControl>();
  final ServiceRequestInitStateControl _serviceInitControl =
      Get.find<ServiceRequestInitStateControl>();
  final RegisterSaveControl _submitControl = Get.find<RegisterSaveControl>();
  final DepartmentControl _departmentControl = Get.find<DepartmentControl>();
  final DisciplineControl _disciplineControl = Get.find<DisciplineControl>();
  final ServiceRequestControl _serviceRequestControl =
      Get.find<ServiceRequestControl>();
  final NameControl _nameControl = Get.find<NameControl>();
  final DivisionControl _divisionControl = Get.find<DivisionControl>();
  final ListenerControl countControl = Get.find<ListenerControl>();
  final AdminImageRegistrySaveControl _adminImageSelectControl =
      Get.find<AdminImageRegistrySaveControl>();
  final TextEditingController textEditingController = TextEditingController(),
      requiredDateController = TextEditingController(),
      descriptionControl = TextEditingController(),
      assetBarCodeController = TextEditingController(),
      assetNameController = TextEditingController(),
      makeController = TextEditingController(),
      modelController = TextEditingController(),
      nameController = TextEditingController(),
      contactNoController = TextEditingController(),
      conditionController = TextEditingController(),
      statusController = TextEditingController(),
      emailController = TextEditingController(),
      ccEmailController = TextEditingController(),
      divisionControlText = TextEditingController(),
      contractControlText = TextEditingController(),
      locationControlText = TextEditingController(),
      buildingControlText = TextEditingController(),
      spotControlText = TextEditingController(),
      floorControlText = TextEditingController(),
      serviceReqControlText = TextEditingController(),
      disciplineControlText = TextEditingController(),
      departmentControlText = TextEditingController(),
      natureNameControl = TextEditingController(),
      nameControlText = TextEditingController(),
      searchControl = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  int? modIndex, woID;
  String? contractIDPK,
      locationIDPK,
      buildingIDPK,
      floorIDPK,
      spotIDPK,
      natureOfComplaintIDPK,
      serviceRequestIDPK,
      divisionIDPK,
      disciplineIDPK,
      departmentIDPK,
      assetIDPK,
      modelIDPK,
      makeIDPK,
      conditionIDPK,
      statusIDPK,
      nameIDPK;
  List serviceData = [];
  var selected;
  String? selectedValue, time;
  late List selectedList;
  List<Uint8List> fileBytes = [];
  List<String> base64Images = [], imgName = [];
  List<File> filename = [];
  List<Map<String, dynamic>> myList = [];
  String? baseImage, formattedDate;
  final TextEditingController _dateTimeController = TextEditingController(),
      _toDateTimeController = TextEditingController();
  String _currentDateTime = '';
  final carouselController = CarouselController();
  int imagePageIndex = 0;
  DateTime selectedDate = DateTime.now(), current = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay fromTime = TimeOfDay.now();
  Timer? _timer;
  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
  }

  List noRecord = [
    {'id': 1, 'msg': 'No record found...'}
  ];

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('h:mm:ss').format(current);
    serviceInitState();
    _timer = Timer.periodic(
        const Duration(seconds: 1), (Timer t) => _getCurrentDateTime());
  }

  void _scrollListener(String? value) {
    final conId = contractIDPK == null ? null : int.parse(contractIDPK!);
    final locId = locationIDPK == null ? null : int.parse(locationIDPK!);
    final buildingId = buildingIDPK == null ? null : int.parse(buildingIDPK!);
    final floorId = floorIDPK == null ? null : int.parse(floorIDPK!);
    final spotId = spotIDPK == null ? null : int.parse(spotIDPK!);
    final divisionId = divisionIDPK == null ? null : int.parse(divisionIDPK!);
    final serviceID =
        serviceRequestIDPK == null ? null : int.parse(serviceRequestIDPK!);
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (value == 'contract') {
        _contractController.changeStatus(conId);
      }
      if (value == 'location') {
        _locationControl.changeStatus(conId);
      }
      if (value == 'building') {
        _buildingControl.changeStatus(conId, locId);
      }
      if (value == 'floor') {
        _floorControl.changeStatus(conId, locId, buildingId);
      }
      if (value == 'spot') {
        _spotControl.changeStatus(conId, locId, buildingId, floorId);
      }
      if (value == 'serviceRequest') {
        _serviceRequestControl.changeStatus();
      }
      if (value == 'natureCcm') {
        _natureOfComplaintControl.changeStatus(divisionId, serviceID);
      }
      if (value == 'division') {
        _divisionControl.changeStatus();
      }
      if (value == 'discipline') {
        _disciplineControl.changeStatus(divisionId);
      }
      if (value == 'asset') {
        _assetControl.changeStatus(buildingId, floorId,spotId,divisionId);
      }
      if (value == 'name') {
        _nameControl.changeStatus();
      }
      if (value == 'department') {
        _departmentControl.changeStatus();
      }
    }
  }

  void _getCurrentDateTime() {
    final now = DateTime.now();
    final formatter = DateFormat('dd-MM-yyyy hh:mm:ss');
    final formattedDateTime = formatter.format(now);
    setState(() {
      _currentDateTime = formattedDateTime;
    });
  }

  Future<void> uploadFile() async {
    // await openAppSettings();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if (result != null && result.files.isNotEmpty) {
      for (var file in result.files) {
        String fileName = file.name.toString();
        imgName.add(file.name);
        if (file.bytes != null) {
          fileBytes.add(file.bytes!);
          baseImage = base64.encode(file.bytes!);
          myList.add({'image': baseImage, 'name': fileName});
        } else if (file.path != null) {
          await Permission.photos.request();
          await Permission.storage.request();
          File pickedFile = File(file.path!);
          Uint8List bytes = await pickedFile.readAsBytes();
          fileBytes.add(bytes);
          myList.add({'name': fileName, 'image': bytes});
        }
      }
      // for (Uint8List file in fileBytes) {
      //   List<int> bytes = file.toList();
      //   baseImage = base64.encode(bytes);
      //   base64Images.add(baseImage!);
      // }
      // print(base64Images.length);
      // for (int i = 0; i < fileBytes.length; i++) {
      //   myList.add({'image': base64Images[i], 'name': imgName[i]});
      // }

      // filename = result.files.map((e) => File(e.name)).toList();
      // RegExp regExp = RegExp(r"'(.*?)'");
      // filename.forEach((file) {
      //   String fileName = file.toString();
      //   fileName = regExp.firstMatch(fileName)!.group(1)!;
      //   imgName.add(fileName);
      //   print(imgName);
      // });
    }
  }

  void previous() => carouselController.previousPage(
      duration: const Duration(milliseconds: 500));

  void next() =>
      carouselController.nextPage(duration: const Duration(milliseconds: 500));

  void animateToSlide(int index) => carouselController.animateToPage(index);

  Future<void> datePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000, 1),
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
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
      _dateTimeController.text = DateFormat('yyyy-MM-dd h:mm').format(DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute));
      timePicker(context);
    }
  }

  Future<void> timePicker(BuildContext context) async {
    TimeOfDay currentTime = TimeOfDay.now();
    TimeOfDay oneHourLaterTimeOfDay = fromTime.replacing(
      hour: (currentTime.hour + 1),
    );

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
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
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
      _dateTimeController.text = DateFormat('yyyy-MM-dd h:mm').format(DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute));
    }
  }

  serviceInitState() async {
    final response = await _serviceInitControl.servicePageInitStateApi(context);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final data = (json['Output']['data']);
      setState(() {
        serviceData = data;
      });

      for (var file in serviceData) {
        List<dynamic> con = [
          {
            'ContractIDPK': file['ContractIDPK'],
            'ContractName': file['ContractName']
          }
        ];
        List<dynamic> loc = [
          {
            'LocalityIDPK': file['LocalityIDPK'],
            'LocalityName': file['LocalityName']
          }
        ];
        List<dynamic> build = [
          {
            'BuildingIDPK': file['BuildingIDPK'],
            'BuildingName': file['BuildingName']
          }
        ];
        List<dynamic> floor = [
          {'FloorIDPK': file['FloorIDPK'], 'FloorName': file['FloorName']}
        ];
        List<dynamic> spot = [
          {'SpotIDPK': file['SpotIDPK'], 'SpotName': file['SpotName']}
        ];
        setState(() {
          _contractController.contractData.assignAll(con);
          _locationControl.locationData.assignAll(loc);
          _buildingControl.buildingData.assignAll(build);
          _floorControl.floorData.assignAll(floor);
          _spotControl.spotData.assignAll(spot);
          contractIDPK =
              _contractController.contractData[0]['ContractIDPK'].toString();
          contractControlText.text =
              _contractController.contractData[0]['ContractName'];
          locationIDPK =
              _locationControl.locationData[0]['LocalityIDPK'].toString();
          locationControlText.text =
              _locationControl.locationData[0]['LocalityName'];
          buildingIDPK =
              _buildingControl.buildingData[0]['BuildingIDPK'].toString();
          buildingControlText.text =
              _buildingControl.buildingData[0]['BuildingName'];
          floorControlText.text = _floorControl.floorData[0]['FloorName'];
          floorIDPK = _floorControl.floorData[0]['FloorIDPK'].toString();
          spotIDPK = _spotControl.spotData[0]['SpotIDPK'].toString();
          spotControlText.text = _spotControl.spotData[0]['SpotName'];
        });
      }
    }
  }

  clear() {
    setState(() {
      contractIDPK = null;
      locationIDPK = null;
      buildingIDPK = null;
      floorIDPK = null;
      spotIDPK = null;
      natureOfComplaintIDPK = null;
      serviceRequestIDPK = null;
      divisionIDPK = null;
      assetIDPK = null;
      disciplineIDPK = null;
      departmentIDPK = null;
      nameIDPK = null;
      departmentIDPK = null;
      contractControlText.clear();
      locationControlText.clear();
      buildingControlText.clear();
      floorControlText.clear();
      spotControlText.clear();
      serviceReqControlText.clear();
      disciplineControlText.clear();
      descriptionControl.clear();
      natureNameControl.clear();
      divisionControlText.clear();
      assetBarCodeController.clear();
      nameController.clear();
      contactNoController.clear();
      conditionController.clear();
      statusController.clear();
      emailController.clear();
      ccEmailController.clear();
      nameControlText.clear();
      _dateTimeController.clear();
      modelController.clear();
      makeController.clear();
      assetNameController.clear();
      departmentControlText.clear();
      fileBytes.clear();
      // base64Images.clear();
      imgName.clear();
    });
  }

  validationFunc() {
    String val = ('Required field is missing');
    if (contractIDPK == null) {
      StackDialog.show(val, 'Please select the contract', Icons.warning, red);
      return false;
    }
    if (locationIDPK == null) {
      StackDialog.show(val, 'Please select the location', Icons.warning, red);
      return false;
    }
    if (buildingIDPK == null) {
      StackDialog.show(val, 'Please select the building', Icons.warning, red);
      return false;
    }
    if (natureNameControl.text.isEmpty) {
      StackDialog.show(
          val, 'Please select the nature Of Complaint', Icons.warning, red);

      return false;
    }
    if (divisionIDPK == null) {
      StackDialog.show(val, 'Please select the Division', Icons.warning, red);
      return false;
    }
    if (serviceRequestIDPK == null) {
      StackDialog.show(
          val, 'Please select the Request/Service Type', Icons.warning, red);
      return false;
    }
    if (descriptionControl.text.isEmpty) {
      StackDialog.show(val, 'Please enter the description', Icons.warning, red);
      return false;
    }
    // if (nameControlText.text.isEmpty) {
    //   StackDialog.show(val, 'Please select the name', Icons.warning, red);
    //   return false;
    // }
    // if (departmentIDPK == null) {
    //   StackDialog.show(val, 'Please select the Department', Icons.warning, red);
    //   return false;
    // }
    if(assetRelated == true){
      if(assetIDPK == null){
        StackDialog.show(
            val, 'Please select the Asset', Icons.warning, red);
        return false;
      }
    }
    saveFunc();
  }

  saveFunc() async {
    final conId = int.parse(contractIDPK!);
    final locId = int.parse(locationIDPK!);
    final buildingId = int.parse(buildingIDPK!);
    final floorId = floorIDPK == null ? null : int.parse(floorIDPK!);
    final spotId = spotIDPK == null ? null : int.parse(spotIDPK!);
    final natureOfComplainId = natureOfComplaintIDPK == null
        ? null
        : int.parse(natureOfComplaintIDPK!);
    final ccmComplaintTypeID =
        serviceRequestIDPK == null ? null : int.parse(serviceRequestIDPK!);
    final divisionId = divisionIDPK == null ? null : int.parse(divisionIDPK!);
    final assetId = assetIDPK != null ? int.parse(assetIDPK!) : 0;
    final discipline =
        disciplineIDPK != null ? int.parse(disciplineIDPK!) : null;
    final name = nameIDPK != null ? int.parse(nameIDPK!) : null;
    final newNatureComplaint =
        natureOfComplaintIDPK == null ? natureNameControl.text : "";
    final newName = nameIDPK == null ? nameControlText.text : "";
    if (kIsWeb) {
      modIndex = 2;
    } else {
      modIndex = 3;
    }
    if (assetIDPK == null) {
      setState(() {
        woID = 1;
      });
    } else {
      setState(() {
        woID = 2;
      });
    }

    final response = await _submitControl.registerSaveApi(
        context,
        conId,
        locId,
        buildingId,
        floorId,
        spotId,
        natureOfComplainId,
        ccmComplaintTypeID,
        divisionId,
        assetId,
        descriptionControl.text,
        _dateTimeController.text,
        contactNoController.text,
        emailController.text,
        discipline,
        name,
        newNatureComplaint,
        newName,
        modIndex,
        woID);
    if (imgName.isEmpty) {
      clear();
    }
    if (imgName.isNotEmpty) {
      final complaintId = _submitControl.value[0]['Data']['IDPK'];
      await _adminImageSelectControl.adminImageSaveApi(context, complaintId,
          _dateTimeController.text, _toDateTimeController.text, myList);
      clear();
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
            color: Colors.white,
            Icons.arrow_back,
            size: 30,
          ),
        ),
        title: const Text(
          'Create a Service Request',
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
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text('Date & Time', style: tileHeader),
                                ),
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
                                    Text(_currentDateTime, style: cardValue),
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Is the service request asset related? ",
                          style: cardSubTitle,
                        ),
                        SizedBox(height: 10, child: assetSwitch())
                      ],
                    ),
                  ),
                  const DividerWidget(),
                  SizedBox(
                    height: displayHeight(context) * 0.7,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: RichText(
                                text: const TextSpan(
                                  text: 'Status :  ',
                                  style: statusHead,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Open', style: statusContent),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              // height: displayHeight(context) * 0.78,
                              child: Card(
                                color: Colors.white,
                                elevation: 2,
                                shadowColor: Colors.grey.shade300,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 16.0, top: 16),
                                      child: Text(
                                        "Primary Details",
                                        style: cardHeading,
                                      ),
                                    ),
                                    contract(double.infinity,
                                        displayWidth(context) * 0.1),
                                    location(double.infinity,
                                        displayWidth(context) * 0.1),
                                    building(double.infinity,
                                        displayWidth(context) * 0.1),
                                    floor(double.infinity,
                                        displayWidth(context) * 0.1),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child: spot(double.infinity,
                                          displayWidth(context) * 0.1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              // height: displayHeight(context) * 0.78,
                              child: Card(
                                color: Colors.white,
                                elevation: 2,
                                shadowColor: Colors.grey.shade300,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 16.0, top: 16),
                                      child: Text(
                                        "Request Details",
                                        style: cardHeading,
                                      ),
                                    ),
                                    requestAnService(double.infinity, 47),
                                    natureOfComplaint(double.infinity, 47),
                                    division(double.infinity, 47),
                                    discipline(double.infinity, 47),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child: description(double.infinity, 47),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: assetRelated,
                              child: SizedBox(
                                // height: displayHeight(context) * 0.78,
                                child: Card(
                                  color: Colors.white,
                                  elevation: 2,
                                  shadowColor: Colors.grey.shade300,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 16.0, top: 16),
                                        child: Text(
                                          "Asset ",
                                          style: cardHeading,
                                        ),
                                      ),
                                      assetBarcode(double.infinity,
                                          displayWidth(context) * 0.1),
                                      assetName(double.infinity,
                                          displayWidth(context) * 0.1),
                                      make(double.infinity,
                                          displayWidth(context) * 0.1),
                                      model(double.infinity,
                                          displayWidth(context) * 0.1),
                                      condition(double.infinity,
                                          displayWidth(context) * 0.1),
                                      status(double.infinity,
                                          displayWidth(context) * 0.1),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              // height: displayHeight(context) * 0.78,
                              child: Card(
                                color: Colors.white,
                                elevation: 2,
                                shadowColor: Colors.grey.shade300,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 16.0, top: 16),
                                      child: Text(
                                        "Preferred Dates",
                                        style: cardHeading,
                                      ),
                                    ),
                                    fromDateTextField(
                                      double.infinity,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              // height: displayHeight(context) * 0.78,
                              child: Card(
                                color: Colors.white,
                                elevation: 2,
                                shadowColor: Colors.grey.shade300,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 16.0, top: 16),
                                      child: Text(
                                        "Requested By",
                                        style: cardHeading,
                                      ),
                                    ),
                                    name(double.infinity, 42),
                                    contactNo(double.infinity, 42),
                                    email(double.infinity, 42),
                                    ccmEmail(double.infinity, 42),
                                    department(double.infinity, 42),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 16.0, left: 16, bottom: 16),
                                      child: attachment(
                                        displayWidth(context) * 0.6,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 50)
                          ],
                        ),
                      ),
                    ),
                  )
                ])),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
        onPressed: () {
          validationFunc();
        },
        label: const Text("submit"),
      ),
    );
  }

  Widget web() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(children: [
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
                child: Center(
                    child:
                        Text('Create a Service Request', style: pageHeaderWeb)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      headerNonMandatoryName('Date & Time'),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        shadowColor: Colors.grey.shade300,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(_currentDateTime, style: cardValue),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(Icons.event_note_rounded,
                                    color: secondaryColor),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Asset Related', style: txtBtn1),
                      assetSwitch(),
                      refreshBtn(),
                      const SizedBox(width: 10),
                      saveBtn(),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: displayHeight(context) * 0.7,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      shadowColor: Colors.grey.shade300,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Location Details', style: tileHeader),
                            const SizedBox(height: 15),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Tooltip(
                                  message: contractControlText.text,
                                  child: contract(displayWidth(context) * 0.2,
                                      displayWidth(context) * 0.03),
                                ),
                                Tooltip(
                                  message: locationControlText.text,
                                  child: location(displayWidth(context) * 0.2,
                                      displayWidth(context) * 0.03),
                                ),
                                Tooltip(
                                  message: buildingControlText.text,
                                  child: building(displayWidth(context) * 0.2,
                                      displayWidth(context) * 0.03),
                                ),
                                Tooltip(
                                  message: floorControlText.text,
                                  child: floor(displayWidth(context) * 0.2,
                                      displayWidth(context) * 0.03),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Tooltip(
                                  message: spotControlText.text,
                                  child: spot(displayWidth(context) * 0.2,
                                      displayWidth(context) * 0.03),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      shadowColor: Colors.grey.shade300,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Request Details', style: tileHeader),
                            const SizedBox(height: 15),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Tooltip(
                                  message: serviceReqControlText.text,
                                  child: requestAnService(
                                      displayWidth(context) * 0.2,
                                      displayWidth(context) * 0.03),
                                ),
                                Tooltip(
                                  message: natureNameControl.text,
                                  child: natureOfComplaint(
                                      displayWidth(context) * 0.2,
                                      displayWidth(context) * 0.03),
                                ),
                                Tooltip(
                                  message: divisionControlText.text,
                                  child: division(displayWidth(context) * 0.2,
                                      displayWidth(context) * 0.03),
                                ),
                                Tooltip(
                                  message: disciplineControlText.text,
                                  child: discipline(displayWidth(context) * 0.2,
                                      displayWidth(context) * 0.03),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                description(displayWidth(context) * 0.9,
                                    displayWidth(context) * 0.03),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 8.0),
                                  child: Text('Minimum 300 Characters Allowed',
                                      style: tableCardTextRight),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: assetRelated,
                    child: SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        shadowColor: Colors.grey.shade300,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Asset', style: tileHeader),
                              const SizedBox(height: 15),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Tooltip(
                                    message: assetBarCodeController.text,
                                    child: assetBarcode(
                                        displayWidth(context) * 0.2,
                                        displayWidth(context) * 0.03),
                                  ),
                                  Tooltip(
                                    message: assetNameController.text,
                                    child: assetName(
                                        displayWidth(context) * 0.2,
                                        displayWidth(context) * 0.03),
                                  ),
                                  Tooltip(
                                    message: makeController.text,
                                    child: make(displayWidth(context) * 0.2,
                                        displayWidth(context) * 0.03),
                                  ),
                                  Tooltip(
                                    message: modelController.text,
                                    child: model(displayWidth(context) * 0.2,
                                        displayWidth(context) * 0.03),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Tooltip(
                                    message: conditionController.text,
                                    child: condition(
                                        displayWidth(context) * 0.2,
                                        displayWidth(context) * 0.03),
                                  ),
                                  Tooltip(
                                    message: statusController.text,
                                    child: status(displayWidth(context) * 0.2,
                                        displayWidth(context) * 0.03),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      shadowColor: Colors.grey.shade300,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Preferred Date & Time', style: tileHeader),
                            const SizedBox(height: 15),
                            fromDateTextField(displayWidth(context) * 0.2),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      shadowColor: Colors.grey.shade300,
                      color: Colors.white,
                      child: Form(
                        key: _formKey,
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Requested by', style: tileHeader),
                                const SizedBox(height: 15),
                                // Row(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     Tooltip(
                                //       message: nameControlText.text,
                                //       child: name(displayWidth(context) * 0.2,
                                //           displayWidth(context) * 0.03),
                                //     ),
                                //     contactNo(displayWidth(context) * 0.2,
                                //         displayWidth(context) * 0.03),
                                //     email(displayWidth(context) * 0.2,
                                //         displayWidth(context) * 0.03),
                                //     ccmEmail(displayWidth(context) * 0.2,
                                //         displayWidth(context) * 0.03)
                                //   ],
                                // ),
                                // Tooltip(
                                //   message: departmentControlText.text,
                                //   child: department(displayWidth(context) * 0.2,
                                //       displayWidth(context) * 0.03),
                                // ),
                                attachment(displayWidth(context) * 0.7),
                              ],
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]));
  }

  Widget attachment(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Attachment', style: tileHeader),
        const SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: uploadFile,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: secondaryColor),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Icon(
                          Icons.add,
                          color: secondaryColor,
                          size: 25,
                        ),
                      ),
                      Text(
                        "Upload",
                        style: cardTitle,
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            if (fileBytes.isNotEmpty)
              InkWell(
                onTap: () {
                  attachPreview();
                },
                child: SizedBox(
                  width: width,
                  height: 80,
                  child: GridView.builder(
                      itemCount: fileBytes.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        final selectedIndex = index;
                        return Stack(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: secondaryColor),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                              ),
                              child: SizedBox(
                                  child: Image.memory(fileBytes[index])),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      fileBytes.removeAt(selectedIndex);
                                      imgName.removeAt(selectedIndex);
                                      myList.removeAt(selectedIndex);
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: red,
                                    )),
                              ],
                            )
                          ],
                        );
                      }),
                ),
              )
          ],
        ),
      ],
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
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Row(
                                    children: const [
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
                              carouselController: carouselController,
                              options: CarouselOptions(
                                  viewportFraction: 1,
                                  enableInfiniteScroll: false,
                                  // height: 500,
                                  enlargeCenterPage: true,
                                  onPageChanged: (index, reason) => {
                                        setState(() => imagePageIndex = index),
                                      }),
                              itemCount: fileBytes.length,
                              itemBuilder: (context, index, realIndex) {
                                // final img = fileBytes[index];
                                return Column(
                                  children: [
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
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(25.0),
                                              child: Container(
                                                // margin: const EdgeInsets.symmetric(
                                                //     horizontal: 30),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Image.memory(
                                                    fileBytes[index],
                                                    fit: BoxFit.cover,
                                                  ),
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
                              count: fileBytes.length),
                        )
                      ],
                    ),
                  );
                },
              ),
            ));
  }

  Widget assetSwitch() {
    return Switch(
      inactiveTrackColor: grey50,
      activeColor: secondaryColor,
      value: assetRelated,
      onChanged: (bool value) {
        setState(() {
          assetRelated = value;
        });
      },
    );
  }

  Widget contract(double val, double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: val,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headerName('Contract'),
                  if (contractControlText.text.isNotEmpty)
                    InkWell(
                        onTap: () {
                          setState(() {
                            contractIDPK = null;
                            locationIDPK = null;
                            buildingIDPK = null;
                            floorIDPK = null;
                            spotIDPK = null;
                            contractControlText.clear();
                            locationControlText.clear();
                            buildingControlText.clear();
                            floorControlText.clear();
                            spotControlText.clear();
                          });
                        },
                        child: const Icon(Icons.clear, size: 14, color: red))
                ],
              )),
          SizedBox(
            height: height,
            width: val,
            child: TextFormField(
                readOnly: true,
                style: const TextStyle(
                    fontSize: 14, overflow: TextOverflow.ellipsis),
                controller: contractControlText,
                cursorColor: secondaryColor,
                decoration: inputBox('Contract'),
                onTap: () async {
                  final conId =
                      contractIDPK == null ? null : int.parse(contractIDPK!);
                  _contractController.index = 10.obs;
                  _contractController.contractApi(conId);
                  searchControl.clear();
                  singleFieldBottomSheet(
                      _contractController.contractData,
                      contractControlText,
                      'ContractName',
                      'ContractIDPK', (selectedValue) {
                    setState(() {
                      contractIDPK = selectedValue;
                    });
                  }, searchContract(), 'contract');
                },
                onChanged: (String value) {}),
          ),
        ],
      ),
    );
  }

  Widget location(double val, double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: val,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headerName('Location'),
                  if (locationControlText.text.isNotEmpty)
                    InkWell(
                        onTap: () {
                          setState(() {
                            buildingIDPK = null;
                            locationIDPK = null;
                            locationControlText.clear();
                            buildingControlText.clear();
                          });
                        },
                        child: const Icon(Icons.clear, size: 14, color: red))
                ],
              )),
          SizedBox(
            height: height,
            width: val,
            child: TextFormField(
                readOnly: true,
                style: const TextStyle(
                    fontSize: 14, overflow: TextOverflow.ellipsis),
                controller: locationControlText,
                cursorColor: secondaryColor,
                decoration: inputBox('Location'),
                onTap: () async {
                  final conId =
                      contractIDPK == null ? null : int.parse(contractIDPK!);
                  _locationControl.index = 10.obs;
                  _locationControl.locationApi(conId);
                  searchControl.clear();

                  singleFieldBottomSheet(
                      _locationControl.locationData,
                      locationControlText,
                      'LocalityName',
                      'LocalityIDPK', (selectedValue) {
                    setState(() {
                      locationIDPK = selectedValue;
                    });
                  }, searchLocation(), 'location');
                },
                onChanged: (String value) {}),
          ),
        ],
      ),
    );
  }

  Widget building(double val, double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: val,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headerName('Building'),
                  if (buildingControlText.text.isNotEmpty)
                    InkWell(
                        onTap: () {
                          setState(() {
                            buildingIDPK = null;
                            floorIDPK = null;
                            buildingControlText.clear();
                            floorControlText.clear();
                          });
                        },
                        child: const Icon(Icons.clear, size: 14, color: red))
                ],
              )),
          SizedBox(
            height: height,
            width: val,
            child: TextFormField(
                readOnly: true,
                style: const TextStyle(
                    fontSize: 14, overflow: TextOverflow.ellipsis),
                controller: buildingControlText,
                cursorColor: secondaryColor,
                decoration: inputBox('Building'),
                onTap: () async {
                  final conId =
                      contractIDPK == null ? null : int.parse(contractIDPK!);
                  final locId =
                      locationIDPK == null ? null : int.parse(locationIDPK!);
                  _buildingControl.index = 10.obs;
                  _buildingControl.buildingApi(conId, locId);
                  searchControl.clear();
                  singleFieldBottomSheet(
                      _buildingControl.buildingData,
                      buildingControlText,
                      'BuildingName',
                      'BuildingIDPK', (selectedValue) {
                    setState(() {
                      buildingIDPK = selectedValue;
                    });
                  }, searchBuilding(), 'building');
                },
                onChanged: (String value) {}),
          ),
        ],
      ),
    );
  }

  Widget floor(double val, double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: val,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headerNonMandatoryName('Floor'),
                  if (floorControlText.text.isNotEmpty)
                    InkWell(
                        onTap: () {
                          setState(() {
                            spotIDPK = null;
                            floorIDPK = null;
                            spotControlText.clear();
                            floorControlText.clear();
                          });
                        },
                        child: const Icon(Icons.clear, size: 14, color: red))
                ],
              )),
          SizedBox(
            height: height,
            width: val,
            child: TextFormField(
                readOnly: true,
                style: const TextStyle(
                    fontSize: 14, overflow: TextOverflow.ellipsis),
                controller: floorControlText,
                cursorColor: secondaryColor,
                decoration: inputBox('Floor'),
                onTap: () async {
                  final conId =
                      contractIDPK == null ? null : int.parse(contractIDPK!);
                  final locId =
                      locationIDPK == null ? null : int.parse(locationIDPK!);
                  final buildingId =
                      buildingIDPK == null ? null : int.parse(buildingIDPK!);
                  _floorControl.index = 10.obs;
                  _floorControl.floorApi(conId, locId, buildingId);
                  searchControl.clear();

                  singleFieldBottomSheet(
                      _floorControl.floorData,
                      floorControlText,
                      'FloorName',
                      'FloorIDPK', (selectedValue) {
                    setState(() {
                      floorIDPK = selectedValue;
                    });
                  }, searchFloor(), 'floor');
                },
                onChanged: (String value) {}),
          ),
        ],
      ),
    );
  }

  Widget spot(double val, double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: val,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headerNonMandatoryName('Spot'),
                  if (spotControlText.text.isNotEmpty)
                    InkWell(
                        onTap: () {
                          setState(() {
                            spotIDPK = null;
                            spotControlText.clear();
                          });
                        },
                        child: const Icon(Icons.clear, size: 14, color: red))
                ],
              )),
          SizedBox(
            height: height,
            width: val,
            child: TextFormField(
                readOnly: true,
                style: const TextStyle(
                    fontSize: 14, overflow: TextOverflow.ellipsis),
                controller: spotControlText,
                cursorColor: secondaryColor,
                decoration: inputBox('Spot'),
                onTap: () async {
                  final conId =
                      contractIDPK == null ? null : int.parse(contractIDPK!);
                  final locId =
                      locationIDPK == null ? null : int.parse(locationIDPK!);
                  final buildingId =
                      buildingIDPK == null ? null : int.parse(buildingIDPK!);
                  final floorId =
                      floorIDPK == null ? null : int.parse(floorIDPK!);
                  _spotControl.index = 10.obs;
                  _spotControl.spotApi(conId, locId, buildingId, floorId);
                  searchControl.clear();

                  singleFieldBottomSheet(_spotControl.spotData, spotControlText,
                      'SpotName', 'SpotIDPK', (selectedValue) {
                    setState(() {
                      spotIDPK = selectedValue;
                    });
                  }, searchSpot(), 'spot');
                },
                onChanged: (String value) {}),
          ),
        ],
      ),
    );
  }

  Widget requestAnService(double val, double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: val,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headerName('Request / Service Type'),
                  if (serviceReqControlText.text.isNotEmpty)
                    InkWell(
                        onTap: () {
                          setState(() {
                            serviceRequestIDPK = null;
                            serviceReqControlText.clear();
                            natureNameControl.clear();
                            natureOfComplaintIDPK = null;
                          });
                        },
                        child: const Icon(Icons.clear, size: 14, color: red))
                ],
              )),
          SizedBox(
            height: height,
            width: val,
            child: TextFormField(
                readOnly: true,
                style: const TextStyle(
                    fontSize: 14, overflow: TextOverflow.ellipsis),
                controller: serviceReqControlText,
                cursorColor: secondaryColor,
                decoration: inputBox('Request / Service Type'),
                onTap: () async {
                  _serviceRequestControl.index = 10.obs;
                  _serviceRequestControl.serviceRequestApi();
                  searchControl.clear();
                  singleFieldBottomSheet(
                      _serviceRequestControl.serviceReqData,
                      serviceReqControlText,
                      'ComplaintTypeName',
                      'ComplaintTypeIDPK', (selectedValue) {
                    setState(() {
                      serviceRequestIDPK = selectedValue;
                    });
                  }, searchRequestType(), 'serviceRequest');
                },
                onChanged: (String value) {}),
          ),
        ],
      ),
    );
  }

  Widget natureOfComplaint(double val, double height) {
    TextStyle header1 = const TextStyle(
        color: Colors.black,
        overflow: TextOverflow.clip,
        fontSize: 12,
        fontWeight: FontWeight.w300);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: val,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headerName('Nature of Complaint'),
                if (natureNameControl.text.isNotEmpty)
                  InkWell(
                      onTap: () {
                        setState(() {
                          natureOfComplaintIDPK = null;
                          serviceRequestIDPK = null;
                          divisionIDPK = null;
                          natureNameControl.clear();
                          divisionControlText.clear();
                          serviceReqControlText.clear();
                          disciplineControlText.clear();
                          disciplineIDPK = null;
                        });
                      },
                      child: const Icon(Icons.clear, size: 14, color: red))
              ],
            ),
          ),
          SizedBox(
            height: height,
            width: val,
            child: TextFormField(
              readOnly: true,
              style: const TextStyle(
                  height: 1.5, fontSize: 14, overflow: TextOverflow.visible),
              controller: natureNameControl,
              cursorColor: secondaryColor,
              decoration: inputBox('Nature Of Complaint'),
              onTap: () {
                final division =
                    divisionIDPK == null ? null : int.parse(divisionIDPK!);
                final complaintID = serviceRequestIDPK == null
                    ? null
                    : int.parse(serviceRequestIDPK!);
                _natureOfComplaintControl.index = 10.obs;
                _natureOfComplaintControl.natureOfComplaintApi(
                    division, complaintID);
                searchControl.clear();
                showModalBottomSheet<void>(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16))),
                  backgroundColor: Colors.white,
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10))),
                      height: 400,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: search(searchNature()),
                          ),
                          NotificationListener<ScrollNotification>(
                            onNotification: (scrollNotification) {
                              if (scrollNotification
                                  is ScrollUpdateNotification) {
                                _scrollListener('natureCcm');
                              }
                              return true;
                            },
                            child: Obx(
                              () => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: SizedBox(
                                  height: 300,
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: 5.0,
                                      crossAxisSpacing: 5.0,
                                      crossAxisCount: 3,
                                      childAspectRatio: MediaQuery.of(context)
                                              .size
                                              .width /
                                          (MediaQuery.of(context).size.height /
                                              1.9),
                                    ),
                                    controller: _scrollController,
                                    itemCount: _natureOfComplaintControl
                                        .natureData.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return _natureOfComplaintControl
                                              .natureData.isEmpty
                                          ? Center(
                                              child: Text('No Record Found',
                                                  style: tileHeader),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                final val =
                                                    _natureOfComplaintControl
                                                        .natureData[index];
                                                if (val['ComplaintNatureIDPK'] !=
                                                        null &&
                                                    val['ComplaintNatureIDPK'] !=
                                                        0) {
                                                  setState(() {
                                                    natureNameControl.text = val[
                                                        'ComplaintNatureName'];
                                                    natureOfComplaintIDPK =
                                                        val['ComplaintNatureIDPK']
                                                            .toString();
                                                  });
                                                }
                                                if (val['DivisionID'] != null &&
                                                    val['DivisionID'] != 0) {
                                                  setState(() {
                                                    divisionControlText.text =
                                                        val['DivisionName'];
                                                    divisionIDPK =
                                                        val['DivisionID']
                                                            .toString();
                                                  });
                                                }
                                                if (val['CCMComplaintTypeID'] !=
                                                        null &&
                                                    val['CCMComplaintTypeID'] !=
                                                        0) {
                                                  setState(() {
                                                    serviceRequestIDPK =
                                                        val['CCMComplaintTypeID']
                                                            .toString();
                                                    serviceReqControlText.text =
                                                        val['CCMComplaintTypeName'];
                                                  });
                                                }

                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      offset: Offset(-1, -1),
                                                      spreadRadius: -11,
                                                      blurRadius: 12,
                                                      color: Color.fromRGBO(
                                                          159, 159, 159, 1.0),
                                                    )
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                        child: Text(
                                                            _natureOfComplaintControl
                                                                            .natureData[
                                                                        index][
                                                                    'ComplaintNatureName'] ??
                                                                '',
                                                            style: tileHeader),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                        child: Text(
                                                            _natureOfComplaintControl
                                                                            .natureData[
                                                                        index][
                                                                    'DivisionName'] ??
                                                                '',
                                                            style: header1),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                        child: Text(
                                                            _natureOfComplaintControl
                                                                            .natureData[
                                                                        index][
                                                                    'PriorityName'] ??
                                                                '',
                                                            style: cardValue),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                        child: Text(
                                                            _natureOfComplaintControl
                                                                            .natureData[
                                                                        index][
                                                                    'CCMComplaintTypeName'] ??
                                                                '',
                                                            style: cardValue),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ));
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget division(double val, double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: val,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headerName('Division'),
                if (divisionIDPK != null)
                  InkWell(
                      onTap: () {
                        setState(() {
                          divisionIDPK = null;
                          natureOfComplaintIDPK = null;
                          divisionControlText.clear();
                          natureNameControl.clear();
                          disciplineControlText.clear();
                          disciplineIDPK = null;
                        });
                      },
                      child: const Icon(Icons.clear, size: 14, color: red))
              ],
            ),
          ),
          SizedBox(
            height: height,
            width: val,
            child: TextFormField(
                readOnly: true,
                style: const TextStyle(
                    fontSize: 14, overflow: TextOverflow.ellipsis),
                controller: divisionControlText,
                cursorColor: secondaryColor,
                decoration: inputBox('Division'),
                onTap: () async {
                  _divisionControl.index = 10.obs;
                  _divisionControl.divisionApi();
                  searchControl.clear();
                  singleFieldBottomSheet(
                      _divisionControl.divisionData,
                      divisionControlText,
                      'DivisionName',
                      'DivisionIDPK', (selectedValue) {
                    setState(() {
                      divisionIDPK = selectedValue;
                    });
                  }, searchDivision(), 'division');
                },
                onChanged: (value) {}),
          ),
        ],
      ),
    );
  }

  Widget discipline(double val, double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: val,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headerNonMandatoryName('Discipline'),
                if (disciplineControlText.text.isNotEmpty)
                  InkWell(
                      onTap: () {
                        setState(() {
                          disciplineControlText.clear();
                          disciplineIDPK = null;
                        });
                      },
                      child: const Icon(Icons.clear, size: 14, color: red))
              ],
            ),
          ),
          SizedBox(
            height: height,
            width: val,
            child: IgnorePointer(
              ignoring: divisionIDPK != null ? false : true,
              child: TextFormField(
                  readOnly: true,
                  style: const TextStyle(
                      fontSize: 14, overflow: TextOverflow.ellipsis),
                  controller: disciplineControlText,
                  cursorColor: secondaryColor,
                  decoration: inputBox('Discipline'),
                  onTap: () async {
                    final divisionId =
                        divisionIDPK == null ? null : int.parse(divisionIDPK!);
                    _disciplineControl.index = 10.obs;
                    _disciplineControl.disciplineApi(divisionId);
                    searchControl.clear();
                    singleFieldBottomSheet(
                        _disciplineControl.disciplineData,
                        disciplineControlText,
                        'DisciplineName',
                        'DisciplineIDPK', (selectedValue) {
                      setState(() {
                        disciplineIDPK = selectedValue;
                      });
                    }, searchDiscipline(), 'discipline');
                  },
                  onChanged: (value) {}),
            ),
          ),
        ],
      ),
    );
  }

  Widget description(double val, double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: val,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headerName('Description'),
                  if (descriptionControl.text.isNotEmpty)
                    InkWell(
                        onTap: () {
                          setState(() {
                            descriptionControl.clear();
                          });
                        },
                        child: const Icon(Icons.clear, size: 14, color: red))
                ],
              )),
          SizedBox(
            height: height,
            width: val,
            child: TextFormField(
              controller: descriptionControl,
              onChanged: (value) {},
              inputFormatters: [LengthLimitingTextInputFormatter(300)],
              cursorColor: secondaryColor,
              decoration: inputBox('Description'),
            ),
          ),
        ],
      ),
    );
  }

  // Widget assetBarcode(double val, double width) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         SizedBox(
  //             width: val,
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 headerNonMandatoryName('Asset Barcode/Tag No'),
  //                 if (assetIDPK != null)
  //                   InkWell(
  //                       onTap: () {
  //                         setState(() {
  //                           assetIDPK = null;
  //                           modelController.clear();
  //                           makeController.clear();
  //                           assetNameController.clear();
  //                         });
  //                       },
  //                       child: const Icon(Icons.clear, size: 14, color: red))
  //               ],
  //             )),
  //         SizedBox(
  //           height: 38,
  //           width: val,
  //           child: DropdownButtonHideUnderline(
  //             child: DropdownButton2<dynamic>(
  //               hint: hintStyle('Select Asset Barcode/Tag No'),
  //               items: assetData.isEmpty
  //                   ? noRecord
  //                       .map((item) => DropdownMenuItem(
  //                             value: item['id'],
  //                             child: dropDownValuesStyle(
  //                                 context, item['msg'], width),
  //                           ))
  //                       .toList()
  //                   : assetData
  //                       .map((item) => DropdownMenuItem(
  //                             onTap: () {
  //                               setState(() {
  //                                 modelController.text = item['ModelName'];
  //                                 makeController.text = item['MakeName'];
  //                                 conditionController.text =
  //                                     item['ConditionName'];
  //                                 assetNameController.text =
  //                                     item['EquipmentName'];
  //                                 statusController.text = item['StatusName'];
  //                                 modelIDPK = item['ModelID'].toString();
  //                                 makeIDPK = item['MakeID'].toString();
  //                                 statusIDPK = item['StatusID'].toString();
  //                                 divisionIDPK = item['DivisionID'].toString();
  //                                 divisionControlText.text =
  //                                     item['DivisionName'];
  //                                 disciplineIDPK =
  //                                     item['DisciplineID'].toString();
  //                                 disciplineControlText.text =
  //                                     item['DisciplineName'];
  //                                 floorIDPK = item['FloorID'].toString();
  //                                 floorControlText.text = item['FloorName'];
  //                                 spotIDPK = item['SpotID'].toString();
  //                                 locationIDPK = item['LocalityID'].toString();
  //                                 locationControlText.text =
  //                                     item['LocalityName'];
  //                                 buildingControlText.text =
  //                                     item['BuildingName'];
  //                                 buildingIDPK = item['BuildingID'].toString();
  //                                 spotIDPK = item['SpotID'].toString();
  //                                 spotControlText.text = item['SpotName'];
  //                               });
  //                             },
  //                             value: item['AssetIDPK'].toString(),
  //                             child: dropDownValuesStyle(
  //                                 context, item['AssetTagNo'], width),
  //                           ))
  //                       .toList(),
  //               value: assetIDPK,
  //               onChanged: (value) {
  //                 setState(() {
  //                   assetIDPK = value;
  //                 });
  //               },
  //               buttonStyleData: buttonStyle,
  //               dropdownStyleData: dropDownStyle,
  //               menuItemStyleData: menuStyleData,
  //               dropdownSearchData: DropdownSearchData(
  //                 searchController: textEditingController,
  //                 searchInnerWidgetHeight: 50,
  //                 searchInnerWidget: Container(
  //                   height: 50,
  //                   padding: dropDownSearchPadding,
  //                   child: TextFormField(
  //                     expands: true,
  //                     maxLines: null,
  //                     style: const TextStyle(color: Colors.black),
  //                     controller: textEditingController,
  //                     decoration: loginInput(grey50, 'Search Asset'),
  //                   ),
  //                 ),
  //                 searchMatchFn: (item, searchValue) {
  //                   final child = item.child;
  //                   if (child is SizedBox && child.child is Text) {
  //                     String val = (child.child as Text).data ?? '';
  //                     return val
  //                         .toLowerCase()
  //                         .contains(searchValue.toLowerCase());
  //                   }
  //                   return false;
  //                 },
  //               ),
  //               onMenuStateChange: (isOpen) {
  //                 if (!isOpen) {
  //                   textEditingController.clear();
  //                 }
  //               },
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget assetBarcode(double val, double height) {
    TextStyle header1 = const TextStyle(
        color: Colors.black,
        overflow: TextOverflow.clip,
        fontSize: 12,
        fontWeight: FontWeight.w300);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: val,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headerName('Asset Barcode/Tag No'),
                  if (assetIDPK != null)
                    InkWell(
                        onTap: () {
                          setState(() {
                            assetIDPK = null;
                            makeIDPK = null;
                            modelIDPK = null;
                            conditionIDPK = null;
                            statusIDPK = null;
                            statusController.clear();
                            conditionController.clear();
                            assetBarCodeController.clear();
                            modelController.clear();
                            makeController.clear();
                            assetNameController.clear();
                          });
                        },
                        child: const Icon(Icons.clear, size: 14, color: red))
                ],
              )),
          SizedBox(
            width: val,
            height: height,
            child: TextFormField(
                readOnly: true,
                style: const TextStyle(
                    height: 1.5, fontSize: 14, overflow: TextOverflow.visible),
                decoration: inputBox('Asset BarCode/Asset TagNo'),
                controller: assetBarCodeController,
                onTap: () {
                  final buildingId =
                  buildingIDPK == null ? null : int.parse(buildingIDPK!);
                  final floorId =
                  floorIDPK == null ? null : int.parse(floorIDPK!);
                  final spotId = spotIDPK == null ? null : int.parse(spotIDPK!);
                  final division =
                  divisionIDPK == null ? null : int.parse(divisionIDPK!);
                  _assetControl.assetApi(buildingId,floorId,spotId,division);
                  showModalBottomSheet<void>(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16))),
                    backgroundColor: Colors.white,
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10))),
                        height: 400,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 15.0),
                              child: search(searchAsset()),
                            ),
                            NotificationListener<ScrollNotification>(
                              onNotification: (scrollNotification) {
                                if (scrollNotification
                                is ScrollUpdateNotification) {
                                  _scrollListener('asset');
                                }
                                return true;
                              },
                              child: Obx(
                                    () => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: SizedBox(
                                    height: 300,
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisSpacing: 5.0,
                                        crossAxisSpacing: 5.0,
                                        crossAxisCount: kIsWeb == true ? 3 : 1,
                                        childAspectRatio: kIsWeb == true
                                            ? MediaQuery.of(context)
                                            .size
                                            .width /
                                            (MediaQuery.of(context)
                                                .size
                                                .height /
                                                1.9)
                                            : (MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.4) /
                                            (MediaQuery.of(context)
                                                .size
                                                .height /
                                                20.9),
                                      ),
                                      controller: _scrollController,
                                      itemCount: _assetControl.assetData.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return _assetControl.assetData.isEmpty
                                            ? Center(
                                          child: Text('No Record Found',
                                              style: tileHeader),
                                        )
                                            : InkWell(
                                            onTap: () {
                                              final val = _assetControl
                                                  .assetData[index];

                                              if (val['AssetIDPK'] !=
                                                  null &&
                                                  val['AssetIDPK'] != 0) {
                                                setState(() {
                                                  assetIDPK =
                                                      val['AssetIDPK']
                                                          .toString();
                                                  assetBarCodeController
                                                      .text =
                                                  val['AssetTagNo'];
                                                });
                                              }
                                              if (val['AssetIDPK'] !=
                                                  null &&
                                                  val['AssetIDPK'] != 0) {
                                                setState(() {
                                                  assetIDPK =
                                                      val['AssetIDPK']
                                                          .toString();
                                                  assetNameController.text =
                                                  val['EquipmentName'];
                                                });
                                              }

                                              if (val['MakeID'] != null &&
                                                  val['MakeID'] != 0) {
                                                setState(() {
                                                  makeIDPK = val['MakeID']
                                                      .toString();
                                                  makeController.text =
                                                  val['MakeName'];
                                                });
                                              }

                                              if (val['ModelID'] != null &&
                                                  val['ModelID'] != 0) {
                                                setState(() {
                                                  modelIDPK = val['ModelID']
                                                      .toString();
                                                  modelController.text =
                                                  val['ModelName'];
                                                });
                                              }

                                              if (val['ConditionID'] !=
                                                  null &&
                                                  val['ConditionID'] != 0) {
                                                setState(() {
                                                  conditionIDPK =
                                                      val['ConditionID']
                                                          .toString();
                                                  conditionController.text =
                                                  val['ConditionName'];
                                                });
                                              }

                                              if (val['StatusID'] != null &&
                                                  val['StatusID'] != 0) {
                                                setState(() {
                                                  statusIDPK =
                                                      val['StatusID']
                                                          .toString();
                                                  statusController.text =
                                                  val['StatusName'];
                                                });
                                              }

                                              if (val['SpotID'] != null &&
                                                  val['SpotID'] != 0) {
                                                setState(() {
                                                  spotIDPK = val['SpotID']
                                                      .toString();
                                                  spotControlText.text =
                                                  val['SpotName'];
                                                });
                                              }

                                              if (val['FloorID'] != null &&
                                                  val['FloorID'] != 0) {
                                                setState(() {
                                                  floorIDPK = val['FloorID']
                                                      .toString();
                                                  floorControlText.text =
                                                  val['FloorName'];
                                                });
                                              }

                                              if (val['DivisionID'] !=
                                                  null &&
                                                  val['DivisionID'] != 0) {
                                                setState(() {
                                                  divisionIDPK =
                                                      val['DivisionID']
                                                          .toString();
                                                  divisionControlText.text =
                                                  val['DivisionName'];
                                                });
                                              }

                                              if (val['DisciplineID'] !=
                                                  null &&
                                                  val['DisciplineID'] !=
                                                      0) {
                                                setState(() {
                                                  disciplineIDPK =
                                                      val['DisciplineID']
                                                          .toString();
                                                  disciplineControlText
                                                      .text =
                                                  val['DisciplineName'];
                                                });
                                              }

                                              setState(() {
                                                locationIDPK =
                                                    val['LocalityID']
                                                        .toString();
                                                locationControlText.text =
                                                val['LocalityName'];
                                                buildingControlText.text =
                                                val['BuildingName'];
                                                buildingIDPK =
                                                    val['BuildingID']
                                                        .toString();
                                              });

                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.circular(
                                                    15.0),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    offset: Offset(-1, -1),
                                                    spreadRadius: -11,
                                                    blurRadius: 12,
                                                    color: Color.fromRGBO(
                                                        159, 159, 159, 1.0),
                                                  )
                                                ],
                                              ),
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.all(
                                                    10.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    SizedBox(
                                                      width: kIsWeb == true
                                                          ? MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          0.25
                                                          : MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          0.85,
                                                      child: Text(
                                                          _assetControl.assetData[
                                                          index]
                                                          [
                                                          'AssetTagNo'] ??
                                                              '',
                                                          style:
                                                          tileHeader),
                                                    ),
                                                    SizedBox(
                                                      width: kIsWeb == true
                                                          ? MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          0.25
                                                          : MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          0.85,
                                                      child: Text(
                                                          _assetControl.assetData[
                                                          index]
                                                          [
                                                          'EquipmentName'] ??
                                                              '',
                                                          style: header1),
                                                    ),
                                                    SizedBox(
                                                      width: kIsWeb == true
                                                          ? MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          0.25
                                                          : MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          0.85,
                                                      child: Text(
                                                          _assetControl.assetData[
                                                          index]
                                                          [
                                                          'MakeName'] ??
                                                              '',
                                                          style: cardValue),
                                                    ),
                                                    SizedBox(
                                                      width: kIsWeb == true
                                                          ? MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          0.25
                                                          : MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          0.85,
                                                      child: Text(
                                                          _assetControl.assetData[
                                                          index]
                                                          [
                                                          'ModelName'] ??
                                                              '',
                                                          style: cardValue),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ));
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
          )
        ],
      ),
    );
  }

  Widget assetName(
    double val,
    double height,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerNonMandatoryName('Asset Name'),
          SizedBox(
            height: height,
            width: val,
            child: IgnorePointer(
              ignoring: true,
              child: TextFormField(
                style: const TextStyle(
                    fontSize: 14, overflow: TextOverflow.ellipsis),
                onChanged: (value) {},
                controller: assetNameController,
                cursorColor: secondaryColor,
                decoration: inputBox('Enter Asset Name'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget make(
    double val,
    double height,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerNonMandatoryName('Make'),
          SizedBox(
            height: height,
            width: val,
            child: IgnorePointer(
              ignoring: true,
              child: TextFormField(
                style: const TextStyle(
                    fontSize: 14, overflow: TextOverflow.ellipsis),
                onChanged: (value) {},
                controller: makeController,
                cursorColor: secondaryColor,
                decoration: inputBox('Enter Make'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget model(
    double val,
    double height,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerNonMandatoryName('Model'),
          SizedBox(
            height: height,
            width: val,
            child: IgnorePointer(
              ignoring: true,
              child: TextFormField(
                style: const TextStyle(
                    fontSize: 14, overflow: TextOverflow.ellipsis),
                onChanged: (value) {},
                controller: modelController,
                cursorColor: secondaryColor,
                decoration: inputBox('Enter Model'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget condition(
    double val,
    double height,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerNonMandatoryName('Condition'),
          SizedBox(
            height: height,
            width: val,
            child: IgnorePointer(
              ignoring: true,
              child: TextFormField(
                style: const TextStyle(
                    fontSize: 14, overflow: TextOverflow.ellipsis),
                onChanged: (value) {},
                controller: conditionController,
                cursorColor: secondaryColor,
                decoration: inputBox('Enter Condition'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget status(
    double val,
    double height,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerNonMandatoryName('Status'),
          SizedBox(
            height: height,
            width: val,
            child: IgnorePointer(
              ignoring: true,
              child: TextFormField(
                style: const TextStyle(
                    fontSize: 14, overflow: TextOverflow.ellipsis),
                onChanged: (value) {},
                controller: statusController,
                cursorColor: secondaryColor,
                decoration: inputBox('Enter Status'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget fromDateTextField(double val) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: val,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headerNonMandatoryName('Date & Time'),
                  if (_dateTimeController.text.isNotEmpty)
                    InkWell(
                        onTap: () {
                          setState(() {
                            _dateTimeController.clear();
                          });
                        },
                        child: const Icon(Icons.clear, size: 14, color: red))
                ],
              )),
          SizedBox(
            height: 32,
            width: val,
            child: TextFormField(
              readOnly: true,
              onTap: () async {
                await datePicker(context);
              },
              onChanged: (value) {
                _dateTimeController.text = value.toString();
              },
              controller: _dateTimeController,
              cursorColor: secondaryColor,
              decoration: inputDateBox('Select Date & Time'),
            ),
          ),
        ],
      ),
    );
  }

  Widget name(double val, double height) {
    TextStyle header1 = const TextStyle(
        color: Colors.black,
        overflow: TextOverflow.clip,
        fontSize: 12,
        fontWeight: FontWeight.w300);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: val,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headerName('Name'),
                if (nameControlText.text.isNotEmpty)
                  InkWell(
                      onTap: () {
                        setState(() {
                          nameIDPK = null;
                          contactNoController.clear();
                          emailController.clear();
                          nameControlText.clear();
                        });
                      },
                      child: const Icon(Icons.clear, size: 14, color: red))
              ],
            ),
          ),
          SizedBox(
            height: height,
            width: val,
            child: TextFormField(
              readOnly: true,
              style: const TextStyle(
                  height: 1.5, fontSize: 14, overflow: TextOverflow.visible),
              controller: nameControlText,
              maxLines: null,
              cursorColor: secondaryColor,
              decoration: inputBox('Name'),
              onTap: () {
                _nameControl.index = 10.obs;
                _nameControl.nameApi();
                searchControl.clear();
                showModalBottomSheet<void>(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16))),
                  backgroundColor: Colors.white,
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10))),
                      height: 400,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: search(searchName()),
                          ),
                          NotificationListener<ScrollNotification>(
                            onNotification: (scrollNotification) {
                              if (scrollNotification
                                  is ScrollUpdateNotification) {
                                _scrollListener('name');
                              }
                              return true;
                            },
                            child: Obx(
                              () => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: SizedBox(
                                  height: 300,
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: 5.0,
                                      crossAxisSpacing: 5.0,
                                      crossAxisCount: 3,
                                      childAspectRatio: MediaQuery.of(context)
                                              .size
                                              .width /
                                          (MediaQuery.of(context).size.height /
                                              1.9),
                                    ),
                                    controller: _scrollController,
                                    itemCount: _nameControl.nameData.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final val = _nameControl.nameData[index];
                                      return _nameControl.nameData.isEmpty
                                          ? Center(
                                              child: Text('No Record Found',
                                                  style: tileHeader),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                if (val['ComplainerIDPK'] !=
                                                        null &&
                                                    val['ComplainerIDPK'] !=
                                                        0) {
                                                  setState(() {
                                                    nameControlText.text =
                                                        val['ComplainerName'];

                                                    nameIDPK =
                                                        val['ComplainerIDPK']
                                                            .toString();
                                                  });
                                                }
                                                if (val['SpotID'] != null &&
                                                    val['SpotID'] != 0) {
                                                  setState(() {
                                                    spotIDPK = val['SpotID']
                                                        .toString();
                                                    spotControlText.text =
                                                        val['SpotName'];
                                                  });
                                                }
                                                if (val['FloorID'] != null &&
                                                    val['FloorID'] != 0) {
                                                  setState(() {
                                                    floorControlText.text =
                                                        val['FloorName'];
                                                    floorIDPK = val['FloorID']
                                                        .toString();
                                                  });
                                                }
                                                if (val['ContactNo'] != null) {
                                                  setState(() {
                                                    contactNoController.text =
                                                        val['ContactNo'];
                                                  });
                                                }
                                                if (val['Email'] != null) {
                                                  setState(() {
                                                    emailController.text =
                                                        val['Email'];
                                                  });
                                                }
                                                setState(() {
                                                  contractIDPK =
                                                      val['ContractID']
                                                          .toString();
                                                  contractControlText.text =
                                                      val['ContractName'];
                                                  locationIDPK =
                                                      val['LocalityID']
                                                          .toString();
                                                  locationControlText.text =
                                                      val['LocalityName'];
                                                  buildingControlText.text =
                                                      val['BuildingName'];
                                                  buildingIDPK =
                                                      val['BuildingID']
                                                          .toString();
                                                });

                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      offset: Offset(-1, -1),
                                                      spreadRadius: -11,
                                                      blurRadius: 12,
                                                      color: Color.fromRGBO(
                                                          159, 159, 159, 1.0),
                                                    )
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                        child: Text(
                                                            val['ComplainerName'] ??
                                                                '',
                                                            style: tileHeader),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                        child: Text(
                                                            val['ContactNo'] ??
                                                                '',
                                                            style: header1),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                        child: Text(
                                                            val['Email'] ?? '',
                                                            style: cardValue),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                        child: Text(
                                                            val['ContractName'] ??
                                                                '',
                                                            style: cardValue),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ));
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget contactNo(
    double val,
    double height,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: val,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headerNonMandatoryName('Contact No'),
                  if (contactNoController.text.isNotEmpty && nameIDPK == null)
                    InkWell(
                      onTap: () {
                        setState(() {
                          contactNoController.clear();
                        });
                      },
                      child: const Icon(Icons.clear, size: 14, color: red),
                    )
                ],
              )),
          SizedBox(
            height: height,
            width: val,
            child: TextFormField(
              readOnly: nameIDPK != null ? true : false,
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              style: const TextStyle(
                  fontSize: 14, overflow: TextOverflow.ellipsis),
              onChanged: (value) {},
              controller: contactNoController,
              cursorColor: secondaryColor,
              decoration: inputBox('Enter contact no'),
            ),
          ),
        ],
      ),
    );
  }

  Widget email(
    double val,
    double height,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: val,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headerNonMandatoryName('E-mail-ID'),
                  if (emailController.text.isNotEmpty && nameIDPK == null)
                    InkWell(
                      onTap: () {
                        setState(() {
                          emailController.clear();
                        });
                      },
                      child: const Icon(Icons.clear, size: 14, color: red),
                    )
                ],
              )),
          SizedBox(
            height: height,
            width: val,
            child: TextFormField(
              readOnly: nameIDPK != null ? true : false,
              keyboardType: TextInputType.emailAddress,
              validator: (String? value) {
                if (value == null) {
                  toaster(context, ' Please enter an email', trending3,
                      Icons.warning);
                  return null;
                }
                // if (!emailRegex.hasMatch(value)) {
                //   toaster(context, ' Please enter a valid email', trending3,
                //       Icons.warning);
                // }
                // return null;
              },
              style: const TextStyle(
                  fontSize: 14, overflow: TextOverflow.ellipsis),
              onChanged: (value) {},
              controller: emailController,
              cursorColor: secondaryColor,
              decoration: inputBox('Enter EmailID'),
            ),
          ),
        ],
      ),
    );
  }

  Widget ccmEmail(
    double val,
    double height,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: val,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headerNonMandatoryName('CC E-Mail-ID'),
                  if (ccEmailController.text.isNotEmpty)
                    InkWell(
                        onTap: () {
                          setState(() {
                            ccEmailController.clear();
                          });
                        },
                        child: const Icon(Icons.clear, size: 14, color: red))
                ],
              )),
          SizedBox(
            height: height,
            width: val,
            child: TextFormField(
              style: const TextStyle(
                  fontSize: 14, overflow: TextOverflow.ellipsis),
              onChanged: (value) {},
              controller: ccEmailController,
              cursorColor: secondaryColor,
              decoration: inputBox('Enter CC EMailID'),
            ),
          ),
        ],
      ),
    );
  }

  Widget department(double val, double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: val,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headerName('Department'),
                if (departmentControlText.text.isNotEmpty)
                  InkWell(
                      onTap: () {
                        setState(() {
                          departmentControlText.clear();
                          departmentIDPK = null;
                        });
                      },
                      child: const Icon(Icons.clear, size: 14, color: red))
              ],
            ),
          ),
          SizedBox(
            height: height,
            width: val,
            child: TextFormField(
                readOnly: true,
                style: const TextStyle(
                    fontSize: 14, overflow: TextOverflow.ellipsis),
                controller: departmentControlText,
                cursorColor: secondaryColor,
                decoration: inputBox('Department'),
                onTap: () async {
                  _departmentControl.index = 10.obs;
                  _departmentControl.departmentApi();
                  searchControl.clear();
                  singleFieldBottomSheet(
                      _departmentControl.departmentData,
                      departmentControlText,
                      'DepartmentName',
                      'DepartmentIDPK', (selectedValue) {
                    setState(() {
                      departmentIDPK = selectedValue;
                    });
                  }, searchDepartment(), 'department');
                },
                onChanged: (value) {}),
          ),
        ],
      ),
    );
  }

  Widget search(Widget child) {
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
                        color: Color(0xFFa5a5a5),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 7.0, left: 8.0),
                      child: child,
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  Future<void> singleFieldBottomSheet(
      List data,
      TextEditingController name,
      String dataName,
      String dataID,
      Function(String)? onSelect,
      Widget searchField,
      String scrollValue) {
    return showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10), topLeft: Radius.circular(10))),
          height: 300,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: search(searchField),
              ),
              NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollUpdateNotification) {
                    _scrollListener(scrollValue);
                  }
                  return true;
                },
                child: Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      height: 200,
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 5.0,
                          crossAxisSpacing: 5.0,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 3.0),
                        ),
                        controller: _scrollController,
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                              onTap: () {
                                setState(() {
                                  name.text = data[index]['$dataName'];
                                });
                                onSelect!(data[index]['$dataID'].toString());
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      offset: Offset(-1, -1),
                                      spreadRadius: -11,
                                      blurRadius: 12,
                                      color: Color.fromRGBO(159, 159, 159, 1.0),
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: Text(data[index]['$dataName'] ?? '',
                                        style: tileHeader),
                                  ),
                                ),
                              ));
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> noRecordSheet(List data) {
    return showModalBottomSheet<void>(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10), topLeft: Radius.circular(10))),
          height: 300,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  height: 200,
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 5.0,
                      crossAxisSpacing: 5.0,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 3.0),
                    ),
                    controller: _scrollController,
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(-1, -1),
                              spreadRadius: -11,
                              blurRadius: 12,
                              color: Color.fromRGBO(159, 159, 159, 1.0),
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 65,
                              child: Icon(Icons.multiple_stop_rounded,
                                  color: secondaryColor, size: 55),
                            ),
                            Text(data[index]['msg'], style: tileHeader),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget searchContract() {
    return TextFormField(
      onChanged: (value) {
        if (value.isEmpty) {
          final conId = contractIDPK == null ? null : int.parse(contractIDPK!);
          _contractController.contractApi(conId);
        } else {
          setState(() {
            _contractController.contractData.assignAll(_contractController
                .contractData
                .where((item) => item['ContractName']
                    .toLowerCase()
                    .contains(value.toLowerCase()))
                .toList());
          });
        }
      },
      controller: searchControl,
      inputFormatters: [LengthLimitingTextInputFormatter(80)],
      decoration: const InputDecoration(
        hintStyle: TextStyle(color: Color(0xFFa5a5a5)),
        border: InputBorder.none,
        hintText: 'Search',
      ),
    );
  }

  Widget searchLocation() {
    return TextFormField(
      onChanged: (value) {
        if (value.isEmpty) {
          final conId = contractIDPK == null ? null : int.parse(contractIDPK!);
          _locationControl.locationApi(conId);
        } else {
          setState(() {
            _locationControl.locationData.assignAll(_locationControl
                .locationData
                .where((item) => item['LocalityName']
                    .toLowerCase()
                    .contains(value.toLowerCase()))
                .toList());
          });
        }
      },
      controller: searchControl,
      inputFormatters: [LengthLimitingTextInputFormatter(80)],
      decoration: const InputDecoration(
        hintStyle: TextStyle(color: Color(0xFFa5a5a5)),
        border: InputBorder.none,
        hintText: 'Search',
      ),
    );
  }

  Widget searchBuilding() {
    return TextFormField(
      onChanged: (value) {
        if (value.isEmpty) {
          final conId = contractIDPK == null ? null : int.parse(contractIDPK!);
          final locId = locationIDPK == null ? null : int.parse(locationIDPK!);
          _buildingControl.buildingApi(conId, locId);
        } else {
          setState(() {
            _buildingControl.buildingData.assignAll(_buildingControl
                .buildingData
                .where((item) => item['BuildingName']
                    .toLowerCase()
                    .contains(value.toLowerCase()))
                .toList());
          });
        }
      },
      controller: searchControl,
      inputFormatters: [LengthLimitingTextInputFormatter(80)],
      decoration: const InputDecoration(
        hintStyle: TextStyle(color: Color(0xFFa5a5a5)),
        border: InputBorder.none,
        hintText: 'Search',
      ),
    );
  }

  Widget searchFloor() {
    return TextFormField(
      onChanged: (value) {
        if (value.isEmpty) {
          final conId = contractIDPK == null ? null : int.parse(contractIDPK!);
          final locId = locationIDPK == null ? null : int.parse(locationIDPK!);
          final buildingId =
              buildingIDPK == null ? null : int.parse(buildingIDPK!);
          _floorControl.floorApi(conId, locId, buildingId);
        } else {
          setState(() {
            _floorControl.floorData.assignAll(_floorControl.floorData
                .where((item) => item['FloorName']
                    .toLowerCase()
                    .contains(value.toLowerCase()))
                .toList());
          });
        }
      },
      controller: searchControl,
      inputFormatters: [LengthLimitingTextInputFormatter(80)],
      decoration: const InputDecoration(
        hintStyle: TextStyle(color: Color(0xFFa5a5a5)),
        border: InputBorder.none,
        hintText: 'Search',
      ),
    );
  }

  Widget searchSpot() {
    return TextFormField(
      onChanged: (value) {
        if (value.isEmpty) {
          final conId = contractIDPK == null ? null : int.parse(contractIDPK!);
          final locId = locationIDPK == null ? null : int.parse(locationIDPK!);
          final buildingId =
              buildingIDPK == null ? null : int.parse(buildingIDPK!);
          final floorId = floorIDPK == null ? null : int.parse(floorIDPK!);
          _spotControl.spotApi(conId, locId, buildingId, floorId);
        } else {
          setState(() {
            _spotControl.spotData.assignAll(_spotControl.spotData
                .where((item) => item['SpotName']
                    .toLowerCase()
                    .contains(value.toLowerCase()))
                .toList());
          });
        }
      },
      controller: searchControl,
      inputFormatters: [LengthLimitingTextInputFormatter(80)],
      decoration: const InputDecoration(
        hintStyle: TextStyle(color: Color(0xFFa5a5a5)),
        border: InputBorder.none,
        hintText: 'Search',
      ),
    );
  }

  Widget searchRequestType() {
    return TextFormField(
      onChanged: (value) {
        if (value.isEmpty) {
          _serviceRequestControl.serviceRequestApi();
        } else {
          setState(() {
            _serviceRequestControl.serviceReqData.assignAll(
                _serviceRequestControl.serviceReqData
                    .where((item) => item['ComplaintTypeName']
                        .toLowerCase()
                        .contains(value.toLowerCase()))
                    .toList());
          });
        }
      },
      controller: searchControl,
      inputFormatters: [LengthLimitingTextInputFormatter(80)],
      decoration: const InputDecoration(
        hintStyle: TextStyle(color: Color(0xFFa5a5a5)),
        border: InputBorder.none,
        hintText: 'Search',
      ),
    );
  }

  Widget searchDiscipline() {
    return TextFormField(
      onChanged: (value) {
        if (value.isEmpty) {
          final divisionId =
              divisionIDPK == null ? null : int.parse(divisionIDPK!);
          _disciplineControl.disciplineApi(divisionId);
        } else {
          setState(() {
            _disciplineControl.disciplineData.assignAll(_disciplineControl
                .disciplineData
                .where((item) => item['DisciplineName']
                    .toLowerCase()
                    .contains(value.toLowerCase()))
                .toList());
          });
        }
      },
      controller: searchControl,
      inputFormatters: [LengthLimitingTextInputFormatter(80)],
      decoration: const InputDecoration(
        hintStyle: TextStyle(color: Color(0xFFa5a5a5)),
        border: InputBorder.none,
        hintText: 'Search',
      ),
    );
  }

  Widget searchDepartment() {
    return TextFormField(
      onChanged: (value) {
        if (value.isEmpty) {
          _departmentControl.departmentApi();
        } else {
          setState(() {
            _departmentControl.departmentData.assignAll(_departmentControl
                .departmentData
                .where((item) => item['DepartmentName']
                    .toLowerCase()
                    .contains(value.toLowerCase()))
                .toList());
          });
        }
      },
      controller: searchControl,
      inputFormatters: [LengthLimitingTextInputFormatter(80)],
      decoration: const InputDecoration(
        hintStyle: TextStyle(color: Color(0xFFa5a5a5)),
        border: InputBorder.none,
        hintText: 'Search',
      ),
    );
  }

  Widget searchAsset() {
    return TextFormField(
      onChanged: (value) {
        if (value.isEmpty) {
          final buildingId =
          buildingIDPK == null ? null : int.parse(buildingIDPK!);
          final floorId =
          floorIDPK == null ? null : int.parse(floorIDPK!);
          final spotId = spotIDPK == null ? null : int.parse(spotIDPK!);
          final division =
          divisionIDPK == null ? null : int.parse(divisionIDPK!);
          _assetControl.assetApi(buildingId,floorId,spotId,division);
        } else {
          setState(() {
            _assetControl.assetData.assignAll(_assetControl.assetData
                .where((item) => item['AssetTagNo']
                .toLowerCase()
                .contains(value.toLowerCase()))
                .toList());
          });
        }
      },
      controller: searchControl,
      inputFormatters: [LengthLimitingTextInputFormatter(80)],
      decoration: const InputDecoration(
        hintStyle: TextStyle(color: Color(0xFFa5a5a5)),
        border: InputBorder.none,
        hintText: 'Search',
      ),
    );
  }

  Widget searchName() {
    return TextFormField(
      onChanged: (value) {
        if (value.isEmpty) {
          _nameControl.nameApi();
        } else {
          setState(() {
            _nameControl.nameData.assignAll(_nameControl.nameData
                .where((item) => item['ComplainerName']
                    .toLowerCase()
                    .contains(value.toLowerCase()))
                .toList());
          });
        }
      },
      onFieldSubmitted: (value) {
        setState(() {
          nameIDPK = null;
          nameControlText.text = value;
        });
        Navigator.pop(context);
      },
      controller: searchControl,
      inputFormatters: [LengthLimitingTextInputFormatter(80)],
      decoration: const InputDecoration(
        hintStyle: TextStyle(color: Color(0xFFa5a5a5)),
        border: InputBorder.none,
        hintText: 'Search or add new',
      ),
    );
  }

  Widget searchNature() {
    return TextFormField(
      onChanged: (value) {
        if (value.isEmpty) {
          _natureOfComplaintControl.natureOfComplaintApi(null, null);
        } else {
          setState(() {
            _natureOfComplaintControl.natureData.assignAll(
                _natureOfComplaintControl
                    .natureData
                    .where((item) => item['ComplaintNatureName']
                        .toLowerCase()
                        .contains(value.toLowerCase()))
                    .toList());
          });
        }
      },
      onFieldSubmitted: (value) {
        setState(() {
          natureOfComplaintIDPK = null;
          natureNameControl.text = value;
        });
        Navigator.pop(context);
      },
      controller: searchControl,
      inputFormatters: [LengthLimitingTextInputFormatter(80)],
      decoration: const InputDecoration(
        hintStyle: TextStyle(color: Color(0xFFa5a5a5)),
        border: InputBorder.none,
        hintText: 'Search or add new',
      ),
    );
  }

  Widget searchDivision() {
    return TextFormField(
      onChanged: (value) {
        if (value.isEmpty) {
          _divisionControl.divisionApi();
        } else {
          setState(() {
            _divisionControl.divisionData.assignAll(_divisionControl
                .divisionData
                .where((item) => item['DivisionName']
                    .toLowerCase()
                    .contains(value.toLowerCase()))
                .toList());
          });
        }
      },
      controller: searchControl,
      inputFormatters: [LengthLimitingTextInputFormatter(80)],
      decoration: const InputDecoration(
        hintStyle: TextStyle(color: Color(0xFFa5a5a5)),
        border: InputBorder.none,
        hintText: 'Search',
      ),
    );
  }

  Widget clearBtn(val) {
    return InkWell(
        onTap: () {
          setState(() {
            val = null;
          });
        },
        child: const Icon(Icons.clear, size: 14, color: red));
  }

  Widget refreshBtn() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(50, 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        primary: Colors.white,
      ),
      onPressed: () {
        clear();
      },
      icon: const Icon(Icons.autorenew_rounded, color: secondaryColor),
      label: const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text("Refresh", style: TextStyle(color: secondaryColor)),
      ),
    );
  }

  Widget saveBtn() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(50, 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        primary: secondaryColor,
      ),
      onPressed: () {
        validationFunc();
      },
      icon: const Icon(Icons.save_rounded),
      label: const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text("Save", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
