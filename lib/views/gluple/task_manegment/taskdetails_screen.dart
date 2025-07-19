import 'dart:convert';
import 'package:ChecklistTree/views/login_screen.dart';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ChecklistTree/views/gluple/task_manegment/subtask_screen.dart';
import 'package:ChecklistTree/views/gluple/task_manegment/viewfiles_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import '../views/login_screen.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'addSpentTime_Screen.dart';
import 'add_subtask_screen.dart';

class TaskDetailsScreen extends StatefulWidget{
  String taskId;
  var response;

  TaskDetailsScreen(this.taskId,this.response);

  _taskDetails createState()=>_taskDetails();
}
class _taskDetails extends State<TaskDetailsScreen> with SingleTickerProviderStateMixin{
  late var userIdStr;
  late var fullNameStr;
  late var designationStr;
  late var token;
  late var empId;
  late var baseUrl;
  bool isLoading=false;
  List<dynamic>subTaskList=[];

  String taskTitle="";
  String taskType="";
  String taskPriorityName="";
  String taskAssigneeName="";
  String taskWatcherName="";
  String taskReporterName="";
  String taskDate="";
  String taskDueDate="";
  String originalEstimate="";
  String taskDescription="";
  String taskStatusName="";
  List<dynamic> filesList=[];
  var descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();
  var statusList = [''];
  List<dynamicTaskTypeModel>statusDynamicList=[];
  String selectedStatus="0";
  String statusValue = '';
  String defaultSelectedStatus="0";

  late TabController tabController;

  List<dynamic> allLogsList=[];
  List<dynamic> historyLogList=[];
  List<dynamic> workLogList=[];

  bool isImageSelected=false;
  XFile? imageFile;
  File? file;



