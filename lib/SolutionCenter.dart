import 'package:anchor/FadeRoute.dart';
import 'package:anchor/MainPage.dart';
import 'package:anchor/NotificationHandler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'constants.dart';

class SolutionCenter extends StatefulWidget {
  const SolutionCenter({Key? key}) : super(key: key);

  @override
  _SolutionCenterState createState() => _SolutionCenterState();
}

class _SolutionCenterState extends State<SolutionCenter> {
  int tabIndex = 0;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: (MediaQuery.of(context).size.width - 310) / 2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 42.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Column(
                      children: [
                        Text(
                          "Çözüm Merkezine\nHoş Geldiniz!",
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
                        Container(
                          width: 180.0,
                          child: Text(
                            "İşlem yapmak istediğiniz alışverişi seçin veya Çözüm Merkezi’ne gönderdiğiniz işlemlere göz atın.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                              color: kTextFieldGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    "assets/images/solutionCenterDraw.png",
                    width: 110.0,
                  ),
                ],
              ),
            ),
            Image.asset(
              "assets/images/solutionCenterUpper.png",
              width: (MediaQuery.of(context).size.width - 270) / 2,
            ),
          ],
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30.0),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(
                        color: Color(0xFFE2E2E2),
                        width: 1.0,
                      ),
                    ),
                    height: 45.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                MediaQuery.of(context).size.width * 0.5 - 26.0,
                            height: 45.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: tabIndex == 0 ? kButtonBlue : Colors.white,
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Text(
                              "Sorun Bildir",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 10.0,
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
                                MediaQuery.of(context).size.width * 0.5 - 26.0,
                            height: 45.0,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: tabIndex == 1 ? kButtonBlue : Colors.white,
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Text(
                              "Çözüm Merkezindeki İşlemler",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 10.0,
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
                Container(
                  height: MediaQuery.of(context).size.height - 407.0,
                  child: StreamBuilder<QuerySnapshot<Map>>(
                      stream: _firestore
                          .collection("Rooms")
                          .where("users",
                              arrayContains: _firebaseAuth.currentUser!.uid)
                          .snapshots(),
                      builder: (context, allRooms) {
                        if (!allRooms.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (allRooms.data!.size == 0) {}
                        List<Map>? itemList;
                        allRooms.data!.docs.forEach((element) {
                          if (tabIndex == 1 &&
                              element.data().containsKey("problemState")) {
                            itemList = [];
                            itemList!.add(element.data());
                          } else if (tabIndex == 0 &&
                              !element.data().containsKey("problemState")) {
                            itemList = [];
                            itemList!.add(element.data());
                          }
                        });
                        if (itemList == null && tabIndex == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 32.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Çözüm Merkezine iletebileceğiniz\nherhangi bir işleminiz\nbulunmuyor!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    height: 1.1,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFB1B1B1),
                                  ),
                                ),
                                SizedBox(
                                  height: 16.0,
                                ),
                                Text(
                                  "Çözüm Merkezine işlem iletmek için\naktif bir alış-satış işleminiz olması ve ilgili işlem ile\nalakalı mevcut bir talebinizin bulunmaması\ngerekmektedir.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    height: 1.2,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFB1B1B1),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        if (itemList == null && tabIndex == 1) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 32.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Çözüm Merkezinde\nherhangi bir işleminiz\nbulunmuyor.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    height: 1.1,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFB1B1B1),
                                  ),
                                ),
                                SizedBox(
                                  height: 16.0,
                                ),
                                Text(
                                  "Çözüm Merkezine işlem göndermek için\nSorun Bildir kısmından ilgili alışverişi seçerek işlemi\ngerçekleştirebilirsiniz",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    height: 1.2,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFB1B1B1),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                            itemCount: itemList!.length,
                            itemBuilder: (context, index) {
                              bool isBuyer = itemList![index]["buyer"] ==
                                  _firebaseAuth.currentUser!.uid;
                              if (itemList![index]["buyer"] == "") {
                                return Container();
                              }
                              return StreamBuilder<DocumentSnapshot<Map>>(
                                  stream: _firestore
                                      .collection("Users")
                                      .doc(isBuyer
                                          ? itemList![index]["seller"]
                                          : itemList![index]["buyer"])
                                      .snapshots(),
                                  builder: (context, otherUserSnapshot) {
                                    if (!otherUserSnapshot.hasData) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                        vertical: 6.0,
                                      ),
                                      child: GestureDetector(
                                        onTap: tabIndex == 0
                                            ? () {
                                                TextEditingController
                                                    _problemController =
                                                    TextEditingController();
                                                String? selected;

                                                showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled: true,
                                                    builder: (context) {
                                                      return StatefulBuilder(
                                                          builder: (context,
                                                              setState) {
                                                        return Container(
                                                          color:
                                                              Color(0xFF757575),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .vertical(
                                                                  top: Radius
                                                                      .circular(
                                                                          20.0),
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  vertical:
                                                                      16.0,
                                                                  horizontal:
                                                                      16.0,
                                                                ),
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Container(
                                                                      width:
                                                                          50.0,
                                                                      height:
                                                                          3.0,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color:
                                                                            kDarkBlue,
                                                                        borderRadius:
                                                                            BorderRadius.circular(10.0),
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
                                                                        color:
                                                                            kDarkBlue,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        fontSize:
                                                                            16.0,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          16.0,
                                                                    ),
                                                                    isBuyer
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
                                                                          EdgeInsets
                                                                              .only(
                                                                        bottom: MediaQuery.of(context)
                                                                            .viewInsets
                                                                            .bottom,
                                                                      ),
                                                                      child:
                                                                          TextField(
                                                                        controller:
                                                                            _problemController,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          hintText:
                                                                              "Yorumunuz",
                                                                          border:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Color(0xFF8C95A1),
                                                                              width: 0.5,
                                                                            ),
                                                                          ),
                                                                          focusedBorder:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Color(0xFF8C95A1),
                                                                              width: 0.5,
                                                                            ),
                                                                          ),
                                                                          enabledBorder:
                                                                              OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                            borderSide:
                                                                                BorderSide(
                                                                              color: Color(0xFF8C95A1),
                                                                              width: 0.5,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        maxLines:
                                                                            3,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          2.0,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      children: [
                                                                        ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          style:
                                                                              ButtonStyle(
                                                                            shape:
                                                                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                              RoundedRectangleBorder(
                                                                                side: BorderSide(
                                                                                  color: kButtonBlue,
                                                                                  width: 1.5,
                                                                                ),
                                                                                borderRadius: BorderRadius.circular(32.0),
                                                                              ),
                                                                            ),
                                                                            minimumSize:
                                                                                MaterialStateProperty.all(Size(140, 40)),
                                                                            backgroundColor:
                                                                                MaterialStateProperty.all(
                                                                              Colors.white,
                                                                            ),
                                                                            elevation:
                                                                                MaterialStateProperty.all(0),
                                                                          ),
                                                                          child:
                                                                              Text(
                                                                            "VAZGEÇ",
                                                                            style:
                                                                                TextStyle(
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
                                                                                  _writeBatch.update(_firestore.collection("Rooms").doc(itemList![index]["roomDocID"]), {
                                                                                    "problem": selected,
                                                                                    "problemDetail": _problemController.text,
                                                                                    "problemDate": FieldValue.serverTimestamp(),
                                                                                    "problemState": "Çözüm Merkezine İletildi.",
                                                                                    "isReported": true,
                                                                                  });
                                                                                  _writeBatch.set(_firestore.collection("Rooms").doc(itemList![index]["roomDocID"]).collection("ProblemMessages").doc(), {
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
                                                                          style:
                                                                              ButtonStyle(
                                                                            shape:
                                                                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                              RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(32.0),
                                                                              ),
                                                                            ),
                                                                            shadowColor:
                                                                                MaterialStateProperty.all(
                                                                              kButtonBlue.withOpacity(0.4),
                                                                            ),
                                                                            minimumSize:
                                                                                MaterialStateProperty.all(Size(140, 40)),
                                                                            backgroundColor:
                                                                                MaterialStateProperty.all(
                                                                              kButtonBlue,
                                                                            ),
                                                                            elevation:
                                                                                MaterialStateProperty.all(20),
                                                                          ),
                                                                          child:
                                                                              Text(
                                                                            "GÖNDER",
                                                                            style:
                                                                                TextStyle(
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
                                              }
                                            : () {
                                                Navigator.push(
                                                  context,
                                                  FadeRoute(
                                                    page: ItemSolutionPage(
                                                      item: itemList![index],
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: Container(
                                                    height: 80,
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                            itemList![index][
                                                                "imageURLs"][0],
                                                          ),
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Color(
                                                                    0xFF234E70)
                                                                .withOpacity(
                                                                    0.1),
                                                            blurRadius: 4.0,
                                                          ),
                                                        ]),
                                                  ),
                                                ),
                                                Container(
                                                  height: 80.0,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            136.0,
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: Text(
                                                          tabIndex == 0
                                                              ? ((itemList![index]["date"].toDate().day < 10 ? "0" : "") +
                                                                  itemList![index]["date"]
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  "/" +
                                                                  (itemList![index]["date"]
                                                                              .toDate()
                                                                              .month <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  itemList![index]["date"]
                                                                      .toDate()
                                                                      .month
                                                                      .toString() +
                                                                  "/" +
                                                                  itemList![index][
                                                                          "date"]
                                                                      .toDate()
                                                                      .year
                                                                      .toString())
                                                              : ((itemList![index]["problemDate"].toDate().day < 10 ? "0" : "") +
                                                                  itemList![index][
                                                                          "problemDate"]
                                                                      .toDate()
                                                                      .day
                                                                      .toString() +
                                                                  "/" +
                                                                  (itemList![index]["problemDate"]
                                                                              .toDate()
                                                                              .month <
                                                                          10
                                                                      ? "0"
                                                                      : "") +
                                                                  itemList![index][
                                                                          "problemDate"]
                                                                      .toDate()
                                                                      .month
                                                                      .toString() +
                                                                  "/" +
                                                                  itemList![index]
                                                                          ["problemDate"]
                                                                      .toDate()
                                                                      .year
                                                                      .toString()),
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            color: Color(
                                                                0xFF818181),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          textAlign:
                                                              TextAlign.end,
                                                        ),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            136.0,
                                                        child: Text(
                                                          itemList![index]
                                                              ["productName"],
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            color: kDarkBlue,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        itemList![index][
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
                                                        itemList![index][
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
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            136.0,
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        2.0),
                                                            color: tabIndex == 0
                                                                ? (itemList![index]["state"] ==
                                                                        "Alıcı Bekleniyor"
                                                                    ? Colors
                                                                        .white
                                                                    : (itemList![index]["state"] ==
                                                                            "Ödeme bekleniyor"
                                                                        ? Color(
                                                                            0xFFF9F5EB)
                                                                        : (itemList![index]["state"] == "Kargo bekleniyor" || itemList![index]["state"] == "Onay bekleniyor"
                                                                            ? Color(
                                                                                0xFFF9F5EB)
                                                                            : (itemList![index]["state"] == "Tamamlandı"
                                                                                ? Color(
                                                                                    0xFFEBF9F4)
                                                                                : Color(
                                                                                    0xFFFEF3F7)))))
                                                                : (itemList![index]["problemState"] ==
                                                                        "Çözüm Merkezine İletildi."
                                                                    ? Color(
                                                                        0xFFFEF3F7)
                                                                    : (itemList![index]["problemState"] ==
                                                                            "Bildiriminiz inceleniyor."
                                                                        ? Color(0xFFF9F5EB)
                                                                        : Color(0xFFEBF9F4))),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Text(
                                                              tabIndex == 0
                                                                  ? (itemList![index]
                                                                              [
                                                                              "state"] ==
                                                                          "Alıcı Bekleniyor"
                                                                      ? ""
                                                                      : (itemList![index]["state"] ==
                                                                              "Ödeme bekleniyor"
                                                                          ? "Alıcı Ödemesi Bekleniyor"
                                                                          : (itemList![index]["state"] == "Kargo bekleniyor" || itemList![index]["state"] == "Onay bekleniyor"
                                                                              ? "Kargo ve Onay Aşamasında"
                                                                              : (itemList![index]["state"] == "Tamamlandı"
                                                                                  ? "Alışveriş Tamamlandı"
                                                                                  : "İptal Oldu"))))
                                                                  : itemList![
                                                                          index]
                                                                      [
                                                                      "problemState"],
                                                              style: TextStyle(
                                                                fontSize: 11,
                                                                color: tabIndex ==
                                                                        0
                                                                    ? itemList![index]["state"] ==
                                                                            "Alıcı Bekleniyor"
                                                                        ? Color(
                                                                            0xFFFFA841)
                                                                        : (itemList![index]["state"] ==
                                                                                "Ödeme bekleniyor"
                                                                            ? Color(
                                                                                0xFFFFA841)
                                                                            : (itemList![index]["state"] == "Kargo bekleniyor" || itemList![index]["state"] == "Onay bekleniyor"
                                                                                ? Color(
                                                                                    0xFFFFA841)
                                                                                : (itemList![index]["state"] == "Tamamlandı"
                                                                                    ? Color(
                                                                                        0xFF6CB49B)
                                                                                    : Color(
                                                                                        0xFFDE6792))))
                                                                    : (itemList![index]["problemState"] ==
                                                                            "Çözüm Merkezine İletildi."
                                                                        ? Color(
                                                                            0xFFDE6792)
                                                                        : (itemList![index]["problemState"] ==
                                                                                "Bildiriminiz inceleniyor."
                                                                            ? Color(0xFFFFA841)
                                                                            : Color(0xFF6CB49B))),
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
                                    );
                                  });
                            });
                      }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ItemSolutionPage extends StatefulWidget {
  const ItemSolutionPage({Key? key, required this.item}) : super(key: key);
  final Map item;
  @override
  State<ItemSolutionPage> createState() => _ItemSolutionPageState();
}

class _ItemSolutionPageState extends State<ItemSolutionPage> {
  Color gray = Color(0xFFE2E2E2);
  Color textGray = Color(0xFF818181);
  Color orange = Color(0xFFFFA841);
  Color green = Color(0xFF139874);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
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
      ),
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
                      "assets/images/navBarUnselectedListing.png",
                      height: 25.0,
                    ),
                    Text(
                      "Alışverişlerim",
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
                      "assets/images/navBarSelectedSolution.png",
                      height: 25.0,
                    ),
                    Text(
                      "Çözüm Merkezi",
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
      backgroundColor: kLightBlueBg,
      appBar: PreferredSize(
        preferredSize: Size(
          MediaQuery.of(context).size.width,
          40.0,
        ),
        child: AppBar(
          backgroundColor: kDarkBlue,
          centerTitle: true,
          title: Text("Çözüm Merkezi"),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.0),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF234E70).withOpacity(0.2),
                          blurRadius: 8.0,
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        widget.item["imageURLs"][0],
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color(0xFF234E70).withOpacity(0.1),
                                        blurRadius: 4.0,
                                      ),
                                    ]),
                              ),
                            ),
                            Container(
                              height: 80.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width -
                                        136.0,
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      "${widget.item["problemDate"].toDate().day} ${months[widget.item["problemDate"].toDate().month - 1]} ${widget.item["problemDate"].toDate().year}, ${widget.item["problemDate"].toDate().hour < 10 ? "0" : ""}${widget.item["problemDate"].toDate().hour}:${widget.item["problemDate"].toDate().minute < 10 ? "0" : ""}${widget.item["problemDate"].toDate().minute}",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF818181),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width -
                                        136.0,
                                    child: Text(
                                      widget.item["productName"],
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: kDarkBlue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    widget.item["selectedProductType"],
                                    style: TextStyle(
                                      fontSize: 13.7,
                                      color: Color(0xFFE2E2E2),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    widget.item["productPrice"] + " TL",
                                    style: TextStyle(
                                      fontSize: 14.1,
                                      color: kDarkBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Text(
                          widget.item["problem"],
                          style: TextStyle(
                            fontSize: 14.1,
                            color: kDarkBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Text(
                          widget.item["problemDetail"],
                          style: TextStyle(
                            fontSize: 14.5,
                            color: kDarkBlue,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: kLightBlueBg,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 56.0,
                      right: 56.0,
                      top: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          (widget.item["problemDate"].toDate().day < 10
                                  ? "0${widget.item["problemDate"].toDate().day}"
                                  : widget.item["problemDate"]
                                      .toDate()
                                      .day
                                      .toString()) +
                              " " +
                              months[widget.item["problemDate"].toDate().month -
                                  1],
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: textGray,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: Text(
                            widget.item.containsKey("reviewStartedDate")
                                ? ((widget.item["reviewStartedDate"]
                                                .toDate()
                                                .day <
                                            10
                                        ? "0${widget.item["reviewStartedDate"].toDate().day}"
                                        : widget.item["reviewStartedDate"]
                                            .toDate()
                                            .day
                                            .toString()) +
                                    " " +
                                    months[widget.item["reviewStartedDate"]
                                            .toDate()
                                            .month -
                                        1])
                                : ((widget.item["problemDate"].toDate().day < 10
                                        ? "0${widget.item["problemDate"].toDate().day}"
                                        : widget.item["problemDate"]
                                            .toDate()
                                            .day
                                            .toString()) +
                                    " " +
                                    months[widget.item["problemDate"]
                                            .toDate()
                                            .month -
                                        1]),
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color:
                                  widget.item.containsKey("reviewStartedDate")
                                      ? textGray
                                      : kLightBlueBg,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Text(
                          widget.item.containsKey("problemRepliedDate")
                              ? (widget.item["problemRepliedDate"]
                                              .toDate()
                                              .day <
                                          10
                                      ? "0${widget.item["problemRepliedDate"].toDate().day}"
                                      : widget.item["problemRepliedDate"]
                                          .toDate()
                                          .day
                                          .toString()) +
                                  " " +
                                  months[widget.item["problemRepliedDate"]
                                          .toDate()
                                          .month -
                                      1]
                              : (widget.item["problemDate"].toDate().day < 10
                                      ? "0${widget.item["problemDate"].toDate().day}"
                                      : widget.item["problemDate"]
                                          .toDate()
                                          .day
                                          .toString()) +
                                  " " +
                                  months[widget.item["problemDate"]
                                          .toDate()
                                          .month -
                                      1],
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: widget.item.containsKey("problemRepliedDate")
                                ? textGray
                                : kLightBlueBg,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 64.0,
                      right: 64.0,
                      top: 4.0,
                      bottom: 8.0,
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          child: Icon(
                            FontAwesomeIcons.solidCheckCircle,
                            color: green,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 3.0,
                            color: widget.item["problemState"] ==
                                    "Çözüm Merkezine İletildi."
                                ? gray
                                : green,
                          ),
                        ),
                        widget.item["problemState"] ==
                                "Çözüm Merkezine İletildi."
                            ? Container(
                                height: 14.0,
                                width: 14.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: gray,
                                    width: 3,
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 3.0),
                                child: Icon(
                                  FontAwesomeIcons.solidCheckCircle,
                                  color: green,
                                ),
                              ),
                        Expanded(
                          child: Container(
                            height: 3.0,
                            color:
                                widget.item["problemState"] == "Dönüş yapıldı."
                                    ? green
                                    : gray,
                          ),
                        ),
                        widget.item["problemState"] == "Dönüş yapıldı."
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 3.0),
                                child: Icon(
                                  FontAwesomeIcons.solidCheckCircle,
                                  color: green,
                                ),
                              )
                            : Container(
                                height: 14.0,
                                width: 14.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: gray,
                                    width: 3,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Çözüm Merkezine\nİletildi.",
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                              color: green,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            "Bildiriminiz\nİnceleniyor.",
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                              color: widget.item["problemState"] ==
                                      "Çözüm Merkezine İletildi."
                                  ? textGray
                                  : green,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Text(
                          "Çözüm Merkezinden\nDönüş yapıldı.",
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                            color:
                                widget.item["problemState"] == "Dönüş yapıldı."
                                    ? green
                                    : textGray,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/solutionCenterAlert.png",
                          height: 32.0,
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Text(
                          "Henüz Çözüm Merkezinden\ndönüş yapılmadı.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17.0,
                            height: 1.1,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB1B1B1),
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Text(
                          "Dönüş yapıldığında burada görüntülenecek.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.0,
                            height: 1.2,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFB1B1B1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 42.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          FadeRoute(
                            page: ProblemChatScreen(
                              item: widget.item,
                            ),
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
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/images/solutionLiveSupportIcon.png",
                            height: 20.0,
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            "Canlı Destek",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
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
}

class ProblemChatScreen extends StatefulWidget {
  const ProblemChatScreen({
    Key? key,
    required this.item,
  }) : super(key: key);
  final Map item;

  @override
  _ProblemChatScreenState createState() => _ProblemChatScreenState();
}

class _ProblemChatScreenState extends State<ProblemChatScreen> {
  TextEditingController _messageController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
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
            GestureDetector(
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
                      "assets/images/navBarUnselectedListing.png",
                      height: 25.0,
                    ),
                    Text(
                      "Alışverişlerim",
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
            GestureDetector(
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
                      "assets/images/navBarSelectedSolution.png",
                      height: 25.0,
                    ),
                    Text(
                      "Çözüm Merkezi",
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
            Container(
              width: (MediaQuery.of(context).size.width - 30.0) / 5,
            ),
            GestureDetector(
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
            GestureDetector(
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
            "Çözüm Merkezi",
            style: TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot<Map>>(
          future:
              _firestore.collection("Users").doc(widget.item["buyer"]).get(),
          builder: (context, buyerSnapshot) {
            return FutureBuilder<DocumentSnapshot<Map>>(
                future: _firestore
                    .collection("Users")
                    .doc(widget.item["seller"])
                    .get(),
                builder: (context, sellerSnapshot) {
                  return StreamBuilder<QuerySnapshot<Map>>(
                      stream: _firestore
                          .collection("Rooms")
                          .doc(widget.item["roomDocID"])
                          .collection("ProblemMessages")
                          .orderBy("date")
                          .snapshots(),
                      builder: (context, messagesSnapshot) {
                        if (!messagesSnapshot.hasData ||
                            !sellerSnapshot.hasData ||
                            !buyerSnapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        Map<String, Map<String, String>> users = {
                          sellerSnapshot.data!.id: {
                            "name": sellerSnapshot.data!.data()!["name"],
                            "pp": sellerSnapshot.data!
                                    .data()!
                                    .containsKey("profilePhoto")
                                ? sellerSnapshot.data!.data()!["profilePhoto"]
                                : ""
                          },
                          buyerSnapshot.data!.id: {
                            "name": buyerSnapshot.data!.data()!["name"],
                            "pp": buyerSnapshot.data!
                                    .data()!
                                    .containsKey("profilePhoto")
                                ? buyerSnapshot.data!.data()!["profilePhoto"]
                                : ""
                          },
                        };
                        List<Map> messages = [];
                        messagesSnapshot.data!.docs.reversed
                            .toList()
                            .forEach((element) {
                          messages.add(element.data());
                        });
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  top: 24.0,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
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
                                                      widget.item["imageURLs"]
                                                          [0],
                                                    ),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      136.0,
                                                  alignment: Alignment.topRight,
                                                  child: Text(
                                                    "${widget.item["problemDate"].toDate().day} ${months[widget.item["problemDate"].toDate().month - 1]} ${widget.item["problemDate"].toDate().year}, ${widget.item["problemDate"].toDate().hour < 10 ? "0" : ""}${widget.item["problemDate"].toDate().hour}:${widget.item["problemDate"].toDate().minute < 10 ? "0" : ""}${widget.item["problemDate"].toDate().minute}",
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Color(0xFF818181),
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                    widget.item["productName"],
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: kDarkBlue,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  widget.item[
                                                      "selectedProductType"],
                                                  style: TextStyle(
                                                    fontSize: 13.7,
                                                    color: Color(0xFFE2E2E2),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  widget.item["productPrice"] +
                                                      " TL",
                                                  style: TextStyle(
                                                    fontSize: 14.1,
                                                    color: kDarkBlue,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10.0,
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
                              Container(
                                height: MediaQuery.of(context).size.height -
                                    239.0 -
                                    80.0,
                                child: ListView.builder(
                                  itemCount: messages.length,
                                  reverse: true,
                                  itemBuilder: (context, index) {
                                    bool isSender = messages[index]["sender"] ==
                                        _firebaseAuth.currentUser!.uid;
                                    String dateText = "";
                                    if (messages[index]["date"] != null) {
                                      DateTime date =
                                          (messages[index]["date"] as Timestamp)
                                              .toDate();

                                      dateText =
                                          "${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour < 10 ? "0" : ""}${date.hour}:${date.minute < 10 ? "0" : ""}${date.minute}";
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 12.0),
                                      child: Container(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment: isSender
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                          children: [
                                            if (!isSender)
                                              users.containsKey(
                                                      messages[index]["sender"])
                                                  ? (users[messages[index]
                                                                  ["sender"]]![
                                                              "pp"] ==
                                                          ""
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 4.0),
                                                          child: Container(
                                                            height: 26.0,
                                                            width: 26.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.grey,
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                          ),
                                                        )
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 4.0),
                                                          child: Container(
                                                            height: 26.0,
                                                            width: 26.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.grey,
                                                              shape: BoxShape
                                                                  .circle,
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    NetworkImage(
                                                                  users[messages[
                                                                          index]
                                                                      [
                                                                      "sender"]]!["pp"]!,
                                                                ),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ))
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 4.0),
                                                      child: Container(
                                                        height: 26.0,
                                                        width: 26.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: kDarkBlue,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                    ),
                                            Column(
                                              crossAxisAlignment: isSender
                                                  ? CrossAxisAlignment.end
                                                  : CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.8),
                                                  decoration: BoxDecoration(
                                                    color: isSender
                                                        ? kButtonBlue
                                                        : Color(0xFFE2E2E2),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight: isSender
                                                          ? Radius.zero
                                                          : const Radius
                                                              .circular(14.0),
                                                      topLeft: !isSender
                                                          ? Radius.zero
                                                          : const Radius
                                                              .circular(14.0),
                                                      bottomLeft:
                                                          const Radius.circular(
                                                              14.0),
                                                      bottomRight:
                                                          const Radius.circular(
                                                              14.0),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 6.0,
                                                                  right: 14.0),
                                                          child: Text(
                                                            messages[index]
                                                                ["message"],
                                                            style: TextStyle(
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: isSender
                                                                  ? Colors.white
                                                                  : kDarkBlue,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 4.0,
                                                ),
                                                Text(
                                                  "${(users.containsKey(messages[index]["sender"]) ? users[messages[index]["sender"]]!["name"] : "Anchor")}, $dateText",
                                                  style: TextStyle(
                                                    color: Color(0xFFE2E2E2),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 11.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (isSender)
                                              users[messages[index]["sender"]]![
                                                          "pp"] ==
                                                      ""
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 4.0),
                                                      child: Container(
                                                        height: 26.0,
                                                        width: 26.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.grey,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 4.0),
                                                      child: Container(
                                                        height: 26.0,
                                                        width: 26.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.grey,
                                                          shape:
                                                              BoxShape.circle,
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                              users[messages[
                                                                          index]
                                                                      [
                                                                      "sender"]]![
                                                                  "pp"]!,
                                                            ),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 10.0,
                                    left: 24.0,
                                    right: 24.0,
                                  ),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFAFAFA),
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                        color: const Color(0xFFB7BACC),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: TextField(
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  fontSize: 12.5,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                controller: _messageController,
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                  isCollapsed: true,
                                                  hintText:
                                                      "Mesajınızı buraya yazın.",
                                                  hintStyle: TextStyle(
                                                    fontSize: 12.0,
                                                    color: kTextFieldGrey,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                cursorColor: Colors.black26,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Container(
                                            height: 36.0,
                                            width: 36.0,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFDBE0EA),
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 2.0,
                                                bottom: 2.0,
                                              ),
                                              child: Transform.rotate(
                                                angle: -0.8,
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    if (_messageController.text
                                                        .trim()
                                                        .isNotEmpty) {
                                                      String tempMessage =
                                                          _messageController
                                                              .text;
                                                      setState(() {
                                                        _messageController
                                                            .clear();
                                                      });
                                                      await _firestore
                                                          .collection("Rooms")
                                                          .doc(widget.item[
                                                              "roomDocID"])
                                                          .collection(
                                                              "ProblemMessages")
                                                          .doc()
                                                          .set({
                                                        "message": tempMessage,
                                                        "sender": _firebaseAuth
                                                            .currentUser!.uid,
                                                        "date": FieldValue
                                                            .serverTimestamp(),
                                                      });
                                                    }
                                                  },
                                                  child: const Icon(
                                                    Icons.send,
                                                    size: 22.0,
                                                    color: kDarkBlue,
                                                  ),
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
                        );
                      });
                });
          }),
    );
  }
}
