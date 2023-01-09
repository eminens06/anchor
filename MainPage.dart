import 'dart:async';

import 'package:anchor/InfoPage.dart';
import 'package:anchor/ProfilePage.dart';
import 'package:anchor/ShoppingPage.dart';
import 'package:anchor/SolutionCenter.dart';
import 'package:anchor/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'AnchorPage.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    this.initialIndex = 0,
  });
  final int initialIndex;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> pages = [
    ShoppingPage(),
    SolutionCenter(),
    AnchorPage(),
    InfoPage(),
    ProfilePage(),
  ];
  List<String> titles = [
    "Alışverişlerim",
    "Çözüm Merkezi",
    "Referans & İlan Oluşturma",
    "İnfo & SSS",
    "Profil",
  ];
  late int pageIndex;
  StreamSubscription? _subscription;

  @override
  void initState() {
    _subscription = FirebaseMessaging.instance.onTokenRefresh.listen((event) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "fcmToken": event,
      });
    });

    pageIndex = widget.initialIndex;
    super.initState();
  }

  @override
  void dispose() {
    if (_subscription != null) {
      _subscription!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: MediaQuery.of(context).viewInsets.bottom == 0.0
          ? Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Container(
                height: 65.0,
                width: 65.0,
                child: FittedBox(
                  child: FloatingActionButton(
                      elevation: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Image.asset(
                          pageIndex != 2
                              ? "assets/images/navBarUnselectedMain.png"
                              : "assets/images/navBarSelectedMain.png",
                        ),
                      ),
                      backgroundColor: kDarkBlue,
                      onPressed: () {
                        if (pageIndex != 2) {
                          setState(() {
                            pageIndex = 2;
                          });
                        }
                      }),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: kBottomNavigationBarHeight,
        color: kDarkBlue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                if (pageIndex != 0) {
                  setState(() {
                    pageIndex = 0;
                  });
                }
              },
              child: Container(
                width: (MediaQuery.of(context).size.width - 30.0) / 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      pageIndex == 0
                          ? "assets/images/navBarSelectedListing.png"
                          : "assets/images/navBarUnselectedListing.png",
                      height: 25.0,
                    ),
                    Text(
                      "Alışverişlerim",
                      style: TextStyle(
                        color:
                            pageIndex == 0 ? Colors.white : Color(0xFF2B5E86),
                        fontWeight: FontWeight.bold,
                        fontSize: 8.5,
                      ),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if (pageIndex != 1) {
                  setState(() {
                    pageIndex = 1;
                  });
                }
              },
              child: Container(
                width: (MediaQuery.of(context).size.width - 30.0) / 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      pageIndex == 1
                          ? "assets/images/navBarSelectedSolution.png"
                          : "assets/images/navBarUnselectedSolution.png",
                      height: 25.0,
                    ),
                    Text(
                      "Çözüm Merkezi",
                      style: TextStyle(
                        color:
                            pageIndex == 1 ? Colors.white : Color(0xFF2B5E86),
                        fontWeight: FontWeight.bold,
                        fontSize: 8.5,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: (MediaQuery.of(context).size.width - 30.0) / 5,
            ),
            InkWell(
              onTap: () {
                if (pageIndex != 3) {
                  setState(() {
                    pageIndex = 3;
                  });
                }
              },
              child: Container(
                width: (MediaQuery.of(context).size.width - 30.0) / 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      pageIndex == 3
                          ? "assets/images/navBarSelectedInfo.png"
                          : "assets/images/navBarUnselectedInfo.png",
                      height: 25.0,
                    ),
                    Text(
                      "Info & SSS",
                      style: TextStyle(
                        color:
                            pageIndex == 3 ? Colors.white : Color(0xFF2B5E86),
                        fontWeight: FontWeight.bold,
                        fontSize: 8.5,
                      ),
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if (pageIndex != 4) {
                  setState(() {
                    pageIndex = 4;
                  });
                }
              },
              child: Container(
                width: (MediaQuery.of(context).size.width - 30.0) / 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      pageIndex == 4
                          ? "assets/images/navBarSelectedSettings.png"
                          : "assets/images/navBarUnselectedSettings.png",
                      height: 25.0,
                    ),
                    Text(
                      "Profil",
                      style: TextStyle(
                        color:
                            pageIndex == 4 ? Colors.white : Color(0xFF2B5E86),
                        fontWeight: FontWeight.bold,
                        fontSize: 8.5,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: kLightBlueBg,
      appBar: PreferredSize(
        preferredSize: Size(
          MediaQuery.of(context).size.width,
          40.0,
        ),
        child: AppBar(
          backgroundColor: kDarkBlue,
          centerTitle: true,
          title: Text(titles[pageIndex]),
        ),
      ),
      body: pages[pageIndex],
    );
  }
}
