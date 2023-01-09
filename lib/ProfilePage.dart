import 'dart:io';

import 'package:anchor/constants.dart';
import 'package:anchor/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import 'FadeRoute.dart';
import 'MainPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map>>(
        stream: _firestore
            .collection("Users")
            .doc(_auth.currentUser!.uid)
            .snapshots(),
        builder: (context, userInfoSnapshot) {
          if (!userInfoSnapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      Scaffold.of(context).appBarMaxHeight! -
                      kBottomNavigationBarHeight),
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      userInfoSnapshot.data!.data()!.containsKey("profilePhoto")
                          ? Container(
                              height: 80.0,
                              width: 80.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(userInfoSnapshot.data!
                                      .data()!["profilePhoto"]),
                                  fit: BoxFit.cover,
                                ),
                                color: Colors.white,
                                border:
                                    Border.all(width: 4.0, color: Colors.white),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 15.0,
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              height: 80.0,
                              width: 80.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 15.0,
                                  )
                                ],
                              ),
                              child: Icon(
                                FontAwesomeIcons.userAlt,
                                color: kDarkBlue,
                                size: 32.0,
                              ),
                            ),
                      SizedBox(
                        height: 12.0,
                      ),
                      Text(
                        userInfoSnapshot.data!.data()!["realName"],
                        style: TextStyle(
                          color: kDarkBlue,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        "@${userInfoSnapshot.data!.data()!["name"]}",
                        style: TextStyle(
                          color: Color(0xFFC3C3C3),
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      Image.asset(
                        "assets/images/profileDivider.png",
                        height: 3.0,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 32.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 24.0,
                            top: 16.0,
                            left: 24.0,
                            right: 24.0,
                          ),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    FadeRoute(
                                      page: SettingsPage(
                                          userInfo:
                                              userInfoSnapshot.data!.data()!),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF2F2F2),
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                          ),
                                          height: 40.0,
                                          width: 40.0,
                                          child: Icon(
                                            Icons.settings,
                                            color: kDarkBlue,
                                            size: 24.0,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 14.0,
                                        ),
                                        Text(
                                          "Ayarlar",
                                          style: TextStyle(
                                            color: kDarkBlue,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: kDarkBlue,
                                      size: 20.0,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    FadeRoute(
                                      page: BankInfoPage(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF2F2F2),
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                          ),
                                          height: 40.0,
                                          width: 40.0,
                                          child: Icon(
                                            FontAwesomeIcons.solidCreditCard,
                                            color: kDarkBlue,
                                            size: 16.0,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 14.0,
                                        ),
                                        Text(
                                          "Hesap Bilgileri",
                                          style: TextStyle(
                                            color: kDarkBlue,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: kDarkBlue,
                                      size: 20.0,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    FadeRoute(
                                      page: UserSettings(
                                          userInfo:
                                              userInfoSnapshot.data!.data()!),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF2F2F2),
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                          ),
                                          height: 40.0,
                                          width: 40.0,
                                          child: Icon(
                                            FontAwesomeIcons.userAlt,
                                            color: kDarkBlue,
                                            size: 16.0,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 14.0,
                                        ),
                                        Text(
                                          "Kullanıcı ayarları",
                                          style: TextStyle(
                                            color: kDarkBlue,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: kDarkBlue,
                                      size: 20.0,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Divider(
                                color: Color(0xFFE2E2E2),
                                height: 3.0,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              InkWell(
                                onTap: () {
                                  launch(
                                    "https://www.anchor-mobile.com/post/gizlilik-politikamız",
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF2F2F2),
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                          ),
                                          height: 40.0,
                                          width: 40.0,
                                          child: Icon(
                                            FontAwesomeIcons.solidFileAlt,
                                            color: kDarkBlue,
                                            size: 16.0,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 14.0,
                                        ),
                                        Text(
                                          "Gizlilik Sözleşmesi",
                                          style: TextStyle(
                                            color: kDarkBlue,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: kDarkBlue,
                                      size: 20.0,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              InkWell(
                                onTap: () {
                                  launch(
                                    "https://www.anchor-mobile.com/post/gizlilik-politikamız",
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF2F2F2),
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                          ),
                                          height: 40.0,
                                          width: 40.0,
                                          child: Icon(
                                            FontAwesomeIcons.solidFileAlt,
                                            color: kDarkBlue,
                                            size: 16.0,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 14.0,
                                        ),
                                        Text(
                                          "KVKK Sözleşmesi",
                                          style: TextStyle(
                                            color: kDarkBlue,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: kDarkBlue,
                                      size: 20.0,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Divider(
                                color: Color(0xFFE2E2E2),
                                height: 3.0,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    FadeRoute(
                                      page: MainPage(
                                        initialIndex: 1,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF2F2F2),
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                          ),
                                          height: 40.0,
                                          width: 40.0,
                                          child: Icon(
                                            Icons.help,
                                            color: kDarkBlue,
                                            size: 16.0,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 14.0,
                                        ),
                                        Text(
                                          "Yardım",
                                          style: TextStyle(
                                            color: kDarkBlue,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: kDarkBlue,
                                      size: 20.0,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              InkWell(
                                onTap: () async {
                                  await _auth.signOut().whenComplete(
                                      () => Navigator.pushAndRemoveUntil(
                                          context,
                                          FadeRoute(
                                            page: MyApp(),
                                          ),
                                          (route) => false));
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF2F2F2),
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                          ),
                                          height: 40.0,
                                          width: 40.0,
                                          child: Icon(
                                            FontAwesomeIcons.signOutAlt,
                                            color: kPink,
                                            size: 16.0,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 14.0,
                                        ),
                                        Text(
                                          "Çıkış Yap",
                                          style: TextStyle(
                                            color: kPink,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: kPink,
                                      size: 20.0,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class BankInfoPage extends StatefulWidget {
  @override
  _BankInfoPageState createState() => _BankInfoPageState();
}

class _BankInfoPageState extends State<BankInfoPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(35),
        child: AppBar(
          title: Text(
            "Hesap Bilgileri",
            style: TextStyle(fontSize: 16),
          ),
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
              size: 24,
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  FadeRoute(
                      page: MainPage(
                    initialIndex: 4,
                  )),
                  (route) => false);
            },
          ),
          backgroundColor: kDarkBlue,
          centerTitle: true,
        ),
      ),
      body: StreamBuilder<DocumentSnapshot<Map>>(
          stream: _firestore
              .collection("Users")
              .doc(_auth.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.data()!["iban"] == null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                  ),
                  Image.asset(
                    "assets/images/bankInfoDraw.png",
                    height: MediaQuery.of(context).size.height * 0.45,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Hesap Bilgilerinizi Girin",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3540),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Kazançlarınızı hesabınıza aktarmamız için\nhesap bilgilerinizi giriniz. ",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      color: Color(0xFF2D3540),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 45),
                    child: TextButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        elevation: MaterialStateProperty.all(14),
                        shadowColor: MaterialStateProperty.all(
                            kButtonBlue.withOpacity(0.5)),
                        backgroundColor: MaterialStateProperty.all(kButtonBlue),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          FadeRoute(
                            page: Scaffold(
                              appBar: PreferredSize(
                                preferredSize: Size.fromHeight(35),
                                child: AppBar(
                                  title: Text(
                                    "Ödeme Ayrıntıları",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  leading: GestureDetector(
                                    child: Icon(
                                      Icons.arrow_back_ios_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  backgroundColor: kDarkBlue,
                                  centerTitle: true,
                                ),
                              ),
                              body: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.10,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xFFFD4056)
                                                  .withOpacity(0.2),
                                              spreadRadius: 0,
                                              blurRadius: 6,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                          color: Color(0xFFFDF4F5),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          border: Border.all(
                                            color: Color(0xFFFD4056),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16.0),
                                              child: Image.asset(
                                                "assets/images/warningBankAccount.png",
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              child: Text(
                                                "Lütfen sadece kendi adınıza kayıtlı hesap bilgilerini\ngiriniz. Bilgileri doğru girdiğinizden emin olunuz. ",
                                                style: TextStyle(
                                                    color: Color(0xFF2D3540),
                                                    fontSize: 10.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16.0,
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Ad & Soyad",
                                                  style: TextStyle(
                                                    color: kTextGrey,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                      child: Text(
                                                        snapshot.data!.data()![
                                                            "realName"],
                                                        style: TextStyle(
                                                          color: kTextGrey,
                                                          fontSize: 14,
                                                        ),
                                                        textAlign:
                                                            TextAlign.end,
                                                        softWrap: true,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 18.0,
                                          ),
                                          Divider(
                                            height: 0,
                                            color: Color(0xFFB4B0B0),
                                            thickness: 1,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 16.0,
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Cep Telefonu",
                                                  style: TextStyle(
                                                    color: kTextGrey,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                      child: Text(
                                                        snapshot.data!.data()![
                                                            "phoneNumber"],
                                                        style: TextStyle(
                                                          color: kTextGrey,
                                                          fontSize: 14,
                                                        ),
                                                        textAlign:
                                                            TextAlign.end,
                                                        softWrap: true,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 18.0,
                                          ),
                                          Divider(
                                            height: 0,
                                            color: Color(0xFFB4B0B0),
                                            thickness: 1,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 16.0,
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "IBAN",
                                                  style: TextStyle(
                                                    color: kTextGrey,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    TextEditingController
                                                        _ibanController =
                                                        TextEditingController();
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            content: TextField(
                                                              controller:
                                                                  _ibanController,
                                                              autofocus: true,
                                                              maxLength: 26,
                                                              decoration:
                                                                  InputDecoration(
                                                                hintText:
                                                                    "IBAN",
                                                                border:
                                                                    UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color:
                                                                        kButtonBlue,
                                                                  ),
                                                                ),
                                                                enabledBorder:
                                                                    UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color:
                                                                        kButtonBlue,
                                                                  ),
                                                                ),
                                                                focusedBorder:
                                                                    UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color:
                                                                        kButtonBlue,
                                                                  ),
                                                                ),
                                                              ),
                                                              cursorColor:
                                                                  kButtonBlue,
                                                            ),
                                                            actions: [
                                                              GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  await _firestore
                                                                      .collection(
                                                                          "Users")
                                                                      .doc(_auth
                                                                          .currentUser!
                                                                          .uid)
                                                                      .update({
                                                                    "iban":
                                                                        _ibanController
                                                                            .text,
                                                                  }).whenComplete(
                                                                          () {
                                                                    Navigator.pushAndRemoveUntil(
                                                                        context,
                                                                        FadeRoute(
                                                                          page:
                                                                              BankInfoPage(),
                                                                        ),
                                                                        (route) => false);
                                                                  });
                                                                },
                                                                child: Text(
                                                                  "TAMAM",
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        kButtonBlue,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Icon(
                                                        FontAwesomeIcons
                                                            .solidEdit,
                                                        color: kDarkBlue,
                                                        size: 14.0,
                                                      ),
                                                      SizedBox(
                                                        width: 4.0,
                                                      ),
                                                      Text(
                                                        "Ekleyin",
                                                        style: TextStyle(
                                                          color: kDarkBlue,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 18.0,
                                          ),
                                          Divider(
                                            height: 0,
                                            color: Color(0xFFB4B0B0),
                                            thickness: 1,
                                          ),
                                          SizedBox(
                                            height: 18.0,
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Adres Bilgisi",
                                              style: TextStyle(
                                                color: kTextGrey,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.55,
                                                  child: Text(
                                                    snapshot.data!
                                                        .data()!["address"],
                                                    style: TextStyle(
                                                      color: kTextGrey,
                                                      fontSize: 14,
                                                    ),
                                                    textAlign: TextAlign.end,
                                                    softWrap: true,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'HESAP BİLGİLERİNİZİ GİRİN',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              );
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.10,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFD4056).withOpacity(0.2),
                              spreadRadius: 0,
                              blurRadius: 6,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          color: Color(0xFFFDF4F5),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          border: Border.all(
                            color: Color(0xFFFD4056),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Image.asset(
                                "assets/images/warningBankAccount.png",
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                "Lütfen sadece kendi adınıza kayıtlı hesap bilgilerini\ngiriniz. Bilgileri doğru girdiğinizden emin olunuz. ",
                                style: TextStyle(
                                    color: Color(0xFF2D3540), fontSize: 10.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Ad & Soyad",
                                  style: TextStyle(
                                    color: kTextGrey,
                                    fontSize: 14,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Text(
                                        snapshot.data!.data()!["realName"],
                                        style: TextStyle(
                                          color: kTextGrey,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.end,
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 18.0,
                          ),
                          Divider(
                            height: 0,
                            color: Color(0xFFB4B0B0),
                            thickness: 1,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "T.C. Kimlik No",
                                  style: TextStyle(
                                    color: kTextGrey,
                                    fontSize: 14,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Text(
                                        snapshot.data!.data()!["idNo"],
                                        style: TextStyle(
                                          color: kTextGrey,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.end,
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 18.0,
                          ),
                          Divider(
                            height: 0,
                            color: Color(0xFFB4B0B0),
                            thickness: 1,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Cep Telefonu",
                                  style: TextStyle(
                                    color: kTextGrey,
                                    fontSize: 14,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Text(
                                        snapshot.data!.data()!["phoneNumber"],
                                        style: TextStyle(
                                          color: kTextGrey,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.end,
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 18.0,
                          ),
                          Divider(
                            height: 0,
                            color: Color(0xFFB4B0B0),
                            thickness: 1,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "IBAN",
                                  style: TextStyle(
                                    color: kTextGrey,
                                    fontSize: 14,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Text(
                                        snapshot.data!.data()!["iban"],
                                        style: TextStyle(
                                          color: kDarkBlue,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.end,
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 18.0,
                          ),
                          Divider(
                            height: 0,
                            color: Color(0xFFB4B0B0),
                            thickness: 1,
                          ),
                          SizedBox(
                            height: 18.0,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Adres Bilgisi",
                              style: TextStyle(
                                color: kTextGrey,
                                fontSize: 14,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.55,
                                  child: Text(
                                    snapshot.data!.data()!["address"],
                                    style: TextStyle(
                                      color: kTextGrey,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.end,
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 45),
                      child: TextButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          elevation: MaterialStateProperty.all(14),
                          shadowColor: MaterialStateProperty.all(
                              kButtonBlue.withOpacity(0.5)),
                          backgroundColor:
                              MaterialStateProperty.all(kButtonBlue),
                        ),
                        onPressed: () {
                          TextEditingController _ibanController =
                              TextEditingController();
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: TextField(
                                    controller: _ibanController,
                                    autofocus: true,
                                    maxLength: 26,
                                    decoration: InputDecoration(
                                      hintText: "IBAN",
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: kButtonBlue,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: kButtonBlue,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: kButtonBlue,
                                        ),
                                      ),
                                    ),
                                    cursorColor: kButtonBlue,
                                  ),
                                  actions: [
                                    GestureDetector(
                                      onTap: () async {
                                        await _firestore
                                            .collection("Users")
                                            .doc(_auth.currentUser!.uid)
                                            .update({
                                          "iban": _ibanController.text,
                                        }).whenComplete(() {
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: Text(
                                        "TAMAM",
                                        style: TextStyle(
                                          color: kButtonBlue,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Text(
                          'DÜZENLE',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key, required this.userInfo}) : super(key: key);
  final Map userInfo;

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  late TextEditingController _realNameController;
  late TextEditingController _userNameController;
  late TextEditingController _phoneController;
  late TextEditingController _mailController;
  late TextEditingController _addressController;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordAgainController = TextEditingController();
  String newImagePath = "";
  ImagePicker _picker = ImagePicker();
  pickImage(ImageSource source) async {
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
          newImagePath = value.path;
        });
        Navigator.pop(context);
      }
    });
  }

  @override
  void initState() {
    _realNameController =
        TextEditingController(text: widget.userInfo["realName"]);
    _userNameController = TextEditingController(text: widget.userInfo["name"]);
    _phoneController =
        TextEditingController(text: widget.userInfo["phoneNumber"]);
    _mailController = TextEditingController(text: widget.userInfo["mail"]);
    _addressController =
        TextEditingController(text: widget.userInfo["address"]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(35),
        child: AppBar(
          title: Text(
            "Kullanıcı Ayarları",
            style: TextStyle(fontSize: 16),
          ),
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
              size: 24,
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  FadeRoute(
                      page: MainPage(
                    initialIndex: 4,
                  )),
                  (route) => false);
            },
          ),
          backgroundColor: kDarkBlue,
          centerTitle: true,
        ),
      ),
      backgroundColor: kLightBlueBg,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<DocumentSnapshot<Map>>(
            stream: _firestore
                .collection("Users")
                .doc(_auth.currentUser!.uid)
                .snapshots(),
            builder: (context, userInfo) {
              if (!userInfo.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                              pickImage(ImageSource.camera);
                                            },
                                            title: Text(
                                              "Kamera",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          ListTile(
                                            onTap: () {
                                              pickImage(ImageSource.gallery);
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
                            child: Container(
                              height: 80,
                              width: 80,
                              child: newImagePath != ""
                                  ? Stack(
                                      children: [
                                        Container(
                                          height: 80.0,
                                          width: 80.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image:
                                                  FileImage(File(newImagePath)),
                                            ),
                                            color: Colors.white,
                                            border: Border.all(
                                                width: 4.0,
                                                color: Colors.white),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 15.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8.0,
                                            ),
                                            child: Container(
                                              height: 20.0,
                                              width: 20.0,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 4.0,
                                                  ),
                                                ],
                                              ),
                                              child: Icon(
                                                FontAwesomeIcons.pen,
                                                color: kDarkBlue,
                                                size: 11.0,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  : widget.userInfo.containsKey("profilePhoto")
                                      ? Stack(
                                          children: [
                                            Container(
                                              height: 80.0,
                                              width: 80.0,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        widget.userInfo[
                                                            "profilePhoto"]),
                                                    fit: BoxFit.cover),
                                                color: Colors.white,
                                                border: Border.all(
                                                    width: 4.0,
                                                    color: Colors.white),
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 15.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                ),
                                                child: Container(
                                                  height: 20.0,
                                                  width: 20.0,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black12,
                                                        blurRadius: 4.0,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Icon(
                                                    FontAwesomeIcons.pen,
                                                    color: kDarkBlue,
                                                    size: 11.0,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      : Stack(
                                          children: [
                                            Container(
                                              height: 80.0,
                                              width: 80.0,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 15.0,
                                                  )
                                                ],
                                              ),
                                              child: Icon(
                                                FontAwesomeIcons.userAlt,
                                                color: kDarkBlue,
                                                size: 32.0,
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                ),
                                                child: Container(
                                                  height: 20.0,
                                                  width: 20.0,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black12,
                                                        blurRadius: 4.0,
                                                      ),
                                                    ],
                                                  ),
                                                  child: Icon(
                                                    FontAwesomeIcons.pen,
                                                    color: kDarkBlue,
                                                    size: 11.0,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                            ),
                          ),
                          SizedBox(
                            height: 32.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 32.0,
                            child: Text(
                              "İsim Soyisim",
                              style: TextStyle(
                                color: kDarkBlue,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Material(
                            shadowColor: Color(0xFF234E70).withOpacity(0.2),
                            elevation: 3.0,
                            borderRadius: BorderRadius.circular(8.0),
                            child: TextField(
                              controller: _realNameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                fillColor: Colors.white,
                                focusColor: Color(0xFF89AEFB),
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 14.0,
                                  horizontal: 12.0,
                                ),
                              ),
                              keyboardType: TextInputType.name,
                              style: TextStyle(
                                color: kTextFieldGrey,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 32.0,
                            child: Text(
                              "Adres",
                              style: TextStyle(
                                color: kDarkBlue,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Material(
                            shadowColor: Color(0xFF234E70).withOpacity(0.2),
                            elevation: 3.0,
                            borderRadius: BorderRadius.circular(8.0),
                            child: TextField(
                              controller: _addressController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                fillColor: Colors.white,
                                focusColor: Color(0xFF89AEFB),
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 14.0,
                                  horizontal: 12.0,
                                ),
                              ),
                              keyboardType: TextInputType.streetAddress,
                              style: TextStyle(
                                color: kTextFieldGrey,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 32.0,
                            child: Text(
                              "Kullanıcı Adı",
                              style: TextStyle(
                                color: kDarkBlue,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Material(
                            shadowColor: Color(0xFF234E70).withOpacity(0.2),
                            elevation: 3.0,
                            borderRadius: BorderRadius.circular(8.0),
                            child: TextField(
                              controller: _userNameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                fillColor: Colors.white,
                                focusColor: Color(0xFF89AEFB),
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 14.0,
                                  horizontal: 12.0,
                                ),
                              ),
                              keyboardType: TextInputType.name,
                              style: TextStyle(
                                color: kTextFieldGrey,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 32.0,
                            child: Text(
                              "Telefon",
                              style: TextStyle(
                                color: kDarkBlue,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Material(
                            shadowColor: Color(0xFF234E70).withOpacity(0.2),
                            elevation: 3.0,
                            borderRadius: BorderRadius.circular(8.0),
                            child: TextField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                fillColor: Colors.white,
                                focusColor: Color(0xFF89AEFB),
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 14.0,
                                  horizontal: 12.0,
                                ),
                              ),
                              keyboardType: TextInputType.name,
                              style: TextStyle(
                                color: kTextFieldGrey,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 32.0,
                            child: Text(
                              "E-mail Adresi",
                              style: TextStyle(
                                color: kDarkBlue,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Material(
                            shadowColor: Color(0xFF234E70).withOpacity(0.2),
                            elevation: 3.0,
                            borderRadius: BorderRadius.circular(8.0),
                            child: TextField(
                              controller: _mailController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                fillColor: Colors.white,
                                focusColor: Color(0xFF89AEFB),
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 14.0,
                                  horizontal: 12.0,
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                color: kTextFieldGrey,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 32.0,
                            child: Text(
                              "Yeni Şifre",
                              style: TextStyle(
                                color: kDarkBlue,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Material(
                            shadowColor: Color(0xFF234E70).withOpacity(0.2),
                            elevation: 3.0,
                            borderRadius: BorderRadius.circular(8.0),
                            child: TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                fillColor: Colors.white,
                                focusColor: Color(0xFF89AEFB),
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 14.0,
                                  horizontal: 12.0,
                                ),
                              ),
                              keyboardType: TextInputType.name,
                              obscureText: true,
                              style: TextStyle(
                                color: kTextFieldGrey,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 32.0,
                            child: Text(
                              "Şifreyi Tekrarla",
                              style: TextStyle(
                                color: kDarkBlue,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Material(
                            shadowColor: Color(0xFF234E70).withOpacity(0.2),
                            elevation: 3.0,
                            borderRadius: BorderRadius.circular(8.0),
                            child: TextField(
                              controller: _passwordAgainController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                fillColor: Colors.white,
                                focusColor: Color(0xFF89AEFB),
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 14.0,
                                  horizontal: 12.0,
                                ),
                              ),
                              keyboardType: TextInputType.name,
                              obscureText: true,
                              style: TextStyle(
                                color: kTextFieldGrey,
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints.tightFor(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 45),
                          child: TextButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              elevation: MaterialStateProperty.all(14),
                              shadowColor: MaterialStateProperty.all(
                                  kButtonBlue.withOpacity(0.5)),
                              backgroundColor:
                                  MaterialStateProperty.all(kButtonBlue),
                            ),
                            onPressed: () async {
                              if (newImagePath != "") {
                                String fileName = "pp" +
                                    _auth.currentUser!.uid +
                                    DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString();
                                await FirebaseStorage.instance
                                    .ref(
                                        "profiles/${_auth.currentUser!.uid}/$fileName}")
                                    .putFile(
                                      File(newImagePath),
                                    )
                                    .then((taskSnapshot) async {
                                  await taskSnapshot.ref
                                      .getDownloadURL()
                                      .then((url) async {
                                    await _firestore
                                        .collection("Users")
                                        .doc(_auth.currentUser!.uid)
                                        .update({"profilePhoto": url});
                                  });
                                });
                              }
                              await FirebaseFirestore.instance
                                  .collection("Users")
                                  .where("phoneNumber",
                                      isEqualTo: _phoneController.text)
                                  .get()
                                  .then((phoneValue) async {
                                if (_phoneController.text !=
                                        widget.userInfo["phoneNumber"] &&
                                    phoneValue.size > 0) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                              'Bu telefon numarası zaten kullanılıyor. Lütfen başka bir tane seçin.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Tamam'),
                                            ),
                                          ],
                                        );
                                      });
                                } else {
                                  if (_phoneController.text != '' &&
                                      _phoneController.text.isNotEmpty &&
                                      _phoneController.text.trim().isNotEmpty) {
                                    if (_phoneController.text.substring(0, 1) ==
                                        '5') {
                                      _phoneController.text =
                                          '+90' + _phoneController.text;
                                    } else if (_phoneController.text
                                            .substring(0, 1) ==
                                        '0') {
                                      _phoneController.text =
                                          '+9' + _phoneController.text;
                                    } else if (_phoneController.text
                                            .substring(0, 1) ==
                                        '9') {
                                      _phoneController.text =
                                          '+' + _phoneController.text;
                                    }
                                    if (_phoneController.text.length != 13) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                  'Lütfen Geçerli Bir Telefon Numarası Girin'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Tamam'),
                                                ),
                                              ],
                                            );
                                          });
                                    } else if (_phoneController.text
                                            .substring(0, 4) !=
                                        '+905') {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                  'Lütfen Geçerli Bir Telefon Numarası Girin'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Tamam'),
                                                ),
                                              ],
                                            );
                                          });
                                    } else {
                                      if (_userNameController.text.isEmpty ||
                                          _userNameController.text == "" ||
                                          _userNameController.text
                                              .trim()
                                              .isEmpty) {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                    'Lütfen Geçerli Bir Kullanıcı Adı Girin'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Tamam'),
                                                  ),
                                                ],
                                              );
                                            });
                                      } else {
                                        if (_mailController.text.isEmpty ||
                                            _mailController.text == "" ||
                                            _mailController.text
                                                .trim()
                                                .isEmpty ||
                                            !_mailController.text
                                                .contains("@")) {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      'Lütfen Geçerli Bir Mail Adresi Girin'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Tamam'),
                                                    ),
                                                  ],
                                                );
                                              });
                                        } else {
                                          await FirebaseFirestore.instance
                                              .collection("Users")
                                              .where("name",
                                                  isEqualTo:
                                                      _userNameController.text)
                                              .get()
                                              .then((value) async {
                                            if (_userNameController.text !=
                                                    widget.userInfo["name"] &&
                                                value.size > 0) {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Bu kullanıcı adı zaten kullanılıyor. Lütfen başka bir tane seçin.'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text('Tamam'),
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            } else {
                                              await FirebaseFirestore.instance
                                                  .collection("Users")
                                                  .where("mail",
                                                      isEqualTo:
                                                          _mailController.text)
                                                  .get()
                                                  .then((mailValue) async {
                                                if (_mailController.text !=
                                                        widget
                                                            .userInfo["mail"] &&
                                                    mailValue.size > 0) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Bu mail adresi zaten kullanılıyor. Lütfen başka bir tane seçin.'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child:
                                                                  Text('Tamam'),
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                } else {
                                                  if (_userNameController
                                                              .text.length <
                                                          3 ||
                                                      _userNameController
                                                              .text.length >
                                                          20) {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                'Kullanıcı adınız 3 karakterden kısa ya da 20 karakterden uzun olamaz.'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                    'Tamam'),
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  } else {
                                                    if (_addressController
                                                        .text.isEmpty) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Lütfen geçerli bir adres girin.'),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      'Tamam'),
                                                                ),
                                                              ],
                                                            );
                                                          });
                                                    } else {
                                                      if (_passwordController
                                                          .text.isEmpty) {
                                                        await _firestore
                                                            .collection("Users")
                                                            .doc(_auth
                                                                .currentUser!
                                                                .uid)
                                                            .update({
                                                          "realName":
                                                              _realNameController
                                                                  .text,
                                                          "name":
                                                              _userNameController
                                                                  .text,
                                                          "mail":
                                                              _mailController
                                                                  .text,
                                                          "address":
                                                              _addressController
                                                                  .text,
                                                        });
                                                        if (_phoneController
                                                                .text !=
                                                            widget.userInfo[
                                                                "phoneNumber"]) {
                                                          await verifyUser(
                                                            phoneNumber:
                                                                _phoneController
                                                                    .text,
                                                            context: context,
                                                            isLogIn: true,
                                                            mail: "",
                                                            name: "",
                                                            realName: "",
                                                            isUpdate: true,
                                                            password: "",
                                                          );
                                                        } else {
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      } else {
                                                        if (_passwordController
                                                                .text.length <
                                                            3) {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                      'Şifreniz 3 karakterden kısa olamaz.'),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: Text(
                                                                          'Tamam'),
                                                                    ),
                                                                  ],
                                                                );
                                                              });
                                                        } else {
                                                          if (_passwordController
                                                                  .text
                                                                  .isEmpty ||
                                                              _passwordController
                                                                      .text ==
                                                                  "" ||
                                                              _passwordController
                                                                  .text
                                                                  .trim()
                                                                  .isEmpty) {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        'Lütfen Geçerli Bir Şifre Girin'),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: Text(
                                                                            'Tamam'),
                                                                      ),
                                                                    ],
                                                                  );
                                                                });
                                                          } else {
                                                            if (_passwordController
                                                                    .text ==
                                                                _passwordAgainController
                                                                    .text) {
                                                              await _firestore
                                                                  .collection(
                                                                      "Users")
                                                                  .doc(_auth
                                                                      .currentUser!
                                                                      .uid)
                                                                  .update({
                                                                "realName":
                                                                    _realNameController
                                                                        .text,
                                                                "name":
                                                                    _userNameController
                                                                        .text,
                                                                "mail":
                                                                    _mailController
                                                                        .text,
                                                                "password":
                                                                    _passwordController
                                                                        .text,
                                                                "address":
                                                                    _addressController
                                                                        .text,
                                                              });
                                                              if (_phoneController
                                                                      .text !=
                                                                  widget.userInfo[
                                                                      "phoneNumber"]) {
                                                                await verifyUser(
                                                                  phoneNumber:
                                                                      _phoneController
                                                                          .text,
                                                                  context:
                                                                      context,
                                                                  isLogIn: true,
                                                                  mail: "",
                                                                  name: "",
                                                                  realName: "",
                                                                  isUpdate:
                                                                      true,
                                                                  password: "",
                                                                );
                                                              } else {
                                                                Navigator.pop(
                                                                    context);
                                                              }
                                                            } else {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      title: Text(
                                                                          'Girmiş olduğunuz şifreler aynı değil.'),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Text('Tamam'),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  });
                                                            }
                                                          }
                                                        }
                                                      }
                                                    }
                                                  }
                                                }
                                              });
                                            }
                                          });
                                        }
                                      }
                                    }
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                                'Lütfen Geçerli Bir Telefon Numarası Girin'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Tamam'),
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                }
                              });
                            },
                            child: Text(
                              'Güncelle',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required this.userInfo}) : super(key: key);
  final Map userInfo;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool allowNotifications;
  @override
  void initState() {
    allowNotifications = widget.userInfo["allowNotifications"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(35),
        child: AppBar(
          title: Text(
            "Ayarlar",
            style: TextStyle(fontSize: 16),
          ),
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
              size: 24,
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  FadeRoute(
                      page: MainPage(
                    initialIndex: 4,
                  )),
                  (route) => false);
            },
          ),
          backgroundColor: kDarkBlue,
          centerTitle: true,
        ),
      ),
      backgroundColor: kLightBlueBg,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Bildirimler",
              style: TextStyle(
                color: kDarkBlue,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            Switch(
              value: allowNotifications,
              activeColor: kButtonBlue,
              onChanged: (b) async {
                setState(() {
                  allowNotifications = !allowNotifications;
                });
                await FirebaseFirestore.instance
                    .collection("Users")
                    .doc(widget.userInfo["uid"])
                    .update(
                  {"allowNotifications": allowNotifications},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
