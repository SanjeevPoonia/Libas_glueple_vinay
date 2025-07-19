import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../utils/app_theme.dart';

class ViewTaskFiles extends StatefulWidget{
  List<dynamic>mediaList;

  ViewTaskFiles(this.mediaList);

  _viewTaskFiles createState()=>_viewTaskFiles();
}
class _viewTaskFiles extends State<ViewTaskFiles>{
  late var userIdStr;
  late var fullNameStr;
  late var designationStr;
  late var token;
  late var empId;
  late var baseUrl;
  bool isLoading=false;
  List<dynamic> filesList=[];
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
          "All Files",
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
        child:
            filesList.isEmpty?
                Center(child: Text("No Files Available",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: AppTheme.orangeColor),),)
                :
                ListView.builder(
            itemCount: filesList.length,
            itemBuilder: (cntx,indx){
              String fileId=filesList[indx]['id'].toString();
              String type=filesList[indx]['type'].toString();
              String tbl_id=filesList[indx]['tbl_id'].toString();
              String file_name=filesList[indx]['file_name'].toString();
              String mime_type=filesList[indx]['mime_type'].toString();
              String size=filesList[indx]['size'].toString();
              String created_at=filesList[indx]['created_at'].toString();
              String fileType="0";
              if(mime_type.contains('image') || mime_type.contains('octet-stream')){
                fileType="1";
              }else{
                fileType="2";
              }
              return Card(
                elevation: 10,
                shadowColor: Colors.deepOrangeAccent,
                color: Colors.deepOrange[30],
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    width: double.infinity,
                    height: 300,
                    child: Column(
                      children: [
                        fileType=="1"?
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                            height: 300,
                            fit: BoxFit.cover,
                            imageUrl: file_name,
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                CircularProgressIndicator(value: downloadProgress.progress),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        )
                            :
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.asset("assets/document_icon.png",height: 300,),
                        )

                      ],
                    ),

                  ),
                ),
              );
            }),),
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
    filesList=widget.mediaList;
    print(filesList.toString());
    Navigator.of(context).pop();

    setState(() {
    });
  }

}