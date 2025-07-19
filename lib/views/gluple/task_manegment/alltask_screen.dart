import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ChecklistTree/views/gluple/task_manegment/taskdetails_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import '../views/login_screen.dart';
import 'package:intl/intl.dart';

import 'addtask_screen.dart';
import 'package:ChecklistTree/views/login_screen.dart';

class AllTask_Screen extends StatefulWidget{
  _allTaskScreen createState()=> _allTaskScreen();
}
class _allTaskScreen extends State<AllTask_Screen>{
  bool isLoading=false;
  late var userIdStr;
  late var fullNameStr;
  late var designationStr;
  late var token;
  late var empId;
  late var baseUrl;
  List<dynamic> taskList=[];
  List<dynamic> totalTaskList=[];
  var reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
            "All Task",
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddTask_Screen()),).then((value) => getTaskList());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.PHColor,
                          ),
                          height: 45,
                          width: 150,
                          child: const Center(child: Text("Add Task",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: Colors.white),),),
                        )
                    ) ,
                  ),

                  SizedBox(height: 10,),
                  Form(
                      key: _formKey,
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
                        onChanged: (String value) async {
                          await _filterData(value);
                        },
                      )),
                  SizedBox(height: 10,),
                  taskList.isEmpty?
                  Align(alignment: Alignment.center,child: Text("No Task Available",style: TextStyle(fontSize: 17.5,color: AppTheme.orangeColor,fontWeight: FontWeight.w900),),):
                  ListView.builder(
                      shrinkWrap: true,
                      physics:const NeverScrollableScrollPhysics(),
                      itemCount: taskList.length,
                      itemBuilder: (BuildContext cntx,int index){
                        var respo=taskList[index];
                        String taskId=taskList[index]['id'].toString();
                        String taskTitle=taskList[index]['title'].toString();
                        String taskDescription=taskList[index]['description'].toString();
                        String taskDueDate="XXX, 00 XXX 0000";
                        if(taskList[index]['end_date']!=null){
                          var deliveryTime=DateTime.parse(taskList[index]['end_date']);
                          var delLocal=deliveryTime.toLocal();
                          taskDueDate=DateFormat('E, dd MMM yyyy').format(delLocal);
                        }
                        String taskStatus=taskList[index]['task_status'].toString();
                        var taskbackColor=AppTheme.task_progress_back;
                        var tasktextColor=AppTheme.task_progress_text;
                        if(taskStatus=='Open'){
                          taskbackColor=AppTheme.task_open_back;
                          tasktextColor=AppTheme.task_open_text;
                        }
                        else if(taskStatus=='Reopened'){
                          taskbackColor=AppTheme.task_Rejected_back;
                          tasktextColor=AppTheme.task_Rejected_text;
                        }
                        else if(taskStatus=='Close'){
                          taskbackColor=AppTheme.task_Close_back;
                          tasktextColor=AppTheme.task_Close_text;
                        }
                        else if(taskStatus=='To Do'){
                          taskbackColor=AppTheme.task_ToDo_back;
                          tasktextColor=AppTheme.task_ToDo_text;
                        }
                        else if(taskStatus=='QA Ready'){
                          taskbackColor=AppTheme.task_QAReady_back;
                          tasktextColor=AppTheme.task_QAReady_text;
                        }
                        else if(taskStatus=='On Hold'){
                          taskbackColor=AppTheme.task_OnHold_back;
                          tasktextColor=AppTheme.task_OnHold_text;
                        }
                        else if(taskStatus=='In Progress'){
                          taskbackColor=AppTheme.task_progress_back;
                          tasktextColor=AppTheme.task_progress_text;
                        }
                        else if(taskStatus=='In Review'){
                          taskbackColor=AppTheme.task_InReview_back;
                          tasktextColor=AppTheme.task_InReview_text;
                        }
                        else if(taskStatus=='Code Review'){
                          taskbackColor=AppTheme.task_CodeReview_back;
                          tasktextColor=AppTheme.task_CodeReview_text;
                        }
                        else if(taskStatus=='Done'){
                          taskbackColor=AppTheme.task_Done_back;
                          tasktextColor=AppTheme.task_Done_text;
                        }
                        else if(taskStatus=='Rejected'){
                          taskbackColor=AppTheme.task_Rejected_back;
                          tasktextColor=AppTheme.task_Rejected_text;
                        }else{
                          taskbackColor=Colors.black;
                          tasktextColor=Colors.white;
                        }
                        return InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TaskDetailsScreen(taskId, respo)),).then((value) => getTaskList());
                          },
                          child: Stack(children: [
                            Padding(padding: const EdgeInsets.only(top: 15),
                              child: Column(

                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.white,
                                        border: Border.all(color: AppTheme.orangeColor,width: 1.0)
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 7,right: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 5,),
                                          Text(taskTitle,style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),),
                                          const SizedBox(height: 10,),
                                          Html(data: taskDescription),
                                          const SizedBox(height: 10,),
                                          Row(
                                            children: [
                                              SizedBox(width: 5,),
                                              Expanded(child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("Task Due Date",style: TextStyle(color: AppTheme.themeColor,fontSize: 12,fontWeight: FontWeight.w500),),
                                                  SizedBox(height: 5,),
                                                  Row(
                                                    children: [
                                                      SvgPicture.asset('assets/at_calendar.svg',height: 21,width: 18,),
                                                      SizedBox(width: 5,),
                                                      Text(taskDueDate,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),),
                                                    ],
                                                  )
                                                ],
                                              )),
                                            ],
                                          ),
                                          const SizedBox(height: 10,),

                                        ],
                                      ),
                                    ),

                                  ),
                                  const SizedBox(height: 25,),
                                ],

                              ) ,),
                            Positioned(
                              right: 0,
                              child:  Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(1),
                                    color: taskbackColor),
                                width: 80,
                                height: 30,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(taskStatus,
                                      style: TextStyle(
                                          color: tasktextColor,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 12)),
                                ),

                              ),),
                          ],),
                        );

                      }),
                ],
              ),
            ),),
    );
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
    userIdStr=await MyUtils.getSharedPreferences("user_id");
    fullNameStr=await MyUtils.getSharedPreferences("full_name");
    token=await MyUtils.getSharedPreferences("token");
    designationStr=await MyUtils.getSharedPreferences("designation");
    empId=await MyUtils.getSharedPreferences("emp_id");
    baseUrl=await MyUtils.getSharedPreferences("base_url");
    Navigator.of(context).pop();
    getTaskList();
  }
  getTaskList() async{
    setState(() {
      isLoading=true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    ApiBaseHelper helper= ApiBaseHelper();
    var response=await helper.getWithToken(baseUrl,"tasks/get-tasks",token, context);
    var responseJSON = json.decode(response.body);
    Navigator.of(context).pop();
    print(responseJSON);
    if (responseJSON['error'] == false) {
      totalTaskList.clear();
      totalTaskList=responseJSON['data']['data'];

      taskList.clear();
      taskList.addAll(totalTaskList);

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
  _filterData(String value) {
    APIDialog.showAlertDialog(context, "Please wait...");

    taskList.clear();
    if(value.isEmpty){

      taskList.addAll(totalTaskList);
    }else{

      for(int i=0;i<totalTaskList.length;i++){
        String taskTitle=totalTaskList[i]['title'].toString().toLowerCase();
        String maStr=value.toLowerCase();


        if(taskTitle.contains(maStr)){
          taskList.add(totalTaskList[i]);
        }
      }
    }

    Navigator.of(context).pop();
    setState(() {
    });

  }
}