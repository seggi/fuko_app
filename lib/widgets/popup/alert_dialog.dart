import 'package:flutter/material.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

Future<void> waitingOption(context, {String? title}) async {
  showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
              content: SizedBox(
            height: 20,
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                ),
                horizontalSpaceRegular,
                Text(title!),
              ],
            )),
          )));
}
