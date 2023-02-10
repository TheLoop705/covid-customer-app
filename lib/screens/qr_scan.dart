import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/Animation/bottomAnimation.dart';
import 'package:customer/models/enteries.dart';
import 'package:customer/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QrCode extends StatefulWidget {
  @override
  _QrCodeState createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  TextEditingController _outputController;
  String email, url, name, phone, address;
  List<Enteries> restaurants = [];
  List<String> restaurantNames = [];

  @override
  initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      // send();
      setState(() {});
    });
    getUser();
  }

  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email') == null ? "Your Email" : prefs.getString(
          'email');
      url = prefs.getString('pic');
      name =
      prefs.getString('name') == null ? "Your Username" : prefs.getString(
          'name');
      phone = prefs.getString('phone') == null ? "Your Phone" : prefs.getString(
          'phone');
      address =
      prefs.getString('address') == null ? "Your Address" : prefs.getString(
          'address');
    });
    print(email);
    getData();
  }

  getData() async {
    Firestore.instance.collection("Enteries").get().then((value) {
      value.documents.forEach((element) {
        if (element['email'] == email) {
          restaurants.add(Enteries(
              element['restaurant'],
              element['time']
          ));
        }
      });
    });
    print(restaurants);
  }

    @override
    Widget build(BuildContext context) {
      return Consumer<ThemeNotifier>(
          builder: (context, notifier, child) =>
              Scaffold(
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      WidgetAnimator(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Scan to add restaurant to the list",
                              style: TextStyle(fontWeight: FontWeight.bold,
                                  color: notifier.darkTheme
                                      ? Colors.white
                                      : primary),)
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      WidgetAnimator(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                      colors: [
                                        Color.fromRGBO(143, 148, 251, 1),
                                        Color.fromRGBO(143, 148, 251, .6),
                                      ]
                                  )
                              ),
                              child: Center(
                                child: GestureDetector(
                                    onTap: () {
                                      _scan();
                                    },
                                    child: Text("Scan", style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),)),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
              )
      );
    }

    Future _scan() async {
      String id;
      await Permission.camera.request();
      String barcode = await scanner.scan();
      if (barcode == null) {
        print('nothing return.');
      } else {
        print(barcode);
        Firestore.instance.collection("Restaurants").where(
            "name", isEqualTo: barcode).get().then((value) {
          print("fuck Ned "+value.toString());
          value.documents.forEach((element) {
            id = element.documentID;
            Firestore.instance.collection("Users").document(
                FirebaseAuth.instance.currentUser.email).collection(
                "Restaurants").document().setData({
                'name': element["name"],
                'location': element["location"],
                'phone': element["phone"],
                'image': element["image"],
                'pdf': element["pdf"],
                'description': element["description"],
                "time": DateTime.now()
            }).then((value) {
              Firestore.instance.collection("Enteries").get().then((value) {
                value.documents.forEach((element) {
                 if(element['email'] == email) {
                   restaurants.add(Enteries(
                       element['restaurant'],
                       element['time']
                   ));
                 }
                });
              }).then((_){
                List<String> restaurantNames = restaurants.map((e){
                  return e.restaurant;
                }).toList();
                bool check = false;
                if(restaurants.isEmpty){
                  check = true;
                }else{
                  restaurantNames.forEach((element){
                    if(element != barcode){
                      check = true;
                    }
                  });
                }

                if(check){
                  Firestore.instance.collection("Enteries").document().setData({
                    'restaurant': barcode,
                    'name': name,
                    'email': email,
                    'image': url,
                    'address': address,
                    'phone': phone,
                    'time': DateTime.now()
                  });
                }else{
                  List<Enteries> filteredEnteries = restaurants.where((element){
                    return element.restaurant == barcode ? true : false;
                  }).toList();
                  List<DateTime> times = filteredEnteries.map((e){
                    return e.time.toDate();
                  }).toList();
                  //times.reduce((curr, next) => curr > next? curr: next);
                  final closetsDateTimeToNow = times.reduce((a, b) => a.difference(DateTime.now()).abs() < b.difference(DateTime.now()).abs() ? a : b);
                  String difference = DateTime.now().difference(closetsDateTimeToNow).toString();
                  print(difference);
                  int difference1 = int.parse(difference.split(":")[0]);
                  if(difference1 > 1){
                    Firestore.instance.collection("Enteries").document().setData({
                      'restaurant': barcode,
                      'name': name,
                      'email': email,
                      'image': url,
                      'address': address,
                      'phone': phone,
                      'time': DateTime.now()
                    }).then((value){
                      Alert(
                        context: context,
                        title: "Alert",
                        desc: "You have Scanned Successfully",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "Ok",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () => Navigator.pop(context),
                            color: primary,
                          ),
                        ],
                      ).show();
                    });
                  }else{
                    print("fuck off Ned");
                    Alert(
                      context: context,
                      title: "Alert",
                      desc: "You have already Scanned QRcode",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "Ok",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          color: primary,
                        ),
                      ],
                    ).show();
                  }
                }
              });
              // restaurants.forEach((element) {
              //   if(element.restaurant != barcode){
              //
              //   }else{
              //     print(Timestamp.now().toDate().difference(element.time.toDate()));
              //     print(element.time.toDate());
              //     print(Timestamp.now().toDate());
              //     String difference = Timestamp.now().toDate().difference(element.time.toDate()).toString();
              //     print(difference.split(":")[0]);
              //     int difference1 = int.parse(difference.split(":")[0]);
              //     if(difference1 > 1){
              //       // enable
              //       Firestore.instance.collection("Enteries").document().setData({
              //         'restaurant': barcode,
              //         'name': name,
              //         'email': email,
              //         'image': url,
              //         'address': address,
              //         'phone': phone,
              //         'time': DateTime.now()
              //       });
              //     }else{
              //       // not
              //       print("dafa ho jao Hassan");
              //     }
              //   }
              // });
              // Firestore.instance.collection("Enteries").where('restaurant',isEqualTo: barcode).get().then((value) {
              //   value.documents.forEach((element) {
              //     //print(element);
              //     //print(json.decode(element.toString()));
              //     // restaurants.add(Enteries(
              //     //     element.documentID,
              //     //     element['email'],
              //     //     element['name'],
              //     //     element['phone'],
              //     //     element['address'],
              //     //     element['restaurant'],
              //     //     element['image'],
              //     //     element['time']
              //     // ));
              //   });
              // }).then((value1){
              //   restaurants.forEach((element) {
              //     print(Timestamp.now().toDate().difference(element.time.toDate()));
              //     print(element.time.toDate());
              //     print(Timestamp.now().toDate());
              //     String difference = Timestamp.now().toDate().difference(element.time.toDate()).toString();
              //     print(difference.split(":")[0]);
              //     int difference1 = int.parse(difference.split(":")[0]);
              //     if(difference1 > 1){
              //       Firestore.instance.collection("Enteries").document().setData({
              //         'restaurant': barcode,
              //         'name': name,
              //         'email': email,
              //         'image': url,
              //         'address': address,
              //         'phone': phone,
              //         'time': DateTime.now()
              //       });
              //     }else{
              //       print("Fuck off");
              //     }
              //   });
              // });
            });
          });
        });
      }
    }
  }
