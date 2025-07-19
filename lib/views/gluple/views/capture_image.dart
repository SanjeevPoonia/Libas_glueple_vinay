import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import '../utils/app_theme.dart';

class CaptureCameraScreen extends StatefulWidget{
  _markAttendance createState()=>_markAttendance();
}
class _markAttendance extends State<CaptureCameraScreen>{
   CameraController? _controller;
  //late Future<void> _initialize_controllerFuture;
   CameraDescription? camera;
  List<CameraDescription> cameras = [];

  int cameraSelection=0;




 /* _prepareCamera() async{

    cameras= await availableCameras();
    camera=cameras.first;
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the _controller. This returns a Future.
    _initialize_controllerFuture = __controller.initialize();

  }*/
  initializeCamera() async {
    print("Camera Triggered");
    _controller = CameraController(cameras[cameraSelection], ResolutionPreset.max);
    _controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
          // Handle access errors here.
            break;
          default:
          // Handle other errors here.
            break;
        }
      }
    });
  }
  Future<void> getCameras() async {
    try {
      cameras = await availableCameras();
      initializeCamera();
    } catch (e) {
      print(e);
    }
    camera = cameras.last;
    print(camera);
  }
  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a Camera_controller.
    getCameras();
  }
  @override
  void dispose() {
    // Dispose of the _controller when the widget is disposed.
    _controller!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,

        child: Stack(
          children: [

            Column(
              children: [
                _controller == null || !_controller!.value.isInitialized
                    ? Container(
                  height: 50,
                  margin: EdgeInsets.only(bottom: 15, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        margin: EdgeInsets.all(5),
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor:
                          AlwaysStoppedAnimation(Colors.blue),
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Loading camera',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
                    : Container(
                  /* margin: EdgeInsets.only(
                     left: 20, right: 20, top: 20),*/
                  child: CameraPreview(_controller!),
                ),
              ],
            ),

            Column(
              children: [


                Spacer(),

                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                      color: AppTheme.camBackColor
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: Container()),
                          Expanded(child: GestureDetector(
                            onTap: () async {
                              XFile file = await _controller!.takePicture();
                              if (file != null) {

                                Navigator.pop(context,file);



                                /* imageSelected = true;
                    imageFile = file;*/
                                setState(() {});
                              }
                            },
                            child: /*Container(
                       height: 42,
                       padding: EdgeInsets.symmetric(horizontal: 5),
                       color: AppTheme.themeColor,
                       child: Center(
                         child: Text(
                           'Take Picture',
                           style: TextStyle(
                               fontSize: 13, color: Colors.white),
                         ),
                       ),
                     )*/
                            Icon(Icons.camera,color: AppTheme.orangeColor,size: 60,),
                          )),
                          Expanded(child: GestureDetector(
                            onTap: () {
                              _cameraChange();
                            },
                            child: Icon(Icons.flip_camera_android,color: AppTheme.themeColor,size: 40,),
                          ))
                        ],
                      ),

                    ],
                  ),
                ),





              ],
            )


          ],
        ),
      ),
    );
  }

  _cameraChange(){
    if(cameraSelection==1){
      cameraSelection=0;
    }else if(cameraSelection==0){
      cameraSelection=1;
    }
    getCameras();
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}