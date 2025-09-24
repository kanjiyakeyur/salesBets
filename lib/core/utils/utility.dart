import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:baseproject/core/app_export.dart';

void showToast(String? msg) {
  Fluttertoast.showToast(
      msg: msg?.toString() ?? '',
    backgroundColor: appTheme.primaryGray,
    textColor: appTheme.black,
    gravity: ToastGravity.BOTTOM,
  );
}

String? getImagePath(String? img) {
  return img;
}

Widget bottomSpacing(){
  return Platform.isAndroid ? SizedBox(
    height: 10.h,
  ) : SizedBox();
}