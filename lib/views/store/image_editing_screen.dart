import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ChecklistTree/utils/app_modal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

import '../../widget/time_utils.dart';


class ImageEditScreen extends StatefulWidget {
  File selectedImage;
  ImageEditScreen(this.selectedImage);

  @override
  ImageEditScreenPageState createState() => ImageEditScreenPageState();
}

class ImageEditScreenPageState extends State<ImageEditScreen> {
  File? editedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProImageEditor.file(
        allowCompleteWithEmptyEditing: true,
        File(widget.selectedImage.path.toString()),
        onImageEditingComplete: (Uint8List bytes) async {
          final tempDir = await getTemporaryDirectory();
          File file = await File('${tempDir.path}/image.png').create();
          file.writeAsBytesSync(bytes);
          editedImage=file;
          AppModel.setTempFilePath(editedImage!.path.toString());
          print("Edited image "+editedImage!.path.toString());
          Navigator.pop(context);

        },
      ),
    );
  }


}
