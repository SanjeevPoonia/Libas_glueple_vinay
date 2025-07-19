import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:ChecklistTree/network/constants.dart';
import 'package:ChecklistTree/network/loader.dart';
import 'package:camera/camera.dart';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';
import 'package:toast/toast.dart';
import 'package:video_player/video_player.dart';

import '../../../utils/app_modal.dart';
import '../../../widget/image_view_screen.dart';
import '../../../widget/textfield_widget.dart';
import '../../../widget/video_widget.dart';
import '../../store/full_video_screen.dart';
import '../../store/image_editing_screen.dart';
import '../../store/recording_screen.dart';
import '../../store/recording_view_screen.dart';
import '../../store/signature_view_screen.dart';
import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import 'dart:io';
import 'package:intl/intl.dart';

import '../views/MarkAttendanceScreen.dart';
import 'dart:ui' as ui;
import 'package:ChecklistTree/network/api_helper.dart' as libas;

import '../views/capture_image.dart';

class LibasCheckIn extends StatefulWidget {
  final String latitude;
  final String longitude;
  final String address;
  bool checkIN;

  LibasCheckIn(
      {required this.latitude,
      required this.longitude,
      required this.address,
      required this.checkIN});

  _libasCheckIn createState() => _libasCheckIn();
}

class _libasCheckIn extends State<LibasCheckIn> {
  final GlobalKey globalKey = new GlobalKey();
  final GlobalKey globalKeyMerchandise = new GlobalKey();
  XFile? capturedImage;
  File? capturedFile;

  XFile? capturedImageMerchandise;
  File? capturedFileMerchandise;
  List<dynamic> quizList = [];

  var userIdStr = "";
  var designationStr = "";
  bool isLoading = false;
  var token = "";
  var fullNameStr = "";
  var empId = "";
  var baseUrl = "";
  var clientCode = "";
  var platform = "";
  var isAttendanceAccess = "1";
  var imageCaptureTime = "";
  var imageCaptureTimeMerchandise = "";

  var openInventory = TextEditingController();
  final _formKeyInventory = GlobalKey<FormState>();

