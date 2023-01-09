import 'dart:io';
import 'dart:math';

import 'package:anchor/ChatScreen.dart';
import 'package:anchor/FadeRoute.dart';
import 'package:anchor/NotificationHandler.dart';
import 'package:anchor/ProfilePage.dart';
import 'package:anchor/constants.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'MainPage.dart';

class ShoppingPage extends StatefulWidget {
  @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  TextEditingController _refCodeController = TextEditingController();
  int tabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map>>(
        stream: _firestore
            .collection("Users")
            .doc(_firebaseAuth.currentUser!.uid)
            .snapshots(),
        builder: (context, userSnapshot) {
          return StreamBuilder<QuerySnapshot<Map>>(
              stream: _firestore
                  .collection("Rooms")
                  .where("seller", isEqualTo: _firebaseAuth.currentUser!.uid)
                  .snapshots(),
              builder: (context, sellerRoomsSnapshot) {
                return StreamBuilder<QuerySnapshot<Map>>(
                    stream: _firestore
                        .collection("Rooms")
                        .where("buyer",
                            isEqualTo: _firebaseAuth.currentUser!.uid)
                        .snapshots(),
                    builder: (context, buyerRoomsSnapshot) {
                      if (!sellerRoomsSnapshot.hasData ||
                          !buyerRoomsSnapshot.hasData ||
                          !userSnapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: kButtonBlue,
                          ),
                        );
                      }
                      if (buyerRoomsSnapshot.data!.size +
                              sellerRoomsSnapshot.data!.size ==
                          0) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 32.0,
                            right: 32.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                "assets/images/noShoppingDraw.png",
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Aktif alış - satış işlemi\nbulunmuyor.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      height: 1.2,
                                      fontWeight: FontWeight.bold,
                                      color: kDarkBlue,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12.0,
                                  ),
                                  Text(
                                    "Güvenli satış işlemini başlatmak için satış yapın butonunu tıklayın. Alıcıysanız satıcı tarafından size verilen referans kodunu girin.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w400,
                                      color: kTextGrey,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        FadeRoute(
                                          page: RoomCreatingPage(),
                                        ),
                                      );
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(32.0),
                                        ),
                                      ),
                                      shadowColor: MaterialStateProperty.all(
                                        kButtonBlue.withOpacity(0.4),
                                      ),
                                      minimumSize: MaterialStateProperty.all(
                                          Size(220, 45)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        kButtonBlue,
                                      ),
                                      elevation: MaterialStateProperty.all(20),
                                    ),
                                    child: Text(
                                      "Güvenli Satış Yapın",
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              insetPadding: EdgeInsets.zero,
                                              backgroundColor:
                                                  Color(0xFF57A1F6),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                side: BorderSide(
                                                  color: Color(0xFF2C8CFB),
                                                  width: 1.0,
                                                ),
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Image.asset(
                                                        "assets/images/refCodeDialogDraw.png",
                                                        height: 75.0,
                                                      ),
                                                      SizedBox(
                                                        height: 90.0,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 18.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Alışverişe Katıl!",
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF474444),
                                                                  fontSize:
                                                                      20.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                              Text(
                                                                "Satıcının sana ilettiği kodu\naşağıya girerek alışverişe\nkatılabilirsin.",
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFF474444),
                                                                    fontSize:
                                                                        11.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 12.0,
                                                        vertical: 32.0),
                                                    child: TextField(
                                                      controller:
                                                          _refCodeController,
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      decoration:
                                                          InputDecoration(
                                                        hintStyle: TextStyle(
                                                            fontSize: 14.0),
                                                        constraints:
                                                            BoxConstraints(
                                                                maxHeight:
                                                                    35.0),
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        4.0,
                                                                    horizontal:
                                                                        12.0),
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.0),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF707070),
                                                              width: 1.0),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.0),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF707070),
                                                              width: 1.0),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.0),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF707070),
                                                              width: 1.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  userSnapshot.data!.data()![
                                                              "address"] ==
                                                          ""
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .warning_rounded,
                                                              color:
                                                                  Colors.white,
                                                              size: 40.0,
                                                            ),
                                                            SizedBox(
                                                              width: 4.0,
                                                            ),
                                                            Column(
                                                              children: [
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "Adres bilgilerinizi ",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              10.0,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          FadeRoute(
                                                                            page:
                                                                                UserSettings(userInfo: userSnapshot.data!.data()!),
                                                                          ),
                                                                        );
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        "profil sayfanız",
                                                                        style: TextStyle(
                                                                            color: Color(
                                                                                0xFF474444),
                                                                            decoration: TextDecoration
                                                                                .underline,
                                                                            fontSize:
                                                                                10.0,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 2.0,
                                                                ),
                                                                Text(
                                                                  "üzerinden doldurmadan işleminize",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          10.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                SizedBox(
                                                                  height: 2.0,
                                                                ),
                                                                Text(
                                                                  "devam edemezsiniz!",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          10.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      : Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                _firestore
                                                                    .collection(
                                                                        "Rooms")
                                                                    .where(
                                                                        "refCode",
                                                                        isEqualTo:
                                                                            _refCodeController
                                                                                .text)
                                                                    .get()
                                                                    .then(
                                                                        (value) {
                                                                  if (value
                                                                          .size >
                                                                      0) {
                                                                    if (value.docs[0].data()[
                                                                            "seller"] ==
                                                                        _firebaseAuth
                                                                            .currentUser!
                                                                            .uid) {
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return Center(
                                                                              child: Wrap(
                                                                                children: [
                                                                                  Stack(
                                                                                    children: [
                                                                                      AlertDialog(
                                                                                        shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.circular(15),
                                                                                        ),
                                                                                        backgroundColor: Color(0xFF6EB0FC),
                                                                                        content: Center(
                                                                                          child: Column(
                                                                                            children: [
                                                                                              Align(
                                                                                                alignment: Alignment.topRight,
                                                                                                child: GestureDetector(
                                                                                                  onTap: () {
                                                                                                    Navigator.pop(context);
                                                                                                  },
                                                                                                  child: Icon(
                                                                                                    FontAwesomeIcons.times,
                                                                                                    color: Colors.white,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                height: 48.0,
                                                                                              ),
                                                                                              Text(
                                                                                                "Kendi oluşturduğunuz ilana alıcı olamazsınız!",
                                                                                                style: TextStyle(
                                                                                                  color: Colors.white,
                                                                                                ),
                                                                                                textAlign: TextAlign.center,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Align(
                                                                                        alignment: Alignment.topCenter,
                                                                                        child: Image.asset(
                                                                                          "assets/images/warningDialogDraw.png",
                                                                                          height: 96.0,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            );
                                                                          });
                                                                    } else {
                                                                      value
                                                                          .docs[
                                                                              0]
                                                                          .reference
                                                                          .update({
                                                                        "buyer": _firebaseAuth
                                                                            .currentUser!
                                                                            .uid,
                                                                        "buyerJoinDate":
                                                                            FieldValue.serverTimestamp(),
                                                                        "users":
                                                                            FieldValue.arrayUnion([
                                                                          _firebaseAuth
                                                                              .currentUser!
                                                                              .uid,
                                                                        ]),
                                                                        "state":
                                                                            "Ödeme bekleniyor",
                                                                      }).whenComplete(
                                                                              () async {
                                                                        await _firestore
                                                                            .collection("Users")
                                                                            .doc(value.docs[0].data()["seller"])
                                                                            .get()
                                                                            .then((userData) async {
                                                                          if (userData
                                                                              .data()!["allowNotifications"]) {
                                                                            await NotificationHandler.sendNotification(
                                                                                fcmToken: userData.data()!["fcmToken"],
                                                                                message: "Alıcı odaya katıldı.");
                                                                          }

                                                                          _refCodeController
                                                                              .clear();
                                                                          Navigator.pop(
                                                                              context);
                                                                        });
                                                                      });
                                                                    }
                                                                  } else {
                                                                    _refCodeController
                                                                        .clear();
                                                                    Navigator.pop(
                                                                        context);
                                                                  }
                                                                });
                                                              },
                                                              child:
                                                                  Text("Katıl"),
                                                            ),
                                                            SizedBox(
                                                                width: 6.0),
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                _refCodeController
                                                                    .clear();
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child:
                                                                  Text("İptal"),
                                                            ),
                                                          ],
                                                        ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(32.0),
                                        ),
                                      ),
                                      shadowColor: MaterialStateProperty.all(
                                        kDarkBlue.withOpacity(0.1),
                                      ),
                                      minimumSize: MaterialStateProperty.all(
                                          Size(220, 45)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        Colors.white,
                                      ),
                                      elevation: MaterialStateProperty.all(20),
                                    ),
                                    child: Text(
                                      "Referans Kodunu Girin",
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: kPink,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                      List<DocumentSnapshot<Map>> itemList = tabIndex == 0
                          ? sellerRoomsSnapshot.data!.docs
                          : buyerRoomsSnapshot.data!.docs;
                      if (itemList.length == 0) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 12.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50.0),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4.0,
                                      offset: Offset(0.0, 3.0),
                                      color: Colors.black.withOpacity(0.1),
                                    ),
                                  ],
                                ),
                                height: 35.0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (tabIndex != 0) {
                                          setState(() {
                                            tabIndex = 0;
                                          });
                                        }
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    0.5 -
                                                24.0,
                                        height: 35.0,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: tabIndex == 0
                                              ? kButtonBlue
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                        child: Text(
                                          "Sattığım Ürünler",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13.0,
                                            color: tabIndex == 0
                                                ? Colors.white
                                                : Color(0xFFB7B1B1),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (tabIndex != 1) {
                                          setState(() {
                                            tabIndex = 1;
                                          });
                                        }
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                    0.5 -
                                                24.0,
                                        height: 35.0,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: tabIndex == 1
                                              ? kButtonBlue
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                        child: Text(
                                          "Aldığım Ürünler",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13.0,
                                            color: tabIndex == 1
                                                ? Colors.white
                                                : Color(0xFFB7B1B1),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 32.0),
                              child: Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        FadeRoute(
                                          page: RoomCreatingPage(),
                                        ),
                                      );
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(32.0),
                                        ),
                                      ),
                                      shadowColor: MaterialStateProperty.all(
                                        kButtonBlue.withOpacity(0.4),
                                      ),
                                      minimumSize: MaterialStateProperty.all(
                                          Size(220, 45)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        kButtonBlue,
                                      ),
                                      elevation: MaterialStateProperty.all(20),
                                    ),
                                    child: Text(
                                      "Güvenli Satış Yapın",
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.0,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              insetPadding: EdgeInsets.zero,
                                              backgroundColor:
                                                  Color(0xFF57A1F6),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                side: BorderSide(
                                                  color: Color(0xFF2C8CFB),
                                                  width: 1.0,
                                                ),
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Image.asset(
                                                        "assets/images/refCodeDialogDraw.png",
                                                        height: 75.0,
                                                      ),
                                                      SizedBox(
                                                        height: 90.0,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 18.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Alışverişe Katıl!",
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF474444),
                                                                  fontSize:
                                                                      20.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                              Text(
                                                                "Satıcının sana ilettiği kodu\naşağıya girerek alışverişe\nkatılabilirsin.",
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFF474444),
                                                                    fontSize:
                                                                        11.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 12.0,
                                                        vertical: 32.0),
                                                    child: TextField(
                                                      controller:
                                                          _refCodeController,
                                                      style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      decoration:
                                                          InputDecoration(
                                                        hintStyle: TextStyle(
                                                            fontSize: 14.0),
                                                        constraints:
                                                            BoxConstraints(
                                                                maxHeight:
                                                                    35.0),
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        4.0,
                                                                    horizontal:
                                                                        12.0),
                                                        fillColor: Colors.white,
                                                        filled: true,
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.0),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF707070),
                                                              width: 1.0),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.0),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF707070),
                                                              width: 1.0),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      4.0),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF707070),
                                                              width: 1.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  userSnapshot.data!.data()![
                                                              "address"] ==
                                                          ""
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .warning_rounded,
                                                              color:
                                                                  Colors.white,
                                                              size: 40.0,
                                                            ),
                                                            SizedBox(
                                                              width: 4.0,
                                                            ),
                                                            Column(
                                                              children: [
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "Adres bilgilerinizi ",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              10.0,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator
                                                                            .push(
                                                                          context,
                                                                          FadeRoute(
                                                                            page:
                                                                                UserSettings(userInfo: userSnapshot.data!.data()!),
                                                                          ),
                                                                        );
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        "profil sayfanız",
                                                                        style: TextStyle(
                                                                            color: Color(
                                                                                0xFF474444),
                                                                            decoration: TextDecoration
                                                                                .underline,
                                                                            fontSize:
                                                                                10.0,
                                                                            fontWeight:
                                                                                FontWeight.w600),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 2.0,
                                                                ),
                                                                Text(
                                                                  "üzerinden doldurmadan işleminize",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          10.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                SizedBox(
                                                                  height: 2.0,
                                                                ),
                                                                Text(
                                                                  "devam edemezsiniz!",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          10.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      : Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                _firestore
                                                                    .collection(
                                                                        "Rooms")
                                                                    .where(
                                                                        "refCode",
                                                                        isEqualTo:
                                                                            _refCodeController
                                                                                .text)
                                                                    .get()
                                                                    .then(
                                                                        (value) {
                                                                  if (value
                                                                          .size >
                                                                      0) {
                                                                    if (value.docs[0].data()[
                                                                            "seller"] ==
                                                                        _firebaseAuth
                                                                            .currentUser!
                                                                            .uid) {
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return Center(
                                                                              child: Wrap(
                                                                                children: [
                                                                                  Stack(
                                                                                    children: [
                                                                                      AlertDialog(
                                                                                        shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.circular(15),
                                                                                        ),
                                                                                        backgroundColor: Color(0xFF6EB0FC),
                                                                                        content: Center(
                                                                                          child: Column(
                                                                                            children: [
                                                                                              Align(
                                                                                                alignment: Alignment.topRight,
                                                                                                child: GestureDetector(
                                                                                                  onTap: () {
                                                                                                    Navigator.pop(context);
                                                                                                  },
                                                                                                  child: Icon(
                                                                                                    FontAwesomeIcons.times,
                                                                                                    color: Colors.white,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                height: 48.0,
                                                                                              ),
                                                                                              Text(
                                                                                                "Kendi oluşturduğunuz ilana alıcı olamazsınız!",
                                                                                                style: TextStyle(
                                                                                                  color: Colors.white,
                                                                                                ),
                                                                                                textAlign: TextAlign.center,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Align(
                                                                                        alignment: Alignment.topCenter,
                                                                                        child: Image.asset(
                                                                                          "assets/images/warningDialogDraw.png",
                                                                                          height: 96.0,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            );
                                                                          });
                                                                    } else {
                                                                      value
                                                                          .docs[
                                                                              0]
                                                                          .reference
                                                                          .update({
                                                                        "buyer": _firebaseAuth
                                                                            .currentUser!
                                                                            .uid,
                                                                        "buyerJoinDate":
                                                                            FieldValue.serverTimestamp(),
                                                                        "users":
                                                                            FieldValue.arrayUnion([
                                                                          _firebaseAuth
                                                                              .currentUser!
                                                                              .uid,
                                                                        ]),
                                                                        "state":
                                                                            "Ödeme bekleniyor",
                                                                      }).whenComplete(
                                                                              () async {
                                                                        await _firestore
                                                                            .collection("Users")
                                                                            .doc(value.docs[0].data()["seller"])
                                                                            .get()
                                                                            .then((userData) async {
                                                                          if (userData
                                                                              .data()!["allowNotifications"]) {
                                                                            await NotificationHandler.sendNotification(
                                                                                fcmToken: userData.data()!["fcmToken"],
                                                                                message: "Alıcı odaya katıldı.");
                                                                          }

                                                                          _refCodeController
                                                                              .clear();
                                                                          Navigator.pop(
                                                                              context);
                                                                        });
                                                                      });
                                                                    }
                                                                  } else {
                                                                    _refCodeController
                                                                        .clear();
                                                                    Navigator.pop(
                                                                        context);
                                                                  }
                                                                });
                                                              },
                                                              child:
                                                                  Text("Katıl"),
                                                            ),
                                                            SizedBox(
                                                                width: 6.0),
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                _refCodeController
                                                                    .clear();
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child:
                                                                  Text("İptal"),
                                                            ),
                                                          ],
                                                        ),
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(32.0),
                                        ),
                                      ),
                                      shadowColor: MaterialStateProperty.all(
                                        kDarkBlue.withOpacity(0.1),
                                      ),
                                      minimumSize: MaterialStateProperty.all(
                                          Size(220, 45)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        Colors.white,
                                      ),
                                      elevation: MaterialStateProperty.all(20),
                                    ),
                                    child: Text(
                                      "Referans Kodunu Girin",
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: kPink,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      return ListView.builder(
                          itemCount: itemList.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0, vertical: 12.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 4.0,
                                            offset: Offset(0.0, 3.0),
                                            color:
                                                Colors.black.withOpacity(0.1),
                                          ),
                                        ],
                                      ),
                                      height: 35.0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (tabIndex != 0) {
                                                setState(() {
                                                  tabIndex = 0;
                                                });
                                              }
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5 -
                                                  24.0,
                                              height: 35.0,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: tabIndex == 0
                                                    ? kButtonBlue
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                              ),
                                              child: Text(
                                                "Sattığım Ürünler",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13.0,
                                                  color: tabIndex == 0
                                                      ? Colors.white
                                                      : Color(0xFFB7B1B1),
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if (tabIndex != 1) {
                                                setState(() {
                                                  tabIndex = 1;
                                                });
                                              }
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5 -
                                                  24.0,
                                              height: 35.0,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: tabIndex == 1
                                                    ? kButtonBlue
                                                    : Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                              ),
                                              child: Text(
                                                "Aldığım Ürünler",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13.0,
                                                  color: tabIndex == 1
                                                      ? Colors.white
                                                      : Color(0xFFB7B1B1),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 6.0,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          FadeRoute(
                                            page: RoomPage(
                                              roomDocID: itemList[index].id,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xFF234E70)
                                                    .withOpacity(0.1),
                                                blurRadius: 8.0,
                                              ),
                                            ]),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: Container(
                                                  height: 80,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          itemList[index]
                                                                  .data()![
                                                              "imageURLs"][0],
                                                        ),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Color(
                                                                  0xFF234E70)
                                                              .withOpacity(0.1),
                                                          blurRadius: 4.0,
                                                        ),
                                                      ]),
                                                ),
                                              ),
                                              Container(
                                                height: 80.0,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              136.0,
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Text(
                                                        (itemList[index]
                                                                        .data()![
                                                                            "date"]
                                                                        .toDate()
                                                                        .day <
                                                                    10
                                                                ? "0"
                                                                : "") +
                                                            itemList[index]
                                                                .data()!["date"]
                                                                .toDate()
                                                                .day
                                                                .toString() +
                                                            "/" +
                                                            (itemList[index]
                                                                        .data()![
                                                                            "date"]
                                                                        .toDate()
                                                                        .month <
                                                                    10
                                                                ? "0"
                                                                : "") +
                                                            itemList[index]
                                                                .data()!["date"]
                                                                .toDate()
                                                                .month
                                                                .toString() +
                                                            "/" +
                                                            itemList[index]
                                                                .data()!["date"]
                                                                .toDate()
                                                                .year
                                                                .toString(),
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color:
                                                              Color(0xFF818181),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        textAlign:
                                                            TextAlign.end,
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              136.0,
                                                      child: Text(
                                                        itemList[index].data()![
                                                            "productName"],
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: kDarkBlue,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      itemList[index].data()![
                                                          "selectedProductType"],
                                                      style: TextStyle(
                                                        fontSize: 13.7,
                                                        color:
                                                            Color(0xFFE2E2E2),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      itemList[index].data()![
                                                              "productPrice"] +
                                                          " TL",
                                                      style: TextStyle(
                                                        fontSize: 14.1,
                                                        color: kDarkBlue,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              136.0,
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      2.0),
                                                          color: itemList[index]
                                                                          .data()![
                                                                      "state"] ==
                                                                  "Alıcı bekleniyor"
                                                              ? Colors.white
                                                              : (itemList[index]
                                                                              .data()![
                                                                          "state"] ==
                                                                      "Ödeme bekleniyor"
                                                                  ? Color(
                                                                      0xFFF9F5EB)
                                                                  : ((itemList[index].data()!["state"] ==
                                                                              "Kargo bekleniyor" ||
                                                                          itemList[index].data()!["state"] ==
                                                                              "Onay bekleniyor")
                                                                      ? Color(
                                                                          0xFFF9F5EB)
                                                                      : (itemList[index].data()!["state"] ==
                                                                              "Tamamlandı"
                                                                          ? Color(
                                                                              0xFFEBF9F4)
                                                                          : Color(
                                                                              0xFFFEF3F7)))),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Text(
                                                            itemList[index].data()![
                                                                        "state"] ==
                                                                    "Alıcı bekleniyor"
                                                                ? ""
                                                                : (itemList[index].data()![
                                                                            "state"] ==
                                                                        "Ödeme bekleniyor"
                                                                    ? "Alıcı Ödemesi Bekleniyor"
                                                                    : ((itemList[index].data()!["state"] ==
                                                                                "Kargo bekleniyor" ||
                                                                            itemList[index].data()!["state"] ==
                                                                                "Onay bekleniyor")
                                                                        ? "Kargo ve Onay Aşamasında"
                                                                        : (itemList[index].data()!["state"] ==
                                                                                "Tamamlandı"
                                                                            ? "Alışveriş Tamamlandı"
                                                                            : "İptal Oldu"))),
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color: itemList[index]
                                                                              .data()![
                                                                          "state"] ==
                                                                      "Alıcı bekleniyor"
                                                                  ? Color(
                                                                      0xFFFFA841)
                                                                  : (itemList[index].data()![
                                                                              "state"] ==
                                                                          "Ödeme bekleniyor"
                                                                      ? Color(
                                                                          0xFFFFA841)
                                                                      : ((itemList[index].data()!["state"] ==
                                                                                  "Kargo bekleniyor" ||
                                                                              itemList[index].data()!["state"] ==
                                                                                  "Onay bekleniyor")
                                                                          ? Color(
                                                                              0xFFFFA841)
                                                                          : (itemList[index].data()!["state"] == "Tamamlandı"
                                                                              ? Color(0xFF6CB49B)
                                                                              : Color(0xFFDE6792)))),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (itemList.length == 1)
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 16.0,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              FadeRoute(
                                                page: RoomCreatingPage(),
                                              ),
                                            );
                                          },
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(32.0),
                                              ),
                                            ),
                                            shadowColor:
                                                MaterialStateProperty.all(
                                              kButtonBlue.withOpacity(0.4),
                                            ),
                                            minimumSize:
                                                MaterialStateProperty.all(
                                                    Size(220, 45)),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              kButtonBlue,
                                            ),
                                            elevation:
                                                MaterialStateProperty.all(20),
                                          ),
                                          child: Text(
                                            "Güvenli Satış Yapın",
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8.0,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    insetPadding:
                                                        EdgeInsets.zero,
                                                    backgroundColor:
                                                        Color(0xFF57A1F6),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      side: BorderSide(
                                                        color:
                                                            Color(0xFF2C8CFB),
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Image.asset(
                                                              "assets/images/refCodeDialogDraw.png",
                                                              height: 75.0,
                                                            ),
                                                            SizedBox(
                                                              height: 90.0,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            18.0),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      "Alışverişe Katıl!",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color(
                                                                            0xFF474444),
                                                                        fontSize:
                                                                            20.0,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                    Text(
                                                                      "Satıcının sana ilettiği kodu\naşağıya girerek alışverişe\nkatılabilirsin.",
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xFF474444),
                                                                          fontSize:
                                                                              11.0,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      12.0,
                                                                  vertical:
                                                                      32.0),
                                                          child: TextField(
                                                            controller:
                                                                _refCodeController,
                                                            style: TextStyle(
                                                                fontSize: 14.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            decoration:
                                                                InputDecoration(
                                                              hintStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          14.0),
                                                              constraints:
                                                                  BoxConstraints(
                                                                      maxHeight:
                                                                          35.0),
                                                              contentPadding:
                                                                  EdgeInsets.symmetric(
                                                                      vertical:
                                                                          4.0,
                                                                      horizontal:
                                                                          12.0),
                                                              fillColor:
                                                                  Colors.white,
                                                              filled: true,
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4.0),
                                                                borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xFF707070),
                                                                    width: 1.0),
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4.0),
                                                                borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xFF707070),
                                                                    width: 1.0),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4.0),
                                                                borderSide: BorderSide(
                                                                    color: Color(
                                                                        0xFF707070),
                                                                    width: 1.0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        userSnapshot.data!
                                                                        .data()![
                                                                    "address"] ==
                                                                ""
                                                            ? Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .warning_rounded,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 40.0,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 4.0,
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            "Adres bilgilerinizi ",
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 10.0,
                                                                                fontWeight: FontWeight.w500),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.push(
                                                                                context,
                                                                                FadeRoute(
                                                                                  page: UserSettings(userInfo: userSnapshot.data!.data()!),
                                                                                ),
                                                                              );
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              "profil sayfanız",
                                                                              style: TextStyle(color: Color(0xFF474444), decoration: TextDecoration.underline, fontSize: 10.0, fontWeight: FontWeight.w600),
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            2.0,
                                                                      ),
                                                                      Text(
                                                                        "üzerinden doldurmadan işleminize",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                10.0,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            2.0,
                                                                      ),
                                                                      Text(
                                                                        "devam edemezsiniz!",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                10.0,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              )
                                                            : Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      _firestore
                                                                          .collection(
                                                                              "Rooms")
                                                                          .where(
                                                                              "refCode",
                                                                              isEqualTo: _refCodeController.text)
                                                                          .get()
                                                                          .then((value) {
                                                                        if (value.size >
                                                                            0) {
                                                                          if (value.docs[0].data()["seller"] ==
                                                                              _firebaseAuth.currentUser!.uid) {
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return Center(
                                                                                    child: Wrap(
                                                                                      children: [
                                                                                        Stack(
                                                                                          children: [
                                                                                            AlertDialog(
                                                                                              shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.circular(15),
                                                                                              ),
                                                                                              backgroundColor: Color(0xFF6EB0FC),
                                                                                              content: Center(
                                                                                                child: Column(
                                                                                                  children: [
                                                                                                    Align(
                                                                                                      alignment: Alignment.topRight,
                                                                                                      child: GestureDetector(
                                                                                                        onTap: () {
                                                                                                          Navigator.pop(context);
                                                                                                        },
                                                                                                        child: Icon(
                                                                                                          FontAwesomeIcons.times,
                                                                                                          color: Colors.white,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                    SizedBox(
                                                                                                      height: 48.0,
                                                                                                    ),
                                                                                                    Text(
                                                                                                      "Kendi oluşturduğunuz ilana alıcı olamazsınız!",
                                                                                                      style: TextStyle(
                                                                                                        color: Colors.white,
                                                                                                      ),
                                                                                                      textAlign: TextAlign.center,
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Align(
                                                                                              alignment: Alignment.topCenter,
                                                                                              child: Image.asset(
                                                                                                "assets/images/warningDialogDraw.png",
                                                                                                height: 96.0,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  );
                                                                                });
                                                                          } else {
                                                                            value.docs[0].reference.update({
                                                                              "buyer": _firebaseAuth.currentUser!.uid,
                                                                              "buyerJoinDate": FieldValue.serverTimestamp(),
                                                                              "users": FieldValue.arrayUnion([
                                                                                _firebaseAuth.currentUser!.uid,
                                                                              ]),
                                                                              "state": "Ödeme bekleniyor",
                                                                            }).whenComplete(() async {
                                                                              await _firestore.collection("Users").doc(value.docs[0].data()["seller"]).get().then((userData) async {
                                                                                if (userData.data()!["allowNotifications"]) {
                                                                                  await NotificationHandler.sendNotification(fcmToken: userData.data()!["fcmToken"], message: "Alıcı odaya katıldı.");
                                                                                }

                                                                                _refCodeController.clear();
                                                                                Navigator.pop(context);
                                                                              });
                                                                            });
                                                                          }
                                                                        } else {
                                                                          _refCodeController
                                                                              .clear();
                                                                          Navigator.pop(
                                                                              context);
                                                                        }
                                                                      });
                                                                    },
                                                                    child: Text(
                                                                        "Katıl"),
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          6.0),
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      _refCodeController
                                                                          .clear();
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                        "İptal"),
                                                                  ),
                                                                ],
                                                              ),
                                                      ],
                                                    ),
                                                  );
                                                });
                                          },
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(32.0),
                                              ),
                                            ),
                                            shadowColor:
                                                MaterialStateProperty.all(
                                              kDarkBlue.withOpacity(0.1),
                                            ),
                                            minimumSize:
                                                MaterialStateProperty.all(
                                                    Size(220, 45)),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Colors.white,
                                            ),
                                            elevation:
                                                MaterialStateProperty.all(20),
                                          ),
                                          child: Text(
                                            "Referans Kodunu Girin",
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              color: kPink,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              );
                            }
                            if (index == itemList.length - 1) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 6.0,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          FadeRoute(
                                            page: RoomPage(
                                              roomDocID: itemList[index].id,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xFF234E70)
                                                    .withOpacity(0.1),
                                                blurRadius: 8.0,
                                              ),
                                            ]),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0),
                                                child: Container(
                                                  height: 80,
                                                  width: 80,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          itemList[index]
                                                                  .data()![
                                                              "imageURLs"][0],
                                                        ),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Color(
                                                                  0xFF234E70)
                                                              .withOpacity(0.1),
                                                          blurRadius: 4.0,
                                                        ),
                                                      ]),
                                                ),
                                              ),
                                              Container(
                                                height: 80.0,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              136.0,
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Text(
                                                        (itemList[index]
                                                                        .data()![
                                                                            "date"]
                                                                        .toDate()
                                                                        .day <
                                                                    10
                                                                ? "0"
                                                                : "") +
                                                            itemList[index]
                                                                .data()!["date"]
                                                                .toDate()
                                                                .day
                                                                .toString() +
                                                            "/" +
                                                            (itemList[index]
                                                                        .data()![
                                                                            "date"]
                                                                        .toDate()
                                                                        .month <
                                                                    10
                                                                ? "0"
                                                                : "") +
                                                            itemList[index]
                                                                .data()!["date"]
                                                                .toDate()
                                                                .month
                                                                .toString() +
                                                            "/" +
                                                            itemList[index]
                                                                .data()!["date"]
                                                                .toDate()
                                                                .year
                                                                .toString(),
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color:
                                                              Color(0xFF818181),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        textAlign:
                                                            TextAlign.end,
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              136.0,
                                                      child: Text(
                                                        itemList[index].data()![
                                                            "productName"],
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: kDarkBlue,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      itemList[index].data()![
                                                          "selectedProductType"],
                                                      style: TextStyle(
                                                        fontSize: 13.7,
                                                        color:
                                                            Color(0xFFE2E2E2),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      itemList[index].data()![
                                                              "productPrice"] +
                                                          " TL",
                                                      style: TextStyle(
                                                        fontSize: 14.1,
                                                        color: kDarkBlue,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              136.0,
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      2.0),
                                                          color: itemList[index]
                                                                          .data()![
                                                                      "state"] ==
                                                                  "Alıcı bekleniyor"
                                                              ? Colors.white
                                                              : (itemList[index]
                                                                              .data()![
                                                                          "state"] ==
                                                                      "Ödeme bekleniyor"
                                                                  ? Color(
                                                                      0xFFF9F5EB)
                                                                  : (itemList[index].data()!["state"] ==
                                                                              "Kargo bekleniyor" ||
                                                                          itemList[index].data()!["state"] ==
                                                                              "Onay bekleniyor"
                                                                      ? Color(
                                                                          0xFFF9F5EB)
                                                                      : (itemList[index].data()!["state"] ==
                                                                              "Tamamlandı"
                                                                          ? Color(
                                                                              0xFFEBF9F4)
                                                                          : Color(
                                                                              0xFFFEF3F7)))),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Text(
                                                            itemList[index].data()![
                                                                        "state"] ==
                                                                    "Alıcı bekleniyor"
                                                                ? ""
                                                                : (itemList[index].data()![
                                                                            "state"] ==
                                                                        "Ödeme bekleniyor"
                                                                    ? "Alıcı Ödemesi Bekleniyor"
                                                                    : (itemList[index].data()!["state"] ==
                                                                                "Kargo bekleniyor" ||
                                                                            itemList[index].data()!["state"] ==
                                                                                "Onay bekleniyor"
                                                                        ? "Kargo ve Onay Aşamasında"
                                                                        : (itemList[index].data()!["state"] ==
                                                                                "Tamamlandı"
                                                                            ? "Alışveriş Tamamlandı"
                                                                            : "İptal Oldu"))),
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color: itemList[index]
                                                                              .data()![
                                                                          "state"] ==
                                                                      "Alıcı bekleniyor"
                                                                  ? Color(
                                                                      0xFFFFA841)
                                                                  : (itemList[index].data()![
                                                                              "state"] ==
                                                                          "Ödeme bekleniyor"
                                                                      ? Color(
                                                                          0xFFFFA841)
                                                                      : (itemList[index].data()!["state"] ==
                                                                                  "Kargo bekleniyor" ||
                                                                              itemList[index].data()!["state"] ==
                                                                                  "Onay bekleniyor"
                                                                          ? Color(
                                                                              0xFFFFA841)
                                                                          : (itemList[index].data()!["state"] == "Tamamlandı"
                                                                              ? Color(0xFF6CB49B)
                                                                              : Color(0xFFDE6792)))),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16.0,
                                  ),
                                  Column(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            FadeRoute(
                                              page: RoomCreatingPage(),
                                            ),
                                          );
                                        },
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32.0),
                                            ),
                                          ),
                                          shadowColor:
                                              MaterialStateProperty.all(
                                            kButtonBlue.withOpacity(0.4),
                                          ),
                                          minimumSize:
                                              MaterialStateProperty.all(
                                                  Size(220, 45)),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            kButtonBlue,
                                          ),
                                          elevation:
                                              MaterialStateProperty.all(20),
                                        ),
                                        child: Text(
                                          "Güvenli Satış Yapın",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  insetPadding: EdgeInsets.zero,
                                                  backgroundColor:
                                                      Color(0xFF57A1F6),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    side: BorderSide(
                                                      color: Color(0xFF2C8CFB),
                                                      width: 1.0,
                                                    ),
                                                  ),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Image.asset(
                                                            "assets/images/refCodeDialogDraw.png",
                                                            height: 75.0,
                                                          ),
                                                          SizedBox(
                                                            height: 90.0,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top:
                                                                          18.0),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "Alışverişe Katıl!",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          0xFF474444),
                                                                      fontSize:
                                                                          20.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                  Text(
                                                                    "Satıcının sana ilettiği kodu\naşağıya girerek alışverişe\nkatılabilirsin.",
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xFF474444),
                                                                        fontSize:
                                                                            11.0,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    12.0,
                                                                vertical: 32.0),
                                                        child: TextField(
                                                          controller:
                                                              _refCodeController,
                                                          style: TextStyle(
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                          decoration:
                                                              InputDecoration(
                                                            hintStyle:
                                                                TextStyle(
                                                                    fontSize:
                                                                        14.0),
                                                            constraints:
                                                                BoxConstraints(
                                                                    maxHeight:
                                                                        35.0),
                                                            contentPadding:
                                                                EdgeInsets.symmetric(
                                                                    vertical:
                                                                        4.0,
                                                                    horizontal:
                                                                        12.0),
                                                            fillColor:
                                                                Colors.white,
                                                            filled: true,
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4.0),
                                                              borderSide: BorderSide(
                                                                  color: Color(
                                                                      0xFF707070),
                                                                  width: 1.0),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4.0),
                                                              borderSide: BorderSide(
                                                                  color: Color(
                                                                      0xFF707070),
                                                                  width: 1.0),
                                                            ),
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4.0),
                                                              borderSide: BorderSide(
                                                                  color: Color(
                                                                      0xFF707070),
                                                                  width: 1.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      userSnapshot.data!
                                                                      .data()![
                                                                  "address"] ==
                                                              ""
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .warning_rounded,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 40.0,
                                                                ),
                                                                SizedBox(
                                                                  width: 4.0,
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          "Adres bilgilerinizi ",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 10.0,
                                                                              fontWeight: FontWeight.w500),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            Navigator.push(
                                                                              context,
                                                                              FadeRoute(
                                                                                page: UserSettings(userInfo: userSnapshot.data!.data()!),
                                                                              ),
                                                                            );
                                                                          },
                                                                          child:
                                                                              Text(
                                                                            "profil sayfanız",
                                                                            style: TextStyle(
                                                                                color: Color(0xFF474444),
                                                                                decoration: TextDecoration.underline,
                                                                                fontSize: 10.0,
                                                                                fontWeight: FontWeight.w600),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          2.0,
                                                                    ),
                                                                    Text(
                                                                      "üzerinden doldurmadan işleminize",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              10.0,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          2.0,
                                                                    ),
                                                                    Text(
                                                                      "devam edemezsiniz!",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              10.0,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            )
                                                          : Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    _firestore
                                                                        .collection(
                                                                            "Rooms")
                                                                        .where(
                                                                            "refCode",
                                                                            isEqualTo: _refCodeController
                                                                                .text)
                                                                        .get()
                                                                        .then(
                                                                            (value) {
                                                                      if (value
                                                                              .size >
                                                                          0) {
                                                                        if (value.docs[0].data()["seller"] ==
                                                                            _firebaseAuth.currentUser!.uid) {
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return Center(
                                                                                  child: Wrap(
                                                                                    children: [
                                                                                      Stack(
                                                                                        children: [
                                                                                          AlertDialog(
                                                                                            shape: RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.circular(15),
                                                                                            ),
                                                                                            backgroundColor: Color(0xFF6EB0FC),
                                                                                            content: Center(
                                                                                              child: Column(
                                                                                                children: [
                                                                                                  Align(
                                                                                                    alignment: Alignment.topRight,
                                                                                                    child: GestureDetector(
                                                                                                      onTap: () {
                                                                                                        Navigator.pop(context);
                                                                                                      },
                                                                                                      child: Icon(
                                                                                                        FontAwesomeIcons.times,
                                                                                                        color: Colors.white,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                    height: 48.0,
                                                                                                  ),
                                                                                                  Text(
                                                                                                    "Kendi oluşturduğunuz ilana alıcı olamazsınız!",
                                                                                                    style: TextStyle(
                                                                                                      color: Colors.white,
                                                                                                    ),
                                                                                                    textAlign: TextAlign.center,
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Align(
                                                                                            alignment: Alignment.topCenter,
                                                                                            child: Image.asset(
                                                                                              "assets/images/warningDialogDraw.png",
                                                                                              height: 96.0,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              });
                                                                        } else {
                                                                          value
                                                                              .docs[0]
                                                                              .reference
                                                                              .update({
                                                                            "buyer":
                                                                                _firebaseAuth.currentUser!.uid,
                                                                            "buyerJoinDate":
                                                                                FieldValue.serverTimestamp(),
                                                                            "users":
                                                                                FieldValue.arrayUnion([
                                                                              _firebaseAuth.currentUser!.uid,
                                                                            ]),
                                                                            "state":
                                                                                "Ödeme bekleniyor",
                                                                          }).whenComplete(() async {
                                                                            await _firestore.collection("Users").doc(value.docs[0].data()["seller"]).get().then((userData) async {
                                                                              if (userData.data()!["allowNotifications"]) {
                                                                                await NotificationHandler.sendNotification(fcmToken: userData.data()!["fcmToken"], message: "Alıcı odaya katıldı.");
                                                                              }

                                                                              _refCodeController.clear();
                                                                              Navigator.pop(context);
                                                                            });
                                                                          });
                                                                        }
                                                                      } else {
                                                                        _refCodeController
                                                                            .clear();
                                                                        Navigator.pop(
                                                                            context);
                                                                      }
                                                                    });
                                                                  },
                                                                  child: Text(
                                                                      "Katıl"),
                                                                ),
                                                                SizedBox(
                                                                    width: 6.0),
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    _refCodeController
                                                                        .clear();
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      "İptal"),
                                                                ),
                                                              ],
                                                            ),
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32.0),
                                            ),
                                          ),
                                          shadowColor:
                                              MaterialStateProperty.all(
                                            kDarkBlue.withOpacity(0.1),
                                          ),
                                          minimumSize:
                                              MaterialStateProperty.all(
                                                  Size(220, 45)),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            Colors.white,
                                          ),
                                          elevation:
                                              MaterialStateProperty.all(20),
                                        ),
                                        child: Text(
                                          "Referans Kodunu Girin",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            color: kPink,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.0,
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 6.0,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    FadeRoute(
                                      page: RoomPage(
                                        roomDocID: itemList[index].id,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF234E70)
                                              .withOpacity(0.1),
                                          blurRadius: 8.0,
                                        ),
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Container(
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    itemList[index].data()![
                                                        "imageURLs"][0],
                                                  ),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(0xFF234E70)
                                                        .withOpacity(0.1),
                                                    blurRadius: 4.0,
                                                  ),
                                                ]),
                                          ),
                                        ),
                                        Container(
                                          height: 80.0,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    136.0,
                                                alignment: Alignment.topRight,
                                                child: Text(
                                                  (itemList[index]
                                                                  .data()![
                                                                      "date"]
                                                                  .toDate()
                                                                  .day <
                                                              10
                                                          ? "0"
                                                          : "") +
                                                      itemList[index]
                                                          .data()!["date"]
                                                          .toDate()
                                                          .day
                                                          .toString() +
                                                      "/" +
                                                      (itemList[index]
                                                                  .data()![
                                                                      "date"]
                                                                  .toDate()
                                                                  .month <
                                                              10
                                                          ? "0"
                                                          : "") +
                                                      itemList[index]
                                                          .data()!["date"]
                                                          .toDate()
                                                          .month
                                                          .toString() +
                                                      "/" +
                                                      itemList[index]
                                                          .data()!["date"]
                                                          .toDate()
                                                          .year
                                                          .toString(),
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Color(0xFF818181),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.end,
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    136.0,
                                                child: Text(
                                                  itemList[index]
                                                      .data()!["productName"],
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: kDarkBlue,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                itemList[index].data()![
                                                    "selectedProductType"],
                                                style: TextStyle(
                                                  fontSize: 13.7,
                                                  color: Color(0xFFE2E2E2),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                itemList[index].data()![
                                                        "productPrice"] +
                                                    " TL",
                                                style: TextStyle(
                                                  fontSize: 14.1,
                                                  color: kDarkBlue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    136.0,
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2.0),
                                                    color: itemList[index]
                                                                    .data()![
                                                                "state"] ==
                                                            "Alıcı bekleniyor"
                                                        ? Colors.white
                                                        : (itemList[index].data()![
                                                                    "state"] ==
                                                                "Ödeme bekleniyor"
                                                            ? Color(0xFFF9F5EB)
                                                            : (itemList[index].data()!["state"] ==
                                                                        "Kargo bekleniyor" ||
                                                                    itemList[index].data()![
                                                                            "state"] ==
                                                                        "Onay bekleniyor"
                                                                ? Color(
                                                                    0xFFF9F5EB)
                                                                : (itemList[index].data()![
                                                                            "state"] ==
                                                                        "Tamamlandı"
                                                                    ? Color(
                                                                        0xFFEBF9F4)
                                                                    : Color(
                                                                        0xFFFEF3F7)))),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Text(
                                                      itemList[index].data()![
                                                                  "state"] ==
                                                              "Alıcı bekleniyor"
                                                          ? ""
                                                          : (itemList[index]
                                                                          .data()![
                                                                      "state"] ==
                                                                  "Ödeme bekleniyor"
                                                              ? "Alıcı Ödemesi Bekleniyor"
                                                              : (itemList[index].data()![
                                                                              "state"] ==
                                                                          "Kargo bekleniyor" ||
                                                                      itemList[index].data()![
                                                                              "state"] ==
                                                                          "Onay bekleniyor"
                                                                  ? "Kargo ve Onay Aşamasında"
                                                                  : (itemList[index]
                                                                              .data()!["state"] ==
                                                                          "Tamamlandı"
                                                                      ? "Alışveriş Tamamlandı"
                                                                      : "İptal Oldu"))),
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: itemList[index]
                                                                        .data()![
                                                                    "state"] ==
                                                                "Alıcı bekleniyor"
                                                            ? Color(0xFFFFA841)
                                                            : (itemList[index]
                                                                            .data()![
                                                                        "state"] ==
                                                                    "Ödeme bekleniyor"
                                                                ? Color(
                                                                    0xFFFFA841)
                                                                : (itemList[index].data()!["state"] ==
                                                                            "Kargo bekleniyor" ||
                                                                        itemList[index].data()!["state"] ==
                                                                            "Onay bekleniyor"
                                                                    ? Color(
                                                                        0xFFFFA841)
                                                                    : (itemList[index].data()!["state"] ==
                                                                            "Tamamlandı"
                                                                        ? Color(
                                                                            0xFF6CB49B)
                                                                        : Color(
                                                                            0xFFDE6792)))),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    });
              });
        });
  }
}

