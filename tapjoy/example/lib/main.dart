// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_tapjoy/flutter_tapjoy.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TJPlacement myPlacement = TJPlacement(name: "EarnVibesByWatchingAds");
  // TJPlacement myPlacement2 = TJPlacement(name: "EarnVibesExplicitTap");
  String contentStateText = "";
  String connectionState = "";
  String iOSATTAuthResult = "";
  String balance = "";

  @override
  void initState() {
    super.initState();
    // set connection result handler
    TapJoyPlugin.shared.setConnectionResultHandler(_connectionResultHandler());

    // connect to TapJoy, all fields are required.
    TapJoyPlugin.shared.connect(
        androidApiKey: 
            "-on6Xz0bSaKLDvf163pC9gECxq9XnLVHKoooCjFKCJfYlYcRpsFtEK0siOLu", //test
        iOSApiKey:
            "oLH6Lxq_SDOQoL9o3gnk9gEBWIrGDDO3ZD43ouLGMmhdBqW2YCw_U7t8ojBe",
        debug: true);

    // set userID
    TapJoyPlugin.shared.setUserID(userID: "user_id123");

    // set contentState handler for each placement
    myPlacement.setHandler(_placementHandler());
    // myPlacement2.setHandler(_placementHandler());

    // add placements.
    TapJoyPlugin.shared.addPlacement(myPlacement);
    // TapJoyPlugin.shared.addPlacement(myPlacement2);
  }

// currency handler
  handler2(result) {
    print("INSIDE CONNECTION STATE");
    switch (result) {
      case TJConnectionResult.connected:
        setState(() {
          connectionState = "Connected";
        });
        break;
      case TJConnectionResult.disconnected:
        setState(() {
          connectionState = "Disconnected";
        });
        break;
    }
  }

  // connection result handler
  TJConnectionResultHandler _connectionResultHandler() {
    return handler2;
  }

  void handler(contentState, name, error) {
    print("INSIDE CONTENT STATE");
    switch (contentState) {
      case TJContentState.requestShowFail:
        print("FAILLLEEEEDDDDDD");
        break;
      case TJContentState.contentReady:
        setState(() {
          contentStateText = "Content Ready for placement :  $name";
        });
        break;
      case TJContentState.contentDidAppear:
        setState(() {
          contentStateText = "Content Did Appear for placement :  $name";
        });
        break;
      case TJContentState.contentDidDisappear:
        setState(() {
          contentStateText = "Content Did Disappear for placement :  $name";
        });
        break;
      case TJContentState.contentRequestSuccess:
        setState(() {
          contentStateText = "Content Request Success for placement :  $name";
        });
        break;
      case TJContentState.contentRequestFail:
        setState(() {
          contentStateText =
              "Content Request Fail + $error for placement :  $name";
        });
        break;
      case TJContentState.userClickedAndroidOnly:
        setState(() {
          contentStateText = "Content User Clicked for placement :  $name";
        });
        break;
    }
  }

  // placement Handler
  TJPlacementHandler _placementHandler() {
    return handler;
  }

  // get App Tracking Authentication . iOS ONLY
  Future<void> getAuth() async {
    TapJoyPlugin.shared.getIOSATTAuth().then((value) {
      switch (value) {
        case IOSATTAuthResult.notDetermined:
          setState(() {
            iOSATTAuthResult = "Not Determined";
          });
          break;
        case IOSATTAuthResult.restricted:
          setState(() {
            iOSATTAuthResult = "Restricted ";
          });
          break;
        case IOSATTAuthResult.denied:
          setState(() {
            iOSATTAuthResult = "Denied ";
          });
          break;
        case IOSATTAuthResult.authorized:
          setState(() {
            iOSATTAuthResult = "Authorized ";
          });
          break;
        case IOSATTAuthResult.none:
          setState(() {
            iOSATTAuthResult = "Error ";
          });
          break;
        case IOSATTAuthResult.iOSVersionNotSupported:
          setState(() {
            iOSATTAuthResult = "IOS Version Not Supported ";
          });
          break;
        case IOSATTAuthResult.android:
          setState(() {
            iOSATTAuthResult = "on Android";
          });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TapJoy Flutter'),
        ),
        body: Center(
          child: Column(
            children: [
              Text("Connection State : $connectionState"),
              ElevatedButton(
                child: const Text("get iOS App Tracking Auth"),
                onPressed: getAuth,
              ),
              Text("IOS Auth Result : $iOSATTAuthResult"),
              ElevatedButton(
                child: const Text("request content for EarnVibesExplicitTap"),
                onPressed: myPlacement.requestContent,
              ),
              // ElevatedButton(
              //   child: const Text("request content for Placement 002"),
              //   onPressed: myPlacement2.requestContent,
              // ),
              Text("Content State : $contentStateText"),
              ElevatedButton(
                child: const Text("show Content for: EarnVibesExplicitTap"),
                onPressed: myPlacement.showPlacement,
              ),
              // ElevatedButton(
              //   child: const Text("show Placement 002"),
              //   onPressed: myPlacement2.showPlacement,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
