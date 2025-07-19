import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewLeaveImageScreen extends StatefulWidget{
  String fileUrl;
  ViewLeaveImageScreen(this.fileUrl);
  _viewLeaveState createState()=> _viewLeaveState();
}
class _viewLeaveState extends State<ViewLeaveImageScreen>{
  @override
  Widget build(BuildContext context) {
    return Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: CachedNetworkImage(
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.fill,
            imageUrl: widget.fileUrl,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        );
  }

}