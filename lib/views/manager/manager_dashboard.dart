
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/app_theme.dart';
import 'add_task_screen.dart';

class ManagerDashboardScreen extends StatefulWidget
{
  StoreState createState()=>StoreState();
}

class StoreState extends State<ManagerDashboardScreen>
{
  List<String> sopList=[
    "SOP 1",
    "SOP 2",
  ];

  String? selectedSOP;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [

          Padding(padding: EdgeInsets.symmetric(horizontal: 0),
            child:Container(
              width: double.infinity,
              height: 100,
              decoration: const BoxDecoration(
                  color: AppTheme.dashboardheader
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  CircleAvatar(
                      backgroundImage: AssetImage("assets/profile.png"),
                      radius: 35),

                  SizedBox(width: 7,),
                  Expanded(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Test Manager",
                        style: TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.orangeColor),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "STR001",
                        style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ],
                  )),
                  SizedBox(width: 7),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "6:10:55 Hrs",
                        style: TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      SizedBox(height: 5,),

                      InkWell(
                        onTap: (){


                        },
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: AppTheme.orangeColor) ,
                          height: 30,
                          child:   Center(
                            child: Text("Check Out",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16
                              ),),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )),

          SizedBox(height: 15),




          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Tasks",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.themeColor),
                ),
              ),

              Spacer(),

              GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTaskScreen()));
                  },

                  child: Icon(Icons.add_circle,color: AppTheme.orangeColor)),

              SizedBox(width: 10)

            ],
          ),

          SizedBox(height: 10),

          ListView.builder(
              shrinkWrap: true,
              itemCount: 4,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context,int pos)

          {
            return Column(
              children: [

                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.white,

                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4), // Color of the shadow
                        spreadRadius: 0, // Spread radius of the shadow
                        blurRadius: 5, // Blur radius of the shadow
                        offset: Offset(0, 0), // Offset of the shadow
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [


                      Text('Task name',style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFf00ADEF),
                      )),

                      Text('Counter visit',style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      )),



                      SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Text('ID',style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFf00ADEF),
                              )),

                              Text('5443',style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              )),


                            ],
                          ),



                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Text('Task Type',style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFf00ADEF),
                              )),

                              Text('One Time',style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              )),


                            ],
                          ),

                          Container()




                        ],
                      ),

                      SizedBox(height: 10),


                      Row(
                        children: [


                          Container(
                              decoration: BoxDecoration(
                                  color: AppTheme.themeColor,
                                  borderRadius: BorderRadius.circular(5)),
                              height: 43,
                              child: const Center(
                                child: Text('Start Task',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white)),
                              ),padding: EdgeInsets.symmetric(horizontal: 10),),

                          SizedBox(width: 15),
                          Text('More info',style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFf00ADEF),
                          )),
                        ],
                      ),




                    ],
                  ),
                ),

                SizedBox(height: 15),
              ],
            );
          }


          ),




          SizedBox(height: 15),




          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Card(color: Colors.white,
              elevation: 5,
              shadowColor: AppTheme.greyColor,
              child: Container(
                width: double.infinity,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child: InkWell(
                        onTap: (){},
                        child:Icon(Icons.arrow_back_ios_new_rounded,color: Colors.black,size: 24,),
                      ),
                    ),
                    Expanded(child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/at_calendar.svg',height: 21,width: 18),
                        SizedBox(width: 5,),
                        Text("June",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w900,color: Colors.black),),
                      ],
                    )),


                    Padding(
                      padding: const EdgeInsets.only(right: 7),
                      child: InkWell(
                        onTap: (){},
                        child: Icon(Icons.arrow_forward_ios_rounded,color: Colors.black,size: 24,),
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),

          Container(
            width: double.infinity,
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(width: 1,color: AppTheme.at_details_divider),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Column(
              children: [
                SizedBox(height: 5,),
                Container(
                  height: 70,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: Align(
                          alignment: Alignment.center,
                          child: Text("Date",textAlign:TextAlign.center,style: TextStyle(color: AppTheme.at_details_title,fontSize: 12.5,fontWeight: FontWeight.w500),),
                        )),
                        const SizedBox(width: 1,),
                        Container(width: 1,color: AppTheme.at_details_divider,),
                        Expanded(child:  Text("Check In",textAlign:TextAlign.center,style: TextStyle(color: AppTheme.at_details_title,fontSize: 12.5,fontWeight: FontWeight.w500),),),
                        const SizedBox(width: 1,),
                        Container(width: 1,color: AppTheme.at_details_divider,),
                        const SizedBox(width: 1,),
                        Expanded(child: Text("Check Out",textAlign:TextAlign.center,style: TextStyle(color: AppTheme.at_details_title,fontSize: 12.5,fontWeight: FontWeight.w500),),),
                        const SizedBox(width: 1,),
                        Container(width: 1,color: AppTheme.at_details_divider,),
                        const SizedBox(width: 1,),
                        Expanded(child: Text("Working Hrs",textAlign:TextAlign.center,style: TextStyle(color: AppTheme.at_details_title,fontSize: 12.5,fontWeight: FontWeight.w500),),),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5,)
              ],
            ),
          ),


          ListView.builder(
            itemCount: 13,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext cntx,int index){

              String firstHalfText="";
              var firstHalfColor=Colors.black;
              String firstHalfStatusText="";


              String secondHalfText="09:37:47";
              var secondHalfColor=Colors.black;
              String secondHalfStatusText="";

              String workingHourText="09:37:47";
              var workingHourColor=Colors.black;
              String workingHourStatusText="";
              firstHalfText="P";
              firstHalfColor=AppTheme.PColor;


              return Container(
                width: double.infinity,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(width: 1,color: AppTheme.at_details_divider),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    InkWell(onTap: (){

                    },
                      child: Container(
                        height: 70,
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: AppTheme.at_details_date_back,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('13 May',style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white
                                        ),),

                                        Text("Mon",style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white
                                        ),),
                                      ],
                                    )
                                ),
                              )),


                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //Text("Check In",style: TextStyle(color: AppTheme.at_details_title,fontSize: 12.5,fontWeight: FontWeight.w500),),
                                  Text(firstHalfText,style: TextStyle(color: firstHalfColor,fontSize: 14.5,fontWeight: FontWeight.w900),),
                                  firstHalfStatusText.isEmpty?SizedBox(height: 1,):
                                  Text(firstHalfStatusText,style: TextStyle(color: firstHalfColor,fontSize: 14.5,fontWeight: FontWeight.w900),)

                                ],
                              )),
                              const SizedBox(width: 1,),
                              Container(width: 1,color: AppTheme.at_details_divider,),
                              const SizedBox(width: 1,),
                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Text("Check Out",style: TextStyle(color: AppTheme.at_details_title,fontSize: 12.5,fontWeight: FontWeight.w500),),
                                  Text(secondHalfText,style: TextStyle(color: secondHalfColor,fontSize: 14.5,fontWeight: FontWeight.w900),),
                                  secondHalfStatusText.isEmpty?SizedBox(height: 1,):
                                  Text(secondHalfStatusText,style: TextStyle(color: secondHalfColor,fontSize: 14.5,fontWeight: FontWeight.w900),)
                                ],
                              )),
                              const SizedBox(width: 1,),
                              Container(width: 1,color: AppTheme.at_details_divider,),
                              const SizedBox(width: 1,),
                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //Text("Working Hrs",style: TextStyle(color: AppTheme.at_details_title,fontSize: 12.5,fontWeight: FontWeight.w500),),
                                  Text(workingHourText,style: TextStyle(color: workingHourColor,fontSize: 14.5,fontWeight: FontWeight.w900),),
                                  workingHourStatusText.isEmpty?SizedBox(height: 1,):
                                  Text(workingHourStatusText,style: TextStyle(color: workingHourColor,fontSize: 14.5,fontWeight: FontWeight.w900),)
                                ],
                              )),





                            ],
                          ),
                        ),
                      ),),
                    const SizedBox(height: 10,)
                  ],
                ),
              );


            },
          ),
        ],
      ),

    );
  }

}

