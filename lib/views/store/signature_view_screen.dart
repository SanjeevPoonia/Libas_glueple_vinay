import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class SignatureView extends StatelessWidget
{
  final String url;
  SignatureView(this.url);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(padding: EdgeInsets.only(top: 35,left: 15),

              child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },

                  child: Icon(Icons.close,color: Colors.black,size: 35)),

            ),


            Expanded(
              child: Center(
                child: Image.network(url),
              )
            ),
          ],
        )
    );
  }
}