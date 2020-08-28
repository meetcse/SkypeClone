import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skypeclone/models/call.dart';
import 'package:skypeclone/provider/user_provider.dart';
import 'package:skypeclone/resources/call_methods.dart';
import 'package:skypeclone/screens/callscreens/pickup/pickup_screen.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethods callMethods = CallMethods();
  PickupLayout({this.scaffold});
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return (userProvider != null && userProvider.getUser != null)
        ? StreamBuilder<DocumentSnapshot>(
            stream: callMethods.callStream(uid: userProvider.getUser.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.data != null) {
                Call call = Call.fromMap(snapshot.data.data);

                if (!call.hasDialled) {
                  return PickUpScreen(
                    call: call,
                  );
                }
                return scaffold;

                //Now what happens here is, from home screen we are taking input scaffold from there
                //and here we have streambuilder (i.e as soon as there is any changes in firestore stream, it will trigger)
                //so, until we dont have any call or any value in firestore for this reference, we will see home screen,
                //otherwise we will see PickUpScreen

              }
              return scaffold;
            },
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
