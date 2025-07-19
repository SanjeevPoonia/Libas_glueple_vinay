import 'dart:convert';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import 'dart:io';
import 'package:intl/intl.dart';

import '../views/MarkAttendanceScreen.dart';
import 'dart:ui'as ui;

class LibasCheckOutScreen extends StatefulWidget{
  final String latitude;
  final String longitude;
  final String address;
  LibasCheckOutScreen({required this.latitude,required this.longitude,required this.address});
  _libarCheckOut createState()=>_libarCheckOut();
}

class _libarCheckOut extends State<LibasCheckOutScreen>{
  final GlobalKey globalKey = new GlobalKey();
  final GlobalKey globalKeyMerchandise = new GlobalKey();
  XFile? capturedImage;
  File? capturedFile;

  XFile? capturedImageMerchandise;
  File? capturedFileMerchandise;

  var userIdStr="";
  var designationStr="";
  var token="";
  var fullNameStr="";
  var empId="";
  var baseUrl="";
  var clientCode="";
  var platform="";
  var isAttendanceAccess="1";
  var imageCaptureTime="";
  var imageCaptureTimeMerchandise="";


  var daySoldQunController = TextEditingController();
  var daySoldAmountController = TextEditingController();
  var MTDQuanController = TextEditingController();
  var MTDValController = TextEditingController();

