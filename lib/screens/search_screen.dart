import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:skypeclone/models/user.dart';
import 'package:skypeclone/resources/firebase_repository.dart';
import 'package:skypeclone/utils/universal_variables.dart';
import 'package:skypeclone/widgets/custom_tile.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  FirebaseRepository _repository = FirebaseRepository();

  List<User> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository.getCurrentUser().then((FirebaseUser user) {
      _repository.fetchAllUsers(user).then((List<User> list) {
        setState(() {
          userList = list;
        });
      });
    });
  }

//Code for App bar and search text field
  searchAppBar(BuildContext context) {
    return GradientAppBar(
      backgroundColorStart: UniversalVariables.gradientColorStart,
      backgroundColorEnd: UniversalVariables.gradientColorEnd,
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: UniversalVariables.blackColor,
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 35,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  //This widget binding is used because except that if we direct;y
                  //use to clear search controller then it throws an exception
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    searchController.clear();
                  });
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Color(0x88ffffff),
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildSuggestions(String query) {
    final List<User> suggestionList = query.isEmpty
        ? []
        : userList.where((User user) {
            String _getUsername = user.username.toLowerCase();
            String _query = query.toLowerCase();
            String _getName = user.name.toLowerCase();
            bool matchesUsername = _getUsername.contains(_query);
            bool matchesName = _getName.contains(_query);

            return (matchesName || matchesUsername);

            //Above 5-6 lines of code can also be written as following syntax

            // (User user) => (user.username.toLowerCase().contains(query.toLowerCase())) ||
            // (user.name.toLowerCase().contains(query.toLowerCase()))
          }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        User searchUser = User(
          uid: suggestionList[index].uid,
          profilePhoto: suggestionList[index].profilePhoto,
          name: suggestionList[index].name,
          username: suggestionList[index].username,
        );

        return CustomTile(
          mini: false,
          onTap: () {},
          leading: CircleAvatar(
            backgroundImage: NetworkImage(searchUser.profilePhoto),
            backgroundColor: Colors.grey,
          ),
          title: Text(
            searchUser.username,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            searchUser.name,
            style: TextStyle(
              color: UniversalVariables.greyColor,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: searchAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: buildSuggestions(query),
      ),
    );
  }
}
