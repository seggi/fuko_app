import 'package:flutter/material.dart';
import 'package:fuko_app/widgets/shared/style.dart';

class FkAuthWidgets {
  static Widget body(context, {List<Widget> itemList = const []}) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [...itemList],
          ),
        ),
      ),
    );
  }

  static Widget topItemsBox(contex, {List<Widget> itemList = const []}) {
    return Column(
      children: [
        ...itemList,
      ],
    );
  }

  Widget authTopContent({List<Widget> itemList = const []}) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20.0),
      child: Align(
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Align(
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
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification? overscroll) {
          overscroll!.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [...itemList],
            ),
          ),
        ),
      ),
    );
  }
}
