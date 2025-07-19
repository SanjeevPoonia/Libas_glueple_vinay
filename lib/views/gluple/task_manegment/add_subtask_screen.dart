import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import 'dart:io';
import '../views/login_screen.dart';
import 'package:intl/intl.dart';
import 'package:ChecklistTree/views/login_screen.dart';

class AddSubTask_Screen extends StatefulWidget{
  String taskId;

  AddSubTask_Screen(this.taskId);

  _addSubtask createState()=> _addSubtask();
}
class _addSubtask extends State<AddSubTask_Screen>{
  bool isLoading=false;
  late var userIdStr;
  late var fullNameStr;
  late var designationStr;
  late var token;
  late var empId;
  late var baseUrl;
  late var platform;
  final _formKey = GlobalKey<FormState>();
  final _dialogKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var watcheerController=TextEditingController();
  var weekController=TextEditingController();
  var dayController=TextEditingController();
  var hourController=TextEditingController();
  var minuteController=TextEditingController();
  String projectValue = '';
  var projectList = [''];
  String selectProjectTitle='Select Project';
  List<dynamicProjectModel>projectDynamicList=[];
  String selectedProjectId="0";
  String taskTypeValue = '';
  var taskTypeList = [''];
  String selectTaskTypeTitle='Select Task Type';
  List<dynamicTaskTypeModel>taskTypeDynamicList=[];
  String selectedTaskType="0";
  String priorityValue = '';
  var priorityList = [''];
  String selectpriorityTitle='Select Priority';
  List<dynamicTaskTypeModel>priorityDynamicList=[];
  String selectedPriority="0";
  String statusValue = '';
  var statusList = [''];
  String selectstatusTitle='Select Status';
  List<dynamicTaskTypeModel>statusDynamicList=[];
  String selectedStatus="0";
  String assigneeValue = '';
  var assigneeList = [''];
  String selectassigneeTitle='Select Assignee';
  List<dynamicTaskTypeModel>assigneeDynamicList=[];
  String selectedAssignee="0";
  String assigneeManager="0";
  List<watcherDynamicModel> totalWatcherList=[];
  List<watcherDynamicModel> selectedWatcherList=[];
  List<watcherDynamicModel> searchedWatcherList=[];
  String selectedWatchersName="";
  String taskDate="";
  String dueDate="";
  String taskDateStr="Select Task Date";
  String dueDateStr="Select Due Date";
  bool isImageSelected=false;
  XFile? imageFile;
  File? file;
  String selectedTitle="";
  String selectedDescription="";
  String selectedOriginalEstimate="";

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
          "Add Sub Task",
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Project*",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                    SizedBox( height: 5,),
                    Container(
                      width: double.infinity,
                      height: 45,
                      padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: AppTheme.greyColor,width: 2.0),

                      ),
                      child: DropdownButton(
                        items: projectList.map((String items) {return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );}).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            projectValue = newValue!;
                            int position=projectList.indexOf(newValue);
                            selectedProjectId=projectDynamicList[position].projectId;
                            print("selected Index $selectedProjectId");

                          });

                        },
                        value: projectValue,
                        icon: Icon(Icons.keyboard_arrow_down,color: AppTheme.themeColor,size: 15,),
                        isExpanded: true,
                        underline: SizedBox(),
                      ),
                    ),

                    SizedBox(height: 10,),
                    Text("Title*",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                    SizedBox( height: 5,),
                    TextFormField(
                      textAlign: TextAlign.start,
                      controller: titleController,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppTheme.bottomDisabledColor,
                              width: 2.0
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppTheme.orangeColor,
                              width: 2.0
                          ),
                        ),
                        hintText: 'Title',
                        hintStyle: TextStyle(
                            color: AppTheme.at_lightgray
                        ),
                      ),
                    ),

                    SizedBox(height: 10,),
                    Text("Task Type*",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                    SizedBox( height: 5,),
                    Container(
                      width: double.infinity,
                      height: 45,
                      padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: AppTheme.greyColor,width: 2.0),

                      ),
                      child: DropdownButton(
                        items: taskTypeList.map((String items) {return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );}).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            taskTypeValue = newValue!;
                            int position=taskTypeList.indexOf(newValue);
                            selectedTaskType=taskTypeDynamicList[position].taskTypeId;
                            print("selected task $selectedTaskType");
                          });

                        },
                        value: taskTypeValue,
                        icon: Icon(Icons.keyboard_arrow_down,color: AppTheme.themeColor,size: 15,),
                        isExpanded: true,
                        underline: SizedBox(),
                      ),
                    ),


                    SizedBox(height: 10,),
                    Text("Status*",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                    SizedBox( height: 5,),
                    Container(
                      width: double.infinity,
                      height: 45,
                      padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: AppTheme.greyColor,width: 2.0),

                      ),
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

                        },
                        value: statusValue,
                        icon: Icon(Icons.keyboard_arrow_down,color: AppTheme.themeColor,size: 15,),
                        isExpanded: true,
                        underline: SizedBox(),
                      ),
                    ),

                    SizedBox(height: 10,),
                    Text("Priority*",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                    SizedBox( height: 5,),
                    Container(
                      width: double.infinity,
                      height: 45,
                      padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: AppTheme.greyColor,width: 2.0),

                      ),
                      child: DropdownButton(
                        items: priorityList.map((String items) {return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );}).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            priorityValue = newValue!;
                            int position=priorityList.indexOf(newValue);
                            selectedPriority=priorityDynamicList[position].taskTypeId;
                            print("selected priority $selectedPriority");
                          });

                        },
                        value: priorityValue,
                        icon: Icon(Icons.keyboard_arrow_down,color: AppTheme.themeColor,size: 15,),
                        isExpanded: true,
                        underline: SizedBox(),
                      ),
                    ),

                    SizedBox(height: 10,),
                    Text("Description*",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                    SizedBox( height: 5,),
                    TextFormField(
                      textAlign: TextAlign.start,
                      controller: descriptionController,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      maxLength: 500,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppTheme.bottomDisabledColor,
                              width: 2.0
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppTheme.orangeColor,
                              width: 2.0
                          ),
                        ),
                        hintText: 'Description',
                        hintStyle: TextStyle(
                            color: AppTheme.at_lightgray
                        ),
                      ),
                    ),

                    SizedBox(height: 10,),
                    Text("Assignee*",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                    SizedBox( height: 5,),
                    Container(
                      width: double.infinity,
                      height: 45,
                      padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: AppTheme.greyColor,width: 2.0),

                      ),
                      child: DropdownButton(
                        items: assigneeList.map((String items) {return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );}).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            assigneeValue = newValue!;
                            int position=assigneeList.indexOf(newValue);
                            selectedAssignee=assigneeDynamicList[position].taskTypeId;
                            assigneeManager=assigneeDynamicList[position].managerId;
                            print("selected Assignee $selectedAssignee");
                          });

                        },
                        value: assigneeValue,
                        icon: Icon(Icons.keyboard_arrow_down,color: AppTheme.themeColor,size: 15,),
                        isExpanded: true,
                        underline: SizedBox(),
                      ),
                    ),

                    SizedBox(height: 10,),
                    Text("Watcher*",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                    SizedBox( height: 5,),
                    InkWell(
                      onTap: (){
                        _showWatcherSelectDialog();
                      },
                      child: TextFormField(
                        enabled: false,
                        textAlign: TextAlign.start,
                        controller: watcheerController,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.bottomDisabledColor,
                                width: 2.0
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppTheme.orangeColor,
                                width: 2.0
                            ),
                          ),
                          hintText: 'Select Watcher',
                          hintStyle: TextStyle(
                              color: AppTheme.at_lightgray
                          ),
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(top: 15), // add padding to adjust icon
                            child: Icon(Icons.arrow_drop_down),
                          ),
                        ),

                      ),
                    ),

                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Task Date",
                              style: TextStyle(fontSize: 14.5,
                                  color: AppTheme.themeColor,
                                  fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            InkWell(
                              onTap: (){
                                _showFromDatePicker();
                              },
                              child: Container(
                                width: double.infinity,
                                height: 45,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: AppTheme.greyColor,width: 2.0),

                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(child: Text(taskDateStr,style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),)),
                                    SizedBox(width: 5,),
                                    SvgPicture.asset('assets/at_calendar.svg',height: 21,width: 18,),
                                  ],
                                ),
                              ),
                            )

                          ],
                        )),
                        SizedBox(width: 5,),
                        Expanded(child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Due Date",
                              style: TextStyle(fontSize: 14.5,
                                  color: AppTheme.themeColor,
                                  fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            InkWell(
                              onTap: (){
                                // _showEndDatePicker();
                                _showEndDateValidation();
                              },
                              child: Container(
                                width: double.infinity,
                                height: 45,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: AppTheme.greyColor,width: 2.0),

                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(child: Text(dueDateStr,style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),)),
                                    SizedBox(width: 5,),
                                    SvgPicture.asset('assets/at_calendar.svg',height: 21,width: 18,),
                                  ],
                                ),
                              ),
                            )

                          ],
                        )),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Text("Original Estimate(2w 4d 6h 45m)",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                    SizedBox( height: 5,),
                    Row(
                      children: [
                        Expanded(child:
                        TextFormField(
                          textAlign: TextAlign.start,
                          controller: weekController,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp('[a-zA-Z]')),
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppTheme.bottomDisabledColor,
                                  width: 2.0
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppTheme.orangeColor,
                                  width: 2.0
                              ),
                            ),
                            hintText: 'W',
                            hintStyle: TextStyle(
                                color: AppTheme.at_lightgray
                            ),
                          ),
                        )
                        ),
                        SizedBox(width: 2,),
                        Text('w',style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),),
                        SizedBox(width: 5,),

                        Expanded(child:
                        TextFormField(
                          textAlign: TextAlign.start,
                          controller: dayController,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp('[a-zA-Z]')),
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppTheme.bottomDisabledColor,
                                  width: 2.0
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppTheme.orangeColor,
                                  width: 2.0
                              ),
                            ),
                            hintText: 'd',
                            hintStyle: TextStyle(
                                color: AppTheme.at_lightgray
                            ),
                          ),
                        )
                        ),
                        SizedBox(width: 2,),
                        Text('d',style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),),
                        SizedBox(width: 5,),

                        Expanded(child:
                        TextFormField(
                          textAlign: TextAlign.start,
                          controller: hourController,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp('[a-zA-Z]')),
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppTheme.bottomDisabledColor,
                                  width: 2.0
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppTheme.orangeColor,
                                  width: 2.0
                              ),
                            ),
                            hintText: 'h',
                            hintStyle: TextStyle(
                                color: AppTheme.at_lightgray
                            ),
                          ),
                        )
                        ),
                        SizedBox(width: 2,),
                        Text('h',style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),),
                        SizedBox(width: 5,),

                        Expanded(child:
                        TextFormField(
                          textAlign: TextAlign.start,
                          controller: minuteController,
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp('[a-zA-Z]')),
                            FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          ],
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppTheme.bottomDisabledColor,
                                  width: 2.0
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppTheme.orangeColor,
                                  width: 2.0
                              ),
                            ),
                            hintText: 'm',
                            hintStyle: TextStyle(
                                color: AppTheme.at_lightgray
                            ),
                          ),
                        )
                        ),
                        SizedBox(width: 2,),
                        Text('m',style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),),
                        SizedBox(width: 5,),
                      ],
                    ),
                    SizedBox(height: 10,),

                    Text("Attachment",style: TextStyle(fontSize: 14.5,color: AppTheme.themeColor,fontWeight: FontWeight.w500),),
                    SizedBox( height: 5,),
                    Padding(padding: const EdgeInsets.only(top: 15),
                      child: Container(

                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                            border: Border.all(color: AppTheme.orangeColor,width: 1.0)
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 7,right: 10,top: 5,bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [

                                  TextButton(
                                      onPressed: (){
                                        imageSelector();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: AppTheme.orangeColor,
                                        ),
                                        height: 45,
                                        padding: const EdgeInsets.all(10),
                                        child: const Center(child: Text("Browse",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: Colors.white),),),
                                      )
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),

                              isImageSelected?
                              Container(
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
                              )
                                  :
                              const SizedBox(height: 1,),
                            ],
                          ),
                        ),

                      ) ,),


                    SizedBox(height: 10,),
                    TextButton(
                        onPressed: (){
                          _submitHandler();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.orangeColor,
                          ),
                          height: 45,
                          child: const Center(child: Text("Submit",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: Colors.white),),),
                        )
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),),
    );
  }
  _showFromDatePicker() async{

    var nowDate=DateTime.now();
    var lastDate=DateTime(nowDate.year,nowDate.month+2,1);
    var firstDate=DateTime(nowDate.year,nowDate.month-1,1);

    DateTime? pickedDate=await showDatePicker(context: context, firstDate: firstDate, lastDate: lastDate);
    if(pickedDate !=null){
      taskDate= DateFormat("yyyy-MM-dd").format(pickedDate);
      setState(() {
        taskDateStr=taskDate;
      });
      _showEndDatePicker();
    }
  }
  _showEndDatePicker() async{
    Toast.show("Please Select Due Date!!",
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.green);

    var nowDate=DateFormat("yyyy-MM-dd").parse(taskDate);
    var lastDate=DateTime(nowDate.year,nowDate.month,nowDate.day+6);

    DateTime? pickedDate=await showDatePicker(context: context, firstDate: nowDate, lastDate: lastDate);
    if(pickedDate !=null){
      dueDate= DateFormat("yyyy-MM-dd").format(pickedDate);

      var fDate=DateFormat("dd MMM yyyy").format(nowDate);
      var tDate= DateFormat("dd MMM yyyy").format(pickedDate);

      setState(() {
        dueDateStr = dueDate;
      });
    }
  }
  _showEndDateValidation(){
    if(taskDate.isEmpty){
      Toast.show("Please Select Task Date First!!!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else{
      _showEndDatePicker();
    }
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
        setState(() {
          debugPrint("SELECTED IMAGE PICK   $imageFiles");
        });
        isImageSelected=true;

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
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      _buildListItems();
    });


  }
  _buildListItems() async{
    APIDialog.showAlertDialog(context, "Please Wait...");
    setState(() {
      isLoading=true;
    });
    userIdStr=await MyUtils.getSharedPreferences("user_id");
    fullNameStr=await MyUtils.getSharedPreferences("full_name");
    token=await MyUtils.getSharedPreferences("token");
    designationStr=await MyUtils.getSharedPreferences("designation");
    empId=await MyUtils.getSharedPreferences("emp_id");
    baseUrl=await MyUtils.getSharedPreferences("base_url");
    if(Platform.isAndroid){
      platform="Android";
    }else if(Platform.isIOS){
      platform="iOS";
    }else{
      platform="Other";
    }
    Navigator.pop(context);
    setState(() {
      isLoading=false;
    });


    getProjectList();
    getTaskType();
    getStatus();
    getPriority();
    getActiveEmployee();
  }
  getProjectList() async{
    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    ApiBaseHelper helper= ApiBaseHelper();
    var response=await helper.getWithToken(baseUrl,"tasks/get-projects",token, context);
    var responseJSON = json.decode(response.body);
    Navigator.of(context).pop();
    print(responseJSON);
    if (responseJSON['error'] == false) {
      List<dynamic> tempList=[];
      tempList=responseJSON['data'];
      projectList.clear();
      projectDynamicList.clear();

      projectList.add(selectProjectTitle);
      projectValue=selectProjectTitle;
      projectDynamicList.add(dynamicProjectModel("0", selectProjectTitle, 'select', "0"));

      for(int i=0;i<tempList.length;i++){
        String pId=tempList[i]['id'].toString();
        String pName=tempList[i]['name'].toString();
        String project_key=tempList[i]['project_key'].toString();
        String project_type=tempList[i]['project_type'].toString();
        projectDynamicList.add(dynamicProjectModel(pId, pName, project_key, project_type));
        projectList.add(pName);
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
  getTaskType() async{
    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    ApiBaseHelper helper= ApiBaseHelper();
    var response=await helper.getWithToken(baseUrl,"common_api/dropdown-master-data?type=task_type",token, context);
    var responseJSON = json.decode(response.body);
    Navigator.of(context).pop();
    print(responseJSON);
    if (responseJSON['error'] == false) {
      List<dynamic> tempList=[];
      tempList=responseJSON['data'];
      taskTypeList.clear();
      taskTypeDynamicList.clear();

      taskTypeList.add(selectTaskTypeTitle);
      taskTypeValue=selectTaskTypeTitle;
      taskTypeDynamicList.add(dynamicTaskTypeModel("0", "select", selectTaskTypeTitle,"0"));

      for(int i=0;i<tempList.length;i++){
        String pId=tempList[i]['id'].toString();
        String project_key=tempList[i]['category_key'].toString();
        String project_type=tempList[i]['category_value'].toString();
        taskTypeDynamicList.add(dynamicTaskTypeModel(pId, project_type, project_key,"0"));
        taskTypeList.add(project_key);
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
  getPriority() async{
    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    ApiBaseHelper helper= ApiBaseHelper();
    var response=await helper.getWithToken(baseUrl,"common_api/dropdown-master-data?type=priority",token, context);
    var responseJSON = json.decode(response.body);
    Navigator.of(context).pop();
    print(responseJSON);
    if (responseJSON['error'] == false) {
      List<dynamic> tempList=[];
      tempList=responseJSON['data'];
      priorityList.clear();
      priorityDynamicList.clear();

      priorityList.add(selectpriorityTitle);
      priorityValue=selectpriorityTitle;
      priorityDynamicList.add(dynamicTaskTypeModel("0", "select", selectpriorityTitle,"0"));

      for(int i=0;i<tempList.length;i++){
        String pId=tempList[i]['id'].toString();
        String project_key=tempList[i]['category_key'].toString();
        String project_type=tempList[i]['category_value'].toString();
        priorityDynamicList.add(dynamicTaskTypeModel(pId, project_type, project_key,"0"));
        priorityList.add(project_key);
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

      statusList.add(selectstatusTitle);
      statusValue=selectstatusTitle;
      statusDynamicList.add(dynamicTaskTypeModel("0", "select", selectstatusTitle,"0"));

      for(int i=0;i<tempList.length;i++){
        String pId=tempList[i]['id'].toString();
        String project_key=tempList[i]['category_key'].toString();
        String project_type=tempList[i]['category_value'].toString();
        statusDynamicList.add(dynamicTaskTypeModel(pId, project_type, project_key,"0"));
        statusList.add(project_key);
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
  getActiveEmployee() async{
    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    ApiBaseHelper helper= ApiBaseHelper();
    var response=await helper.getWithToken(baseUrl,"rest_api/activeEmployee",token, context);
    var responseJSON = json.decode(response.body);
    Navigator.of(context).pop();
    print(responseJSON);
    if (responseJSON['error'] == false) {
      List<dynamic> tempList=[];
      tempList=responseJSON['data'];
      assigneeList.clear();
      assigneeDynamicList.clear();

      totalWatcherList.clear();
      selectedWatcherList.clear();
      searchedWatcherList.clear();

      assigneeList.add(selectassigneeTitle);
      assigneeValue=selectassigneeTitle;
      assigneeDynamicList.add(dynamicTaskTypeModel("0", "select", selectassigneeTitle,"0"));

      for(int i=0;i<tempList.length;i++){
        String pId=tempList[i]['id'].toString();
        String emp_id=tempList[i]['emp_id'].toString();
        String employee=tempList[i]['employee'].toString();
        String manager=tempList[i]['reported_to'].toString();
        assigneeDynamicList.add(dynamicTaskTypeModel(pId, emp_id, employee,manager));
        assigneeList.add("$employee ( $emp_id )");
        totalWatcherList.add(watcherDynamicModel(emp_id, employee, pId, false));
        searchedWatcherList.add(watcherDynamicModel(emp_id, employee, pId, false));
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
  _showWatcherSelectDialog(){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext contx){
          return StatefulBuilder(builder: (ctx,setDialogState){
            return Padding(padding: MediaQuery.of(ctx).viewInsets,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                margin: EdgeInsets.only(left: 5,right: 5),
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
                              Expanded(child: Text("Select Watcher",style: TextStyle(fontWeight: FontWeight.w900,color: Colors.black,fontSize: 18.5),)),
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
                        Form(
                            key: _dialogKey,
                            child:  TextFormField(
                              textAlign: TextAlign.start,
                              decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppTheme.bottomDisabledColor,
                                        width: 2.0
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppTheme.orangeColor,
                                        width: 2.0
                                    ),
                                  ),
                                  hintText: 'Search',
                                  hintStyle: TextStyle(
                                      color: AppTheme.at_lightgray
                                  ),
                                  labelText: 'Search',
                                  alignLabelWithHint: true
                              ),
                              onChanged: (String value)  {

                                setDialogState((){
                                  searchedWatcherList.clear();
                                  if(value.isEmpty){
                                    searchedWatcherList.addAll(totalWatcherList);
                                  }else{
                                    String search=value.toString().toLowerCase();
                                    for(int i=0;i<totalWatcherList.length;i++){
                                      String empName=totalWatcherList[i].empName.toLowerCase();
                                      if(empName.contains(search)){
                                        searchedWatcherList.add(totalWatcherList[i]);
                                      }
                                    }
                                  }
                                });


                              },
                            )),
                        SizedBox(height: 10,),
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: searchedWatcherList.length,
                            shrinkWrap: true,
                            itemBuilder: (sntx,indx){
                              return CheckboxListTile(
                                  controlAffinity: ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  title: Text(
                                    searchedWatcherList[indx].empName,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  value: searchedWatcherList[indx].selected,
                                  onChanged: (value){

                                    setDialogState((){
                                      searchedWatcherList[indx].selected=value!;
                                      if(selectedWatcherList.contains(searchedWatcherList[indx])){
                                        selectedWatcherList.remove(searchedWatcherList[indx]);
                                      }else{
                                        selectedWatcherList.add(searchedWatcherList[indx]);
                                      }
                                      for(int i=0;i<totalWatcherList.length;i++){
                                        String userId=totalWatcherList[i].userId;
                                        String selUserId=searchedWatcherList[indx].userId;
                                        if(selUserId==userId){
                                          totalWatcherList[i].selected=value;
                                          break;
                                        }
                                      }
                                    });
                                    _setWatcher();
                                  });
                            }),
                        const SizedBox(height: 10,),
                        TextButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                              _setWatcher();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppTheme.at_blue,
                              ),
                              height: 40,
                              padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                              child:  Center(child: Text("Apply",style: const TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: Colors.white),),),
                            )
                        ),
                      ],
                    )
                ),
              ),);
          });
        });
  }
  _setWatcher(){
    selectedWatchersName="";
    for(int i=0;i<selectedWatcherList.length;i++){
      String empName=selectedWatcherList[i].empName;
      if(selectedWatchersName.isEmpty){
        selectedWatchersName=empName;
      }else{
        selectedWatchersName='$selectedWatchersName,$empName';
      }
    }

    watcheerController.text=selectedWatchersName;

    setState(() {

    });
  }
  _submitHandler(){
    selectedTitle=titleController.text;
    selectedDescription=descriptionController.text;

    if(selectedProjectId=="0"){
      Toast.show("Please Select Project.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(selectedTitle.isEmpty || selectedTitle==""){
      Toast.show("Please Enter Title",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(selectedTitle.isEmpty || selectedTitle==""){
      Toast.show("Please Enter Title",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(selectedTaskType=="0"){
      Toast.show("Please Select Task Type",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(selectedStatus=="0"){
      Toast.show("Please Select Status",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(selectedPriority=="0"){
      Toast.show("Please Select Priority",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(selectedDescription.isEmpty || selectedDescription==""){
      Toast.show("Please Enter Description.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(selectedAssignee=="0"){
      Toast.show("Please Select Assignee",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(taskDate.isEmpty){
      Toast.show("Please Select Task Date",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(dueDate.isEmpty){
      Toast.show("Please Select Due Date",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else{
      if(isImageSelected){
        _submitTaskWithImage();
      }else{
        _submitTaskOnServer();
      }

    }

  }
  _submitTaskWithImage() async{
    APIDialog.showAlertDialog(context, 'Please wait...');

    String watchersId="";
    for(int i=0;i<selectedWatcherList.length;i++){
      String watchId=selectedWatcherList[i].userId;
      if(watchersId.isEmpty){
        watchersId=watchId;
      }else{
        watchersId='$watchersId,$watchId';
      }
    }
    String originalEsti="";

    String week=weekController.text;
    String day=dayController.text;
    String hour=hourController.text;
    String minute=minuteController.text;
    if(week.isEmpty){
      week='0w';
    }else{
      week='$week w';
    }
    if(day.isEmpty){
      day='0d';
    }else{
      day='$day d';
    }
    if(hour.isEmpty){
      hour='0h';
    }else{
      hour='$hour h';
    }
    if(minute.isEmpty){
      minute='0m';
    }else{
      minute='$minute m';
    }
    originalEsti='$week $day $hour $minute';

    String fileName = imageFile!.path.split('/').last;
    String extension = fileName.split('.').last;

    FormData formData = FormData.fromMap({
      "project": selectedProjectId,
      "parent_id": widget.taskId,
      "title": selectedTitle,
      "description": selectedDescription,
      "start_date": taskDate,
      "end_date": dueDate,
      "task_type": selectedTaskType,
      "status": selectedStatus,
      "priority": selectedPriority,
      "assignee": selectedAssignee,
      "reporting_manager": assigneeManager,
      "watcher_ids": watchersId,
      "original_estimate":originalEsti,
      "file": await MultipartFile.fromFile(imageFile!.path,
          filename: fileName),

    });
    String apiUrl=baseUrl+"tasks/save-tasks";
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
        _showCustomDialog(response.data['message']);
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
  _submitTaskOnServer()async{
    APIDialog.showAlertDialog(context, "Please Wait...");
    String watchersId="";
    for(int i=0;i<selectedWatcherList.length;i++){
      String watchId=selectedWatcherList[i].userId;
      if(watchersId.isEmpty){
        watchersId=watchId;
      }else{
        watchersId='$watchersId,$watchId';
      }
    }
    String originalEsti="";

    String week=weekController.text;
    String day=dayController.text;
    String hour=hourController.text;
    String minute=minuteController.text;
    if(week.isEmpty){
      week='0w';
    }else{
      week='$week w';
    }
    if(day.isEmpty){
      day='0d';
    }else{
      day='$day d';
    }
    if(hour.isEmpty){
      hour='0h';
    }else{
      hour='$hour h';
    }
    if(minute.isEmpty){
      minute='0m';
    }else{
      minute='$minute m';
    }
    originalEsti='$week $day $hour $minute';
    var requestModel = {
      "project": selectedProjectId,
      "parent_id": widget.taskId,
      "title": selectedTitle,
      "description": selectedDescription,
      "start_date": taskDate,
      "end_date": dueDate,
      "task_type": selectedTaskType,
      "status": selectedStatus,
      "priority": selectedPriority,
      "assignee": selectedAssignee,
      "reporting_manager": assigneeManager,
      "watcher_ids": watchersId,
      "original_estimate":originalEsti,
    };
    ApiBaseHelper helper= ApiBaseHelper();
    var response = await helper.postAPIWithHeader(baseUrl, 'tasks/save-tasks',requestModel,context, token);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      if(responseJSON['code']==200){
        _showCustomDialog(responseJSON['message']);
      }
    }else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  _finishTheScreen(){
    Navigator.of(context).pop();
  }
  _showCustomDialog(String msg){
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
                          _finishTheScreen();
                        },
                        child: Icon(Icons.close_rounded,color: Colors.red,size: 20,),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 100,
                      width: double.infinity,
                      child: Lottie.asset("assets/api_done_anim.json"),
                    ),
                    SizedBox(height: 10,),
                    Align(
                      alignment: Alignment.center,
                      child: Text(msg,style: TextStyle(color: AppTheme.orangeColor,fontWeight: FontWeight.w900,fontSize: 18),),
                    ),
                    SizedBox(height: 20,),
                    TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          _finishTheScreen();
                          //call attendance punch in or out
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



}
class dynamicProjectModel{
  String projectId,projectName,projectKey,projectType;


  dynamicProjectModel(
      this.projectId,
      this.projectName,
      this.projectKey,
      this.projectType,);
}
class dynamicTaskTypeModel{
  String taskTypeId,categoryKey,categoryValue;
  String managerId;

  dynamicTaskTypeModel(this.taskTypeId, this.categoryKey, this.categoryValue,this.managerId);
}
class watcherDynamicModel{
  String empId,empName,userId;
  bool selected;

  watcherDynamicModel(this.empId, this.empName, this.userId, this.selected);
}