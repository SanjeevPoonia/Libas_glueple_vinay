import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ChecklistTree/views/store/full_video_screen.dart';
import 'package:ChecklistTree/views/store/recording_screen.dart';
import 'package:ChecklistTree/widget/loader.dart';
import 'package:ChecklistTree/widget/textfield_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signature/signature.dart';
import 'package:toast/toast.dart';
import 'package:video_player/video_player.dart';

import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../network/constants.dart';
import '../../utils/app_modal.dart';
import '../../utils/app_theme.dart';
import '../../widget/appbar_widget.dart';
import '../../widget/image_view_screen.dart';
import '../gluple/views/MarkAttendanceScreen.dart';
import '../gluple/views/capture_image.dart';
import '../store/recording_view_screen.dart';
import '../store/signature_view_screen.dart';
import '../../widget/video_widget.dart';
import '../store/image_editing_screen.dart';

class MCQTest1Screen extends StatefulWidget {
  final bool isDraftedTask;
  final String taskID;
  final String subTaskID;

  MCQTest1Screen(this.taskID, this.subTaskID,this.isDraftedTask);

  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<MCQTest1Screen> {
  int selectedRadioIndex = 9999;
  String audioBaseUrl="";
  String imageURl = "";
  List<String> imageUrlList=[];
  List<TextEditingController> controllerList=[];
  List<String> videoUrlList=[];
  List<String> signatureUrlList=[];
  List<String> audioUrlList=[];
  List<File?> selectedFile=[];
  VideoPlayerOptions videoPlayerOptions = VideoPlayerOptions(mixWithOthers: true);
  String voiceURl = "";
  bool pageNavigator = false;
  bool check = false;
  String voiceNoteUrl = "";
  int _start = 120;
  List<int> checkList = [];
  List<dynamic> answerList = [];
  Timer? _timer;
  List<int> selectedOption=[];
  bool isLoading = false;
  Map<String, dynamic> trainingData = {};
  int currentQuestionIndex = 0;
  String imageBaseUrl="";
  String videoBaseUrl="";
  String signatureBaseUrl="";
  List<dynamic> quizList = [];
  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  XFile? selectedImage;
  File? selectedAudio;
  int attemptCount=0;
  double percentage=0.0;

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.blue,
    exportBackgroundColor: Colors.transparent,
    exportPenColor: Colors.black,
  );



  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [

                voiceNoteUrl!=""?

                InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RecordingView(voiceNoteUrl)));
                  },
                  child: Container(
                    height: 125,
                    padding: EdgeInsets.only(top: 65),
                    color: AppTheme.orangeColor.withOpacity(0.5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Image.asset("assets/music_ic.png",width: 25,height: 25),

                        SizedBox(width: 10),

                        Text(
                          'View Audio Instruction',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),

                        ),



                      ],
                    ),
                  ),
                ):Container(),




                voiceNoteUrl!=""?
                AppBarWidget2("Task Details"):AppBarWidget("Task Details"),
              ],
            ),
            Expanded(
                child: isLoading
                    ? Center(
                        child: Loader(),
                      )
                    : ListView(

                        children: [

                          SizedBox(height: 10),





                          Row(
                            children: [
                              SizedBox(width: 15),

                             // Spacer(),

                              Column(

                                children: [

                                  Text(
                                    'Ques. Attempted',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),

                                  ),






                                   Container(
                                     width: 100,
                                     height: 120,
                                     child: CircularPercentIndicator(
                                      radius: 50.0,
                                      animation: true,
                                      animationDuration: 1200,
                                      lineWidth: 15.0,
                                      percent: percentage,
                                      center:    Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            attemptCount.toString()+"/",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black
                                            ),

                                          ),

                                          Text(
                                            quizList.length.toString(),
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black
                                            ),

                                          ),

                                        ],
                                      ),
                                      circularStrokeCap: CircularStrokeCap.butt,
                                      backgroundColor: Colors.grey.withOpacity(0.6),
                                      progressColor: Colors.green,
                                                                       ),
                                   ),





                                ],
                              ),



                            ],
                          ),






                          SizedBox(height: 5),

                          ListView.builder(
                              itemCount: quizList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context,int pos)

                              {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    SizedBox(height: 3),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 13, right: 10),
                                      child: Text(
                                        'Q' +
                                            (pos + 1).toString()+". "+
                                        quizList[pos]["question"],
                                        style: TextStyle(
                                          fontSize: 15.5,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontStyle: FontStyle.italic
                                        ),

                                      ),
                                    ),
                                    SizedBox(height: 12),

                                    ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: 2,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (BuildContext context, int pos22) {
                                          return Column(
                                            children: [
                                              Container(
                                                height: 46,
                                                margin:
                                                EdgeInsets.symmetric(horizontal: 13),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(4),
                                                    color: Color(0xFFF2F2F2),
                                                    border: Border.all(
                                                        color: selectedOption[pos] == pos22
                                                            ? Color(0xFFFF7C00)
                                                            : Color(0xFF707070),
                                                        width: selectedOption[pos] == pos22
                                                            ? 1
                                                            : 0.3)),
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 10),
                                                    GestureDetector(
                                                        onTap: () {


                                                          bool updatePercent=false;


                                                          if(selectedOption[pos]==9999)
                                                            {
                                                              updatePercent=true;
                                                            }


                                                          setState(() {
                                                            selectedOption[pos] = pos22;
                                                          });

                                                           submitSingleQuestion(context,pos,updatePercent);
                                                        },
                                                        child: selectedOption[pos] == pos22
                                                            ? Icon(
                                                            Icons
                                                                .radio_button_checked,
                                                            color:
                                                            AppTheme.orangeColor,
                                                            size: 23)
                                                            : Icon(Icons.radio_button_off,
                                                            color: Color(0xFFC6C6C6),
                                                            size: 23)),
                                                    SizedBox(width: 10),
                                                    Expanded(
                                                        child: Text(
                                                          pos22 == 0 ? "Yes" : "No",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: selectedOption[pos] == pos
                                                                ? FontWeight.w600
                                                                : FontWeight.w500,
                                                            color: Color(0xFF708096),
                                                          ),
                                                        )),
                                                    SizedBox(width: 6),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 10)
                                            ],
                                          );
                                        }),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        quizList[pos]["image"]
                                            .toString() ==
                                            "1"
                                            ?
                                        SizedBox(width: 15):Container(),
                                        quizList[pos]["image"]
                                            .toString() ==
                                            "1"
                                            ? GestureDetector(
                                            onTap: () {

                                              if(Platform.isAndroid)
                                                {
                                                  _openAndroidCamera(context,pos);
                                                }
                                              else
                                                {
                                                  _fetchImage(context,pos);
                                                }




                                            },
                                            child: Icon(Icons.camera_alt,
                                                size: 32,
                                                color: AppTheme.orangeColor))
                                            : Container(),
                                        quizList[pos]["audio"]
                                            .toString() ==
                                            "1"
                                            ? SizedBox(width: 15)
                                            : Container(),
                                        quizList[pos]["audio"]
                                            .toString() ==
                                            "1"
                                            ? GestureDetector(
                                            onTap: () async {


                         final data = await Navigator.push(context, MaterialPageRoute(builder: (context)=>RecordAudioScreen()));

                         if (data != null) {
                           selectedAudio = File(data);
                           selectedFile[pos]=selectedAudio;
                           print(selectedAudio.toString()+"*****");
                           uploadImage("2",pos);
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



                                        quizList[pos]["video"]
                                            .toString() ==
                                            "1"?SizedBox(width: 15):Container(),
                                        quizList[pos]["video"]
                                            .toString() ==
                                            "1"?
                                       GestureDetector(
                                         child: Icon(Icons.video_call_sharp,
                                             size: 32,
                                             color: AppTheme.orangeColor),
                                         onTap: (){

                                           _fetchVideo(context, pos);
                                         },
                                       ):Container(),

                                        quizList[pos]["e_signature"]
                                            .toString() ==
                                            "1"?
                                        SizedBox(width: 15):Container(),

                                        quizList[pos]["e_signature"]
                                            .toString() ==
                                            "1"?
                                        GestureDetector(
                                          onTap:(){
                                            _controller.clear();
                                            setState(() {

                                            });

                                            signatureDialog(context, pos);




                              },

                                            child: Image.asset("assets/signature.png",width: 32,height: 32,color: AppTheme.orangeColor)):Container()
                                      ],
                                    ),

                                    SizedBox(height: 10),




                                    quizList[pos]["video"]
                                        .toString() ==
                                        "1" && videoUrlList[pos]!=""?
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FullVideoScreen(videoUrlList[pos])));
                                      },
                                      child: Container(
                                        height: 90,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 13, vertical: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4),
                                            color: Color(0xFFFFF1E4),
                                            border: Border.all(
                                                color: Color(0xFF707070),
                                                width: 0.3)),
                                        child: Row(
                                          children: [


                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                  width: 130, height: 72,
                                                child: VideoWidget(
                                                    url: videoUrlList[pos],
                                                    play: false,
                                                    loaderColor: AppTheme.themeColor),
                                              ),

                                            Expanded(
                                                child: Text(
                                                  videoUrlList[pos].split('/').last,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: selectedOption[pos] == 1
                                                        ? FontWeight.w600
                                                        : FontWeight.w500,
                                                    color: selectedOption[pos] == 1
                                                        ? Color(0xFFFF7C00)
                                                        : Color(0xFF708096),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ):Container(),


                                    quizList[pos]["audio"]
                                        .toString() ==
                                        "1" && audioUrlList[pos]!=""?
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RecordingView(audioUrlList[pos])));
                                      },
                                      child: Container(
                                        height: 90,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 13, vertical: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4),
                                            color: Color(0xFFFFF1E4),
                                            border: Border.all(
                                                color: Color(0xFF707070),
                                                width: 0.3)),
                                        child: Row(
                                          children: [


                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              width: 130, height: 72,
                                              child: Image.asset("assets/audio.png",
                                                  width: 130, height: 72),
                                            ),

                                            Expanded(
                                                child: Text(
                                                  audioUrlList[pos].split('/').last,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: selectedOption[pos] == 1
                                                        ? FontWeight.w600
                                                        : FontWeight.w500,
                                                    color: selectedOption[pos] == 1
                                                        ? Color(0xFFFF7C00)
                                                        : Color(0xFF708096),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ):Container(),



                                    quizList[pos]["image"]
                                        .toString() ==
                                        "1" && imageUrlList[pos]!=""?
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ImageView(imageUrlList[pos])));
                                      },
                                      child: Container(
                                        height: 90,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 13, vertical: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4),
                                            color: Color(0xFFFFF1E4),
                                            border: Border.all(
                                                color: Color(0xFF707070),
                                                width: 0.3)),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              child: Image.network(imageUrlList[pos],
                                                  width: 130, height: 72),
                                            ),
                                            Expanded(
                                                child: Text(
                                                  imageUrlList[pos].split('/').last,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: selectedOption[pos] == 1
                                                        ? FontWeight.w600
                                                        : FontWeight.w500,
                                                    color: selectedOption[pos] == 1
                                                        ? Color(0xFFFF7C00)
                                                        : Color(0xFF708096),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ):Container(),

                                    quizList[pos]["e_signature"]
                                        .toString() ==
                                        "1" && signatureUrlList[pos]!=""?
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignatureView(signatureUrlList[pos])));
                                      },
                                      child: Container(
                                        height: 90,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 13, vertical: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(4),
                                            color: Color(0xFFFFF1E4),
                                            border: Border.all(
                                                color: Color(0xFF707070),
                                                width: 0.3)),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              child: Container(
                                                  width: 130, height: 72,
                                                color: Colors.white,
                                                child: Image.network(signatureUrlList[pos],
                                                    width: 130, height: 72),
                                              ),
                                            ),
                                            Expanded(
                                                child: Text(signatureUrlList[pos].split('/').last,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: selectedOption[pos] == 1
                                                        ? FontWeight.w600
                                                        : FontWeight.w500,
                                                    color: selectedOption[pos] == 1
                                                        ? Color(0xFFFF7C00)
                                                        : Color(0xFF708096),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ):Container(),



                                    quizList[pos]["remark"].toString()=="1"?
                                    SizedBox(height: 5):Container(),
                                    quizList[pos]["remark"].toString()=="1"?
                                    TextFieldWidget("Remark", "Enter Remark",controller: controllerList[pos]):Container(),
                                    quizList[pos]["remark"].toString()=="1"?
                                    SizedBox(height: 15):Container(),

                                    pos==quizList.length-1?Container():


                                    Container(
                                        child: Divider(color: Colors.grey.withOpacity(0.4)),margin: EdgeInsets.symmetric(horizontal: 13))
                                  ],
                                );
                              }


                          ),


                          InkWell(
                            onTap: () {

                              checkAnswer();

                             /* if(answerFlag && videoFlag && audioFlag && signatureFlag && imageFlag)
                                {
                                  print("All clear");
                                  //All validations passed
                                  //Submit Data


                                }
*/

                              //  Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: MCQTestType2Screen()));


                            },
                            child: Container(
                                height: 57,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 13),
                                color: AppTheme.themeColor,
                                child: Center(
                                    child: Text(
                                   "Submit",
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ))),
                          ),
                          SizedBox(height: 16),
                        ],
                      ))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchQuizForTasks(context);
  }

  fetchQuizForTasks(BuildContext context) async {
    String? authKey = await MyUtils.getSharedPreferences("access_token");
    setState(() {
      isLoading = true;
    });
    //0 incomplete
    var data = {
      "auth_key": authKey,
      "task_id": widget.taskID,
      "sub_task_id": widget.subTaskID,
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('get_task_questions', data, context);
    var responseJSON = json.decode(response.body);
    voiceNoteUrl = responseJSON["audioInstruction"] ?? "";
    quizList = responseJSON["taskQuestions"];


    for(int i=0;i<quizList.length;i++)
      {
        selectedOption.add(9999);
        imageUrlList.add("");
        videoUrlList.add("");
        signatureUrlList.add("");
        audioUrlList.add("");
        selectedFile.add(null);
        controllerList.add(TextEditingController(text: ""));
      }

    if(widget.isDraftedTask)
      {
        fetchDraftedTaskDetails(context);
      }




    setState(() {
      isLoading = false;
    });

    print(responseJSON);

    // quizList = responseJSON["taskData"];
  }
  fetchDraftedTaskDetails(BuildContext context) async {
    String? authKey = await MyUtils.getSharedPreferences("access_token");
    setState(() {
      isLoading = true;
    });
    //0 incomplete
    var data = {
      "auth_key": authKey,
      "task_id": widget.taskID,
      "sub_task_id": widget.subTaskID,
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('saved_draft', data, context);
    var responseJSON = json.decode(response.body);
    setState(() {
      isLoading = false;
    });

    List<dynamic> submittedAnswers = responseJSON["savedAnswer"];
    imageBaseUrl=responseJSON["imageBaseUrl"];
    audioBaseUrl=responseJSON["voiceBaseUrl"];
    videoBaseUrl=responseJSON["videoBaseUrl"];
    signatureBaseUrl=responseJSON["signatureBaseUrl"];
    print("Length of Submit");
    print(submittedAnswers.length.toString());


    selectedOption.add(9999);
    imageUrlList.add("");
    videoUrlList.add("");
    signatureUrlList.add("");
    audioUrlList.add("");
    selectedFile.add(null);
    controllerList.add(TextEditingController(text: ""));



    for (int i = 0; i < quizList.length; i++) {
      for (int j = 0; j < submittedAnswers.length; j++) {

        if (submittedAnswers[j]["question_id"].toString() ==
            quizList[i]["id"].toString()) {
          attemptCount=attemptCount+1;
          percentage=(attemptCount*100)/quizList.length;
          percentage=percentage/100;


          if(submittedAnswers[j]["answer"].toString() =="1")
            {
              selectedOption[i]=0;
            }
          else{
            selectedOption[i]=1;
          }

          if(submittedAnswers[j]["image"]!=null && submittedAnswers[j]["image"]!="")
            {
              imageUrlList[i]=imageBaseUrl+"/"+submittedAnswers[j]["image"];
            }


          if(submittedAnswers[j]["voice"]!=null && submittedAnswers[j]["voice"]!="")
          {
            audioUrlList[i]=audioBaseUrl+"/"+submittedAnswers[j]["voice"]+"/";
          }




          if(submittedAnswers[j]["video"]!=null && submittedAnswers[j]["video"]!="")
          {

            videoUrlList[i]=videoBaseUrl+"/"+submittedAnswers[j]["video"]+"/";
          }


          if(submittedAnswers[j]["e_signature"]!=null && submittedAnswers[j]["e_signature"]!="")
          {

            signatureUrlList[i]=signatureBaseUrl+"/"+submittedAnswers[j]["e_signature"]+"/";
          }




        }
      }
    }

    setState(() {});

    print(responseJSON);

    // quizList = responseJSON["taskData"];
  }




  submitSingleQuestion(BuildContext context,int pos,bool updatePercent) async {
    String? authKey = await MyUtils.getSharedPreferences("access_token");
    String? userID = await MyUtils.getSharedPreferences("user_id_libas");
    APIDialog.showAlertDialog(context, "Please wait...");
    //0 incomplete
    var data = {
      "auth_key": authKey,
      "task_id": widget.taskID,
      "sub_task_id": widget.subTaskID,
      "question_id": quizList[pos]["id"].toString(),
      "emp_id": userID,
      "answer": selectedOption[pos] == 0 ? "1" : "0"
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('save_answer_draft', data, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    print("Log Data222");
    if(responseJSON["status"]==1)
      {

        print("Log Data");

        dev.log(selectedOption[pos].toString());


        if(updatePercent)
          {
            attemptCount=attemptCount+1;
            percentage=(attemptCount*100)/quizList.length;
            percentage=percentage/100;
          }

      }

    print(responseJSON);
    setState(() {});

    // quizList = responseJSON["taskData"];
  }


  submitAllQuestions(BuildContext context) async {
    String? authKey = await MyUtils.getSharedPreferences("access_token");
    String? userID = await MyUtils.getSharedPreferences("user_id_libas");
    APIDialog.showAlertDialog(context, "Please wait...");

    List<dynamic> finalAnswerList=[];

    for(int i=0;i<quizList.length;i++)
      {
        finalAnswerList.add({
          "question_id":quizList[i]["id"].toString(),
          "answer":selectedOption[i] == 0 ? "1" : "0",
          "remark":controllerList[i].text.toString()
        });
      }

    //0 incomplete
    var data = {
      "auth_key": authKey,
      "task_id": widget.taskID,
      "sub_task_id": widget.subTaskID,
      "emp_id": userID,
      "parameter": finalAnswerList
    };
    print(data);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('submit_task', data, context);
    var responseJSON = json.decode(response.body);
    Navigator.pop(context);
    print(responseJSON);
    setState(() {});
    if(responseJSON["status"]==1) {
      Toast.show(responseJSON["message"],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      Navigator.pop(context);
    }
    else
      {
        Toast.show(responseJSON["message"],
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }






    // quizList = responseJSON["taskData"];
  }



  _fetchImage(BuildContext context22,int pos) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    print('Image File From Android' + (image?.path).toString());
    if (image != null) {
      selectedFile[pos] = File(image.path);
      setState(() {});
      imagePreviewDialog(context,pos);
      // uploadImage();
    }
  }


  _openAndroidCamera(BuildContext context22,int pos)
  async {
    final imageData=await Navigator.push(context,MaterialPageRoute(builder: (context)=>CaptureCameraScreen()));
    if(imageData!=null)
    {
      selectedFile[pos] = File(imageData.path.toString());
      setState(() {});
      imagePreviewDialog(context,pos);

    }
  }


  _fetchVideo(BuildContext context,int pos) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
    print('Image File From Android' + (video?.path).toString());
    if (video != null) {
      selectedFile[pos] = File(video.path);
      setState(() {});
      previewVideoDialog(context,pos);
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
        return  Center(
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
                                        borderRadius:
                                        BorderRadius.circular(5)),
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
                                  uploadImage("3",index);
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
        return  Center(
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
                          onPressed: () => exportImage(context,index),
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
                                        borderRadius:
                                        BorderRadius.circular(5)),
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

                                  if(selectedFile[index]==null)
                                    {
                                      Toast.show("Please save your signature first",
                                          duration: Toast.lengthLong,
                                          gravity: Toast.bottom,
                                          backgroundColor: Colors.green);
                                    }
                                  else
                                    {

                                      print(selectedFile[index]!.path.toString());

                                      Navigator.pop(context);

                                      uploadImage("4",index);

                                    /*  Navigator.pop(context);
                                      uploadImage("1",index);*/
                                    }





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



  void imagePreviewDialog(BuildContext context,int pos) {
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
                            child: Image.file(File(selectedFile[pos]!.path.toString())),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Row(
                          children: [
                            SizedBox(width: 15),
                            Expanded(
                                child: InkWell(
                                  onTap: () async {

                                    final data = await Navigator.push(context, MaterialPageRoute(builder: (context)=>ImageEditScreen(selectedFile[pos]!)));


                                    print(AppModel.temFilePath);
                                    if(AppModel.temFilePath!="")
                                    {
                                      Navigator.pop(context);
                                      print("The File path is" +AppModel.temFilePath.toString());
                                      selectedFile[pos]=File(AppModel.temFilePath.toString());
                                      AppModel.setTempFilePath("");
                                      setState(() {});
                                      imagePreviewDialog(context,pos);
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
                                    uploadImage("1",pos);
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




  Future<void> exportImage(BuildContext context,int pos) async {
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
    String randomName="digitalSign$randomNumber.png";
    if (kDebugMode) {
      print(randomName);
    }

    final tempDirectory= await getTemporaryDirectory();
    File files= await File('${tempDirectory.path}/$randomName').create();
    files.writeAsBytesSync(data!);

    setState(() {
      selectedFile[pos]=files;

    });
  }

  uploadImage(String fileType,int pos) async {
    APIDialog.showAlertDialog(context, 'Updating image...');
    String? authKey = await MyUtils.getSharedPreferences("access_token");
    String? userID = await MyUtils.getSharedPreferences("user_id_libas");
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(selectedFile[pos]!.path),
      "user_id": AppModel.userID,
      "file_type": fileType,
      "Orignal_Name": selectedFile[pos]!.path.split('/').last,
      "fileCount": "1",
      "auth_key": authKey,
      "task_id": widget.taskID,
      "sub_task_id": widget.subTaskID,
      "emp_id": userID,
      "question_id": quizList[pos]["id"].toString(),
    });

    print("Fields are "+formData.fields.toString());



    Dio dio = Dio();
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers['Authorization'] = AppModel.token;
    print(AppConstant.appBaseURL + "save_draft");

    try {
      var response =
          await dio.post(AppConstant.appBaseURL + "save_draft", data: formData);
      print(response.data);
      var responseJSON = jsonDecode(response.data.toString());
      Navigator.pop(context);
      if (responseJSON['status'] == 1) {
        Toast.show(responseJSON['message'].toString(),
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.green);

        if(fileType=="1")
          {
            imageUrlList[pos] = responseJSON["image_url"] ?? "";
          }
        else if(fileType=="2")
          {
            audioUrlList[pos] = responseJSON["voice_url"] ?? "";
          }

        else if(fileType=="3")
        {
          videoUrlList[pos] = responseJSON["video_url"] ?? "";
        }

        else if(fileType=="4")
        {
          signatureUrlList[pos] = responseJSON["signature_url"] ?? "";
        }

        setState(() {});
      } else {
        Toast.show(responseJSON['message'].toString(),
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    } catch (e) {
      if (e is DioException) {
        Navigator.pop(context);
        Toast.show("Something went wrong!",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
      //handle DioError here by error type or by error code

      else {
        Navigator.pop(context);
        Toast.show("Something went wrong!",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    }
  }


  checkAnswer()
  {
    bool answerFlag=false;

    for(int i=0;i<quizList.length;i++)
    {

      if(selectedOption[i]==9999)
      {

        print("Loop");
        Toast.show("Please select a answer for Question "+(i+1).toString(),
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
        answerFlag=true;
        break;
      }
    }
    if(!answerFlag)
      {
       checkImage();
      }




  }
  checkVideo()
  {

    bool videoFlag=false;

    for(int i=0;i<quizList.length;i++)
    {
      if(quizList[i]["video"].toString()=="1")
      {
        if(videoUrlList[i]=="")
        {
          Toast.show("Please upload a video for Question "+(i+1).toString(),
              duration: Toast.lengthLong,
              gravity: Toast.bottom,
              backgroundColor: Colors.red);
          videoFlag=true;
          break;
        }
      }

    }

    if(!videoFlag)
    {
      checkAudio();
    }




  }

  checkSignature()
  {
    bool signatureFlag=false;
    for(int i=0;i<quizList.length;i++)
    {
      if(quizList[i]["e_signature"].toString()=="1")
      {
        if(signatureUrlList[i]=="")
        {
          Toast.show("Please upload a signature for Question "+(i+1).toString(),
              duration: Toast.lengthLong,
              gravity: Toast.bottom,
              backgroundColor: Colors.red);
          signatureFlag=false;
          break;
        }
      }

    }

    if(!signatureFlag)
      {
        submitAllQuestions(context);


        print("All Clear");
      }



  }

  checkAudio()
  {

    bool audioFlag=false;

    for(int i=0;i<quizList.length;i++)
    {
      if(quizList[i]["audio"].toString()=="1")
      {
        if(audioUrlList[i]=="")
        {
          Toast.show("Please upload a audio recording for Question "+(i+1).toString(),
              duration: Toast.lengthLong,
              gravity: Toast.bottom,
              backgroundColor: Colors.red);
          audioFlag=true;
          break;
        }
      }
    }

    if(!audioFlag)
      {
       // submitAllQuestions(context);
        checkSignature();
      }

  }


  checkImage()
  {

    bool imageFlag=false;

    for(int i=0;i<quizList.length;i++)
    {
      if(quizList[i]["image"].toString()=="1")
      {
        if(imageUrlList[i]=="")
        {
          Toast.show("Please upload image for Question "+(i+1).toString(),
              duration: Toast.lengthLong,
              gravity: Toast.bottom,
              backgroundColor: Colors.red);
          imageFlag=true;
          break;
        }
      }
    }

    if(!imageFlag)
    {
      checkVideo();
    }


  }


}
