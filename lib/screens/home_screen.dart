import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:skypeclone/provider/user_provider.dart';
import 'package:skypeclone/screens/callscreens/pickup/pickup_layout.dart';
import 'package:skypeclone/screens/pageviews/chat_list_screen.dart';
import 'package:skypeclone/utils/universal_variables.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _labelFontSize = 10;

  PageController pageController;
  int _page = 0;

  @override
  void initState() {
    // TODO: implement initState

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      //Post frame call back means that initstate is called even before the frame of app is rendered
      //and because of that we will not get context at init state time
      //so to get context after frame is rendered we use this method
      //And we are using userprovider here because we want to call method refreshUser
      //and home screen is best place to call that as every app will come in this screen first
      //as soon as user is logged in
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      userProvider.refreshUser();
    });
    super.initState();
    pageController = PageController();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      //Now introducing PickupLayout here and you are thinking how and why???
      //Just check to PickupLayout screen description inside StreamBuilder!!!!
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.blackColor,
        body: PageView(
          children: <Widget>[
            Container(
              child: ChatListScreen(),
            ),
            Center(
                child: Text(
              "Call Logs",
              style: TextStyle(color: Colors.white),
            )),
            Center(
                child: Text(
              "Contacts",
              style: TextStyle(color: Colors.white),
            )),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CupertinoTabBar(
              backgroundColor: UniversalVariables.blackColor,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat,
                    color: (_page == 0)
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor,
                  ),
                  title: Text(
                    "Chats",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color: (_page == 0)
                            ? UniversalVariables.lightBlueColor
                            : Colors.grey),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.call,
                    color: (_page == 1)
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor,
                  ),
                  title: Text(
                    "Calls",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color: (_page == 1)
                            ? UniversalVariables.lightBlueColor
                            : Colors.grey),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.contact_phone,
                    color: (_page == 2)
                        ? UniversalVariables.lightBlueColor
                        : UniversalVariables.greyColor,
                  ),
                  title: Text(
                    "Contacts",
                    style: TextStyle(
                        fontSize: _labelFontSize,
                        color: (_page == 2)
                            ? UniversalVariables.lightBlueColor
                            : Colors.grey),
                  ),
                ),
              ],
              onTap: navigationTapped,
              currentIndex: _page,
            ),
          ),
        ),
      ),
    );
  }
}
