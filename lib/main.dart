import 'package:anchor/MainPage.dart';
import 'package:anchor/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'FadeRoute.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('tr', 'TR'),
      ],
      theme: ThemeData(
        fontFamily: 'Metropolis',
      ),
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data == null) {
                return WelcomePage();
              } else {
                return FutureBuilder<DocumentSnapshot<Map>>(
                    future: FirebaseFirestore.instance
                        .collection("Users")
                        .doc(snapshot.data!.uid)
                        .get(),
                    builder: (context, userSnapshot) {
                      if (!userSnapshot.hasData) {
                        return Scaffold(
                          body: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/images/firstBg.png",
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }
                      if (userSnapshot.data!.exists) {
                        return MainPage();
                      } else {
                        return WelcomePage();
                      }
                    });
              }
            } else {
              return Scaffold(
                body: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/firstBg.png",
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }
}

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/firstBg.png",
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 44.0,
              right: 44.0,
              top: 48.0,
              bottom: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Bütün 2.el alışverişleriniz\nBizimle güvende!",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                Image.asset(
                  "assets/images/welcomeDraw.png",
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Alıcısı olduğun ürün güvenle eline ulaşsın, dolandırılma ihtimalin ortadan kalksın!",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 12.0,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      "Anchor size de kafa rahatlığı sunmak için var!",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.0,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                      ),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                          minimumSize: MaterialStateProperty.all(Size(40, 40)),
                          backgroundColor: MaterialStateProperty.all(
                            kPurpleBlue,
                          ),
                          elevation: MaterialStateProperty.all(0),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            FadeRoute(
                              page: SignUpPage(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Üye Ol",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                      ),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                          minimumSize: MaterialStateProperty.all(Size(40, 40)),
                          backgroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                          elevation: MaterialStateProperty.all(0),
                          overlayColor:
                              MaterialStateProperty.all(kPink.withOpacity(0.3)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Giriş Yap",
                                style: TextStyle(
                                  color: kPink,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            FadeRoute(
                              page: LogInPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _realNameController = TextEditingController();
  bool isPolicyChecked = false;
  bool isContactChecked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height,
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/thirdBg.png",
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 36.0,
                          top: 4.0,
                        ),
                        child: Text(
                          "Üye Olun",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 100.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _realNameController,
                          decoration: InputDecoration(
                            hintText: "Ad Soyad",
                            hintStyle: TextStyle(
                              color: Color(0xFFDEDEDE),
                              fontWeight: FontWeight.w500,
                              fontSize: 13.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: kPurpleBlue,
                            focusColor: Color(0xFF89AEFB),
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 12.0,
                            ),
                          ),
                          keyboardType: TextInputType.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            hintText: "Telefon",
                            hintStyle: TextStyle(
                              color: Color(0xFFDEDEDE),
                              fontWeight: FontWeight.w500,
                              fontSize: 13.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: kPurpleBlue,
                            focusColor: Color(0xFF89AEFB),
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 12.0,
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextField(
                          controller: _mailController,
                          decoration: InputDecoration(
                            hintText: "E-mail",
                            hintStyle: TextStyle(
                              color: Color(0xFFDEDEDE),
                              fontWeight: FontWeight.w500,
                              fontSize: 13.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: kPurpleBlue,
                            focusColor: Color(0xFF89AEFB),
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 12.0,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: "Kullanıcı Adı",
                            hintStyle: TextStyle(
                              color: Color(0xFFDEDEDE),
                              fontWeight: FontWeight.w500,
                              fontSize: 13.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: kPurpleBlue,
                            focusColor: Color(0xFF89AEFB),
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 12.0,
                            ),
                          ),
                          keyboardType: TextInputType.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: "Şifre",
                            hintStyle: TextStyle(
                              color: Color(0xFFDEDEDE),
                              fontWeight: FontWeight.w500,
                              fontSize: 13.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: kPurpleBlue,
                            focusColor: Color(0xFF89AEFB),
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 12.0,
                            ),
                          ),
                          obscureText: true,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: "Hesabınız var mı?\n",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.0,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Giriş Yapın",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.0,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          FadeRoute(
                                            page: LogInPage(),
                                          ),
                                        );
                                      },
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.end,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                shape:
                                    MaterialStateProperty.all(CircleBorder()),
                                minimumSize: MaterialStateProperty.all(
                                  Size(
                                    60,
                                    60,
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFFFE9ECC)),
                                shadowColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              onPressed: () async {
                                String _userPhone = _phoneController.text;
                                if (_userPhone != '' &&
                                    _userPhone.isNotEmpty &&
                                    _userPhone.trim().isNotEmpty) {
                                  if (_userPhone.substring(0, 1) == '5') {
                                    _userPhone = '+90' + _userPhone;
                                  } else if (_userPhone.substring(0, 1) ==
                                      '0') {
                                    _userPhone = '+9' + _userPhone;
                                  } else if (_userPhone.substring(0, 1) ==
                                      '9') {
                                    _userPhone = '+' + _userPhone;
                                  }
                                  if (_userPhone.length != 13) {
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
                                  } else if (_userPhone.substring(0, 4) !=
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
                                    if (_passwordController.text.isEmpty ||
                                        _passwordController.text == "" ||
                                        _passwordController.text
                                            .trim()
                                            .isEmpty) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                  'Lütfen Geçerli Bir Şifre Girin'),
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
                                      if (_passwordController.text.length < 3) {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text(
                                                    'Şifreniz 3 karakterden kısa olamaz.'),
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
                                        if (_nameController.text.isEmpty ||
                                            _nameController.text == "" ||
                                            _nameController.text
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
                                                .where("name",
                                                    isEqualTo:
                                                        _nameController.text)
                                                .get()
                                                .then((value) async {
                                              if (value.size > 0) {
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
                                                            child:
                                                                Text('Tamam'),
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              } else {
                                                await FirebaseFirestore.instance
                                                    .collection("Users")
                                                    .where("mail",
                                                        isEqualTo:
                                                            _mailController
                                                                .text)
                                                    .get()
                                                    .then((mailValue) async {
                                                  if (mailValue.size > 0) {
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
                                                                child: Text(
                                                                    'Tamam'),
                                                              ),
                                                            ],
                                                          );
                                                        });
                                                  } else {
                                                    if (_nameController
                                                                .text.length <
                                                            3 ||
                                                        _nameController
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
                                                      if (_realNameController
                                                          .text.isEmpty) {
                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Lütfen Geçerli Bir Ad Soyad Girin'),
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
                                                        await verifyUser(
                                                          phoneNumber:
                                                              _userPhone,
                                                          context: context,
                                                          isLogIn: false,
                                                          mail: _mailController
                                                              .text,
                                                          name: _nameController
                                                              .text,
                                                          password:
                                                              _passwordController
                                                                  .text,
                                                          realName:
                                                              _realNameController
                                                                  .text,
                                                        );
                                                      }
                                                    }
                                                  }
                                                });
                                              }
                                            });
                                          }
                                        }
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
                              },
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 32.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
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
    );
  }
}

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/secondBg.png",
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 36.0, top: 18.0),
                        child: Text(
                          "Tekrar\nHoşgeldiniz",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            hintText: "Telefon",
                            hintStyle: TextStyle(
                              color: Color(0xFFDEDEDE),
                              fontWeight: FontWeight.w500,
                              fontSize: 11.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: kPurpleBlue,
                            focusColor: Color(0xFF89AEFB),
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 14.0,
                              horizontal: 12.0,
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: "Şifre",
                            hintStyle: TextStyle(
                              color: Color(0xFFDEDEDE),
                              fontWeight: FontWeight.w500,
                              fontSize: 11.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: kPurpleBlue,
                            focusColor: Color(0xFF89AEFB),
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 14.0,
                              horizontal: 12.0,
                            ),
                          ),
                          obscureText: true,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: "Şifremi Unuttum",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.0,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    //TODO: NEW PASSWORD
                                  },
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.09,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: "Üye Ol",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.0,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      FadeRoute(
                                        page: SignUpPage(),
                                      ),
                                    );
                                  },
                              ),
                              textAlign: TextAlign.end,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                shape:
                                    MaterialStateProperty.all(CircleBorder()),
                                minimumSize: MaterialStateProperty.all(
                                  Size(
                                    60,
                                    60,
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFFFE9ECC)),
                                shadowColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              onPressed: () async {
                                if (_phoneController.text == '') {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                              'Lütfen Geçerli bir Telefon numarası / Mail / Kullanıcı adı girin.'),
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
                                } else if (_passwordController.text == '') {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                              'Lütfen Geçerli bir şifre girin.'),
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
                                  await verifyUser(
                                    phoneNumber: _phoneController.text,
                                    context: context,
                                    isLogIn: true,
                                    mail: "",
                                    name: "",
                                    realName: "",
                                    password: _passwordController.text,
                                  );
                                }
                              },
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 32.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
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
    );
  }
}