  final _formKeyInventory = GlobalKey<FormState>();

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
        appBar: AppBar  (
          leading: IconButton(
            icon: const Icon(Icons.keyboard_arrow_left_outlined, color: Colors.black,size: 35,),
            onPressed: () => {
              Navigator.of(context).pop()
            },
          ),
          backgroundColor: AppTheme.at_details_header,
          title: const Text(
            "Check Out",
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Padding(padding: EdgeInsets.all(5),
                child: Card(
                  child: Padding(padding: EdgeInsets.only(top: 5),
                    child: Column(
                      children: [

                        Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(child: Text("Staff Image",
                                style: TextStyle(fontSize: 14.5,
                                    color: AppTheme.themeColor,
                                    fontWeight: FontWeight.w500),),),
                              InkWell(
                                onTap: (){
                                  prepairCamera();
                                },
                                child: Container(
                                  height: 25,
                                  width: 75,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: AppTheme.orangeColor,
                                    borderRadius: BorderRadius.all(Radius.circular(7)),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Capture",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12,fontWeight: FontWeight.w900,color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),),
                        SizedBox(height: 10,),
                        capturedFile==null?Center(child:Text("Please Capture Staff Image!!!",textAlign:TextAlign.center,style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w500),),):
                        RepaintBoundary(
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
                                      image: FileImage(capturedFile!),
                                      fit: BoxFit.cover
                                  ),

                                ),
                              ),
                              Positioned(
                                  bottom: 10,
                                  left: 10,
                                  child: Container(
                                    height: 45,
                                    width: 200,
                                    color: Colors.black.withOpacity(0.5),
                                    child: Column(
                                      children: [
                                        Text("${widget.latitude}-${widget.longitude}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 12),),
                                        SizedBox(height: 5,),
                                        Text(imageCaptureTime,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 12),),
                                      ],
                                    ),

                                  ))
                            ],
                          ),

                        ),

                      ],
                    ),),
                  clipBehavior: Clip.hardEdge,
                ),),
              SizedBox(height: 10,),
              Padding(padding: EdgeInsets.all(5),
                child: Card(
                  child: Padding(padding: EdgeInsets.only(top: 5),
                    child: Column(
                      children: [

                        Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(child: Text("Counter Image",
                                style: TextStyle(fontSize: 14.5,
                                    color: AppTheme.themeColor,
                                    fontWeight: FontWeight.w500),),),
                              InkWell(
                                onTap: (){
                                  prepairCameraForMerchandise();
                                },
                                child: Container(
                                  height: 25,
                                  width: 75,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: AppTheme.orangeColor,
                                    borderRadius: BorderRadius.all(Radius.circular(7)),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Capture",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12,fontWeight: FontWeight.w900,color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),),
                        SizedBox(height: 10,),
                        capturedFileMerchandise==null?Center(child:Text("Please Capture Counter Image!!!",textAlign:TextAlign.center,style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w500),),):
                        RepaintBoundary(
                          key: globalKeyMerchandise,
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 400,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                      image: FileImage(capturedFileMerchandise!),
                                      fit: BoxFit.cover
                                  ),

                                ),
                              ),
                              Positioned(
                                  bottom: 10,
                                  left: 10,
                                  child: Container(
                                    height: 45,
                                    width: 200,
                                    color: Colors.black.withOpacity(0.5),
                                    child: Column(
                                      children: [
                                        Text("${widget.latitude}-${widget.longitude}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 12),),
                                        SizedBox(height: 5,),
                                        Text(imageCaptureTimeMerchandise,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 12),),
                                      ],
                                    ),

                                  ))
                            ],
                          ),

                        ),

                      ],
                    ),),
                  clipBehavior: Clip.hardEdge,
                ),),
              SizedBox(height: 10,),
              Form(
                  key: _formKeyInventory,
                  child:Padding(padding: EdgeInsets.all(5),
                    child: Card(
                      child: Padding(padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Enter Day Sold Quantity",
                                style: TextStyle(fontSize: 14.5,
                                    color: AppTheme.themeColor,
                                    fontWeight: FontWeight.w500),),),
                            SizedBox(height: 5,),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(color: AppTheme.greyColor,width: 2.0),

                              ),
                              child: TextField(
                                minLines: 1,
                                maxLines: 1,
                                keyboardType: TextInputType.number,
                                controller: daySoldQunController,
                                decoration: InputDecoration(
                                    border: InputBorder.none
                                ),
                              ),

                            ),

                            SizedBox(height: 10,),

                            Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Enter Day Sold Amount",
                                style: TextStyle(fontSize: 14.5,
                                    color: AppTheme.themeColor,
                                    fontWeight: FontWeight.w500),),),
                            SizedBox(height: 5,),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(color: AppTheme.greyColor,width: 2.0),

                              ),
                              child: TextField(
                                minLines: 1,
                                maxLines: 1,
                                keyboardType: TextInputType.number,
                                controller: daySoldAmountController,
                                decoration: InputDecoration(
                                    border: InputBorder.none
                                ),
                              ),

                            ),

                            SizedBox(height: 10,),

                            Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Enter MTD Qty",
                                style: TextStyle(fontSize: 14.5,
                                    color: AppTheme.themeColor,
                                    fontWeight: FontWeight.w500),),),
                            SizedBox(height: 5,),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(color: AppTheme.greyColor,width: 2.0),

                              ),
                              child: TextField(
                                minLines: 1,
                                maxLines: 1,
                                keyboardType: TextInputType.number,
                                controller: MTDQuanController,
                                decoration: InputDecoration(
                                    border: InputBorder.none
                                ),
                              ),

                            ),

                            SizedBox(height: 10,),

                            Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("Enter MTD Value",
                                style: TextStyle(fontSize: 14.5,
                                    color: AppTheme.themeColor,
                                    fontWeight: FontWeight.w500),),),
                            SizedBox(height: 5,),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(color: AppTheme.greyColor,width: 2.0),

                              ),
                              child: TextField(
                                minLines: 1,
                                maxLines: 1,
                                keyboardType: TextInputType.number,
                                controller: MTDValController,
                                decoration: InputDecoration(
                                    border: InputBorder.none
                                ),
                              ),

                            ),


                          ],
                        ),),
                      clipBehavior: Clip.hardEdge,
                    ),),  ),

              SizedBox(height: 10,),
              TextButton(
                  onPressed: (){
                    checkValidation();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppTheme.orangeColor,
                    ),
                    height: 45,
                    padding: const EdgeInsets.all(10),
                    child: const Center(child: Text("Check Out",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: Colors.white),),),
                  )
              ),


            ],
          ),
        )

    );
  }

  Future<void> prepairCamera() async{

    // imageSelector(context);


    if(Platform.isAndroid){
      final imageData=await Navigator.push(context,MaterialPageRoute(builder: (context)=>MarkAttendanceScreen()));
      if(imageData!=null)
      {
        capturedImage=imageData;
        capturedFile=File(capturedImage!.path);


        var dateFormatter = DateFormat('dd MMM,yyyy hh:mm a');
        DateTime now = DateTime.now();
        imageCaptureTime = dateFormatter.format(now);


        _faceFromCamera();
      }else{
        Toast.show("Unable to capture Image. Please try Again...",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    }else{
      Toast.show("Unable to capture Image in iOS. Please try Again...",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  _faceFromCamera() async{
    APIDialog.showAlertDialog(context, "Detecting Face....");
    final image=InputImage.fromFile(capturedFile!);
    final faces=await _faceDetector.processImage(image);
    print("faces in image ${faces.length}");
    Navigator.pop(context);
    if(faces.isNotEmpty){
      setState(() {

      });
      // _showCameraImageDialog();
    }else{
      capturedFile=null;
      capturedImage=null;
      Toast.show("Face not detected in captured image. Please capture a selfie.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      _showFaceErrorCustomDialog();
      setState(() {
      });
    }
  }
  _showFaceErrorCustomDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
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
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.close_rounded,color: Colors.red,size: 20,),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text(
                      "Please capture Selfie!!!",
                      style: TextStyle(color: Colors.red,fontWeight: FontWeight.w900,fontSize: 18),),
                    SizedBox(height: 20,),

                    Text(
                      "Face not detected in captured Image. Please capture Selfie.",
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 14),),
                    SizedBox(height: 20,),
                    TextButton(
                        onPressed: (){
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
                          child: const Center(child: Text("OK",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
                        )
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
  Future<void> prepairCameraForMerchandise() async{

    // imageSelector(context);


    if(Platform.isAndroid){
      final imageData=await Navigator.push(context,MaterialPageRoute(builder: (context)=>MarkAttendanceScreen()));
      if(imageData!=null)
      {
        capturedImageMerchandise=imageData;
        capturedFileMerchandise=File(capturedImageMerchandise!.path);


        var dateFormatter = DateFormat('dd MMM,yyyy hh:mm a');
        DateTime now = DateTime.now();
        imageCaptureTimeMerchandise = dateFormatter.format(now);

        setState(() {
        });
        //_faceFromCamera();
      }else{
        Toast.show("Unable to capture Image. Please try Again...",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    }else{
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
    userIdStr=await MyUtils.getSharedPreferences("user_id")??"";
    fullNameStr=await MyUtils.getSharedPreferences("full_name")??"";
    token=await MyUtils.getSharedPreferences("token")??"";
    designationStr=await MyUtils.getSharedPreferences("designation")??"";
    empId=await MyUtils.getSharedPreferences("emp_id")??"";
    baseUrl=await MyUtils.getSharedPreferences("base_url")??"";
    clientCode=await MyUtils.getSharedPreferences("client_code")??"";
    String? access=await MyUtils.getSharedPreferences("at_access")??'1';
    isAttendanceAccess=access;
    if(Platform.isAndroid){
      platform="Android";
    }else if(Platform.isIOS){
      platform="iOS";
    }else{
      platform="Other";
    }
    print("userId:-"+userIdStr.toString());
    print("token:-"+token.toString());
    print("employee_id:-"+empId.toString());
    print("Base Url:-"+baseUrl.toString());
    print("Platform:-"+platform);
    print("Client Code:-"+clientCode);






    Navigator.of(context).pop();


  }
  checkValidation(){

    if(capturedFile!=null){
      if(capturedFileMerchandise!=null){
        if(daySoldQunController.text.isNotEmpty){
          if(daySoldAmountController.text.isNotEmpty){
            if(MTDQuanController.text.isNotEmpty){
              if(MTDValController.text.isNotEmpty){
                markOnlyAttendance("Android");
              }else{
                Toast.show("Please Enter MTD Value!!!",
                    duration: Toast.lengthLong,
                    gravity: Toast.bottom,
                    backgroundColor: Colors.red);
              }
            }else{
              Toast.show("Please Enter MTD Qty!!!",
                  duration: Toast.lengthLong,
                  gravity: Toast.bottom,
                  backgroundColor: Colors.red);
            }
          }else{
            Toast.show("Please Enter Day Sold Amount!!!",
                duration: Toast.lengthLong,
                gravity: Toast.bottom,
                backgroundColor: Colors.red);
          }
        }else{
          Toast.show("Please Enter Day Sold Quantity!!!",
              duration: Toast.lengthLong,
              gravity: Toast.bottom,
              backgroundColor: Colors.red);
        }
      }else{
        Toast.show("Please Capture Counter Image!!!",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    }else{
      Toast.show("Please Capture Staff Image!!!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  markOnlyAttendance(String from) async{
    String attendanceCheck="";
    String addressStr=widget.address;
    attendanceCheck="out";

    APIDialog.showAlertDialog(context, 'Submitting Attendance...');



    //final bytes= await File(file!.path).readAsBytesSync();
    // String base64Image="data:image/jpeg;base64,"+base64Encode(bytes);
    // print("imagePan $base64Image");
    print("Base Url $baseUrl");
    print("Check Status $attendanceCheck");
    print("emp_user_id $userIdStr");

    var requestModel = {
      "emp_user_id": userIdStr,
      "latitude":widget.latitude,
      "longitude":widget.longitude,
      "status":"status",
      "attendance_check_status":attendanceCheck,
      "attendance_type" : "attendance",
      "attendance_check_location":addressStr,
      // "capture":base64Image,
      "device":platform,
      "mac_address":"flutter",
      "other_break_time":"00:00:00:00",
      "comment":"flutter",
    };
    ApiBaseHelper apiBaseHelper=  ApiBaseHelper();
    var response = await apiBaseHelper.postAPIWithHeader(baseUrl, "attendance_management/attendanceCheckInCheckOutMobile", requestModel, context, token);

    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {

      if(responseJSON['data']['insertId']!=null){
        String id=responseJSON['data']['insertId'].toString();
        uploadOnlyImage(from, id);
      }


    }
    else if(responseJSON['code']==401|| responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

    }
    else{
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }



  }

  String uint8ListTob64(Uint8List uint8list) {
    String base64String = base64Encode(uint8list);
    String header = "data:image/png;base64,";
    return header + base64String;
  }

  uploadOnlyImage(String from,String id) async{

    APIDialog.showAlertDialog(context, "Uploading Image...");

    var bytes=null;

    RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    ui.Image image= await boundary.toImage();

    ByteData? byteData= await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? pngBytes = byteData?.buffer.asUint8List();
    final imageEnconded=uint8ListTob64(pngBytes!);



    /*if(from=='camera'){
      bytes= await File(capturedFile!.path).readAsBytesSync();
    }else{
      bytes = await File(file!.path).readAsBytesSync();
    }
    String base64Image="data:image/jpeg;base64,"+base64Encode(bytes);*/

    var requestModel = {
      "id": id,
      "capture":imageEnconded,
      "device":platform,
    };
    ApiBaseHelper apiBaseHelper=  ApiBaseHelper();
    var response = await apiBaseHelper.postAPIWithHeader(baseUrl, "attendance_management/updateImageAttendance", requestModel, context, token);
    var responseJSON = json.decode(response.body);
    Navigator.of(context).pop();
    if (responseJSON['error'] == false) {
      _showCustomDialog();
    }
    else if(responseJSON['code']==401|| responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

    }
    else{
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }


  }
  _showCustomDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
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
                        onTap: (){
                          Navigator.of(context).pop();
                          _finishScreen();
                        },
                        child: Icon(Icons.close_rounded,color: Colors.red,size: 20,),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 100,
                      width: double.infinity,
                      child: Lottie.asset("assets/att_anim.json"),
                    ),
                    SizedBox(height: 10,),
                    Align(
                      alignment: Alignment.center,
                      child: Text("Time Marked!!!",style: TextStyle(color: AppTheme.orangeColor,fontWeight: FontWeight.w900,fontSize: 18),),
                    ),
                    SizedBox(height: 20,),
                    TextButton(
                        onPressed: (){
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
                          child: const Center(child: Text("Done",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
                        )
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _finishScreen(){
    Navigator.of(context).pop();
  }
}