  int selectedRadioIndex = 9999;
  String audioBaseUrl = "";
  String imageURl = "";
  List<String> imageUrlList = [];
  List<TextEditingController> controllerList = [];
  List<String> videoUrlList = [];
  List<String> signatureUrlList = [];
  List<String> audioUrlList = [];
  List<File?> selectedFile = [];
  VideoPlayerOptions videoPlayerOptions =
      VideoPlayerOptions(mixWithOthers: true);
  String voiceURl = "";
  bool pageNavigator = false;
  bool check = false;
  String voiceNoteUrl = "";
  int _start = 120;
  List<int> checkList = [];
  List<dynamic> answerList = [];
  Timer? _timer;
  Map<String, dynamic> trainingData = {};
  int currentQuestionIndex = 0;
  String imageBaseUrl = "";
  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  XFile? selectedImage;
  File? selectedAudio;
  int attemptCount = 0;
  double percentage = 0.0;

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.blue,
    exportBackgroundColor: Colors.transparent,
    exportPenColor: Colors.black,
  );

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_left_outlined,
              color: Colors.black,
              size: 35,
            ),
            onPressed: () => {Navigator.of(context).pop()},
          ),
          backgroundColor: AppTheme.at_details_header,
          title: Text(
            widget.checkIN ? "Check In" : "Check Out",
            style: TextStyle(
                fontSize: 18.5,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          /*actions: [IconButton(onPressed: (){
              _showAlertDialog();

            }, icon: SvgPicture.asset("assets/logout.svg"))] ,*/
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: isLoading
            ? Center(child: Loader())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Card(
                        child: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Your Image",
                                          style: TextStyle(
                                              fontSize: 14.5,
                                              color: AppTheme.themeColor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          prepairCamera();
                                        },
                                        child: Container(
                                          height: 25,
                                          width: 75,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: AppTheme.orangeColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7)),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "Capture",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                capturedFile == null
                                    ? Center(
                                        child: Text(
                                          "Please capture your image!!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )
                                    : RepaintBoundary(
                                        key: globalKey,
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: 400,
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                shape: BoxShape.rectangle,
                                                image: DecorationImage(
                                                    image: FileImage(
                                                        capturedFile!),
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                            Positioned(
                                                bottom: 10,
                                                left: 10,
                                                child: Container(
                                                  height: 45,
                                                  width: 200,
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "${widget.latitude}-${widget.longitude}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        imageCaptureTime,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                              ],
                            )),
                        clipBehavior: Clip.hardEdge,
                      ),
                    ),
                    SizedBox(height: 10),

                    // Implement Checkliost

                    ListView.builder(
                        itemCount: quizList.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int pos) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 3),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 13, right: 10),
                                child: Text(
                                  'Q' +
                                      (pos + 1).toString() +
                                      ". " +
                                      quizList[pos]["question"],
                                  style: TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  quizList[pos]["image"].toString() == "1"
                                      ? SizedBox(width: 15)
                                      : Container(),
                                  quizList[pos]["image"].toString() == "1"
                                      ? GestureDetector(
                                          onTap: () {
                                            if (Platform.isAndroid) {
                                              _openAndroidCamera(context, pos);
                                            } else {
                                              _fetchImage(context, pos);
                                            }
                                          },
                                          child: Icon(Icons.camera_alt,
                                              size: 32,
                                              color: AppTheme.orangeColor))
                                      : Container(),
                                  quizList[pos]["audio"].toString() == "1"
                                      ? SizedBox(width: 15)
                                      : Container(),
                                  quizList[pos]["audio"].toString() == "1"
                                      ? GestureDetector(
                                          onTap: () async {
                                            final data = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RecordAudioScreen()));

                                            if (data != null) {
                                              selectedAudio = File(data);
                                              selectedFile[pos] = selectedAudio;
                                              print(selectedAudio.toString() +
                                                  "*****");
                                              uploadImage("2", pos);
                                            }

/*
                                              if (data != null) {
                                                selectedAudio = File(data);
                                                selectedFile[pos]=selectedAudio;
                                                print(selectedAudio.toString()+"*****");
                                                uploadImage("2",pos);
                                              }*/
                                          },
                                          child: Icon(Icons.mic,
                                              size: 32,
                                              color: AppTheme.orangeColor))
                                      : Container(),
                                  quizList[pos]["video"].toString() == "1"
                                      ? SizedBox(width: 15)
                                      : Container(),
                                  quizList[pos]["video"].toString() == "1"
                                      ? GestureDetector(
                                          child: Icon(Icons.video_call_sharp,
                                              size: 32,
                                              color: AppTheme.orangeColor),
                                          onTap: () {
                                            _fetchVideo(context, pos);
                                          },
                                        )
                                      : Container(),
                                  quizList[pos]["e_signature"].toString() == "1"
                                      ? SizedBox(width: 15)
                                      : Container(),
                                  quizList[pos]["e_signature"].toString() == "1"
                                      ? GestureDetector(
                                          onTap: () {
                                            _controller.clear();
                                            setState(() {});

                                            signatureDialog(context, pos);
                                          },
                                          child: Image.asset(
                                              "assets/signature.png",
                                              width: 32,
                                              height: 32,
                                              color: AppTheme.orangeColor))
                                      : Container()
                                ],
                              ),
                              SizedBox(height: 10),
                              quizList[pos]["video"].toString() == "1" &&
                                      videoUrlList[pos] != ""
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FullVideoScreen(
                                                        videoUrlList[pos])));
                                      },
                                      child: Container(
                                        height: 90,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 13, vertical: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Color(0xFFFFF1E4),
                                            border: Border.all(
                                                color: Color(0xFF707070),
                                                width: 0.3)),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              width: 130,
                                              height: 72,
                                              child: VideoWidget(
                                                  url: videoUrlList[pos],
                                                  play: false,
                                                  loaderColor:
                                                      AppTheme.themeColor),
                                            ),
                                            Expanded(
                                                child: Text(
                                              videoUrlList[pos].split('/').last,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF708096),
                                              ),
                                            ))
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),
                              quizList[pos]["audio"].toString() == "1" &&
                                      audioUrlList[pos] != ""
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RecordingView(
                                                        audioUrlList[pos])));
                                      },
                                      child: Container(
                                        height: 90,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 13, vertical: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Color(0xFFFFF1E4),
                                            border: Border.all(
                                                color: Color(0xFF707070),
                                                width: 0.3)),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              width: 130,
                                              height: 72,
                                              child: Image.asset(
                                                  "assets/audio.png",
                                                  width: 130,
                                                  height: 72),
                                            ),
                                            Expanded(
                                                child: Text(
                                              audioUrlList[pos].split('/').last,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF708096),
                                              ),
                                            ))
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),
                              quizList[pos]["image"].toString() == "1" &&
                                      imageUrlList[pos] != ""
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ImageView(
                                                    imageUrlList[pos])));
                                      },
                                      child: Container(
                                        height: 90,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 13, vertical: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Color(0xFFFFF1E4),
                                            border: Border.all(
                                                color: Color(0xFF707070),
                                                width: 0.3)),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Image.network(
                                                  imageUrlList[pos],
                                                  width: 130,
                                                  height: 72),
                                            ),
                                            Expanded(
                                                child: Text(
                                              imageUrlList[pos].split('/').last,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF708096),
                                              ),
                                            ))
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),
                              quizList[pos]["e_signature"].toString() == "1" &&
                                      signatureUrlList[pos] != ""
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignatureView(
                                                        signatureUrlList[
                                                            pos])));
                                      },
                                      child: Container(
                                        height: 90,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 13, vertical: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: Color(0xFFFFF1E4),
                                            border: Border.all(
                                                color: Color(0xFF707070),
                                                width: 0.3)),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Container(
                                                width: 130,
                                                height: 72,
                                                color: Colors.white,
                                                child: Image.network(
                                                    signatureUrlList[pos],
                                                    width: 130,
                                                    height: 72),
                                              ),
                                            ),
                                            Expanded(
                                                child: Text(
                                              signatureUrlList[pos]
                                                  .split('/')
                                                  .last,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF708096),
                                              ),
                                            ))
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),
                              quizList[pos]["remark"].toString() == "1"
                                  ? SizedBox(height: 5)
                                  : Container(),
                              quizList[pos]["remark"].toString() == "1"
                                  ? Container(
                                      child: TextFieldWidget(
                                          "Remark", "Enter Remark",
                                          controller: controllerList[pos]),
                                    )
                                  : Container(),
                              quizList[pos]["remark"].toString() == "1"
                                  ? SizedBox(height: 15)
                                  : Container(),
                              pos == quizList.length - 1
                                  ? Container()
                                  : Container(
                                      child: Divider(
                                          color: Colors.grey.withOpacity(0.4)),
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 13))
                            ],
                          );
                        }),

                    TextButton(
                        onPressed: () {
                          checkImage();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.orangeColor,
                          ),
                          height: 45,
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              widget.checkIN ? "Check IN" : "Check Out",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                        )),
                  ],
                ),
              ));
  }

  Future<void> prepairCamera() async {
    // imageSelector(context);

    if (Platform.isAndroid) {
      final imageData = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => MarkAttendanceScreen()));
      if (imageData != null) {
        capturedImage = imageData;
        capturedFile = File(capturedImage!.path);

        var dateFormatter = DateFormat('dd MMM,yyyy hh:mm a');
        DateTime now = DateTime.now();
        imageCaptureTime = dateFormatter.format(now);

        _faceFromCamera();
      } else {
        Toast.show("Unable to capture Image. Please try Again...",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    } else {
      _fetchImageForCheckin(context);
    }
  }

  _faceFromCamera() async {
    APIDialog.showAlertDialog(context, "Detecting Face....");
    final image = InputImage.fromFile(capturedFile!);
    final faces = await _faceDetector.processImage(image);
    print("faces in image ${faces.length}");
    Navigator.pop(context);
    if (faces.isNotEmpty) {
      setState(() {});
      // _showCameraImageDialog();
    } else {
      capturedFile = null;
      capturedImage = null;
      Toast.show(
          "Face not detected in captured image. Please capture a selfie.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      _showFaceErrorCustomDialog();
      setState(() {});
    }
  }

  _showFaceErrorCustomDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Please capture Selfie!!!",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w900,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Face not detected in captured Image. Please capture Selfie.",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 14),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          //call attendance punch in or out
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.themeColor,
                          ),
                          height: 45,
                          padding: const EdgeInsets.all(10),
                          child: const Center(
                            child: Text(
                              "OK",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> prepairCameraForMerchandise() async {
    // imageSelector(context);

    if (Platform.isAndroid) {
      final imageData = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => MarkAttendanceScreen()));
      if (imageData != null) {
        capturedImageMerchandise = imageData;
        capturedFileMerchandise = File(capturedImageMerchandise!.path);

        var dateFormatter = DateFormat('dd MMM,yyyy hh:mm a');
        DateTime now = DateTime.now();
        imageCaptureTimeMerchandise = dateFormatter.format(now);

        setState(() {});
        //_faceFromCamera();
      } else {
        Toast.show("Unable to capture Image. Please try Again...",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    } else {
      Toast.show("Unable to capture Image in iOS. Please try Again...",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      _getDashboardData();
    });
  }

  _getDashboardData() async {
    APIDialog.showAlertDialog(context, 'Please Wait...');
    userIdStr = await MyUtils.getSharedPreferences("user_id") ?? "";
    fullNameStr = await MyUtils.getSharedPreferences("full_name") ?? "";
    token = await MyUtils.getSharedPreferences("token") ?? "";
    designationStr = await MyUtils.getSharedPreferences("designation") ?? "";
    empId = await MyUtils.getSharedPreferences("emp_id") ?? "";
    baseUrl = await MyUtils.getSharedPreferences("base_url") ?? "";
    clientCode = await MyUtils.getSharedPreferences("client_code") ?? "";
    String? access = await MyUtils.getSharedPreferences("at_access") ?? '1';
    isAttendanceAccess = access;
    if (Platform.isAndroid) {
      platform = "Android";
    } else if (Platform.isIOS) {
      platform = "iOS";
    } else {
      platform = "Other";
    }
    print("userId:-" + userIdStr.toString());
    print("token:-" + token.toString());
    print("employee_id:-" + empId.toString());
    print("Base Url:-" + baseUrl.toString());
    print("Platform:-" + platform);
    print("Client Code:-" + clientCode);

    Navigator.of(context).pop();

    fetchQuizForTasks(context);
  }

  checkValidation() {
    if (capturedFile != null) {
      if (capturedFileMerchandise != null) {
        if (openInventory.text.isNotEmpty) {
          markOnlyAttendance("Android");
        } else {
          Toast.show("Please Enter Open Inventory!!!",
              duration: Toast.lengthLong,
              gravity: Toast.bottom,
              backgroundColor: Colors.red);
        }
      } else {
        Toast.show("Please Capture Visual Merchandise Image!!!",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    } else {
      Toast.show("Please Capture Staff Image!!!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  markOnlyAttendance(String from) async {
    String attendanceCheck = "";
    String addressStr = widget.address;
    attendanceCheck = "in";

    APIDialog.showAlertDialog(context, 'Submitting Attendance...');

    //final bytes= await File(file!.path).readAsBytesSync();
    // String base64Image="data:image/jpeg;base64,"+base64Encode(bytes);
    // print("imagePan $base64Image");
    print("Base Url $baseUrl");
    print("Check Status $attendanceCheck");
    print("emp_user_id $userIdStr");

    var requestModel = {
      "emp_user_id": userIdStr,
      "latitude": widget.latitude,
      "longitude": widget.longitude,
      "status": "status",
      "attendance_check_status": attendanceCheck,
      "attendance_type": "attendance",
      "attendance_check_location": addressStr,
      // "capture":base64Image,
      "device": platform,
      "mac_address": "flutter",
      "other_break_time": "00:00:00:00",
      "comment": "flutter",
    };
    ApiBaseHelper apiBaseHelper = ApiBaseHelper();
    var response = await apiBaseHelper.postAPIWithHeader(
        baseUrl,
        "attendance_management/attendanceCheckInCheckOutMobile",
        requestModel,
        context,
        token);

    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      if (responseJSON['data']['insertId'] != null) {
        String id = responseJSON['data']['insertId'].toString();
        uploadOnlyImage(from, id);
      }
    } else if (responseJSON['code'] == 401 ||
        responseJSON['message'] == 'Invalid token.') {
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  fetchQuizForTasks(BuildContext context) async {
    String? authKey = await MyUtils.getSharedPreferences("access_token");
    String? glupleToken = await MyUtils.getSharedPreferences("token") ?? "";
    setState(() {
      isLoading = true;
    });
    //0 incomplete
    var data = {
      "auth_key": authKey,
      "glueple_token": glupleToken,
      "type": widget.checkIN ? "check_in" : "check_out"
    };
    print(data);

    libas.ApiBaseHelper helper = libas.ApiBaseHelper();
    var response =
        await helper.postAPI('get_checkin_checkout_questions', data, context);
    var responseJSON = json.decode(response.body);

    setState(() {
      isLoading = false;
    });
    quizList = responseJSON["questions"];
    for (int i = 0; i < quizList.length; i++) {
      imageUrlList.add("");
      videoUrlList.add("");
      signatureUrlList.add("");
      audioUrlList.add("");
      selectedFile.add(null);
      controllerList.add(TextEditingController(text: ""));
    }
    setState(() {});

    print(responseJSON);

    // quizList = responseJSON["taskData"];
  }

  String uint8ListTob64(Uint8List uint8list) {
    String base64String = base64Encode(uint8list);
    String header = "data:image/png;base64,";
    return header + base64String;
  }

  uploadOnlyImage(String from, String id) async {
    APIDialog.showAlertDialog(context, "Uploading Image...");

    var bytes = null;

    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? pngBytes = byteData?.buffer.asUint8List();
    final imageEnconded = uint8ListTob64(pngBytes!);

    /*if(from=='camera'){
      bytes= await File(capturedFile!.path).readAsBytesSync();
    }else{
      bytes = await File(file!.path).readAsBytesSync();
    }
    String base64Image="data:image/jpeg;base64,"+base64Encode(bytes);*/

    var requestModel = {
      "id": id,
      "capture": imageEnconded,
      "device": platform,
    };
    ApiBaseHelper apiBaseHelper = ApiBaseHelper();
    var response = await apiBaseHelper.postAPIWithHeader(
        baseUrl,
        "attendance_management/updateImageAttendance",
        requestModel,
        context,
        token);
    var responseJSON = json.decode(response.body);
    Navigator.of(context).pop();
    if (responseJSON['error'] == false) {
      _showCustomDialog();
    } else if (responseJSON['code'] == 401 ||
        responseJSON['message'] == 'Invalid token.') {
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  _showCustomDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          _finishScreen();
                        },
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 100,
                      width: double.infinity,
                      child: Lottie.asset("assets/att_anim.json"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Time Marked!!!",
                        style: TextStyle(
                            color: AppTheme.orangeColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _finishScreen();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.themeColor,
                          ),
                          height: 45,
                          padding: const EdgeInsets.all(10),
                          child: const Center(
                            child: Text(
                              "Done",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }

  submitSingleQuestion(BuildContext context) async {
    String? authKey = await MyUtils.getSharedPreferences("access_token");
    String? userID = await MyUtils.getSharedPreferences("user_id_libas");
    APIDialog.showAlertDialog(context, "Please wait...");
    //0 incomplete
    /* var data = {
      "auth_key": authKey,
      "question_id": quizList[pos]["id"].toString(),
      "emp_id": userID,
      "answer": "1",
      "remark":controllerList[pos].text.toString()
    };
    print(data);*/

    List<dynamic> finalAnswerList = [];

    for (int i = 0; i < quizList.length; i++) {
      finalAnswerList.add({
        "question_id": quizList[i]["id"].toString(),
        "answer": "1",
        "remark": controllerList[i].text.toString()
      });
    }

    //0 incomplete
    var data = {
      "auth_key": authKey,
      "emp_id": userID,
      "parameter": finalAnswerList
    };
    print(data);

    libas.ApiBaseHelper helper = libas.ApiBaseHelper();
    var response =
        await helper.postAPI('save_answer_checkin_checkout', data, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);

    if (responseJSON["status"] == 1) {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      print("Capture image path " + capturedFile!.path.toString());

      Navigator.pop(context, capturedFile);
    }

    print(responseJSON);
    setState(() {});

    // quizList = responseJSON["taskData"];
  }

  _fetchImage(BuildContext context22, int pos) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    print('Image File From Android' + (image?.path).toString());
    if (image != null) {
      selectedFile[pos] = File(image.path);
      setState(() {});
      imagePreviewDialog(context, pos);
      // uploadImage();
    }
  }

  _fetchImageForCheckin(BuildContext context22) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    print('Image File From Android' + (image?.path).toString());
    if (image != null) {
      capturedImage = image;
      capturedFile = File(capturedImage!.path.toString());
      setState(() {});
      // imagePreviewDialog(context,pos);
      // uploadImage();
    }
  }

  _openAndroidCamera(BuildContext context22, int pos) async {
    final imageData = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => CaptureCameraScreen()));
    if (imageData != null) {
      selectedFile[pos] = File(imageData.path.toString());
      setState(() {});
      imagePreviewDialog(context, pos);
    }
  }

  _fetchVideo(BuildContext context, int pos) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
    print('Image File From Android' + (video?.path).toString());
    if (video != null) {
      selectedFile[pos] = File(video.path);
      setState(() {});
      previewVideoDialog(context, pos);
      // uploadImage();
    }
  }

  Future<void> previewVideoDialog(BuildContext context, int index) async {
    VideoPlayerController? _controller;
    final chewieController;
    VideoPlayerOptions videoPlayerOptions =
        VideoPlayerOptions(mixWithOthers: true);
    _controller = VideoPlayerController.file(File(selectedFile[index]!.path));
    await _controller.initialize();

    chewieController = await ChewieController(
      videoPlayerController: _controller,
      autoPlay: false,
      looping: false,
    );
    setState(() {});

    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 407,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: const Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text('Upload Video',
                                style: TextStyle(
                                    fontSize: 15.5,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close, size: 22),

                            /*Image.asset(
                                      'assets/close_icc.png',
                                      width: 20,
                                      height: 20,
                                      color: Colors.black,
                                    )*/
                          ),
                          const SizedBox(width: 10)
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                        child: Container(
                      height: 240,
                      child: Chewie(
                        controller: chewieController,
                      ),
                    )),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        SizedBox(width: 15),
                        Expanded(
                            child: Card(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(5)),
                                    height: 49,
                                    child: const Center(
                                      child: Text('Cancel',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white)),
                                    )),
                              ),
                            ),
                            flex: 1),
                        SizedBox(width: 20),
                        Expanded(
                            child: Card(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  uploadImage("3", index);
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: AppTheme.themeColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    height: 49,
                                    child: const Center(
                                      child: Text('Upload',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white)),
                                    )),
                              ),
                            ),
                            flex: 1),
                        SizedBox(width: 15),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  Future<void> signatureDialog(BuildContext context, int index) async {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 410,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: const Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text('Upload signature',
                                style: TextStyle(
                                    fontSize: 15.5,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close, size: 22),

                            /*Image.asset(
                                      'assets/close_icc.png',
                                      width: 20,
                                      height: 20,
                                      color: Colors.black,
                                    )*/
                          ),
                          const SizedBox(width: 10)
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Signature(
                      key: const Key('signature'),
                      controller: _controller,
                      height: 200,
                      backgroundColor: Colors.grey[100]!,
                    ),
                    Row(
                      children: [
                        IconButton(
                          key: const Key('exportPNG'),
                          icon: const Icon(Icons.check_circle_outline),
                          color: AppTheme.themeColor,
                          onPressed: () => exportImage(context, index),
                          tooltip: 'Export Image',
                        ),
                        IconButton(
                          icon: const Icon(Icons.undo),
                          color: Colors.blue,
                          onPressed: () {
                            setState(() => _controller.undo());
                          },
                          tooltip: 'Undo',
                        ),
                        IconButton(
                          icon: const Icon(Icons.redo),
                          color: Colors.blue,
                          onPressed: () {
                            setState(() => _controller.redo());
                          },
                          tooltip: 'Redo',
                        ),
                        IconButton(
                          key: const Key('clear'),
                          icon: const Icon(Icons.clear_rounded),
                          color: Colors.red,
                          onPressed: () {
                            setState(() => _controller.clear());
                          },
                          tooltip: 'Clear',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: 15),
                        Expanded(
                            child: Card(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(5)),
                                    height: 49,
                                    child: const Center(
                                      child: Text('Cancel',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white)),
                                    )),
                              ),
                            ),
                            flex: 1),
                        SizedBox(width: 20),
                        Expanded(
                            child: Card(
                              child: InkWell(
                                onTap: () {
                                  if (selectedFile[index] == null) {
                                    Toast.show(
                                        "Please save your signature first",
                                        duration: Toast.lengthLong,
                                        gravity: Toast.bottom,
                                        backgroundColor: Colors.green);
                                  } else {
                                    print(selectedFile[index]!.path.toString());

                                    Navigator.pop(context);

                                    uploadImage("4", index);

                                    /*  Navigator.pop(context);
                                      uploadImage("1",index);*/
                                  }
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: AppTheme.themeColor,
                                        borderRadius: BorderRadius.circular(5)),
                                    height: 49,
                                    child: const Center(
                                      child: Text('Upload',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white)),
                                    )),
                              ),
                            ),
                            flex: 1),
                        SizedBox(width: 15),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  void imagePreviewDialog(BuildContext context, int pos) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, dialogState) {
            return AlertDialog(
                insetPadding: const EdgeInsets.all(10),
                scrollable: true,
                contentPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                //this right here
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: const Color(0xFFF3F3F3),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text('Upload Image',
                                    style: TextStyle(
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black)),
                              ),
                              // const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Icon(Icons.close, size: 22),
                                ),

                                /*Image.asset(
                                    'assets/close_icc.png',
                                    width: 20,
                                    height: 20,
                                    color: Colors.black,
                                  )*/
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 13),
                        Center(
                          child: SizedBox(
                            height: 170,
                            child: Image.file(
                                File(selectedFile[pos]!.path.toString())),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Row(
                          children: [
                            SizedBox(width: 15),
                            Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    final data = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ImageEditScreen(
                                                    selectedFile[pos]!)));

                                    print(AppModel.temFilePath);
                                    if (AppModel.temFilePath != "") {
                                      Navigator.pop(context);
                                      print("The File path is" +
                                          AppModel.temFilePath.toString());
                                      selectedFile[pos] =
                                          File(AppModel.temFilePath.toString());
                                      AppModel.setTempFilePath("");
                                      setState(() {});
                                      imagePreviewDialog(context, pos);
                                    }
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xFF577B8D),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      height: 49,
                                      child: const Center(
                                        child: Text('Edit',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                      )),
                                ),
                                flex: 1),
                            SizedBox(width: 20),
                            Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    uploadImage("1", pos);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: AppTheme.themeColor,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      height: 49,
                                      child: const Center(
                                        child: Text('Upload',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                      )),
                                ),
                                flex: 1),
                            SizedBox(width: 15),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ],
                ));
          });
        });
  }

  Future<void> exportImage(BuildContext context, int pos) async {
    if (_controller.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          key: Key('snackbarPNG'),
          content: Text('No content'),
        ),
      );
      return;
    }

    final Uint8List? data =
        await _controller.toPngBytes(height: 200, width: 500);
    Random random = new Random();
    int randomNumber = random.nextInt(100);
    String randomName = "digitalSign$randomNumber.png";
    if (kDebugMode) {
      print(randomName);
    }

    final tempDirectory = await getTemporaryDirectory();
    File files = await File('${tempDirectory.path}/$randomName').create();
    files.writeAsBytesSync(data!);

    setState(() {
      selectedFile[pos] = files;
    });
  }

  uploadImage(String fileType, int pos) async {
    APIDialog.showAlertDialog(context, 'Uploading File...');
    String? authKey = await MyUtils.getSharedPreferences("access_token");
    String? userID = await MyUtils.getSharedPreferences("user_id_libas");
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(selectedFile[pos]!.path),
      "file_type": fileType,
      "Orignal_Name": selectedFile[pos]!.path.split('/').last,
      "fileCount": "1",
      "auth_key": authKey,
      "emp_id": userID,
      "question_id": quizList[pos]["id"].toString(),
      "remark": "",
    });

    print("Fields are " + formData.fields.toString());

    Dio dio = Dio();
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers['Authorization'] = AppModel.token;
    print(AppConstant.appBaseURL + "save_answer_checkin_checkout_artifects");

    try {
      var response = await dio.post(
          AppConstant.appBaseURL + "save_answer_checkin_checkout_artifects",
          data: formData);
      print(response.data);
      //var responseJSON = jsonDecode(response.data);
      Navigator.pop(context);
      if (response.data['status'].toString() == "1") {
        Toast.show(response.data['message'].toString(),
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.green);

        if (fileType == "1") {
          imageUrlList[pos] = response.data["image_url"] ?? "";
        } else if (fileType == "2") {
          audioUrlList[pos] = response.data["voice_url"] ?? "";
        } else if (fileType == "3") {
          videoUrlList[pos] = response.data["video_url"] ?? "";
        } else if (fileType == "4") {
          signatureUrlList[pos] = response.data["signature_url"] ?? "";
        }

        setState(() {});
      } else {
        Toast.show(response.data['message'].toString(),
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    } catch (e) {
      if (e is DioException) {
        print(e.message);
        Navigator.pop(context);
        Toast.show("Something went wrong!",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
      //handle DioError here by error type or by error code

      else {
        print("Block 2");

        Navigator.pop(context);
        Toast.show("Something went wrong!",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    }
  }

  checkVideo() {
    bool videoFlag = false;

    for (int i = 0; i < quizList.length; i++) {
      if (quizList[i]["video"].toString() == "1") {
        if (videoUrlList[i] == "") {
          Toast.show("Please upload a video for Question " + (i + 1).toString(),
              duration: Toast.lengthLong,
              gravity: Toast.bottom,
              backgroundColor: Colors.red);
          videoFlag = true;
          break;
        }
      }
    }

    if (!videoFlag) {
      checkAudio();
    }
  }

  checkSignature() {
    bool signatureFlag = false;
    for (int i = 0; i < quizList.length; i++) {
      if (quizList[i]["e_signature"].toString() == "1") {
        if (signatureUrlList[i] == "") {
          Toast.show(
              "Please upload a signature for Question " + (i + 1).toString(),
              duration: Toast.lengthLong,
              gravity: Toast.bottom,
              backgroundColor: Colors.red);
          signatureFlag = false;

          break;
        }
      }
    }

    if (!signatureFlag) {
      if (capturedFile == null) {
        Toast.show("Please upload staff image!",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      } else {
        submitSingleQuestion(context);
      }

      print("All Clear");
    }
  }

  checkAudio() {
    bool audioFlag = false;

    for (int i = 0; i < quizList.length; i++) {
      if (quizList[i]["audio"].toString() == "1") {
        if (audioUrlList[i] == "") {
          Toast.show(
              "Please upload a audio recording for Question " +
                  (i + 1).toString(),
              duration: Toast.lengthLong,
              gravity: Toast.bottom,
              backgroundColor: Colors.red);
          audioFlag = true;
          break;
        }
      }
    }

    if (!audioFlag) {
      // submitAllQuestions(context);
      checkRemarks();
    }
  }

  checkRemarks() {
    bool remarkFlag = false;

    for (int i = 0; i < quizList.length; i++) {
      if (quizList[i]["remark"].toString() == "1") {
        if (controllerList[i].text == "") {
          Toast.show("Please add a remark for Question " + (i + 1).toString(),
              duration: Toast.lengthLong,
              gravity: Toast.bottom,
              backgroundColor: Colors.red);
          remarkFlag = true;
          break;
        }
      }
    }

    if (!remarkFlag) {
      // submitAllQuestions(context);
      checkSignature();
    }
  }

  checkImage() {
    bool imageFlag = false;

    for (int i = 0; i < quizList.length; i++) {
      if (quizList[i]["image"].toString() == "1") {
        if (imageUrlList[i] == "") {
          Toast.show("Please upload image for Question " + (i + 1).toString(),
              duration: Toast.lengthLong,
              gravity: Toast.bottom,
              backgroundColor: Colors.red);
          imageFlag = true;
          break;
        }
      }
    }

    if (!imageFlag) {
      checkVideo();
    }
  }

  _finishScreen() {
    Navigator.of(context).pop();
  }
}
