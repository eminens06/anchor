import 'package:anchor/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              64.0 -
              kBottomNavigationBarHeight,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                height: 140.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Anchor Bilgi Merkezine\nHoş Geldin!",
                          style: TextStyle(
                            color: kDarkBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          "Sıkça Sorulan Sorulara ve merak\nettiğin bütün detaylara bu ekran\nüzerinden ulaşabilirsin.",
                          style: TextStyle(
                            color: kTextFieldGrey,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Image.asset(
                      "assets/images/infoPageDraw.png",
                      height: 110.0,
                    ),
                  ],
                )),
            Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      64.0 -
                      kBottomNavigationBarHeight -
                      140.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.0),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4.0,
                    color: Color(0xFF818181).withOpacity(0.2),
                  ),
                ],
              ),
              child: FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection("FAQ").get(),
                  builder: (context, faqs) {
                    if (!faqs.hasData) {
                      return Container();
                    }
                    return ListView.builder(
                        itemCount: faqs.data!.docs.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                top: index == 0 ? 24.0 : 0.0,
                                left: 16.0,
                                right: 16.0,
                                bottom: index == 11 ? 12.0 : 0.0),
                            child: CustomExpansionTile(
                              question: faqs.data!.docs[index]["question"],
                              answer: faqs.data!.docs[index]["answer"],
                            ),
                          );
                        });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomExpansionTile extends StatefulWidget {
  final String question;
  final String answer;
  CustomExpansionTile({required this.question, required this.answer, Key? key})
      : super(key: key);

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xFFFEFDFD),
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Color(0xFF707070).withOpacity(0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF6EB0FC),
                spreadRadius: -12.0,
              ),
            ]),
        child: Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.question,
                  style: TextStyle(
                    color: isExpanded ? Color(0xFF6EB0FC) : kDarkBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            trailing: isExpanded
                ? Text(
                    "-",
                    style: TextStyle(
                      color: Color(0xFF6EB0FC),
                      fontWeight: FontWeight.w600,
                      fontSize: 25,
                    ),
                  )
                : Icon(
                    Icons.keyboard_arrow_down,
                    color: kDarkBlue,
                    size: 25.0,
                  ),
            onExpansionChanged: (b) {
              setState(() {
                isExpanded = b;
              });
            },
            expandedAlignment: Alignment.centerLeft,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 16.0,
                  left: 16.0,
                  bottom: 8.0,
                ),
                child: Text(
                  widget.answer,
                  style: TextStyle(
                    color: Color(0xFF234E70),
                  ),
                  textAlign: TextAlign.start,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