class RoomCreatingPage extends StatefulWidget {
  @override
  _RoomCreatingPageState createState() => _RoomCreatingPageState();
}

class _RoomCreatingPageState extends State<RoomCreatingPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  String refCode = "";
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productPriceController = TextEditingController();
  TextEditingController _productDescriptionController = TextEditingController();
  TextEditingController _buyerNameController = TextEditingController();
  TextEditingController _productLinkController = TextEditingController();
  DateTime cargoDate = DateTime.now();
  List<String> productTypeList = [
    "Elektronik",
    "Kıyafet",
    "Mutfak",
    "Mobilya",
    "Kişesel bakım"
  ];
  String? selectedProductType;
  List<String> cargoList = [
    "Yurtiçi Kargo",
    "Aras Kargo",
    "MNG Kargo",
  ];
  String? selectedCargo;
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  Future<String> getRandomString(int length) async {
    String refCode = String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => _chars.codeUnitAt(
          _rnd.nextInt(_chars.length),
        ),
      ),
    );
    if (await _firestore
        .collection("Rooms")
        .where("refCode", isEqualTo: refCode)
        .get()
        .then((value) {
      return value.size == 0;
    })) {
      return refCode;
    } else {
      return getRandomString(length);
    }
  }

  List<DropdownMenuItem<dynamic>> getDropDownList(List<String> list) {
    List<DropdownMenuItem> dropDownList = [];
    list.forEach((element) {
      dropDownList.add(DropdownMenuItem(
        child: Text(element),
        value: element,
      ));
    });
    return dropDownList;
  }

  showWarning(String warning, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              warning,
              textAlign: TextAlign.center,
            ),
            content: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Tamam',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                )
              ],
            ),
          );
        });
  }

  ImagePicker _picker = ImagePicker();
  List<String> imagePath = ["", "", "", ""];
  pickImageByIndex(ImageSource source, int i) async {
    await _picker
        .pickImage(
      source: source,
      imageQuality: 20,
    )
        .then((value) {
      if (value == null) {
        Navigator.pop(context);
      } else {
        setState(() {
          imagePath[i] = value.path;
        });
        Navigator.pop(context);
      }
    });
  }

  Future<List<String>> uploadImage(String ref) async {
    List<String> imageURLs = [];
    if (imagePath[0] != "") {
      String fileName = "pp" +
          _firebaseAuth.currentUser!.uid +
          DateTime.now().millisecondsSinceEpoch.toString();
      await _storage
          .ref("products/$ref/$fileName}")
          .putFile(
            File(imagePath[0]),
          )
          .then((taskSnapshot) async {
        await taskSnapshot.ref.getDownloadURL().then((url) {
          imageURLs.add(url);
        });
      });
    }
    if (imagePath[1] != "") {
      String fileName = "img1" +
          _firebaseAuth.currentUser!.uid +
          DateTime.now().millisecondsSinceEpoch.toString();
      await _storage
          .ref("products/$ref/$fileName}")
          .putFile(
            File(imagePath[1]),
          )
          .then((taskSnapshot) async {
        await taskSnapshot.ref.getDownloadURL().then((url) {
          imageURLs.add(url);
        });
      });
    }
    if (imagePath[2] != "") {
      String fileName = "img2" +
          _firebaseAuth.currentUser!.uid +
          DateTime.now().millisecondsSinceEpoch.toString();
      await _storage
          .ref("products/$ref/$fileName}")
          .putFile(
            File(imagePath[2]),
          )
          .then((taskSnapshot) async {
        await taskSnapshot.ref.getDownloadURL().then((url) {
          imageURLs.add(url);
        });
      });
    }
    if (imagePath[3] != "") {
      String fileName = "img3" +
          _firebaseAuth.currentUser!.uid +
          DateTime.now().millisecondsSinceEpoch.toString();
      await _storage
          .ref("products/$ref/$fileName}")
          .putFile(
            File(imagePath[3]),
          )
          .then((taskSnapshot) async {
        await taskSnapshot.ref.getDownloadURL().then((url) {
          imageURLs.add(url);
        });
      });
    }
    return Future.value(imageURLs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBlueBg,
      appBar: PreferredSize(
        preferredSize: Size(
          MediaQuery.of(context).size.width,
          40.0,
        ),
        child: AppBar(
          backgroundColor: kDarkBlue,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_rounded,
            ),
          ),
          title: Text(
            "Güvenli Satış Yapın",
            style: TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/roomCreatingDraw.png",
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              SizedBox(
                height: 18.0,
              ),
              Text(
                "İlanın detaylarını paylaşın",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: kDarkBlue,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Ürün adı, cinsi, anlaşılan ücret, kargo detayları, ürün linki gibi bilgileri girdikten sonra size verilen referans kodunu alıcıya iletin.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w300,
                    color: kTextGrey,
                  ),
                ),
              ),
              SizedBox(
                height: 18.0,
              ),
              CustomTextField(
                title: "Ürün Adı",
                fieldController: _productNameController,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        "Ürün Cinsi",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: kDarkBlue,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    PhysicalModel(
                      color: kDarkBlue.withOpacity(0.1),
                      shadowColor: kDarkBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                      elevation: 8.0,
                      child: DropdownButtonFormField(
                        icon: Icon(
                          FontAwesomeIcons.sort,
                          color: kDarkBlue,
                          size: 16.0,
                        ),
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: kTextFieldGrey,
                        ),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              width: 0,
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              width: 0,
                              color: Colors.transparent,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              width: 0,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        onTap: () {},
                        itemHeight: 48,
                        value: selectedProductType,
                        onSaved: (dynamic s) {
                          setState(() {
                            selectedProductType = s as String;
                          });
                        },
                        onChanged: (dynamic s) {
                          setState(() {
                            selectedProductType = s as String;
                          });
                        },
                        items: getDropDownList(productTypeList),
                      ),
                    ),
                  ],
                ),
              ),
              CustomTextField(
                title: "Anlaşılan Ücret",
                fieldController: _productPriceController,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        "Anlaşılan Kargolama Tarihi",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: kDarkBlue,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                          locale: Locale("tr", "TR"),
                        ).then((value) {
                          setState(() {
                            cargoDate = value!;
                          });
                        });
                      },
                      child: PhysicalModel(
                        color: kDarkBlue.withOpacity(0.1),
                        shadowColor: kDarkBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.0),
                        elevation: 8.0,
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(
                                  (cargoDate.day < 10 ? "0" : "") +
                                      cargoDate.day.toString() +
                                      "/" +
                                      (cargoDate.month < 10 ? "0" : "") +
                                      cargoDate.month.toString() +
                                      "/" +
                                      cargoDate.year.toString(),
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500,
                                    color: kTextFieldGrey,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: Icon(
                                  Icons.date_range,
                                  color: kDarkBlue,
                                  size: 20.0,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Row(
                        children: [
                          Text(
                            "Kargo Firması",
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: kDarkBlue,
                            ),
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Tooltip(
                            triggerMode: TooltipTriggerMode.tap,
                            message:
                                "Kargo firmasını henüz belirlemediyseniz daha sonra alışveriş ayarlarından değiştirebilirsiniz.",
                            padding: EdgeInsets.all(8.0),
                            margin: EdgeInsets.only(
                                left: 70.0,
                                right: 20.0,
                                top: 20.0,
                                bottom: 20.0),
                            showDuration: Duration(seconds: 10),
                            decoration: BoxDecoration(
                              color: Color(0xFFE2E2E2),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12.0)),
                              border: Border.all(
                                color: Color(0xFF2C8CFA),
                              ),
                            ),
                            textStyle: TextStyle(
                              color: kDarkBlue,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                            ),
                            verticalOffset: -5,
                            child: Icon(
                              FontAwesomeIcons.solidQuestionCircle,
                              color: Color(0xFF2C8CFA),
                              size: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    PhysicalModel(
                      color: kDarkBlue.withOpacity(0.1),
                      shadowColor: kDarkBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                      elevation: 8.0,
                      child: DropdownButtonFormField(
                        icon: Icon(
                          FontAwesomeIcons.sort,
                          color: kDarkBlue,
                          size: 16.0,
                        ),
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: kTextFieldGrey,
                        ),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              width: 0,
                              color: Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              width: 0,
                              color: Colors.transparent,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              width: 0,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        onTap: () {},
                        itemHeight: 48,
                        value: selectedCargo,
                        onSaved: (dynamic s) {
                          setState(() {
                            selectedCargo = s as String;
                          });
                        },
                        onChanged: (dynamic s) {
                          setState(() {
                            selectedCargo = s as String;
                          });
                        },
                        items: getDropDownList(cargoList),
                      ),
                    ),
                  ],
                ),
              ),
              CustomTextField(
                title: "Ürün Açıklaması",
                fieldController: _productDescriptionController,
              ),
              CustomTextField(
                title: "Alıcının İsmi",
                fieldController: _buyerNameController,
              ),
              CustomTextField(
                title: "Ürünün Linki",
                fieldController: _productLinkController,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      "Ürün Fotoğrafı",
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: kDarkBlue,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 4.0,
                  ),
                  Tooltip(
                    triggerMode: TooltipTriggerMode.tap,
                    message:
                        "Ürün ilanında bulunan detayları ekleyebileceğiniz gibi, alıcı ile öncesinde üzerine anlaştığınız satış şartlarını da buraya not düşebilirsiniz.",
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.only(
                        left: 70.0, right: 20.0, top: 20.0, bottom: 20.0),
                    showDuration: Duration(seconds: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFFE2E2E2),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                      border: Border.all(
                        color: Color(0xFF2C8CFA),
                      ),
                    ),
                    textStyle: TextStyle(
                      color: kDarkBlue,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                    ),
                    verticalOffset: -5,
                    child: Icon(
                      FontAwesomeIcons.solidQuestionCircle,
                      color: Color(0xFF2C8CFA),
                      size: 16.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 48.0,
                    child: Wrap(
                      runSpacing: 6.0,
                      spacing: 6.0,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    contentPadding: EdgeInsets.zero,
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          onTap: () {
                                            pickImageByIndex(
                                                ImageSource.camera, 0);
                                          },
                                          title: Text(
                                            "Kamera",
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            pickImageByIndex(
                                                ImageSource.gallery, 0);
                                          },
                                          title: Text(
                                            "Galeri",
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: imagePath[0] == ""
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Icon(
                                      Icons.add,
                                      color: Color(0xFF89AEFB),
                                      size: 32.0,
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 72.0,
                                  width: 72.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(File(imagePath[0])),
                                    ),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    contentPadding: EdgeInsets.zero,
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          onTap: () {
                                            pickImageByIndex(
                                                ImageSource.camera, 1);
                                          },
                                          title: Text(
                                            "Kamera",
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            pickImageByIndex(
                                                ImageSource.gallery, 1);
                                          },
                                          title: Text(
                                            "Galeri",
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: imagePath[1] == ""
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Icon(
                                      Icons.add,
                                      color: Color(0xFF89AEFB),
                                      size: 32.0,
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 72.0,
                                  width: 72.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(File(imagePath[1])),
                                    ),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    contentPadding: EdgeInsets.zero,
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          onTap: () {
                                            pickImageByIndex(
                                                ImageSource.camera, 2);
                                          },
                                          title: Text(
                                            "Kamera",
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            pickImageByIndex(
                                                ImageSource.gallery, 2);
                                          },
                                          title: Text(
                                            "Galeri",
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: imagePath[2] == ""
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Icon(
                                      Icons.add,
                                      color: Color(0xFF89AEFB),
                                      size: 32.0,
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 72.0,
                                  width: 72.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(File(imagePath[2])),
                                    ),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    contentPadding: EdgeInsets.zero,
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          onTap: () {
                                            pickImageByIndex(
                                                ImageSource.camera, 3);
                                          },
                                          title: Text(
                                            "Kamera",
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            pickImageByIndex(
                                                ImageSource.gallery, 3);
                                          },
                                          title: Text(
                                            "Galeri",
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: imagePath[3] == ""
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Icon(
                                      Icons.add,
                                      color: Color(0xFF89AEFB),
                                      size: 32.0,
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 72.0,
                                  width: 72.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(File(imagePath[3])),
                                    ),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 18.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  await getRandomString(8).then((value) async {
                    setState(() {
                      refCode = value;
                    });
                    if (_productNameController.text.isEmpty) {
                      showWarning("Lütfen bir ürün adını girin", context);
                    } else if (selectedProductType == null) {
                      showWarning("Lütfen ürün tipini seçin", context);
                    } else if (_productPriceController.text.isEmpty) {
                      showWarning("Lütfen anlaşılan ücreti girin", context);
                    } else if (_productDescriptionController.text.isEmpty) {
                      showWarning("Lütfen ürün açıklamasını girin", context);
                    } else if (_buyerNameController.text.isEmpty) {
                      showWarning("Lütfen alıcı adını girin", context);
                    } else if (selectedCargo == null) {
                      showWarning("Lütfen kargo firmasını seçin", context);
                    } else if (imagePath[0] == "" &&
                        imagePath[1] == "" &&
                        imagePath[2] == "" &&
                        imagePath[3] == "") {
                      showWarning(
                          "Lütfen en az 1 ürün fotoğrafı yükleyin", context);
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.transparent,
                              content: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          });
                      await uploadImage(refCode).then((imageURLs) async {
                        DocumentReference roomDocRef =
                            _firestore.collection("Rooms").doc();
                        await roomDocRef.set({
                          "seller": _firebaseAuth.currentUser!.uid,
                          "buyer": "",
                          "users": [
                            _firebaseAuth.currentUser!.uid,
                          ],
                          "refCode": refCode,
                          "roomDocID": roomDocRef.id,
                          "productName": _productNameController.text,
                          "selectedProductType": selectedProductType,
                          "productPrice": _productPriceController.text,
                          "productDescription":
                              _productDescriptionController.text,
                          "buyerName": _buyerNameController.text,
                          "selectedCargo": selectedCargo,
                          "productLink": _productLinkController.text,
                          "cargoDate": Timestamp.fromDate(cargoDate),
                          "imageURLs": imageURLs,
                          "state": "Alıcı bekleniyor",
                          "date": FieldValue.serverTimestamp(),
                        }).whenComplete(() {
                          Navigator.pushAndRemoveUntil(
                              context,
                              FadeRoute(
                                page: RoomPage(
                                  roomDocID: roomDocRef.id,
                                ),
                              ),
                              (route) => false);
                        });
                      });
                    }
                  });
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  shadowColor: MaterialStateProperty.all(
                    kButtonBlue.withOpacity(0.4),
                  ),
                  minimumSize: MaterialStateProperty.all(Size(220, 45)),
                  backgroundColor: MaterialStateProperty.all(
                    kButtonBlue,
                  ),
                  elevation: MaterialStateProperty.all(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    "Referans Kodu Oluştur",
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoomPage extends StatefulWidget {
  RoomPage({required this.roomDocID});
  final String roomDocID;
  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  int bottomIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  TextEditingController _cargoTrackingCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightBlueBg,
      appBar: PreferredSize(
        preferredSize: Size(
          MediaQuery.of(context).size.width,
          40.0,
        ),
        child: AppBar(
          backgroundColor: kDarkBlue,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_rounded,
            ),
          ),
          title: Text(
            "Alışveriş Takip Ekranı",
            style: TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
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
                          "assets/images/navBarUnselectedMain.png",
                        ),
                      ),
                      backgroundColor: kDarkBlue,
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            FadeRoute(
                              page: MainPage(
                                initialIndex: 2,
                              ),
                            ),
                            (route) => false);
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
                Navigator.pushAndRemoveUntil(
                    context,
                    FadeRoute(
                      page: MainPage(
                        initialIndex: 0,
                      ),
                    ),
                    (route) => false);
              },
              child: Container(
                width: (MediaQuery.of(context).size.width - 30.0) / 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/navBarSelectedListing.png",
                      height: 25.0,
                    ),
                    Text(
                      "Alışverişlerim",
                      style: TextStyle(
                        color: Colors.white,
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
                Navigator.pushAndRemoveUntil(
                    context,
                    FadeRoute(
                      page: MainPage(
                        initialIndex: 1,
                      ),
                    ),
                    (route) => false);
              },
              child: Container(
                width: (MediaQuery.of(context).size.width - 30.0) / 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/navBarUnselectedSolution.png",
                      height: 25.0,
                    ),
                    Text(
                      "Çözüm Merkezi",
                      style: TextStyle(
                        color: Color(0xFF2B5E86),
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
                Navigator.pushAndRemoveUntil(
                    context,
                    FadeRoute(
                      page: MainPage(
                        initialIndex: 3,
                      ),
                    ),
                    (route) => false);
              },
              child: Container(
                width: (MediaQuery.of(context).size.width - 30.0) / 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/navBarUnselectedInfo.png",
                      height: 25.0,
                    ),
                    Text(
                      "Info & SSS",
                      style: TextStyle(
                        color: Color(0xFF2B5E86),
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
                Navigator.pushAndRemoveUntil(
                    context,
                    FadeRoute(
                      page: MainPage(
                        initialIndex: 4,
                      ),
                    ),
                    (route) => false);
              },
              child: Container(
                width: (MediaQuery.of(context).size.width - 30.0) / 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/navBarUnselectedSettings.png",
                      height: 25.0,
                    ),
                    Text(
                      "Profil",
                      style: TextStyle(
                        color: Color(0xFF2B5E86),
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
      body: StreamBuilder<DocumentSnapshot<Map>>(
          stream:
              _firestore.collection("Rooms").doc(widget.roomDocID).snapshots(),
          builder: (context, roomSnapshot) {
            if (!roomSnapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            bool isSeller = _firebaseAuth.currentUser!.uid ==
                roomSnapshot.data!.data()!["seller"];

            if (roomSnapshot.data!.data()!["buyer"] == "") {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0, horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomTextField(
                        title: "Ürün Adı",
                        value: roomSnapshot.data!.data()!["productName"],
                      ),
                      CustomTextField(
                        title: "Ürün Cinsi",
                        value:
                            roomSnapshot.data!.data()!["selectedProductType"],
                      ),
                      CustomTextField(
                        title: "Anlaşılan Ücret",
                        value: roomSnapshot.data!.data()!["productPrice"],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(
                                "Anlaşılan Kargolama Tarihi",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: kDarkBlue,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            PhysicalModel(
                              color: kDarkBlue.withOpacity(0.1),
                              shadowColor: kDarkBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.0),
                              elevation: 8.0,
                              child: Container(
                                height: 55,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: Text(
                                        (roomSnapshot.data!
                                                        .data()!["cargoDate"]
                                                        .toDate()
                                                        .day <
                                                    10
                                                ? "0"
                                                : "") +
                                            roomSnapshot.data!
                                                .data()!["cargoDate"]
                                                .toDate()
                                                .day
                                                .toString() +
                                            "/" +
                                            (roomSnapshot.data!
                                                        .data()!["cargoDate"]
                                                        .toDate()
                                                        .month <
                                                    10
                                                ? "0"
                                                : "") +
                                            roomSnapshot.data!
                                                .data()!["cargoDate"]
                                                .toDate()
                                                .month
                                                .toString() +
                                            "/" +
                                            roomSnapshot.data!
                                                .data()!["cargoDate"]
                                                .toDate()
                                                .year
                                                .toString(),
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w500,
                                          color: kTextFieldGrey,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 12.0),
                                      child: Icon(
                                        Icons.date_range,
                                        color: kDarkBlue,
                                        size: 20.0,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomTextField(
                        title: "Kargo Firması",
                        value: roomSnapshot.data!.data()!["selectedCargo"],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              "Ürün Fotoğrafı",
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                color: kDarkBlue,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 48.0,
                            child: Wrap(
                              runSpacing: 6.0,
                              spacing: 6.0,
                              children: [
                                roomSnapshot.data!.data()!["imageURLs"][0] == ""
                                    ? SizedBox()
                                    : Container(
                                        height: 72.0,
                                        width: 72.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(roomSnapshot
                                                .data!
                                                .data()!["imageURLs"][0]),
                                          ),
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                if (roomSnapshot.data!
                                        .data()!["imageURLs"]
                                        .length ==
                                    2)
                                  roomSnapshot.data!.data()!["imageURLs"][1] ==
                                          ""
                                      ? SizedBox()
                                      : Container(
                                          height: 72.0,
                                          width: 72.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(roomSnapshot
                                                  .data!
                                                  .data()!["imageURLs"][1]),
                                            ),
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                if (roomSnapshot.data!
                                        .data()!["imageURLs"]
                                        .length ==
                                    3)
                                  roomSnapshot.data!.data()!["imageURLs"][2] ==
                                          ""
                                      ? SizedBox()
                                      : Container(
                                          height: 72.0,
                                          width: 72.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(roomSnapshot
                                                  .data!
                                                  .data()!["imageURLs"][2]),
                                            ),
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                if (roomSnapshot.data!
                                        .data()!["imageURLs"]
                                        .length ==
                                    4)
                                  roomSnapshot.data!.data()!["imageURLs"][3] ==
                                          ""
                                      ? SizedBox()
                                      : Container(
                                          height: 72.0,
                                          width: 72.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(roomSnapshot
                                                  .data!
                                                  .data()!["imageURLs"][3]),
                                            ),
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 18.0,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await FlutterClipboard.copy(
                                  roomSnapshot.data!.data()!["refCode"])
                              .then((value) {
                            showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  Future.delayed(Duration(seconds: 1), () {
                                    try {
                                      Navigator.of(dialogContext,
                                              rootNavigator: true)
                                          .pop('dialog');
                                    } catch (e) {
                                      print("dialog already closed");
                                    }
                                  });
                                  return Center(
                                    child: Wrap(
                                      children: [
                                        Container(
                                          height: 130,
                                          width: 130,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10.0),
                                              ),
                                              color: Colors.white),
                                          child: Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  FontAwesomeIcons
                                                      .solidCheckCircle,
                                                  color: Color(0xFF37A57F),
                                                  size: 32.0,
                                                ),
                                                SizedBox(
                                                  height: 12.0,
                                                ),
                                                Text(
                                                  "Kod\nKopyalandı!",
                                                  style: TextStyle(
                                                    color: Color(0xFF37A57F),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          });
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                          shadowColor: MaterialStateProperty.all(
                            kButtonBlue.withOpacity(0.4),
                          ),
                          minimumSize: MaterialStateProperty.all(Size(220, 45)),
                          backgroundColor: MaterialStateProperty.all(
                            kButtonBlue,
                          ),
                          elevation: MaterialStateProperty.all(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 50.0,
                            ),
                            Text(
                              roomSnapshot.data!.data()!["refCode"],
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              width: 50.0,
                              child: Icon(
                                FontAwesomeIcons.solidCopy,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            Color gray = Color(0xFFE2E2E2);
            Color orange = Color(0xFFFFA841);
            Color green = Color(0xFF139874);
            return StreamBuilder<DocumentSnapshot<Map>>(
                stream: _firestore
                    .collection("Users")
                    .doc(isSeller
                        ? roomSnapshot.data!.data()!["buyer"]
                        : roomSnapshot.data!.data()!["seller"])
                    .snapshots(),
                builder: (context, otherUserSnapshot) {
                  if (!otherUserSnapshot.hasData) {
                    return Container();
                  }
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                "assets/images/roomPageTopBg.png",
                              ),
                              alignment: Alignment.topLeft,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.14,
                              ),
                              Text(
                                "Güvenli alışveriş",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 26.0,
                                  height: 1.2,
                                  fontWeight: FontWeight.bold,
                                  color: kDarkBlue,
                                ),
                              ),
                              SizedBox(
                                height: 12.0,
                              ),
                              Container(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width -
                                            70.0),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text:
                                        otherUserSnapshot.data!.data()!["name"],
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF607ED1),
                                      fontFamily: 'Metropolis',
                                      height: 1.2,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            "\nadlı kullanıcıyla işlem gerçekleştiriliyor. ",
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w300,
                                          color: Color(0xFF607ED1),
                                          fontFamily: 'Metropolis',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.width * 0.07,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.92,
                                height:
                                    MediaQuery.of(context).size.width * 0.55,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Image.asset(
                                        isSeller
                                            ? "assets/images/roomPageWomanDraw.png"
                                            : "assets/images/roomPageManDraw.png",
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.55,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF4379B6),
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10.0),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.25),
                                              offset: Offset(3.0, 0),
                                              blurRadius: 3.0,
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.infoCircle,
                                                color: Colors.white,
                                                size: 32.0,
                                              ),
                                              SizedBox(
                                                width: 8.0,
                                              ),
                                              SingleChildScrollView(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8.0),
                                                  child: Container(
                                                    width:
                                                        (MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.6) -
                                                            56.0,
                                                    child: Text(
                                                      isSeller
                                                          ? "Alışverişine dair bütün işlemleri gerçekleştirebileceğin ekrandasın. Aşağıda yer alan butonlar sayesinde alıcı ile sohbet edebilir, kargo bilgilerini girebilir ve bir sorun yaşanması halinde bize ulaşabilirsin. Alışverişinin hangi aşamada olduğunu ise adım adım takip edebilirsin. Bir sonraki adımda neler yapman gerektiğini bilmiyorsan bütün gerekli bilgilerin yer aldığı İnfo & SSS sekmemize göz atabilirsin."
                                                          : 'Alışverişine dair bütün işlemleri gerçekleştirebileceğin ekrandasın. Aşağıda yer alan butonlar sayesinde satıcı ile sohbet edebilir, ödemelerini gerçekleştirebilir ve bir sorun yaşanması halinde bize ulaşabilirsin. Alışverişinin hangi aşamada olduğunu ise adım adım takip edebilirsin.\n\nBir sonraki adımda neler yapman gerektiğini bilmiyorsan bütün gerekli bilgilerin yer aldığı İnfo & SSS sekmemize göz atabilirsin.',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        fontSize: 11.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(14.0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4.0,
                                  color: Colors.black.withOpacity(0.3),
                                )
                              ]),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        bottomIndex = 0;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 18.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Alışveriş Süreci",
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w700,
                                              color: bottomIndex == 0
                                                  ? kDarkBlue
                                                  : Color(0xFFB7B1B1),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          bottomIndex == 0
                                              ? Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2,
                                                  height: 3.0,
                                                  color: kButtonBlue,
                                                )
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2,
                                                  height: 0.2,
                                                  decoration:
                                                      BoxDecoration(boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black,
                                                      blurRadius: 0.5,
                                                    ),
                                                  ]),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        bottomIndex = 1;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 18.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Ürün Bilgisi",
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w700,
                                              color: bottomIndex == 1
                                                  ? kDarkBlue
                                                  : Color(0xFFB7B1B1),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          bottomIndex == 1
                                              ? Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2,
                                                  height: 3.0,
                                                  color: kButtonBlue,
                                                )
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2,
                                                  height: 0.2,
                                                  decoration:
                                                      BoxDecoration(boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black,
                                                      blurRadius: 0.5,
                                                    ),
                                                  ]),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 12.0,
                              ),
                              bottomIndex == 0
                                  ? Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 12.0,
                                              left: 32.0,
                                              right: 32.0),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 3.0),
                                                child: Icon(
                                                  FontAwesomeIcons
                                                      .solidCheckCircle,
                                                  color: Color(0xFF139874),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: 3.0,
                                                  color: roomSnapshot.data!
                                                                  .data()![
                                                              "state"] ==
                                                          "Alıcı bekleniyor"
                                                      ? gray
                                                      : (roomSnapshot.data!
                                                                      .data()![
                                                                  "state"] ==
                                                              "Ödeme bekleniyor"
                                                          ? orange
                                                          : green),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 3.0),
                                                child: Icon(
                                                  FontAwesomeIcons
                                                      .solidCheckCircle,
                                                  color: roomSnapshot.data!
                                                                  .data()![
                                                              "state"] ==
                                                          "Alıcı bekleniyor"
                                                      ? gray
                                                      : (roomSnapshot.data!
                                                                      .data()![
                                                                  "state"] ==
                                                              "Ödeme bekleniyor"
                                                          ? orange
                                                          : green),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: 3.0,
                                                  color: (roomSnapshot.data!
                                                                      .data()![
                                                                  "state"] ==
                                                              "Ödeme bekleniyor" ||
                                                          roomSnapshot.data!
                                                                      .data()![
                                                                  "state"] ==
                                                              "Alıcı bekleniyor")
                                                      ? gray
                                                      : green,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 3.0),
                                                child: Icon(
                                                  FontAwesomeIcons
                                                      .solidCheckCircle,
                                                  color: (roomSnapshot.data!
                                                                      .data()![
                                                                  "state"] ==
                                                              "Ödeme bekleniyor" ||
                                                          roomSnapshot.data!
                                                                      .data()![
                                                                  "state"] ==
                                                              "Alıcı bekleniyor")
                                                      ? gray
                                                      : green,
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: 3.0,
                                                  color: (roomSnapshot.data!
                                                                      .data()![
                                                                  "state"] ==
                                                              "Ödeme bekleniyor" ||
                                                          roomSnapshot.data!
                                                                      .data()![
                                                                  "state"] ==
                                                              "Alıcı bekleniyor")
                                                      ? gray
                                                      : (roomSnapshot.data!
                                                                      .data()![
                                                                  "state"] ==
                                                              "Kargo bekleniyor"
                                                          ? orange
                                                          : green),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 3.0),
                                                child: Icon(
                                                  FontAwesomeIcons
                                                      .solidCheckCircle,
                                                  color: (roomSnapshot.data!
                                                                      .data()![
                                                                  "state"] ==
                                                              "Ödeme bekleniyor" ||
                                                          roomSnapshot.data!
                                                                      .data()![
                                                                  "state"] ==
                                                              "Alıcı bekleniyor")
                                                      ? gray
                                                      : (roomSnapshot.data!
                                                                      .data()![
                                                                  "state"] ==
                                                              "Kargo bekleniyor"
                                                          ? orange
                                                          : green),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  height: 3.0,
                                                  color: roomSnapshot.data!
                                                                  .data()![
                                                              "state"] ==
                                                          "Onay bekleniyor"
                                                      ? orange
                                                      : (roomSnapshot.data!
                                                                      .data()![
                                                                  "state"] ==
                                                              "Tamamlandı"
                                                          ? green
                                                          : gray),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 3.0),
                                                child: Icon(
                                                  FontAwesomeIcons
                                                      .solidCheckCircle,
                                                  color: roomSnapshot.data!
                                                                  .data()![
                                                              "state"] ==
                                                          "Onay bekleniyor"
                                                      ? orange
                                                      : (roomSnapshot.data!
                                                                      .data()![
                                                                  "state"] ==
                                                              "Tamamlandı"
                                                          ? green
                                                          : gray),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 6.0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 18.0, right: 20.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Alıcı ve Satıcı\nBuluştu.",
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xFF139874),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                "Alıcı Ödemesi\nBekleniyor.",
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.w500,
                                                  color: roomSnapshot.data!
                                                                  .data()![
                                                              "state"] ==
                                                          "Alıcı bekleniyor"
                                                      ? gray
                                                      : (roomSnapshot.data!
                                                                      .data()![
                                                                  "state"] ==
                                                              "Ödeme bekleniyor"
                                                          ? orange
                                                          : green),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                "Alıcı Ödemesi\nAlındı!",
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.w500,
                                                  color: (roomSnapshot.data!
                                                                      .data()![
                                                                  "state"] ==
                                                              "Ödeme bekleniyor" ||
                                                          roomSnapshot.data!
                                                                      .data()![
                                                                  "state"] ==
                                                              "Alıcı bekleniyor")
                                                      ? gray
                                                      : green,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                "Kargo\nAşamasında!",
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.w500,
                                                  color: (roomSnapshot.data!
                                                                      .data()![
                                                                  "state"] ==
                                                              "Ödeme bekleniyor" ||
                                                          roomSnapshot.data!
                                                                      .data()![
                                                                  "state"] ==
                                                              "Alıcı bekleniyor")
                                                      ? gray
                                                      : (roomSnapshot.data!
                                                                      .data()![
                                                                  "state"] ==
                                                              "Kargo bekleniyor"
                                                          ? orange
                                                          : green),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                "Alışveriş\nTamamlandı!",
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.w500,
                                                  color: roomSnapshot.data!
                                                                  .data()![
                                                              "state"] ==
                                                          "Onay bekleniyor"
                                                      ? orange
                                                      : (roomSnapshot.data!
                                                                      .data()![
                                                                  "state"] ==
                                                              "Tamamlandı"
                                                          ? green
                                                          : gray),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/images/roomPageClockIcon.png",
                                              height: 48.0,
                                              width: 48.0,
                                            ),
                                            SizedBox(
                                              width: 8.0,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.58,
                                                child: Text(
                                                  isSeller
                                                      ? "Alıcı ödeme işlemini gerçekleştirdikten sonra ilgili ürünü kargolaman ve kargo takip bilgisini uygulamamıza girmen için 72 saatiniz olduğunu unutmayın."
                                                      : 'Alıcısı olduğunuz ürünün ödemesini\ngerçekleştirmek için 72 saatiniz olduğunu unutmayın.\nÖdemesi gerçekleştirilmeyen\nişlemler satıcı itirazıyla iptal\nedilecektir.',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 11.5,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFF8F8F8F),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                side: BorderSide(
                                                  color: Color(0xFFEAEAEA),
                                                ),
                                              ),
                                            ),
                                            shadowColor:
                                                MaterialStateProperty.all(
                                              roomSnapshot.data!
                                                          .data()!["state"] ==
                                                      "Ödeme bekleniyor"
                                                  ? Color(0xFF48D1AB)
                                                      .withOpacity(0.3)
                                                  : (roomSnapshot.data!.data()![
                                                              "state"] ==
                                                          "Kargo bekleniyor"
                                                      ? Color(0xFF89AEFB)
                                                          .withOpacity(0.3)
                                                      : Color(0xFF48D1AB)
                                                          .withOpacity(0.3)),
                                            ),
                                            elevation:
                                                MaterialStateProperty.all(10.0),
                                          ),
                                          onPressed: isSeller
                                              ? ((roomSnapshot.data!
                                                          .data()!["state"] ==
                                                      "Ödeme bekleniyor")
                                                  ? null
                                                  : (roomSnapshot.data!.data()![
                                                              "state"] ==
                                                          "Kargo bekleniyor"
                                                      ? () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  backgroundColor:
                                                                      Color(
                                                                          0xFF57A1F6),
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              16.0)),
                                                                  content:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            12.0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 8.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Image.asset(
                                                                                "assets/images/cargoTrackingIcon.png",
                                                                                height: 35.0,
                                                                                width: 35.0,
                                                                              ),
                                                                              SizedBox(
                                                                                width: 8.0,
                                                                              ),
                                                                              Text(
                                                                                "Lütfen Kargo\nBilgilerini Giriniz",
                                                                                style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontSize: 16.0,
                                                                                ),
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              8.0,
                                                                        ),
                                                                        Divider(
                                                                          color: Colors
                                                                              .white
                                                                              .withOpacity(0.5),
                                                                          height:
                                                                              2.0,
                                                                          thickness:
                                                                              2.0,
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              18.0,
                                                                        ),
                                                                        Text(
                                                                          "Kargo Takip Numarası",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                12.0,
                                                                          ),
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              8.0,
                                                                        ),
                                                                        TextField(
                                                                          controller:
                                                                              _cargoTrackingCodeController,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                12.0,
                                                                          ),
                                                                          decoration: InputDecoration(
                                                                              contentPadding: EdgeInsets.symmetric(
                                                                                vertical: 2.0,
                                                                                horizontal: 8.0,
                                                                              ),
                                                                              constraints: BoxConstraints(maxHeight: 30.0),
                                                                              border: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(6.0),
                                                                                borderSide: BorderSide.none,
                                                                              ),
                                                                              focusedBorder: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(6.0),
                                                                                borderSide: BorderSide.none,
                                                                              ),
                                                                              enabledBorder: OutlineInputBorder(
                                                                                borderRadius: BorderRadius.circular(6.0),
                                                                                borderSide: BorderSide.none,
                                                                              ),
                                                                              filled: true,
                                                                              fillColor: Colors.white),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  actions: [
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          () async {
                                                                        await roomSnapshot
                                                                            .data!
                                                                            .reference
                                                                            .update({
                                                                          "cargoTrackingCode":
                                                                              _cargoTrackingCodeController.text,
                                                                        });
                                                                        if (otherUserSnapshot
                                                                            .data!
                                                                            .data()!["allowNotifications"]!) {
                                                                          await NotificationHandler.sendNotification(
                                                                              fcmToken: otherUserSnapshot.data!.data()!["fcmToken"],
                                                                              message: "Ürününüz kargoya verildi.");
                                                                        }
                                                                        await roomSnapshot
                                                                            .data!
                                                                            .reference
                                                                            .update({
                                                                          "state":
                                                                              "Onay bekleniyor"
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: Text(
                                                                          "Tamam"),
                                                                    ),
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        _cargoTrackingCodeController
                                                                            .clear();
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: Text(
                                                                          "İptal"),
                                                                    ),
                                                                  ],
                                                                );
                                                              });
                                                        }
                                                      : null))
                                              : (roomSnapshot.data!
                                                          .data()!["state"] ==
                                                      "Ödeme bekleniyor"
                                                  ? () async {
                                                      //TODO: PAYMENT PAGE
                                                      if (otherUserSnapshot
                                                              .data!
                                                              .data()![
                                                          "allowNotifications"]) {
                                                        await NotificationHandler
                                                            .sendNotification(
                                                                fcmToken: otherUserSnapshot
                                                                        .data!
                                                                        .data()![
                                                                    "fcmToken"],
                                                                message:
                                                                    "Alıcı ödemeyi yaptı.");
                                                      }

                                                      await roomSnapshot
                                                          .data!.reference
                                                          .update({
                                                        "state":
                                                            "Kargo bekleniyor"
                                                      });
                                                    }
                                                  : (roomSnapshot.data!.data()![
                                                              "state"] ==
                                                          "Kargo bekleniyor"
                                                      ? null
                                                      : () async {
                                                          if (otherUserSnapshot
                                                                  .data!
                                                                  .data()![
                                                              "allowNotifications"]) {
                                                            await NotificationHandler.sendNotification(
                                                                fcmToken: otherUserSnapshot
                                                                        .data!
                                                                        .data()![
                                                                    "fcmToken"],
                                                                message:
                                                                    "Alıcı siparişi onayladı.");
                                                          }
                                                          await roomSnapshot
                                                              .data!.reference
                                                              .update({
                                                            "state":
                                                                "Tamamlandı"
                                                          });
                                                        })),
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 220,
                                            height: 45,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                roomSnapshot.data!
                                                            .data()!["state"] ==
                                                        "Ödeme bekleniyor"
                                                    ? Icon(
                                                        FontAwesomeIcons
                                                            .solidCreditCard,
                                                        size: 20.0,
                                                        color:
                                                            Color(0xFF48D1AB),
                                                      )
                                                    : (roomSnapshot.data!
                                                                    .data()![
                                                                "state"] ==
                                                            "Kargo bekleniyor"
                                                        ? Image.asset(
                                                            "assets/images/roomCargoButtonIcon.png",
                                                            width: 20.0,
                                                          )
                                                        : Icon(
                                                            FontAwesomeIcons
                                                                .check,
                                                            size: 20.0,
                                                            color: Color(
                                                                0xFF48D1AB))),
                                                SizedBox(
                                                  width: 16.0,
                                                ),
                                                isSeller
                                                    ? (roomSnapshot.data!
                                                                    .data()![
                                                                "state"] ==
                                                            "Ödeme bekleniyor"
                                                        ? Text(
                                                            "Ödeme Bekleniyor",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF48D1AB),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12,
                                                            ),
                                                          )
                                                        : (roomSnapshot.data!
                                                                        .data()![
                                                                    "state"] ==
                                                                "Kargo bekleniyor"
                                                            ? Text(
                                                                "Kargo Bilgileri Girişi",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF89AEFB),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12,
                                                                ),
                                                              )
                                                            : (roomSnapshot.data!
                                                                            .data()![
                                                                        "state"] ==
                                                                    "Onay bekleniyor"
                                                                ? Text(
                                                                    "Onay Bekleniyor",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          0xFF48D1AB),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                  )
                                                                : Text(
                                                                    "Alışveriş Tamamlandı!",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          0xFF48D1AB),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          10.5,
                                                                    ),
                                                                  ))))
                                                    : (roomSnapshot.data!
                                                                    .data()![
                                                                "state"] ==
                                                            "Ödeme bekleniyor"
                                                        ? Text(
                                                            "Ödeme Yap",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF48D1AB),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12,
                                                            ),
                                                          )
                                                        : (roomSnapshot.data!
                                                                        .data()![
                                                                    "state"] ==
                                                                "Kargo bekleniyor"
                                                            ? Text(
                                                                "Kargo Bekleniyor",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xFF89AEFB),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12,
                                                                ),
                                                              )
                                                            : (roomSnapshot.data!
                                                                            .data()![
                                                                        "state"] ==
                                                                    "Onay bekleniyor"
                                                                ? Text(
                                                                    "Alışverişi Onayla",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          0xFF48D1AB),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          12,
                                                                    ),
                                                                  )
                                                                : Text(
                                                                    "Alışveriş Tamamlandı!",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          0xFF48D1AB),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          10.5,
                                                                    ),
                                                                  )))),
                                                SizedBox(
                                                  width: 16.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8.0,
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                side: BorderSide(
                                                  color: Color(0xFFEAEAEA),
                                                ),
                                              ),
                                            ),
                                            shadowColor:
                                                MaterialStateProperty.all(
                                              Color(0xFF0877F7)
                                                  .withOpacity(0.3),
                                            ),
                                            elevation:
                                                MaterialStateProperty.all(10.0),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              FadeRoute(
                                                page: ChatScreen(
                                                  item: roomSnapshot.data!
                                                      .data()!,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 220,
                                            height: 45,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/images/roomMessagesIcon.png",
                                                  width: 20.0,
                                                ),
                                                SizedBox(
                                                  width: 16.0,
                                                ),
                                                Text(
                                                  "Mesajlaşma Ekranı",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Color(0xFF0877F7),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 16.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8.0,
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.white),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                side: BorderSide(
                                                  color: Color(0xFFEAEAEA),
                                                ),
                                              ),
                                            ),
                                            shadowColor:
                                                MaterialStateProperty.all(
                                              Color(0xFFFE9ECC)
                                                  .withOpacity(0.3),
                                            ),
                                            elevation:
                                                MaterialStateProperty.all(10.0),
                                          ),
                                          onPressed:
                                              roomSnapshot.data!
                                                      .data()!
                                                      .containsKey("problem")
                                                  ? () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                side:
                                                                    BorderSide(
                                                                  color: Color(
                                                                      0xFFABCDF1),
                                                                ),
                                                              ),
                                                              backgroundColor:
                                                                  Color(
                                                                      0xFFE5EFFA),
                                                              content: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              kButtonBlue,
                                                                          borderRadius:
                                                                              BorderRadius.circular(6.0),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Icon(
                                                                            FontAwesomeIcons.infoCircle,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                20.0,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            12.0,
                                                                      ),
                                                                      Text(
                                                                        "Talebiniz iletildi!",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              18.0,
                                                                          height:
                                                                              1.2,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              kDarkBlue,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        12.0,
                                                                  ),
                                                                  Text(
                                                                    "Talebinizin sürecini Çözüm Merkezi kısmından takip edebilir, çözüm merkeziyle iletişime geçebilirsiniz.",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color:
                                                                          kDarkBlue,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          });
                                                    }
                                                  : () {
                                                      TextEditingController
                                                          _problemController =
                                                          TextEditingController();
                                                      String? selected;

                                                      showModalBottomSheet(
                                                          context: context,
                                                          isScrollControlled:
                                                              true,
                                                          builder: (context) {
                                                            return StatefulBuilder(
                                                                builder: (context,
                                                                    setState) {
                                                              return Container(
                                                                color: Color(
                                                                    0xFF757575),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .vertical(
                                                                        top: Radius.circular(
                                                                            20.0),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .symmetric(
                                                                        vertical:
                                                                            16.0,
                                                                        horizontal:
                                                                            16.0,
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          Container(
                                                                            width:
                                                                                50.0,
                                                                            height:
                                                                                3.0,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: kDarkBlue,
                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                8.0,
                                                                          ),
                                                                          Text(
                                                                            "Sorun Bildir",
                                                                            style:
                                                                                TextStyle(
                                                                              color: kDarkBlue,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 16.0,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                16.0,
                                                                          ),
                                                                          roomSnapshot.data!.data()!["buyer"] == _firebaseAuth.currentUser!.uid
                                                                              ? Column(
                                                                                  children: [
                                                                                    GestureDetector(
                                                                                      onTap: () {
                                                                                        setState(() {
                                                                                          selected = "İlan detaylarında hata söz konusu";
                                                                                        });
                                                                                      },
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Container(
                                                                                            decoration: BoxDecoration(
                                                                                              shape: BoxShape.circle,
                                                                                              color: Color(0xFFE2E2E2),
                                                                                            ),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(5.0),
                                                                                              child: Container(
                                                                                                height: 11.0,
                                                                                                width: 11.0,
                                                                                                decoration: BoxDecoration(
                                                                                                  shape: BoxShape.circle,
                                                                                                  color: selected == "İlan detaylarında hata söz konusu" ? kButtonBlue : Color(0xFFE2E2E2),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 8.0,
                                                                                          ),
                                                                                          Text(
                                                                                            "İlan detaylarında hata söz konusu",
                                                                                            style: TextStyle(
                                                                                              color: Color(0xFF2D3540),
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: 14.0,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 14.0,
                                                                                    ),
                                                                                    GestureDetector(
                                                                                      onTap: () {
                                                                                        setState(() {
                                                                                          selected = "Ödeme süreci ile ilgili sorun yaşıyorum";
                                                                                        });
                                                                                      },
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Container(
                                                                                            decoration: BoxDecoration(
                                                                                              shape: BoxShape.circle,
                                                                                              color: Color(0xFFE2E2E2),
                                                                                            ),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(5.0),
                                                                                              child: Container(
                                                                                                height: 11.0,
                                                                                                width: 11.0,
                                                                                                decoration: BoxDecoration(
                                                                                                  shape: BoxShape.circle,
                                                                                                  color: selected == "Ödeme süreci ile ilgili sorun yaşıyorum" ? kButtonBlue : Color(0xFFE2E2E2),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 8.0,
                                                                                          ),
                                                                                          Text(
                                                                                            "Ödeme süreci ile ilgili sorun yaşıyorum",
                                                                                            style: TextStyle(
                                                                                              color: Color(0xFF2D3540),
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: 14.0,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 14.0,
                                                                                    ),
                                                                                    GestureDetector(
                                                                                      onTap: () {
                                                                                        setState(() {
                                                                                          selected = "Kargo süreci ile ilgili sorun yaşıyorum";
                                                                                        });
                                                                                      },
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Container(
                                                                                            decoration: BoxDecoration(
                                                                                              shape: BoxShape.circle,
                                                                                              color: Color(0xFFE2E2E2),
                                                                                            ),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(5.0),
                                                                                              child: Container(
                                                                                                height: 11.0,
                                                                                                width: 11.0,
                                                                                                decoration: BoxDecoration(
                                                                                                  shape: BoxShape.circle,
                                                                                                  color: selected == "Kargo süreci ile ilgili sorun yaşıyorum" ? kButtonBlue : Color(0xFFE2E2E2),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 8.0,
                                                                                          ),
                                                                                          Text(
                                                                                            "Kargo süreci ile ilgili sorun yaşıyorum",
                                                                                            style: TextStyle(
                                                                                              color: Color(0xFF2D3540),
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: 14.0,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 14.0,
                                                                                    ),
                                                                                    GestureDetector(
                                                                                      onTap: () {
                                                                                        setState(() {
                                                                                          selected = "Elime ulaşan ürün kırık/hatalı/yanlış";
                                                                                        });
                                                                                      },
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Container(
                                                                                            decoration: BoxDecoration(
                                                                                              shape: BoxShape.circle,
                                                                                              color: Color(0xFFE2E2E2),
                                                                                            ),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(5.0),
                                                                                              child: Container(
                                                                                                height: 11.0,
                                                                                                width: 11.0,
                                                                                                decoration: BoxDecoration(
                                                                                                  shape: BoxShape.circle,
                                                                                                  color: selected == "Elime ulaşan ürün kırık/hatalı/yanlış" ? kButtonBlue : Color(0xFFE2E2E2),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 8.0,
                                                                                          ),
                                                                                          Text(
                                                                                            "Elime ulaşan ürün kırık/hatalı/yanlış",
                                                                                            style: TextStyle(
                                                                                              color: Color(0xFF2D3540),
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: 14.0,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 14.0,
                                                                                    ),
                                                                                    GestureDetector(
                                                                                      onTap: () {
                                                                                        setState(() {
                                                                                          selected = "İade talebinde bulunmak istiyorum";
                                                                                        });
                                                                                      },
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Container(
                                                                                            decoration: BoxDecoration(
                                                                                              shape: BoxShape.circle,
                                                                                              color: Color(0xFFE2E2E2),
                                                                                            ),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(5.0),
                                                                                              child: Container(
                                                                                                height: 11.0,
                                                                                                width: 11.0,
                                                                                                decoration: BoxDecoration(
                                                                                                  shape: BoxShape.circle,
                                                                                                  color: selected == "İade talebinde bulunmak istiyorum" ? kButtonBlue : Color(0xFFE2E2E2),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 8.0,
                                                                                          ),
                                                                                          Text(
                                                                                            "İade talebinde bulunmak istiyorum",
                                                                                            style: TextStyle(
                                                                                              color: Color(0xFF2D3540),
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: 14.0,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 14.0,
                                                                                    ),
                                                                                    GestureDetector(
                                                                                      onTap: () {
                                                                                        setState(() {
                                                                                          selected = "Diğer";
                                                                                        });
                                                                                      },
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Container(
                                                                                            decoration: BoxDecoration(
                                                                                              shape: BoxShape.circle,
                                                                                              color: Color(0xFFE2E2E2),
                                                                                            ),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(5.0),
                                                                                              child: Container(
                                                                                                height: 11.0,
                                                                                                width: 11.0,
                                                                                                decoration: BoxDecoration(
                                                                                                  shape: BoxShape.circle,
                                                                                                  color: selected == "Diğer" ? kButtonBlue : Color(0xFFE2E2E2),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 8.0,
                                                                                          ),
                                                                                          Text(
                                                                                            "Diğer",
                                                                                            style: TextStyle(
                                                                                              color: Color(0xFF2D3540),
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: 14.0,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 16.0,
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                              : Column(
                                                                                  children: [
                                                                                    GestureDetector(
                                                                                      onTap: () {
                                                                                        setState(() {
                                                                                          selected = "İlan detaylarında değişiklik yapmak istiyorum";
                                                                                        });
                                                                                      },
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Container(
                                                                                            decoration: BoxDecoration(
                                                                                              shape: BoxShape.circle,
                                                                                              color: Color(0xFFE2E2E2),
                                                                                            ),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(5.0),
                                                                                              child: Container(
                                                                                                height: 11.0,
                                                                                                width: 11.0,
                                                                                                decoration: BoxDecoration(
                                                                                                  shape: BoxShape.circle,
                                                                                                  color: selected == "İlan detaylarında değişiklik yapmak istiyorum" ? kButtonBlue : Color(0xFFE2E2E2),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 8.0,
                                                                                          ),
                                                                                          Text(
                                                                                            "İlan detaylarında değişiklik yapmak\nistiyorum",
                                                                                            style: TextStyle(
                                                                                              color: Color(0xFF2D3540),
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: 14.0,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 14.0,
                                                                                    ),
                                                                                    GestureDetector(
                                                                                      onTap: () {
                                                                                        setState(() {
                                                                                          selected = "Kargo süreci ile ilgili sorun yaşıyorum";
                                                                                        });
                                                                                      },
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Container(
                                                                                            decoration: BoxDecoration(
                                                                                              shape: BoxShape.circle,
                                                                                              color: Color(0xFFE2E2E2),
                                                                                            ),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(5.0),
                                                                                              child: Container(
                                                                                                height: 11.0,
                                                                                                width: 11.0,
                                                                                                decoration: BoxDecoration(
                                                                                                  shape: BoxShape.circle,
                                                                                                  color: selected == "Kargo süreci ile ilgili sorun yaşıyorum" ? kButtonBlue : Color(0xFFE2E2E2),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 8.0,
                                                                                          ),
                                                                                          Text(
                                                                                            "Kargo süreci ile ilgili sorun yaşıyorum",
                                                                                            style: TextStyle(
                                                                                              color: Color(0xFF2D3540),
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: 14.0,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 14.0,
                                                                                    ),
                                                                                    GestureDetector(
                                                                                      onTap: () {
                                                                                        setState(() {
                                                                                          selected = "İadesi gerçekleşen ürün kırık/hatalı/yanlış";
                                                                                        });
                                                                                      },
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Container(
                                                                                            decoration: BoxDecoration(
                                                                                              shape: BoxShape.circle,
                                                                                              color: Color(0xFFE2E2E2),
                                                                                            ),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(5.0),
                                                                                              child: Container(
                                                                                                height: 11.0,
                                                                                                width: 11.0,
                                                                                                decoration: BoxDecoration(
                                                                                                  shape: BoxShape.circle,
                                                                                                  color: selected == "İadesi gerçekleşen ürün kırık/hatalı/yanlış" ? kButtonBlue : Color(0xFFE2E2E2),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 8.0,
                                                                                          ),
                                                                                          Text(
                                                                                            "İadesi gerçekleşen ürün kırık/hatalı/yanlış",
                                                                                            style: TextStyle(
                                                                                              color: Color(0xFF2D3540),
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: 14.0,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 14.0,
                                                                                    ),
                                                                                    GestureDetector(
                                                                                      onTap: () {
                                                                                        setState(() {
                                                                                          selected = "Diğer";
                                                                                        });
                                                                                      },
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Container(
                                                                                            decoration: BoxDecoration(
                                                                                              shape: BoxShape.circle,
                                                                                              color: Color(0xFFE2E2E2),
                                                                                            ),
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(5.0),
                                                                                              child: Container(
                                                                                                height: 11.0,
                                                                                                width: 11.0,
                                                                                                decoration: BoxDecoration(
                                                                                                  shape: BoxShape.circle,
                                                                                                  color: selected == "Diğer" ? kButtonBlue : Color(0xFFE2E2E2),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(
                                                                                            width: 8.0,
                                                                                          ),
                                                                                          Text(
                                                                                            "Diğer",
                                                                                            style: TextStyle(
                                                                                              color: Color(0xFF2D3540),
                                                                                              fontWeight: FontWeight.w500,
                                                                                              fontSize: 14.0,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 16.0,
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.only(
                                                                              bottom: MediaQuery.of(context).viewInsets.bottom,
                                                                            ),
                                                                            child:
                                                                                TextField(
                                                                              controller: _problemController,
                                                                              decoration: InputDecoration(
                                                                                hintText: "Yorumunuz",
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                                  borderSide: BorderSide(
                                                                                    color: Color(0xFF8C95A1),
                                                                                    width: 0.5,
                                                                                  ),
                                                                                ),
                                                                                focusedBorder: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                                  borderSide: BorderSide(
                                                                                    color: Color(0xFF8C95A1),
                                                                                    width: 0.5,
                                                                                  ),
                                                                                ),
                                                                                enabledBorder: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(10.0),
                                                                                  borderSide: BorderSide(
                                                                                    color: Color(0xFF8C95A1),
                                                                                    width: 0.5,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              maxLines: 3,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                2.0,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              ElevatedButton(
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                style: ButtonStyle(
                                                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                                    RoundedRectangleBorder(
                                                                                      side: BorderSide(
                                                                                        color: kButtonBlue,
                                                                                        width: 1.5,
                                                                                      ),
                                                                                      borderRadius: BorderRadius.circular(32.0),
                                                                                    ),
                                                                                  ),
                                                                                  minimumSize: MaterialStateProperty.all(Size(140, 40)),
                                                                                  backgroundColor: MaterialStateProperty.all(
                                                                                    Colors.white,
                                                                                  ),
                                                                                  elevation: MaterialStateProperty.all(0),
                                                                                ),
                                                                                child: Text(
                                                                                  "VAZGEÇ",
                                                                                  style: TextStyle(
                                                                                    fontSize: 15.0,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: kButtonBlue,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              ElevatedButton(
                                                                                onPressed: selected != null && _problemController.text.isNotEmpty
                                                                                    ? () async {
                                                                                        WriteBatch _writeBatch = _firestore.batch();
                                                                                        _writeBatch.update(roomSnapshot.data!.reference, {
                                                                                          "problem": selected,
                                                                                          "problemDetail": _problemController.text,
                                                                                          "problemDate": FieldValue.serverTimestamp(),
                                                                                          "problemState": "Çözüm Merkezine İletildi.",
                                                                                          "isReported": true,
                                                                                        });
                                                                                        _writeBatch.set(roomSnapshot.data!.reference.collection("ProblemMessages").doc(), {
                                                                                          "message": _problemController.text,
                                                                                          "date": FieldValue.serverTimestamp(),
                                                                                          "sender": _firebaseAuth.currentUser!.uid,
                                                                                        });
                                                                                        await _writeBatch.commit().whenComplete(() async {
                                                                                          await NotificationHandler.sendNotification(fcmToken: "admin", isTopic: true, message: "Çözüm merkezinde yeni bir işlem var.");
                                                                                          await NotificationHandler.sendNotification(fcmToken: otherUserSnapshot.data!.data()!["fcmToken"], message: "Bir işleminizle ilgili çözüm merkezi ile iletişim kuruldu.");
                                                                                          Navigator.pop(context);
                                                                                          showDialog(
                                                                                              context: context,
                                                                                              builder: (context) {
                                                                                                return AlertDialog(
                                                                                                  shape: RoundedRectangleBorder(
                                                                                                    borderRadius: BorderRadius.circular(10.0),
                                                                                                    side: BorderSide(
                                                                                                      color: Color(0xFFABCDF1),
                                                                                                    ),
                                                                                                  ),
                                                                                                  backgroundColor: Color(0xFFE5EFFA),
                                                                                                  content: Column(
                                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                                    children: [
                                                                                                      Row(
                                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                        children: [
                                                                                                          Container(
                                                                                                            decoration: BoxDecoration(
                                                                                                              color: kButtonBlue,
                                                                                                              borderRadius: BorderRadius.circular(6.0),
                                                                                                            ),
                                                                                                            child: Padding(
                                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                                              child: Icon(
                                                                                                                FontAwesomeIcons.infoCircle,
                                                                                                                color: Colors.white,
                                                                                                                size: 20.0,
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                          SizedBox(
                                                                                                            width: 12.0,
                                                                                                          ),
                                                                                                          Text(
                                                                                                            "Talebiniz iletildi!",
                                                                                                            textAlign: TextAlign.center,
                                                                                                            style: TextStyle(
                                                                                                              fontSize: 18.0,
                                                                                                              height: 1.2,
                                                                                                              fontWeight: FontWeight.bold,
                                                                                                              color: kDarkBlue,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                      SizedBox(
                                                                                                        height: 12.0,
                                                                                                      ),
                                                                                                      Text(
                                                                                                        "Talebinizin sürecini Çözüm Merkezi kısmından takip edebilir, çözüm merkeziyle iletişime geçebilirsiniz.",
                                                                                                        textAlign: TextAlign.center,
                                                                                                        style: TextStyle(
                                                                                                          fontSize: 12.0,
                                                                                                          fontWeight: FontWeight.w500,
                                                                                                          color: kDarkBlue,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                );
                                                                                              });
                                                                                        });
                                                                                      }
                                                                                    : () {
                                                                                        showDialog(
                                                                                            context: context,
                                                                                            builder: (context) {
                                                                                              return Center(
                                                                                                child: Wrap(
                                                                                                  children: [
                                                                                                    Stack(
                                                                                                      children: [
                                                                                                        AlertDialog(
                                                                                                          shape: RoundedRectangleBorder(
                                                                                                            borderRadius: BorderRadius.circular(15),
                                                                                                          ),
                                                                                                          backgroundColor: Color(0xFF6EB0FC),
                                                                                                          content: Center(
                                                                                                            child: Column(
                                                                                                              children: [
                                                                                                                Align(
                                                                                                                  alignment: Alignment.topRight,
                                                                                                                  child: GestureDetector(
                                                                                                                    onTap: () {
                                                                                                                      Navigator.pop(context);
                                                                                                                    },
                                                                                                                    child: Icon(
                                                                                                                      FontAwesomeIcons.times,
                                                                                                                      color: Colors.white,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                SizedBox(
                                                                                                                  height: 48.0,
                                                                                                                ),
                                                                                                                Text(
                                                                                                                  "Sorun bildirebilmeniz için yorum kısmını doldurmanız gereklidir.",
                                                                                                                  style: TextStyle(
                                                                                                                    color: Colors.white,
                                                                                                                  ),
                                                                                                                  textAlign: TextAlign.center,
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        Align(
                                                                                                          alignment: Alignment.topCenter,
                                                                                                          child: Image.asset(
                                                                                                            "assets/images/warningDialogDraw.png",
                                                                                                            height: 96.0,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              );
                                                                                            });
                                                                                      },
                                                                                style: ButtonStyle(
                                                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                                    RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(32.0),
                                                                                    ),
                                                                                  ),
                                                                                  shadowColor: MaterialStateProperty.all(
                                                                                    kButtonBlue.withOpacity(0.4),
                                                                                  ),
                                                                                  minimumSize: MaterialStateProperty.all(Size(140, 40)),
                                                                                  backgroundColor: MaterialStateProperty.all(
                                                                                    kButtonBlue,
                                                                                  ),
                                                                                  elevation: MaterialStateProperty.all(20),
                                                                                ),
                                                                                child: Text(
                                                                                  "GÖNDER",
                                                                                  style: TextStyle(
                                                                                    fontSize: 15.0,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                2.0,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            });
                                                          });
                                                    },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 220,
                                            height: 45,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Transform.rotate(
                                                  angle: 3.15,
                                                  child: Icon(
                                                    Icons.info,
                                                    color: Color(0xFFFE9ECC),
                                                    size: 20.0,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 16.0,
                                                ),
                                                Text(
                                                  "Sorun Bildir",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Color(0xFFFE9ECC),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 16.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8.0,
                                        ),
                                      ],
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.tag,
                                                size: 12.0,
                                                color: Color(0xFF6EB0FC),
                                              ),
                                              SizedBox(
                                                width: 6.0,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    88.0,
                                                child: Text(
                                                  roomSnapshot.data!
                                                      .data()!["productName"],
                                                  style: TextStyle(
                                                    color: kDarkBlue,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 12.0,
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.bookmark,
                                                size: 12.0,
                                                color: Color(0xFF6EB0FC),
                                              ),
                                              SizedBox(
                                                width: 6.0,
                                              ),
                                              Text(
                                                roomSnapshot.data!.data()![
                                                    "selectedProductType"],
                                                style: TextStyle(
                                                  fontSize: 13.7,
                                                  color: Color(0xFFC3C3C3),
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 16.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 230,
                                                width: 215,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          roomSnapshot.data!
                                                                  .data()![
                                                              "imageURLs"][0]),
                                                      fit: BoxFit.cover,
                                                    )),
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Column(
                                                children: [
                                                  if (roomSnapshot.data!
                                                          .data()!["imageURLs"]
                                                          .length >=
                                                      2)
                                                    Container(
                                                      height: 70.0,
                                                      width: 70.0,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                roomSnapshot
                                                                        .data!
                                                                        .data()![
                                                                    "imageURLs"][1]),
                                                            fit: BoxFit.cover,
                                                          )),
                                                    ),
                                                  if (roomSnapshot.data!
                                                          .data()!["imageURLs"]
                                                          .length >=
                                                      3)
                                                    SizedBox(
                                                      height: 8.0,
                                                    ),
                                                  if (roomSnapshot.data!
                                                          .data()!["imageURLs"]
                                                          .length >=
                                                      3)
                                                    Container(
                                                      height: 70.0,
                                                      width: 70.0,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                roomSnapshot
                                                                        .data!
                                                                        .data()![
                                                                    "imageURLs"][2]),
                                                            fit: BoxFit.cover,
                                                          )),
                                                    ),
                                                  if (roomSnapshot.data!
                                                          .data()!["imageURLs"]
                                                          .length ==
                                                      4)
                                                    SizedBox(
                                                      height: 8.0,
                                                    ),
                                                  if (roomSnapshot.data!
                                                          .data()!["imageURLs"]
                                                          .length ==
                                                      4)
                                                    Container(
                                                      height: 70.0,
                                                      width: 70.0,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                roomSnapshot
                                                                        .data!
                                                                        .data()![
                                                                    "imageURLs"][3]),
                                                            fit: BoxFit.cover,
                                                          )),
                                                    ),
                                                ],
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12.0),
                                            child: Container(
                                              height: 1,
                                              color: Color(0xFFC9C6C6),
                                            ),
                                          ),
                                          ProductInfoRow(
                                              title: "Anlaşılan Ücret",
                                              info: roomSnapshot.data!
                                                      .data()!["productPrice"] +
                                                  " TL",
                                              icon:
                                                  "assets/images/productPriceIcon.png"),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12.0),
                                            child: Container(
                                              height: 1,
                                              color: Color(0xFFC9C6C6),
                                            ),
                                          ),
                                          ProductInfoRow(
                                              title: isSeller
                                                  ? "Alıcının İsmi"
                                                  : "Satıcının İsmi",
                                              info: roomSnapshot.data!
                                                  .data()!["buyerName"],
                                              icon:
                                                  "assets/images/buyerNameIcon.png"),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12.0),
                                            child: Container(
                                              height: 1,
                                              color: Color(0xFFC9C6C6),
                                            ),
                                          ),
                                          ProductInfoRow(
                                              title: "Kargo Firması",
                                              info: roomSnapshot.data!
                                                  .data()!["selectedCargo"],
                                              icon:
                                                  "assets/images/selectedCargoIcon.png"),
                                          if (roomSnapshot.data!
                                              .data()!
                                              .containsKey("cargoTrackingCode"))
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12.0),
                                              child: Container(
                                                height: 1,
                                                color: Color(0xFFC9C6C6),
                                              ),
                                            ),
                                          if (roomSnapshot.data!
                                              .data()!
                                              .containsKey("cargoTrackingCode"))
                                            ProductInfoRow(
                                                title: "Kargo Takip",
                                                info:
                                                    roomSnapshot.data!.data()![
                                                        "cargoTrackingCode"],
                                                icon:
                                                    "assets/images/selectedCargoIcon.png"),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12.0),
                                            child: Container(
                                              height: 1,
                                              color: Color(0xFFC9C6C6),
                                            ),
                                          ),
                                          ProductInfoRow(
                                              title:
                                                  "Anlaşılan Kargolama Tarihi",
                                              info: (roomSnapshot.data!
                                                              .data()![
                                                                  "cargoDate"]
                                                              .toDate()
                                                              .day <
                                                          10
                                                      ? "0"
                                                      : "") +
                                                  roomSnapshot.data!
                                                      .data()!["cargoDate"]
                                                      .toDate()
                                                      .day
                                                      .toString() +
                                                  "/" +
                                                  (roomSnapshot.data!
                                                              .data()![
                                                                  "cargoDate"]
                                                              .toDate()
                                                              .month <
                                                          10
                                                      ? "0"
                                                      : "") +
                                                  roomSnapshot.data!
                                                      .data()!["cargoDate"]
                                                      .toDate()
                                                      .month
                                                      .toString() +
                                                  "/" +
                                                  roomSnapshot.data!
                                                      .data()!["cargoDate"]
                                                      .toDate()
                                                      .year
                                                      .toString(),
                                              icon:
                                                  "assets/images/cargoDateIcon.png"),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12.0),
                                            child: Container(
                                              height: 1,
                                              color: Color(0xFFC9C6C6),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Image.asset(
                                                    "assets/images/productDescriptionIcon.png",
                                                    height: 13.0,
                                                    width: 20.0,
                                                  ),
                                                  SizedBox(
                                                    width: 6.0,
                                                  ),
                                                  Text(
                                                    "Ürün Açıklaması & Detaylar",
                                                    style: TextStyle(
                                                      color: kDarkBlue,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 8.0,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    32,
                                                decoration: BoxDecoration(
                                                    color: Color(0xFFFEFDFD),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    border: Border.all(
                                                      color: Color(0xFF707070)
                                                          .withOpacity(0.1),
                                                    )),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    roomSnapshot.data!.data()![
                                                        "productDescription"],
                                                    style: TextStyle(
                                                      color: kTextFieldGrey,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 13.0,
                                                    ),
                                                    textAlign: TextAlign.start,
                                                    maxLines: 1,
                                                    softWrap: false,
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 32.0,
                                          ),
                                        ],
                                      ),
                                    ),
                              SizedBox(
                                height: 8.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    this.fieldController,
    this.value,
    required this.title,
  });

  final TextEditingController? fieldController;
  final String? value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              title == "Ürünün Linki"
                  ? Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Row(
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: kDarkBlue,
                            ),
                          ),
                          Text(
                            " (opsiyonel)",
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w300,
                              color: kDarkBlue,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: kDarkBlue,
                        ),
                      ),
                    ),
              SizedBox(
                width: 4.0,
              ),
              if (title == "Ürün Açıklaması" ||
                  title == "Alıcının İsmi" && fieldController != null)
                Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  message: title == "Ürün Açıklaması"
                      ? "Ürün ilanında bulunan detayları ekleyebileceğiniz gibi, alıcı ile öncesinde üzerine anlaştığınız satış şartlarını da buraya not düşebilirsiniz."
                      : "Alıcının geri kalan bilgileri bizim tarafımızca talep edilecek ve saklanacaktır",
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.only(
                      left: 70.0, right: 20.0, top: 20.0, bottom: 20.0),
                  showDuration: Duration(seconds: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFFE2E2E2),
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    border: Border.all(
                      color: Color(0xFF2C8CFA),
                    ),
                  ),
                  textStyle: TextStyle(
                    color: kDarkBlue,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  ),
                  verticalOffset: -5,
                  child: Icon(
                    FontAwesomeIcons.solidQuestionCircle,
                    color: Color(0xFF2C8CFA),
                    size: 16.0,
                  ),
                ),
            ],
          ),
          SizedBox(
            height: 4.0,
          ),
          PhysicalModel(
            color: kDarkBlue.withOpacity(0.05),
            shadowColor: kDarkBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.0),
            elevation: 8.0,
            child: TextField(
              enabled: fieldController != null,
              controller: fieldController != null
                  ? fieldController
                  : TextEditingController(text: value),
              keyboardType: title == "Anlaşılan Ücret"
                  ? TextInputType.number
                  : TextInputType.text,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
                color: kTextFieldGrey,
              ),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    8.0,
                  ),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    8.0,
                  ),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: title == "Anlaşılan Ücret"
                    ? Icon(
                        FontAwesomeIcons.coins,
                        size: 15.0,
                        color: kDarkBlue,
                      )
                    : (title == "Kargo Firması" || title == "Ürün Cinsi"
                        ? Icon(
                            FontAwesomeIcons.sort,
                            size: 15.0,
                            color: kDarkBlue,
                          )
                        : null),
              ),
              maxLines: title == "Ürün Açıklaması" ? 5 : 1,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductInfoRow extends StatelessWidget {
  const ProductInfoRow({
    required this.title,
    required this.info,
    required this.icon,
  });
  final String title;
  final String info;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset(
              icon,
              height: 13.0,
              width: 20.0,
            ),
            SizedBox(
              width: 6.0,
            ),
            Text(
              title,
              style: TextStyle(
                color: kDarkBlue,
                fontWeight: FontWeight.bold,
                fontSize: 13.0,
              ),
            ),
          ],
        ),
        Text(
          info,
          style: TextStyle(
            color: kTextFieldGrey,
            fontWeight: FontWeight.bold,
            fontSize: 13.0,
          ),
        ),
      ],
    );
  }
}
