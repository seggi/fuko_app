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

  static Widget authInputFieldBox(context, {List<Widget> itemList = const []}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [...itemList],
            ),
          ),
        ),
      ),
    );
  }
}
