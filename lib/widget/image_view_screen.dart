import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageView extends StatelessWidget
{
  final String url;
  ImageView(this.url);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(padding: EdgeInsets.only(top: 35,left: 15),

              child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },

                  child: Icon(Icons.close,color: Colors.white,size: 35)),

            ),


            Expanded(
              child: PhotoView(
                imageProvider: NetworkImage(url),
              ),
            ),
          ],
        )
    );
  }
}