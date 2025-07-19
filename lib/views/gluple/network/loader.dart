
import 'package:flutter/material.dart';

import '../utils/app_theme.dart';


class Loader extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.themeColor),
      ),
    );
  }

}