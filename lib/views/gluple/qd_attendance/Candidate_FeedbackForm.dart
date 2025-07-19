import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../utils/app_theme.dart';

class CandidateFeedback extends StatefulWidget{
 /* String candidateName;
  String candidateId;
  String callFrom;
  String callTo;
  String accessNumber;
  String callDate;

  CandidateFeedback(
      this.candidateName, this.candidateId, this.callFrom, this.callTo,this.accessNumber,this.callDate, {super.key});
*/

  String candidateName;
  String candidateMobile;
  String candidateEmail;
  String candidateDesignation;
  String candidateStatus;

  CandidateFeedback(this.candidateName, this.candidateMobile,
      this.candidateEmail, this.candidateDesignation, this.candidateStatus, {super.key});

  _candidateFeedback createState()=>_candidateFeedback();

}
class _candidateFeedback extends State<CandidateFeedback>{
  var filterList=['1','2','3','4','5'];
  String filterDropDown = '1';
  String qualitWorkOnVehicle="1";
  String arcsAdvisor="1";
  String explanationOfJobs="1";
  String adhrenceTime="1";
  String allJobDone="1";
  var p1Controller = TextEditingController();
  var p2Controller = TextEditingController();
  var n1Controller = TextEditingController();
  var n2Controller = TextEditingController();
  var receivedController = TextEditingController();
  var feedbackController = TextEditingController();

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
            "Add Feedback",
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
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                /*Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      color: AppTheme.otpColor
                  ),
                  margin: EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                            color: AppTheme.orangeColor
                        ),
                        child: Text(widget.candidateName,style: TextStyle(fontWeight: FontWeight.w700,color: Colors.white,fontSize: 14),),
                      ),
                      SizedBox(height: 10,),
                      Padding(padding: EdgeInsets.only(left: 10,right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              children: [
                                Text("Access No : ",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),),
                                SizedBox(width: 5,),
                                Expanded(child: Text(widget.accessNumber,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700,color: Colors.black),),),
                              ],
                            ),


                            SizedBox(height: 10,),

                            Row(
                              children: [
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Call From",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),),
                                    SizedBox(height: 3,),
                                    Text(widget.callFrom,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w700,color: Colors.black),),
                                  ],
                                )),
                                SizedBox(width: 5,),
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text("Call To",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),),
                                    SizedBox(height: 3,),
                                    Text(widget.callTo,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w700,color: Colors.black),),
                                  ],
                                )),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Text("Date",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),),
                                SizedBox(width: 5,),
                                Expanded(child: Text(widget.callDate,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w700,color: Colors.black),),),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),

                          ],
                        ),),






                    ],
                  ),
                ),*/
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                      color: AppTheme.otpColor
                  ),
                  margin: EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                            color: AppTheme.orangeColor
                        ),
                        child: Text("${widget.candidateName}",style: TextStyle(fontWeight: FontWeight.w700,color: Colors.white,fontSize: 14),),
                      ),
                      SizedBox(height: 10,),
                      Padding(padding: EdgeInsets.only(left: 10,right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(child: Text("Mobile :${widget.candidateMobile}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),)),
                                widget.candidateStatus=="open"?
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppTheme.at_blue
                                  ),
                                  child: Center(child: Text("Open",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 12,color: Colors.white),),),
                                ):
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppTheme.at_red
                                  ),
                                  child: Center(child: Text(widget.candidateStatus,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 12,color: Colors.white),),),
                                )

                              ],
                            ),
                            SizedBox(height: 5,),
                            Text("Email :${widget.candidateEmail}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),),
                            SizedBox(height: 5,),
                            Text("Designation :${widget.candidateDesignation}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black),),
                            SizedBox(height: 5,),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),),






                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Text("Quality of the work done on the Vehicle.",
                  style: TextStyle(fontSize: 14.5,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),),
                SizedBox(height: 2,),
                Container(
                  width: double.infinity,
                  height: 45,
                  padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: AppTheme.greyColor,width: 2.0),

                  ),
                  child: DropdownButton(
                    items: filterList.map((String items) {return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );}).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        qualitWorkOnVehicle = newValue!;
                      });

                    },
                    value: qualitWorkOnVehicle,
                    icon: Icon(Icons.keyboard_arrow_down,color: AppTheme.themeColor,size: 15,),
                    isExpanded: true,
                    underline: SizedBox(),
                  ),
                ),

                SizedBox(height: 10,),
                Text("Attention, responsiveness & courtesy of Service Advisor.",
                  style: TextStyle(fontSize: 14.5,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),),
                SizedBox(height: 2,),
                Container(
                  width: double.infinity,
                  height: 45,
                  padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: AppTheme.greyColor,width: 2.0),

                  ),
                  child: DropdownButton(
                    items: filterList.map((String items) {return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );}).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        arcsAdvisor = newValue!;
                      });

                    },
                    value: arcsAdvisor,
                    icon: Icon(Icons.keyboard_arrow_down,color: AppTheme.themeColor,size: 15,),
                    isExpanded: true,
                    underline: SizedBox(),
                  ),
                ),

                SizedBox(height: 10,),
                Text("Explanation of the jobs done and charges.",
                  style: TextStyle(fontSize: 14.5,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),),
                SizedBox(height: 2,),
                Container(
                  width: double.infinity,
                  height: 45,
                  padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: AppTheme.greyColor,width: 2.0),

                  ),
                  child: DropdownButton(
                    items: filterList.map((String items) {return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );}).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        explanationOfJobs = newValue!;
                      });

                    },
                    value: explanationOfJobs,
                    icon: Icon(Icons.keyboard_arrow_down,color: AppTheme.themeColor,size: 15,),
                    isExpanded: true,
                    underline: SizedBox(),
                  ),
                ),

                SizedBox(height: 10,),
                Text("Adherence to timelines committed (estimate & delivery).",
                  style: TextStyle(fontSize: 14.5,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),),
                SizedBox(height: 2,),
                Container(
                  width: double.infinity,
                  height: 45,
                  padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: AppTheme.greyColor,width: 2.0),

                  ),
                  child: DropdownButton(
                    items: filterList.map((String items) {return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );}).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        adhrenceTime = newValue!;
                      });

                    },
                    value: adhrenceTime,
                    icon: Icon(Icons.keyboard_arrow_down,color: AppTheme.themeColor,size: 15,),
                    isExpanded: true,
                    underline: SizedBox(),
                  ),
                ),

                SizedBox(height: 10,),
                Text("Whether all jobs were completed as requested by you.",
                  style: TextStyle(fontSize: 14.5,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),),
                SizedBox(height: 2,),
                Container(
                  width: double.infinity,
                  height: 45,
                  padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: AppTheme.greyColor,width: 2.0),

                  ),
                  child: DropdownButton(
                    items: filterList.map((String items) {return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );}).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        allJobDone = newValue!;
                      });

                    },
                    value: allJobDone,
                    icon: Icon(Icons.keyboard_arrow_down,color: AppTheme.themeColor,size: 15,),
                    isExpanded: true,
                    underline: SizedBox(),
                  ),
                ),

                SizedBox(height: 10,),
                Text("Whether all jobs were completed as requested by you.",
                  style: TextStyle(fontSize: 14.5,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),),
                SizedBox(height: 2,),
                Container(
                  width: double.infinity,
                  height: 45,
                  padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: AppTheme.greyColor,width: 2.0),

                  ),
                  child: DropdownButton(
                    items: filterList.map((String items) {return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );}).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        allJobDone = newValue!;
                      });

                    },
                    value: allJobDone,
                    icon: Icon(Icons.keyboard_arrow_down,color: AppTheme.themeColor,size: 15,),
                    isExpanded: true,
                    underline: SizedBox(),
                  ),
                ),


                SizedBox(height: 10,),
                Text("Positive Point 1",
                  style: TextStyle(fontSize: 14.5,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),),
                SizedBox(height: 2,),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: AppTheme.greyColor,width: 2.0),

                  ),
                  child: TextField(
                    minLines: 1,
                    keyboardType: TextInputType.text,
                    controller: p1Controller,
                  ),

                ),

                SizedBox(height: 10,),
                Text("Positive Point 2",
                  style: TextStyle(fontSize: 14.5,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),),
                SizedBox(height: 2,),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: AppTheme.greyColor,width: 2.0),

                  ),
                  child: TextField(
                    minLines: 1,
                    keyboardType: TextInputType.text,
                    controller: p2Controller,
                  ),

                ),

                SizedBox(height: 10,),
                Text("Negative Point 1",
                  style: TextStyle(fontSize: 14.5,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),),
                SizedBox(height: 2,),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: AppTheme.greyColor,width: 2.0),

                  ),
                  child: TextField(
                    minLines: 1,
                    keyboardType: TextInputType.text,
                    controller: n1Controller,
                  ),

                ),

                SizedBox(height: 10,),
                Text("Negative Point 2",
                  style: TextStyle(fontSize: 14.5,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),),
                SizedBox(height: 2,),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: AppTheme.greyColor,width: 2.0),

                  ),
                  child: TextField(
                    minLines: 1,
                    keyboardType: TextInputType.text,
                    controller: n2Controller,
                  ),

                ),

                SizedBox(height: 10,),
                Text("Feedback Received From",
                  style: TextStyle(fontSize: 14.5,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),),
                SizedBox(height: 2,),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: AppTheme.greyColor,width: 2.0),

                  ),
                  child: TextField(
                    minLines: 1,
                    keyboardType: TextInputType.text,
                    controller: receivedController,
                  ),

                ),


                SizedBox(height: 10,),
                Text("Additional Remark",
                  style: TextStyle(fontSize: 14.5,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),),
                SizedBox(height: 2,),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: AppTheme.greyColor,width: 2.0),

                  ),
                  child: TextField(
                    minLines: 2,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    controller: feedbackController,
                  ),

                ),

                SizedBox(height: 10,),
                InkWell(
                  onTap: (){

                  },
                  child: Container(
                    height: 45,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5),
                        color: AppTheme.at_details_date_back
                    ),
                    child: Center(child: Text("Submit",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16,color: Colors.white),),),
                  ),
                ),

                SizedBox(height: 10,)



              ],
            ),
          ),
        )

    );
  }
}