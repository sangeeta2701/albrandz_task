import 'package:flutter/material.dart' show BuildContext, Text;
import 'package:ndialog/ndialog.dart' show ProgressDialog, DialogTransitionType;

class Pdialog {
  static ProgressDialog pdialog(
      BuildContext context, String title,String message, bool isDismissible) {
    return ProgressDialog(
      context,
      blur: 0.0,
      title: Text(title),
      message: Text(message),
      dialogTransitionType: DialogTransitionType.TopToBottom,
      dismissable: isDismissible,
    );
  }

  static void hideDialog(ProgressDialog pds, int seconds) {
    try {
      if (seconds == 0) {
        pds.dismiss();
      } else {
        Future.delayed(Duration(seconds: seconds)).then((value) {
          pds.dismiss();
        });
      }
    } catch (_) {}
    
  }
}