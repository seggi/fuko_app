import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:fuko_app/widgets/shared/style.dart';
import 'package:fuko_app/widgets/shared/ui_helper.dart';

List mainScreesName = ["savings", "loan"];

class FkContentBoxWidgets {
  static Widget body(context, screenName,
      {widTxt = "", List<Widget> itemList = const [], fn, userData = const {} }) {
    if (screenName == "home") {
      return Scaffold(
        appBar: AppBar(title: const Text(""), actions: [
          Badge(
            badgeContent: const Text(
              '9',
              style: TextStyle(color: fkWhiteText),
            ),
            child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications)),
            position: BadgePosition.topEnd(end: 2, top: 2),
          )
        ],),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: fkDefaultColor,
                ),
                child: Column(
                  children: [
                     CircleAvatar(
                        radius: 40.0,
                        child: ClipRRect(
                            child: const Icon(Icons.person),
                            borderRadius: BorderRadius.circular(50.0),
                        ),
                    ),
                    verticalSpaceRegular,
                     Text('${userData['userName']}', 
                      style: const TextStyle(
                        color: fkWhiteText, 
                        fontSize: 20, 
                        fontWeight: FontWeight.w600
                      ),
                    )
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
               ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onLongPress: fn,
              )
            ],
          ),
        ),
        body: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [...itemList],
            ),
          ),
        ),
      );
    } else if (mainScreesName.contains(screenName)) {
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
    } else {
      return widTxt == ""
          ? Scaffold(
              body: SafeArea(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [...itemList],
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: fn,
                backgroundColor: Colors.deepOrangeAccent,
                child: const Icon(
                  Icons.add,
                  size: 30,
                ),
              ),
            )
          : Scaffold(
              body: SafeArea(
                child: Expanded(
                  child: Column(
                    children: [...itemList],
                  ),
                ),
              ),
            );
    }
  }

  static Widget topItemsBox(context, {List<Widget> itemList = const []}) {
    return Column(
      children: [
        ...itemList,
      ],
    );
  }

  Widget initialItems({List<Widget> itemList = const []}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Align(
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [...itemList],
          )),
    );
  }

  static buttonsItemsBox(context, {List<Widget> itemList = const []}) {
    return Expanded(
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification? overscroll) {
          overscroll!.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Form(
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

// Bottom Navigation Bar
class FkContentBoxWidgetsWithBottomBar {
  static Widget body(
      {screenBox,
      titleTxt,
      widTxt = "",
      List<BottomNavigationBarItem> bottomItemList = const [],
      selectedIndexItem,
      onItemTappedIcon}) {
    return widTxt == ""
        ? Scaffold(
            appBar: AppBar(
              title: Text(titleTxt),
            ),
            body: Container(
              child: screenBox,
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: [...bottomItemList],
              currentIndex: selectedIndexItem,
              selectedItemColor: Colors.deepOrangeAccent,
              onTap: onItemTappedIcon,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(titleTxt),
            ),
            body: Container(
              child: screenBox,
            ),
          );
  }
}

class FkAddDataFormBox {
  static Widget body(context, {List<Widget> itemList = const []}) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [...itemList],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Scroll the entire screen

class FkScrollViewWidgets {
  static Widget body(context, {List<Widget> itemList = const []}) {
    return Scaffold(
      body: SafeArea(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification? overscroll) {
            overscroll!.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [...itemList],
            ),
          ),
        ),
      ),
    );
  }
}