import 'package:anchor/ProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'FadeRoute.dart';
import 'NotificationHandler.dart';
import 'ShoppingPage.dart';
import 'constants.dart';

class AnchorPage extends StatefulWidget {
  const AnchorPage({Key? key}) : super(key: key);

  @override
  State<AnchorPage> createState() => _AnchorPageState();
}

class _AnchorPageState extends State<AnchorPage> {
  TextEditingController _refCodeController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map>>(
        stream: _firestore
            .collection("Users")
            .doc(_firebaseAuth.currentUser!.uid)
            .snapshots(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: kButtonBlue,
              ),
            );
          }

          return Container(
            height: MediaQuery.of(context).size.height -
                40.0 -
                kBottomNavigationBarHeight,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/anchorPageBg.png"),
                  fit: BoxFit.cover),
            ),
            child: Column(
              children: [
                Container(
                  height: (MediaQuery.of(context).size.height -
                          40.0 -
                          kBottomNavigationBarHeight -
                          24.0) /
                      2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/anchorPageTopIcon.png",
                        height: 45.0,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(
                        "??r??n sat??yorsan??z a??a????daki butona t??klayarak\nal??c??n??za ??zel ilan olu??turabilirsiniz!",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
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
                        child: Text(
                          "G??venli Sat???? Yap??n",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: (MediaQuery.of(context).size.height -
                          40.0 -
                          kBottomNavigationBarHeight -
                          24.0) /
                      2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/anchorPageBottomIcon.png",
                        height: 40.0,
                      ),
                      SizedBox(
                        height: 18.0,
                      ),
                      Text(
                        "E??er al??c??ysan??z hemen a??a????daki buton ile\nal??c??n??n iletti??i referans kodunu girebilir ve\ng??venli al????veri?? yapmaya ba??layabilirsiniz!",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  insetPadding: EdgeInsets.zero,
                                  backgroundColor: Color(0xFF57A1F6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Image.asset(
                                            "assets/images/refCodeDialogDraw.png",
                                            height: 75.0,
                                          ),
                                          SizedBox(
                                            height: 90.0,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 18.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Al????veri??e Kat??l!",
                                                    style: TextStyle(
                                                      color: Color(0xFF474444),
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    "Sat??c??n??n sana iletti??i kodu\na??a????ya girerek al????veri??e\nkat??labilirsin.",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF474444),
                                                        fontSize: 11.0,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0, vertical: 32.0),
                                        child: TextField(
                                          controller: _refCodeController,
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500),
                                          decoration: InputDecoration(
                                            hintStyle:
                                                TextStyle(fontSize: 14.0),
                                            constraints:
                                                BoxConstraints(maxHeight: 35.0),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 4.0,
                                                    horizontal: 12.0),
                                            fillColor: Colors.white,
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                              borderSide: BorderSide(
                                                  color: Color(0xFF707070),
                                                  width: 1.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                              borderSide: BorderSide(
                                                  color: Color(0xFF707070),
                                                  width: 1.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                              borderSide: BorderSide(
                                                  color: Color(0xFF707070),
                                                  width: 1.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      userSnapshot.data!.data()!["address"] ==
                                              ""
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.warning_rounded,
                                                  color: Colors.white,
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
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              FadeRoute(
                                                                page: UserSettings(
                                                                    userInfo: userSnapshot
                                                                        .data!
                                                                        .data()!),
                                                              ),
                                                            );
                                                          },
                                                          child: Text(
                                                            "profil sayfan??z",
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF474444),
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                fontSize: 10.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 2.0,
                                                    ),
                                                    Text(
                                                      "??zerinden doldurmadan i??leminize",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10.0,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    SizedBox(
                                                      height: 2.0,
                                                    ),
                                                    Text(
                                                      "devam edemezsiniz!",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10.0,
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
                                                  MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    _firestore
                                                        .collection("Rooms")
                                                        .where("refCode",
                                                            isEqualTo:
                                                                _refCodeController
                                                                    .text)
                                                        .get()
                                                        .then((value) {
                                                      if (value.size > 0) {
                                                        if (value.docs[0]
                                                                    .data()[
                                                                "seller"] ==
                                                            _firebaseAuth
                                                                .currentUser!
                                                                .uid) {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return Center(
                                                                  child: Wrap(
                                                                    children: [
                                                                      Stack(
                                                                        children: [
                                                                          AlertDialog(
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(15),
                                                                            ),
                                                                            backgroundColor:
                                                                                Color(0xFF6EB0FC),
                                                                            content:
                                                                                Center(
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
                                                                                    "Kendi olu??turdu??unuz ilana al??c?? olamazs??n??z!",
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
                                                                            alignment:
                                                                                Alignment.topCenter,
                                                                            child:
                                                                                Image.asset(
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
                                                              .docs[0].reference
                                                              .update({
                                                            "buyer":
                                                                _firebaseAuth
                                                                    .currentUser!
                                                                    .uid,
                                                            "buyerJoinDate":
                                                                FieldValue
                                                                    .serverTimestamp(),
                                                            "users": FieldValue
                                                                .arrayUnion([
                                                              _firebaseAuth
                                                                  .currentUser!
                                                                  .uid,
                                                            ]),
                                                            "state":
                                                                "??deme bekleniyor",
                                                          }).whenComplete(
                                                                  () async {
                                                            await _firestore
                                                                .collection(
                                                                    "Users")
                                                                .doc(value
                                                                        .docs[0]
                                                                        .data()[
                                                                    "seller"])
                                                                .get()
                                                                .then(
                                                                    (userData) async {
                                                              if (userData
                                                                      .data()![
                                                                  "allowNotifications"]) {
                                                                await NotificationHandler.sendNotification(
                                                                    fcmToken: userData
                                                                            .data()![
                                                                        "fcmToken"],
                                                                    message:
                                                                        "Al??c?? odaya kat??ld??.");
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
                                                        Navigator.pop(context);
                                                      }
                                                    });
                                                  },
                                                  child: Text("Kat??l"),
                                                ),
                                                SizedBox(width: 6.0),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    _refCodeController.clear();
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("??ptal"),
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                                );
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
                            Color(0xFFFE9ECC).withOpacity(0.5),
                          ),
                          minimumSize: MaterialStateProperty.all(Size(220, 45)),
                          backgroundColor: MaterialStateProperty.all(
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
            ),
          );
        });
  }
}
