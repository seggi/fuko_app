import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fuko_app/widgets/drawer.dart';

import '../widgets/shared/style.dart';

List mainScreesName = ["savings", "loan", "groupe", "expenses", "notebook"];

class FkContentBoxWidgets {
  static Widget body(context, screenName,
      {onItemTapped,
      selectedIndex,
      username = "",
      widTxt = "",
      badgeTxt = "",
      picture = "",
      List<Widget> itemList = const [],
      fn}) {
    if (screenName == "home") {
      return Scaffold(
        backgroundColor: fkDefaultColor,
        drawer: NavDrawer(username: username, picture: picture),
        appBar: AppBar(elevation: 0.0, actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Badge(
              badgeContent: Text(
                badgeTxt,
                style: const TextStyle(color: fkWhiteText),
              ),
              child: IconButton(
                  onPressed: fn, icon: const Icon(Icons.notifications)),
              position: BadgePosition.topEnd(end: 2, top: 2),
            ),
          ),
        ]),
        body: SafeArea(
          child: Container(
            color: fkDefaultColor,
            child: Column(
              children: [...itemList],
            ),
          ),
        ),
      );
    } else if (screenName == "groupe detail") {
      return Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColor),
          ),
          child: SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [...itemList],
              ),
            ),
          ),
        ),
      );
    } else if (screenName == "dashboard") {
      return Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColor),
          ),
          child: SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [...itemList],
              ),
            ),
          ),
        ),
      );
    } else if (mainScreesName.contains(screenName)) {
      return Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColor),
          ),
          child: SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [...itemList],
              ),
            ),
          ),
        ),
      );
    } else if (screenName == "dept" || screenName == "loan") {
      return Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColor),
          ),
          child: SafeArea(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification? overscroll) {
                overscroll!.disallowIndicator();
                return true;
              },
              child: SizedBox(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [...itemList],
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.privacy_tip_sharp),
              label: 'Personal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_alt),
              label: 'With other',
            ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: fkBlueText,
          onTap: onItemTapped,
        ),
      );
    } else {
      return widTxt == ""
          ? Scaffold(
              body: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: gradientColor),
                ),
                child: SafeArea(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [...itemList],
                    ),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: fn,
                backgroundColor: fkDefaultColor,
                child: const Icon(
                  Icons.add,
                  size: 30,
                ),
              ),
            )
          : Scaffold(
              body: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: gradientColor),
                ),
                child: SafeArea(
                  child: Expanded(
                    child: Column(
                      children: [...itemList],
                    ),
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
          padding: const EdgeInsets.only(left: 0.0, right: 0.0),
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
            body: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: gradientColor),
              ),
              child: Container(
                child: screenBox,
              ),
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
            body: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: gradientColor),
              ),
              child: Container(
                child: screenBox,
              ),
            ),
          );
  }
}

class FkAddDataFormBox {
  static Widget body(context, {List<Widget> itemList = const []}) {
    return Scaffold(
      appBar: AppBar(),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColor),
        ),
        child: SafeArea(
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
      ),
    );
  }
}

// Scroll the entire screen

class FkScrollViewWidgets {
  static Widget body(context, {List<Widget> itemList = const []}) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColor),
        ),
        child: SafeArea(
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
      ),
    );
  }
}

// Screen tabBar

class FkTabBarView {
  static Widget tabBar(context,
      {addFn,
      paymentFn,
      String? screenTitle,
      List<Widget> pageTitle = const [],
      List<Widget> page = const []}) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: const Color(0xFF2C384A),
                title: Text('$screenTitle',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 18.0)),
                pinned: true,
                floating: true,
                bottom: TabBar(
                  // isScrollable: true,
                  indicatorColor: Colors.deepOrange,
                  tabs: [...pageTitle],
                ),
              )
            ];
          },
          body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[...page]),
        ),
      ),
    );
  }
}