  String taskCreatedBy="";
  bool showEdit=false;

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
          "Task Details",
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
      body: isLoading?SizedBox():
      Padding(padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 10,
                shadowColor: Colors.deepOrangeAccent,
                color: Colors.deepOrange[30],
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(taskTitle,style: TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: AppTheme.themeColor),)),
                            SizedBox(width: 5,),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppTheme.themeColor),
                              width: 110,
                              height: 30,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(taskType,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12)),
                              ),

                            ),
                            SizedBox(width: 5,),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Expanded(child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Assignee",style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                  color: Colors.black
                                ),),
                                const SizedBox(height: 5,),
                                Text(taskAssigneeName,style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: AppTheme.themeColor
                                ),),
                              ],

                            )),
                            SizedBox(width: 5,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Priority",style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Colors.black
                                ),),
                                const SizedBox(height: 5,),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppTheme.task_Reopen_text),
                                  width: 100,
                                  height: 20,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(taskPriorityName,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 12)),
                                  ),

                                ),
                              ],

                            ),

                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Expanded(child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Task Date",style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Colors.black
                                ),),
                                const SizedBox(height: 5,),
                                Text(taskDate,style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: AppTheme.themeColor
                                ),),
                              ],

                            )),
                            SizedBox(width: 5,),
                            Expanded(child:
                                Row(
                                    children: [
                                      Expanded(child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text("Due Date",style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: Colors.black
                                          ),),
                                          const SizedBox(height: 5,),
                                          Text(taskDueDate,style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                              color: AppTheme.themeColor
                                          ),),
                                        ],

                                      )),
                                      SizedBox(width: 2,),
                                      selectedStatus=="67"?
                                      SizedBox(width: 1,):
                                      InkWell(
                                        onTap: (){
                                          _showEndDatePicker();
                                        },
                                        child: Icon(Icons.edit_calendar_rounded,
                                          color: AppTheme.orangeColor,
                                          size: 24,
                                        ),
                                      )
                                    ],
                                )
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            const Text("Reporter :- ",style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Colors.black
                            ),),
                            const SizedBox(width: 5,),
                            Expanded(child: Text(taskReporterName,style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Colors.black
                            ),),)
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            const Text("Watcher :- ",style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Colors.black
                            ),),
                            const SizedBox(width: 5,),
                            Expanded(child: Text(taskWatcherName,style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Colors.black
                            ),),)
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            const Text("Original Estimate :- ",style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Colors.black
                            ),),
                            const SizedBox(width: 5,),
                            Expanded(child: Text(originalEstimate,style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Colors.black
                            ),),)
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Text("Description",style: TextStyle(fontSize: 12,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                            SizedBox(width: 5,),
                            selectedStatus=="67"?
                                SizedBox(width: 1,):
                            InkWell(
                              onTap: (){
                                _showBottomForDescriptionUpdate();
                              },
                              child: Icon(Icons.edit_note,
                                color: AppTheme.orangeColor,
                                size: 24,
                              ),
                            )
                          ],
                        ),
                        SizedBox( height: 5,),
                        Html(data: taskDescription),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Text("Status",style: TextStyle(fontSize: 12,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                            SizedBox(width: 10,),
                            Expanded(child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppTheme.lightblueColor),
                              height: 30,
                              child: Align(
                                alignment: Alignment.center,
                                child: DropdownButton(
                                  items: statusList.map((String items) {return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );}).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      statusValue = newValue!;
                                      int position=statusList.indexOf(newValue);
                                      selectedStatus=statusDynamicList[position].taskTypeId;
                                      print("selected Status $selectedStatus");
                                    });
                                    _updateStatus(selectedStatus);

                                  },
                                  value: statusValue,
                                  icon: Icon(Icons.keyboard_arrow_down,color: AppTheme.themeColor,size: 15,),
                                  isExpanded: true,
                                  underline: SizedBox(),
                                ),
                              ),

                            )),

                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            /*selectedStatus=='67'?
                                Expanded(child: Container()):
                                  showEdit?
                                  Expanded(child: InkWell(
                                  onTap: (){

                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: AppTheme.themeColor),
                                    height: 30,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Icon(Icons.edit_document,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),

                                  ),
                                )):
                                  Expanded(child: Container()),


                            SizedBox(width: 5,),*/

                            selectedStatus=='67'?
                            Expanded(child: Container()):
                                showEdit?
                                  Expanded(child: InkWell(
                                    onTap: (){
                                      _showBottomForDeleteConfirmation();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: AppTheme.at_red),
                                      height: 30,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Icon(Icons.delete_forever,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),

                                    ),
                                  )):
                                        Expanded(child: Container()),

                            SizedBox(width: 5,),
                            selectedStatus=='67'?
                            Expanded(child: Container()):
                            Expanded(child: InkWell(
                              onTap: (){
                                imageSelector();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppTheme.at_title),
                                height: 30,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    SizedBox(width: 2,),
                                    Text("File",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 12,color: Colors.white),),
                                  ],
                                ),

                              ),
                            )),

                            SizedBox(width: 5,),
                            Expanded(child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewTaskFiles(filesList)),);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppTheme.themeColor),
                                height: 30,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.remove_red_eye_outlined,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    SizedBox(width: 2,),
                                    Text("File",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 12,color: Colors.white),),
                                  ],
                                ),

                              ),
                            )),


                          ],
                        ),
                        SizedBox(height: 20,),
                        selectedStatus=='67'?
                            SizedBox(height: 1,):
                        Row(
                          children: [
                            Expanded(child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddSubTask_Screen(widget.taskId)),);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppTheme.at_title),
                                height: 30,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    SizedBox(width: 2,),
                                    Text("Add SubTask",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 12,color: Colors.white),),
                                  ],
                                ),

                              ),
                            )),
                            SizedBox(width: 5,),
                            Expanded(child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddSpentTime_Screen(widget.taskId)),).then((value) => _getDashboardData());
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppTheme.themeColor),
                                height: 30,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.timer,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    SizedBox(width: 2,),
                                    Text("Time Tracking",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 12,color: Colors.white),),
                                  ],
                                ),

                              ),
                            ))
                          ],
                        ),
                        SizedBox(height: 20,),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ViewSubTask_Screen(widget.taskId,taskStatusName)),);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppTheme.at_title),
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.remove_red_eye_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                SizedBox(width: 2,),
                                Text("View SubTask",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 12,color: Colors.white),),
                              ],
                            ),

                          ),
                        ),
                      ],
                    ),

                  ),
                ),
              ),
              SizedBox(height: 50,),



              Text("Activity",style: TextStyle(fontWeight: FontWeight.w900,color: Colors.black,fontSize: 16),),
              SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppTheme.lightblueColor),
                height: 45,
                child: TabBar(
                    controller: tabController,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.redAccent
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Tab(
                        text: "All",
                      ),
                      Tab(
                        text: "History",
                      ),
                      Tab(
                        text: "Work Log",
                      ),

                    ]),

              ),
              SizedBox(height: 10,),
              Container(
                height: MediaQuery.of(context).size.height/2,
               child: TabBarView(
                 controller: tabController,
                 children: [
                   allLogsList.isEmpty?
                   Text("No Record Found",textAlign:TextAlign.center,style: TextStyle(fontWeight: FontWeight.w900,color: AppTheme.orangeColor,fontSize: 14),):
                   ListView.builder(
                       itemCount: allLogsList.length,
                       itemBuilder: (cntx,indx){
                         String createdAt=allLogsList[indx]['created_at'].toString();
                         String userName=allLogsList[indx]['user_name'].toString();
                         String value=allLogsList[indx]['value'].toString();
                         String dateToShow="XXX, 00 XXX 0000";
                         if(allLogsList[indx]['created_at']!=null){
                           var deliveryTime=DateTime.parse(allLogsList[indx]['created_at']);
                           var delLocal=deliveryTime.toLocal();
                           dateToShow=DateFormat('E, dd MMM yyyy hh:mm a').format(delLocal);
                         }
                         return Card(
                           margin: EdgeInsets.only(bottom: 10),
                           elevation: 10,
                           shadowColor: Colors.deepPurpleAccent,
                           color: Colors.deepPurpleAccent[30],
                           child: Padding(
                             padding: EdgeInsets.all(10),
                             child: Container(
                               width: double.infinity,
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text(userName,style: TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: AppTheme.themeColor),),
                                   SizedBox(height: 10,),
                                   Html(data: value),
                                   SizedBox(height: 10,),
                                   Text(dateToShow,textAlign: TextAlign.end,style: TextStyle(fontWeight: FontWeight.w500,color: AppTheme.orangeColor,fontStyle: FontStyle.italic,fontSize: 12),),
                                 ],
                               ),

                             ),
                           ),
                         );
                       }),

                   historyLogList.isEmpty?
                   Text("No Record Found",textAlign:TextAlign.center,style: TextStyle(fontWeight: FontWeight.w900,color: AppTheme.orangeColor,fontSize: 14),):
                   ListView.builder(
                       itemCount: historyLogList.length,
                       itemBuilder: (cntx,indx){
                         String createdAt=historyLogList[indx]['created_at'].toString();
                         String userName=historyLogList[indx]['user_name'].toString();
                         String value=historyLogList[indx]['value'].toString();
                         String dateToShow="XXX, 00 XXX 0000";
                         if(historyLogList[indx]['created_at']!=null){
                           var deliveryTime=DateTime.parse(historyLogList[indx]['created_at']);
                           var delLocal=deliveryTime.toLocal();
                           dateToShow=DateFormat('E, dd MMM yyyy hh:mm a').format(delLocal);
                         }
                         return Card(
                           margin: EdgeInsets.only(bottom: 10),
                           elevation: 10,
                           shadowColor: Colors.deepPurpleAccent,
                           color: Colors.deepPurpleAccent[30],
                           child: Padding(
                             padding: EdgeInsets.all(10),
                             child: Container(
                               width: double.infinity,
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text(userName,style: TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: AppTheme.themeColor),),
                                   SizedBox(height: 10,),
                                   Html(data: value),
                                   SizedBox(height: 10,),
                                   Text(dateToShow,textAlign: TextAlign.end,style: TextStyle(fontWeight: FontWeight.w500,color: AppTheme.orangeColor,fontStyle: FontStyle.italic,fontSize: 12),),
                                 ],
                               ),

                             ),
                           ),
                         );
                       }),

                   workLogList.isEmpty?
                   Text("No Record Found",textAlign:TextAlign.center,style: TextStyle(fontWeight: FontWeight.w900,color: AppTheme.orangeColor,fontSize: 14),):
                   ListView.builder(
                       itemCount: workLogList.length,
                       itemBuilder: (cntx,indx){
                         String createdAt=workLogList[indx]['created_at'].toString();
                         String userName=workLogList[indx]['user_name'].toString();
                         String value=workLogList[indx]['value'].toString();
                         String dateToShow="XXX, 00 XXX 0000";
                         if(workLogList[indx]['created_at']!=null){
                           var deliveryTime=DateTime.parse(workLogList[indx]['created_at']);
                           var delLocal=deliveryTime.toLocal();
                           dateToShow=DateFormat('E, dd MMM yyyy hh:mm a').format(delLocal);
                         }
                         return Card(
                           margin: EdgeInsets.only(bottom: 10),
                           elevation: 10,
                           shadowColor: Colors.deepPurpleAccent,
                           color: Colors.deepPurpleAccent[30],
                           child: Padding(
                             padding: EdgeInsets.all(10),
                             child: Container(
                               width: double.infinity,
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text(userName,style: TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: AppTheme.themeColor),),
                                   SizedBox(height: 10,),
                                   Html(data: value),
                                   SizedBox(height: 10,),
                                   Text(dateToShow,textAlign: TextAlign.end,style: TextStyle(fontWeight: FontWeight.w500,color: AppTheme.orangeColor,fontStyle: FontStyle.italic,fontSize: 12),),
                                 ],
                               ),

                             ),
                           ),
                         );
                       }),

                 ],
               ),
              ),

              





            ],
          ),
        ),),
    );
  }

  imageSelector() async{

    imageFile = await ImagePicker().pickImage(source: ImageSource.gallery,
        imageQuality: 60,preferredCameraDevice: CameraDevice.front
    );

    if(imageFile!=null){
      file=File(imageFile!.path);

      final imageFiles = imageFile;
      if (imageFiles != null) {
        print("You selected  image : " + imageFiles.path.toString());
        isImageSelected=true;
        _showImageDialog();
      } else {
        print("You have not taken image");
      }
    }else{
      Toast.show("Unable to Browse Image. Please try Again...",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }


  }
  _showImageDialog(){

    showDialog(context: context, builder: (ctx)=>AlertDialog(
        title: const Text("Upload Image",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 18),),
        content: Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.rectangle,
            image: DecorationImage(
                image: FileImage(file!),
                fit: BoxFit.cover
            ),

          ),
        ),
        actions: <Widget>[
          TextButton(
              onPressed: (){
                Navigator.of(ctx).pop();
                _uploadTaskImage();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppTheme.themeColor,
                ),
                height: 45,
                padding: const EdgeInsets.all(10),
                child: const Center(child: Text("Upload",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
              )
          ),
          TextButton(
              onPressed: (){
                isImageSelected=false;
                Navigator.of(ctx).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppTheme.greyColor,
                ),
                height: 45,
                padding: const EdgeInsets.all(10),
                child: const Center(child: Text("Cancel",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
              )
          )
        ]
    ));
  }
  _uploadTaskImage() async{
    APIDialog.showAlertDialog(context, 'Please wait...');
    String fileName = imageFile!.path.split('/').last;
    String extension = fileName.split('.').last;

    FormData formData = FormData.fromMap({
      "task_id": widget.taskId,
      "file": await MultipartFile.fromFile(imageFile!.path,
          filename: fileName),
    });
    String apiUrl=baseUrl+"tasks/add-tasks-files";
    print(apiUrl);
    Dio dio = Dio();
    dio.options.headers['Content-Type'] = 'multipart/form-data';
    dio.options.headers['X-Auth-Token'] = token;
    try {
      var response = await dio.post(apiUrl, data: formData);
      print(response.data);
      Navigator.pop(context);
      // var responseJSON = json.decode(response.data);
      //
      // print(responseJSON);
      if (response.data['error'] == false) {
        Toast.show(response.data['message'],
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.green);
      }else{
        Toast.show(response.data['message'],
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    }on DioError catch(e){
      print(e);
      print(e.response.toString());
      Navigator.pop(context);
      Toast.show(e.message.toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }



  }
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    Future.delayed(const Duration(milliseconds: 0), () {
      _getDashboardData();
    });
  }
  _getDashboardData() async {
    APIDialog.showAlertDialog(context, 'Please Wait...');
    userIdStr=await MyUtils.getSharedPreferences("user_id");
    fullNameStr=await MyUtils.getSharedPreferences("full_name");
    token=await MyUtils.getSharedPreferences("token");
    designationStr=await MyUtils.getSharedPreferences("designation");
    empId=await MyUtils.getSharedPreferences("emp_id");
    baseUrl=await MyUtils.getSharedPreferences("base_url");

    taskTitle=widget.response['title'].toString();
    taskDescription=widget.response['description'].toString();
    taskDueDate="XXX, 00 XXX 0000";
    taskDate="XXX, 00 XXX 0000";
    if(widget.response['end_date']!=null){
      var deliveryTime=DateTime.parse(widget.response['end_date']);
      var delLocal=deliveryTime.toLocal();
      taskDueDate=DateFormat('E, dd MMM yyyy').format(delLocal);
    }
    if(widget.response['start_date']!=null){
      var deliveryTime=DateTime.parse(widget.response['start_date']);
      var delLocal=deliveryTime.toLocal();
      taskDate=DateFormat('E, dd MMM yyyy').format(delLocal);
    }


    taskType=widget.response['task_type_name'].toString();
    taskAssigneeName=widget.response['emp_name'].toString();
    taskReporterName=widget.response['reporter_name'].toString();
    taskWatcherName=widget.response['watcher'].toString();
    originalEstimate=widget.response['original_estimate'].toString();
    taskStatusName=widget.response['task_status'].toString();
    taskPriorityName=widget.response['task_priority'].toString();
    defaultSelectedStatus=widget.response['status'].toString();
    taskCreatedBy=widget.response['created_by'].toString();
    print("login user Id $userIdStr");
    print("createdBy $taskCreatedBy");
    if(userIdStr==taskCreatedBy){
      showEdit=true;
    }else{
      showEdit=false;
    }



    filesList.clear();
    filesList=widget.response['mediaFile'];


    Navigator.of(context).pop();
    //getSubTaskList();
    getStatus();
    getAllLog();
    getHistoryLog();
    getWorkLog();
  }
  getSubTaskList() async{
    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    ApiBaseHelper helper= ApiBaseHelper();
    var response=await helper.getWithToken(baseUrl,"tasks/get-subtask-from-task?id=${widget.taskId}",token, context);
    var responseJSON = json.decode(response.body);
    Navigator.of(context).pop();
    print(responseJSON);
    if (responseJSON['error'] == false) {
      subTaskList.clear();
      subTaskList=responseJSON['data'];
      setState(() {
        isLoading=false;
      });

    }else if(responseJSON['code']==401|| responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        isLoading=false;
      });
      _logOut(context);
    }else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

      setState(() {
        isLoading=false;
      });

    }
  }
  _logOut(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("user_id");
    await preferences.remove("email");
    await preferences.remove("designation");
    await preferences.remove("department");
    await preferences.remove("manager");
    await preferences.remove("location");
    await preferences.remove("first_name");
    await preferences.remove("last_name");
    await preferences.remove("role");
    await preferences.remove("full_name");
    await preferences.remove("token");
    await preferences.remove("emp_id");
    await preferences.remove("at_access");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false);
  }
  getStatus() async{
    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    ApiBaseHelper helper= ApiBaseHelper();
    var response=await helper.getWithToken(baseUrl,"common_api/dropdown-master-data?type=status",token, context);
    var responseJSON = json.decode(response.body);
    Navigator.of(context).pop();
    print(responseJSON);
    if (responseJSON['error'] == false) {
      List<dynamic> tempList=[];
      tempList=responseJSON['data'];
      statusList.clear();
      statusDynamicList.clear();
      for(int i=0;i<tempList.length;i++){
        String pId=tempList[i]['id'].toString();
        String project_key=tempList[i]['category_key'].toString();
        String project_type=tempList[i]['category_value'].toString();
        statusDynamicList.add(dynamicTaskTypeModel(pId, project_type, project_key,"0"));
        statusList.add(project_key);
        if(defaultSelectedStatus==pId){
          statusValue=project_key;
          selectedStatus=pId;
        }


      }
      setState(() {
        isLoading=false;
      });

    }else if(responseJSON['code']==401|| responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        isLoading=false;
      });
      _logOut(context);
    }else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

      setState(() {
        isLoading=false;
      });

    }
  }
  _showEndDatePicker() async{


    var nowDate=DateTime.now();
    var lastDate=DateTime(nowDate.year,nowDate.month+6,nowDate.day);

    DateTime? pickedDate=await showDatePicker(context: context, firstDate: nowDate, lastDate: lastDate);
    if(pickedDate !=null){
      String selectedDate = DateFormat("yyyy-MM-dd").format(pickedDate);
      String dateForShow=DateFormat("E, dd MMM yyyy").format(pickedDate);
      _updateDueDate(selectedDate, dateForShow);
    }
  }
  _updateDueDate(String endDate,String dateForShow)async{
    APIDialog.showAlertDialog(context, "Please Wait...");
     var requestModelfrom = {
      "end_date": 1,
    };
    var requestModel = {
      "id": widget.taskId,
      "end_date": endDate,
      "change_value": jsonEncode(requestModelfrom),
    };
    ApiBaseHelper helper= ApiBaseHelper();
    var response = await helper.postAPIWithHeader(baseUrl, 'tasks/update-task',requestModel,context, token);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      if(responseJSON['code']==200){
        setState(() {
          taskDueDate=dateForShow;
        });
      }
    }else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  _updateStatus(String statusId)async{
    APIDialog.showAlertDialog(context, "Please Wait...");

    var requestModel = {
      "id": widget.taskId,
      "status": statusId,
    };
    ApiBaseHelper helper= ApiBaseHelper();
    var response = await helper.postAPIWithHeader(baseUrl, 'tasks/update-task',requestModel,context, token);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      setState(() {

      });
    }else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  _updateDescription(String description)async{
    APIDialog.showAlertDialog(context, "Please Wait...");
    var requestModelfrom = {
      "description": 1,
    };
    var requestModel = {
      "id": widget.taskId,
      "description": description,
      "change_value": jsonEncode(requestModelfrom),
    };
    ApiBaseHelper helper= ApiBaseHelper();
    var response = await helper.postAPIWithHeader(baseUrl, 'tasks/update-task',requestModel,context, token);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      if(responseJSON['code']==200){
        setState(() {
          taskDescription=description;
        });
      }
    }else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  _showBottomForDescriptionUpdate(){



    var btnColor=Colors.green;


    descriptionController.text=taskDescription;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext contx){
          return StatefulBuilder(builder: (ctx,setDialogState){
            return Padding(padding: MediaQuery.of(context).viewInsets,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
                ),
                child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20,),
                        Align(alignment: Alignment.center, child: Container(height: 5,width: 30,color: AppTheme.greyColor,),),
                        const SizedBox(height: 10,),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              const Expanded(child: Text("Update Description",style: TextStyle(fontWeight: FontWeight.w900,color: Colors.black,fontSize: 18.5),)),
                              const SizedBox(width: 5,),
                              InkWell(
                                onTap: (){
                                  Navigator.of(context).pop();
                                },
                                child: const Icon(Icons.close_rounded,color: AppTheme.greyColor,size: 32,),
                              ),
                              const SizedBox(width: 5,),

                            ],
                          ),),

                        const SizedBox(height: 10,),
                        const Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("Enter Description",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w900,color: AppTheme.themeColor),),),
                        Form(
                            key: _formKey,
                            child:  Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black,width: 1,style: BorderStyle.solid),
                                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Center(
                                    child: TextField(
                                      minLines: 1,
                                      maxLines: 5,
                                      keyboardType: TextInputType.multiline,
                                      controller: descriptionController,
                                      maxLength: 500,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                          border: InputBorder.none
                                      ),
                                      focusNode: _focusNode,

                                    ),
                                  ),
                                ),

                              ),)),
                        const SizedBox(height: 10,),
                        TextButton(
                            onPressed: (){
                              _validationCheckForDescription();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: btnColor,
                              ),
                              height: 40,
                              padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                              child:  const Center(child: Text('Update',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: Colors.white),),),
                            )
                        ),


                      ],
                    )
                ),
              ),);
          });
        });
  }
  _validationCheckForDescription(){
    String reasonStr=descriptionController.text.toString();
    print("test Description $reasonStr");
    if(reasonStr.isNotEmpty){
      _focusNode.unfocus();
      Navigator.of(context).pop();
      if(taskDescription!=reasonStr){
        _updateDescription(reasonStr);
      }



    }else{
      Toast.show("Please Enter a valid Description for Task",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }


  getAllLog() async{
    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    ApiBaseHelper helper= ApiBaseHelper();
    var response=await helper.getWithToken(baseUrl,"tasks/task-history-by-type?id=${widget.taskId}&type=all",token, context);
    var responseJSON = json.decode(response.body);
    Navigator.of(context).pop();
    print(responseJSON);
    if (responseJSON['error'] == false) {
      allLogsList.clear();
      allLogsList=responseJSON['data'];
      setState(() {
        isLoading=false;
      });

    }else if(responseJSON['code']==401|| responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        isLoading=false;
      });
      _logOut(context);
    }else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

      setState(() {
        isLoading=false;
      });

    }
  }
  getHistoryLog() async{
    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    ApiBaseHelper helper= ApiBaseHelper();
    var response=await helper.getWithToken(baseUrl,"tasks/task-history-by-type?id=${widget.taskId}&type=task_history",token, context);
    var responseJSON = json.decode(response.body);
    Navigator.of(context).pop();
    print(responseJSON);
    if (responseJSON['error'] == false) {
      historyLogList.clear();
      historyLogList=responseJSON['data'];
      setState(() {
        isLoading=false;
      });

    }else if(responseJSON['code']==401|| responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        isLoading=false;
      });
      _logOut(context);
    }else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

      setState(() {
        isLoading=false;
      });

    }
  }
  getWorkLog() async{
    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    ApiBaseHelper helper= ApiBaseHelper();
    var response=await helper.getWithToken(baseUrl,"tasks/task-history-by-type?id=${widget.taskId}&type=worklog",token, context);
    var responseJSON = json.decode(response.body);
    Navigator.of(context).pop();
    print(responseJSON);
    if (responseJSON['error'] == false) {
      workLogList.clear();
      workLogList=responseJSON['data'];
      setState(() {
        isLoading=false;
      });

    }else if(responseJSON['code']==401|| responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        isLoading=false;
      });
      _logOut(context);
    }else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);

      setState(() {
        isLoading=false;
      });

    }
  }


  _showBottomForDeleteConfirmation(){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext contx){
          return StatefulBuilder(builder: (ctx,setDialogState){
            return Padding(padding: MediaQuery.of(context).viewInsets,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
                ),
                child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20,),
                        Align(alignment: Alignment.center, child: Container(height: 5,width: 30,color: AppTheme.greyColor,),),
                        const SizedBox(height: 10,),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              const Expanded(child: Text("Delete Task!",style: TextStyle(fontWeight: FontWeight.w900,color: Colors.red,fontSize: 18.5),)),
                              const SizedBox(width: 5,),
                              InkWell(
                                onTap: (){
                                  Navigator.of(context).pop();
                                },
                                child: const Icon(Icons.close_rounded,color: AppTheme.at_green,size: 32,),
                              ),
                              const SizedBox(width: 5,),

                            ],
                          ),),
                        const SizedBox(height: 10,),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("Are you sure you want to delete this task ? ", textAlign: TextAlign.center,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: AppTheme.themeColor),),),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(child: TextButton(
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppTheme.themeColor,
                                  ),
                                  height: 40,
                                  padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                  child:  const Center(child: Text('Cancel',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: Colors.white),),),
                                )
                            )),
                            SizedBox(width: 10,),
                            Expanded(child: TextButton(
                                onPressed: (){
                                  Navigator.of(context).pop();
                                  _deleteTask();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppTheme.task_Reopen_text,
                                  ),
                                  height: 40,
                                  padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                  child:  const Center(child: Text('Delete',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: Colors.white),),),
                                )
                            )),
                          ],
                        ),


                      ],
                    )
                ),
              ),);
          });
        });
  }

  _deleteTask()async{
    APIDialog.showAlertDialog(context, "Please Wait...");

    var requestModel = {
      "id": widget.taskId,
    };
    ApiBaseHelper helper= ApiBaseHelper();
    var response = await helper.postAPIWithHeader(baseUrl, 'tasks/delete-task',requestModel,context, token);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
     if(responseJSON['code']==200){
       fininshScreen();
     }
    }
    else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  fininshScreen(){
    Navigator.of(context).pop();
  }


}
class dynamicTaskTypeModel{
  String taskTypeId,categoryKey,categoryValue;
  String managerId;

  dynamicTaskTypeModel(this.taskTypeId, this.categoryKey, this.categoryValue,this.managerId);
}