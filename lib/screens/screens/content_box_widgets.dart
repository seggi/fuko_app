import 'package:flutter/material.dart';

class FkContentBoxWidgets {
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

  Widget initialItems({List<Widget> itemList = const []}) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Align(
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [...itemList],
          )),
    );
  }

  static buttonsItemsBox(contex, {List<Widget> itemList = const []}) {
    return Expanded(
      child: Container(
          child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification? overscroll) {
          overscroll!.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Form(
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
