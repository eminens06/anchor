import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'FadeRoute.dart';
import 'MainPage.dart';
import 'constants.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.item,
  }) : super(key: key);
  final Map item;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            "Mesajlaş",
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
                          .collection("Messages")
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
                                                    "${widget.item["date"].toDate().day} ${months[widget.item["date"].toDate().month - 1]} ${widget.item["date"].toDate().year}, ${widget.item["date"].toDate().hour < 10 ? "0" : ""}${widget.item["date"].toDate().hour}:${widget.item["date"].toDate().minute < 10 ? "0" : ""}${widget.item["date"].toDate().minute}",
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
                                    80,
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
                                              users[messages[index]["sender"]]![
                                                          "pp"] ==
                                                      ""
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 4.0),
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
                                                              right: 4.0),
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
                                                  "${users[messages[index]["sender"]]!["name"]}, $dateText",
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
                                                              "Messages")
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
