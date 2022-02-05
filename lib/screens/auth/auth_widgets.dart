import 'package:flutter/material.dart';
import 'package:fuko_app/widgets/shared/style.dart';

class FkAuthWidgets {
  static Widget body(context, {List<Widget> itemList = const []}) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Container(
            child: Column(
              children: [...itemList],
            ),
          ),
        ),
      ),
    );
  }

  static Widget topItemsBox(contex, {List<Widget> itemList = const []}) {
    return Container(
      child: Column(
        children: [
          ...itemList,
        ],
      ),
    );
  }

  Widget authTopContent({List<Widget> itemList = const []}) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(20.0),
      child: Align(
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Fuko",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: fkBlackText),
                ),
              ),
              ...itemList
            ],
          )),
    );
  }

  static Widget authInputFieldBox(context,
      {formKey, List<Widget> itemList = const []}) {
    return Expanded(
      child: Container(
          child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification? overscroll) {
          overscroll!.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [...itemList],
            ),
          ),
        ),
      )),
    );
  }
}