class CodePage extends StatefulWidget {
  final String phoneNumber;
  final String name;
  final String mail;
  final String password;
  final String realName;
  final bool isLogIn;
  final String verificationID;
  final isUpdate;
  const CodePage({
    required this.phoneNumber,
    required this.isLogIn,
    required this.verificationID,
    required this.name,
    required this.mail,
    required this.password,
    required this.isUpdate,
    required this.realName,
  });

  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/fourthBg.png",
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back_ios_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 36.0, top: 18.0),
                            child: Text(
                              "Kodu Girin",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                                height: 1.1,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 36.0, top: 18.0),
                            child: Image.asset(
                              "assets/images/codeDraw.png",
                              width: 140.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFEBF4F7),
                              ),
                              text: widget.phoneNumber,
                            ),
                            TextSpan(
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w300,
                                color: Color(0xFFEBF4F7),
                              ),
                              text:
                                  " numaralı telefona\n6 haneli kod gönderildi.",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                      ),
                      Container(
                        width: 230.0,
                        child: TextField(
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          controller: _codeController,
                          decoration: InputDecoration(
                            hintText: "123456",
                            hintStyle: TextStyle(
                              color: Colors.white38,
                              fontWeight: FontWeight.w500,
                              fontSize: 24.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: kPurpleBlue,
                            filled: true,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 14.0,
                              horizontal: 12.0,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Container(
                        width: 230.0,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                            ),
                            minimumSize:
                                MaterialStateProperty.all(Size(40, 40)),
                            backgroundColor: MaterialStateProperty.all(
                              Colors.white,
                            ),
                            elevation: MaterialStateProperty.all(0),
                            overlayColor: MaterialStateProperty.all(
                                kPink.withOpacity(0.3)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Onayla",
                                  style: TextStyle(
                                    color: kPink,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onPressed: () async {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return WillPopScope(
                                    onWillPop: () {
                                      return Future.value(false);
                                    },
                                    child: AlertDialog(
                                      backgroundColor: Colors.transparent,
                                      content: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  );
                                });
                            if (widget.isUpdate) {
                              await FirebaseAuth.instance.currentUser!
                                  .updatePhoneNumber(
                                      PhoneAuthProvider.credential(
                                          verificationId: widget.verificationID,
                                          smsCode: _codeController.text))
                                  .whenComplete(() async {
                                await FirebaseFirestore.instance
                                    .collection("Users")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({
                                  "phoneNumber": widget.phoneNumber,
                                });
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  FadeRoute(
                                    page: MainPage(),
                                  ),
                                  (route) => false,
                                );
                              }).catchError((Object e) {
                                if (e is FirebaseAuthException) {
                                  print(e.code);

                                  if (e.code == 'ınvalıd-phone-number' ||
                                      e.code == 'mıssıng-phone-number') {
                                    _codeController.clear();
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                                'Lütfen Telefon Numaranızı doğru girdiğinizden emin olun.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Tamam'),
                                              ),
                                            ],
                                          );
                                        });
                                  }

                                  if (e.code == 'ınvalıd-verıfıcatıon-code' ||
                                      e.code == 'mıssıng-verıfıcatıon-code' ||
                                      e.code == 'ınvalıd-verıfıcatıon-ıd') {
                                    _codeController.clear();
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                                'Lütfen SMS kodunu doğru girdiğinizden emin olun.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Tamam'),
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                  if (e.code == 'sessıon-expıred') {
                                    _codeController.clear();
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title:
                                                Text('Lütfen tekrar deneyin.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Tamam'),
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                  if (e.code == 'too-many-requests') {
                                    _codeController.clear();
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                                'Çok fazla sayıda deneme yaptığınız için giriş işlemleriniz bir süre askıya alındı.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
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
                            } else {
                              FirebaseAuth.instance
                                  .signInWithCredential(
                                      PhoneAuthProvider.credential(
                                          verificationId: widget.verificationID,
                                          smsCode: _codeController.text))
                                  .then((credential) {
                                if (widget.isLogIn) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop('dialog');
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    FadeRoute(
                                      page: MainPage(),
                                    ),
                                    (route) => false,
                                  );
                                } else {
                                  FirebaseMessaging.instance
                                      .getToken()
                                      .then((fcmToken) {
                                    FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(credential.user!.uid)
                                        .set({
                                      "phoneNumber": widget.phoneNumber,
                                      "realName": widget.realName,
                                      "password": widget.password,
                                      "name": widget.name,
                                      "mail": widget.mail,
                                      "uid": credential.user!.uid,
                                      "address": "",
                                      "allowNotifications": true,
                                      "fcmToken": fcmToken,
                                      "signUpDate":
                                          FieldValue.serverTimestamp(),
                                    }).whenComplete(() {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop('dialog');

                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        FadeRoute(
                                          page: MainPage(),
                                        ),
                                        (route) => false,
                                      );
                                    });
                                  });
                                }
                              }).catchError((Object e) {
                                if (e is FirebaseAuthException) {
                                  print(e.code);

                                  if (e.code == 'ınvalıd-phone-number' ||
                                      e.code == 'mıssıng-phone-number') {
                                    _codeController.clear();
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                                'Lütfen Telefon Numaranızı doğru girdiğinizden emin olun.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Tamam'),
                                              ),
                                            ],
                                          );
                                        });
                                  }

                                  if (e.code == 'ınvalıd-verıfıcatıon-code' ||
                                      e.code == 'mıssıng-verıfıcatıon-code' ||
                                      e.code == 'ınvalıd-verıfıcatıon-ıd') {
                                    _codeController.clear();
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                                'Lütfen SMS kodunu doğru girdiğinizden emin olun.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Tamam'),
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                  if (e.code == 'sessıon-expıred') {
                                    _codeController.clear();
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title:
                                                Text('Lütfen tekrar deneyin.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Tamam'),
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                  if (e.code == 'too-many-requests') {
                                    _codeController.clear();
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                                'Çok fazla sayıda deneme yaptığınız için giriş işlemleriniz bir süre askıya alındı.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
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
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFEBF4F7),
                              ),
                              text: "Kod gelmedi mi? ",
                            ),
                            TextSpan(
                              style: TextStyle(
                                color: Color(0xFFEBF4F7),
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              text: "Tekrar İsteyin",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    FadeRoute(
                                      page: widget.isLogIn
                                          ? LogInPage()
                                          : SignUpPage(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future verifyUser({
  required String phoneNumber,
  required BuildContext context,
  required bool isLogIn,
  required String name,
  required String mail,
  required String password,
  required String realName,
  bool isUpdate = false,
}) async {
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
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (!isUpdate) {
    if (isLogIn) {
      await _firestore
          .collection("Users")
          .where("name", isEqualTo: phoneNumber)
          .get()
          .then((nameValue) async {
        if (nameValue.size > 0) {
          if (nameValue.docs[0].data()["password"] == password) {
            phoneNumber = nameValue.docs[0].data()["phoneNumber"];
          } else {
            phoneNumber = "";
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Şifrenizi doğru girdiğinizden emin olun.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text('Tamam'),
                      ),
                    ],
                  );
                });
          }
        } else {
          await _firestore
              .collection("Users")
              .where("mail", isEqualTo: phoneNumber)
              .get()
              .then((mailValue) async {
            if (mailValue.size > 0) {
              if (mailValue.docs[0].data()["password"] == password) {
                phoneNumber = mailValue.docs[0].data()["phoneNumber"];
              } else {
                phoneNumber = "";
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Şifrenizi doğru girdiğinizden emin olun.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text('Tamam'),
                          ),
                        ],
                      );
                    });
              }
            } else {
              if (phoneNumber != '' &&
                  phoneNumber.isNotEmpty &&
                  phoneNumber.trim().isNotEmpty) {
                if (phoneNumber.substring(0, 1) == '5') {
                  phoneNumber = '+90' + phoneNumber;
                } else if (phoneNumber.substring(0, 1) == '0') {
                  phoneNumber = '+9' + phoneNumber;
                } else if (phoneNumber.substring(0, 1) == '9') {
                  phoneNumber = '+' + phoneNumber;
                }
                if (phoneNumber.length != 13) {
                  phoneNumber = "";
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Kayıtlı kullanıcı bulunamadı.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text('Tamam'),
                            ),
                          ],
                        );
                      });
                } else if (phoneNumber.substring(0, 4) != '+905') {
                  phoneNumber = "";
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Kayıtlı kullanıcı bulunamadı.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text('Tamam'),
                            ),
                          ],
                        );
                      });
                } else {
                  await _firestore
                      .collection("Users")
                      .where("phoneNumber", isEqualTo: phoneNumber)
                      .get()
                      .then((phoneValue) {
                    if (phoneValue.size == 0) {
                      phoneNumber = "";
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Kayıtlı kullanıcı bulunamadı.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Tamam'),
                                ),
                              ],
                            );
                          });
                    } else {
                      if (phoneValue.docs[0].data()["password"] == password) {
                        phoneNumber = phoneValue.docs[0].data()["phoneNumber"];
                      } else {
                        phoneNumber = "";
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                    'Şifrenizi doğru girdiğinizden emin olun.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
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
                }
              } else {
                phoneNumber = "";
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Kayıtlı kullanıcı bulunamadı.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
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
        }
      });
    } else {
      await _firestore
          .collection("Users")
          .where("phoneNumber", whereIn: [phoneNumber, name, mail])
          .get()
          .then((phoneValue) async {
            if (phoneValue.size > 0) {
              phoneNumber = "";
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                          'Bu telefon numarası ile kayıtlı bir kullanıcı zaten var'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text('Tamam'),
                        ),
                      ],
                    );
                  });
              return;
            } else {
              await _firestore
                  .collection("Users")
                  .where("mail", whereIn: [phoneNumber, name, mail])
                  .get()
                  .then((mailValue) async {
                    if (mailValue.size > 0) {
                      phoneNumber = "";
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                  'Bu mail adresi ile kayıtlı bir kullanıcı zaten var'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Tamam'),
                                ),
                              ],
                            );
                          });
                      return;
                    } else {
                      await _firestore
                          .collection("Users")
                          .where("name", whereIn: [phoneNumber, name, mail])
                          .get()
                          .then((nameValue) {
                            if (nameValue.size > 0) {
                              phoneNumber = "";
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                          'Bu kullanıcı adı ile kayıtlı bir kullanıcı zaten var'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                          child: Text('Tamam'),
                                        ),
                                      ],
                                    );
                                  });
                            }
                          });
                    }
                  });
            }
          });
    }
  }
  if (phoneNumber == "") {
    return;
  }
  await _auth.verifyPhoneNumber(
    phoneNumber: phoneNumber,
    timeout: Duration(seconds: 120),
    verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
      if (isUpdate) {
        await FirebaseAuth.instance.currentUser!
            .updatePhoneNumber(phoneAuthCredential)
            .whenComplete(() async {
          await _firestore
              .collection("Users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            "phoneNumber": phoneNumber,
          });
          Navigator.pushAndRemoveUntil(
            context,
            FadeRoute(
              page: MainPage(),
            ),
            (route) => false,
          );
        });
      } else {
        await _auth
            .signInWithCredential(phoneAuthCredential)
            .then((result) async {
          if (isLogIn) {
            Navigator.pushAndRemoveUntil(
              context,
              FadeRoute(
                page: MainPage(),
              ),
              (route) => false,
            );
          } else {
            await FirebaseMessaging.instance.getToken().then((fcmToken) async {
              await _firestore.collection("Users").doc(result.user!.uid).set({
                "phoneNumber": phoneNumber,
                "realName": realName,
                "password": password,
                "name": name,
                "mail": mail,
                "uid": result.user!.uid,
                "address": "",
                "allowNotifications": true,
                "fcmToken": fcmToken,
                "signUpDate": FieldValue.serverTimestamp(),
              }).whenComplete(() {
                Navigator.pushAndRemoveUntil(
                  context,
                  FadeRoute(
                    page: MainPage(),
                  ),
                  (route) => false,
                );
              });
            });
          }
        }).catchError((e) {
          if (e.code == 'too-many-requests') {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                        'Çok fazla sayıda deneme yaptığınız için giriş işlemleriniz bir süre askıya alındı.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text('Tamam'),
                      ),
                    ],
                  );
                });
          }
        });
      }
    },
    verificationFailed: (FirebaseAuthException authException) {
      print("AUTH EXCEPTION CODE:" + authException.code);
      print(authException.message);
      if (authException.code == 'too-many-requests') {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                    'Çok fazla sayıda deneme yaptığınız için giriş işlemleriniz bir süre askıya alındı.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                    child: Text('Tamam'),
                  ),
                ],
              );
            });
      }
      if (authException.code == 'invalid-phone-number') {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Lütfen geçerli bir telefon numarası girin.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                    child: Text('Tamam'),
                  ),
                ],
              );
            });
      }
    },
    codeSent: (String verificationID, int? resendToken) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Navigator.push(
        context,
        FadeRoute(
          page: CodePage(
            phoneNumber: phoneNumber,
            isLogIn: isLogIn,
            verificationID: verificationID,
            name: name,
            mail: mail,
            password: password,
            isUpdate: isUpdate,
            realName: realName,
          ),
        ),
      );
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      verificationId = verificationId;
      print(verificationId);
      print("Time out");
    },
  );
}
