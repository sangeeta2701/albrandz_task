
import 'package:albrandz_task/Widgets/dialogs/pdialog.dart';
import 'package:flutter/material.dart'
    show
        BuildContext,
        CircularProgressIndicator,
        AlwaysStoppedAnimation,
        Color,
        Colors;
import 'package:ndialog/ndialog.dart' show ProgressDialog;

import '../../utils/colors.dart';



ProgressDialog progresssbar(BuildContext context, title,message, isCacelable) {
  ProgressDialog pds = Pdialog.pdialog(context, title,message, isCacelable);
  pds.setLoadingWidget(CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(themeColor),
    backgroundColor: Colors.black26,
  ));
  return pds;
}