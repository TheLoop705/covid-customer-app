import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/Animation/FadeAnimation.dart';
import 'package:customer/screens/login.dart';
import 'package:customer/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String name,email,phone,address,password;
  bool progress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill
                      )
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(1, Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/light-1.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 100,
                        child: FadeAnimation(1.3, Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/light-2.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 100,
                        child: FadeAnimation(1.5, Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/clock.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        child: FadeAnimation(1.6, Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Center(
                            child: Text("Signup", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
                          ),
                        )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left:30.0,right: 30,bottom: 30),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(1.8, Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10)
                              )
                            ]
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey[100]))
                              ),
                              child: TextField(
                                onChanged: (value){
                                  name = value;
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Enter your name",
                                    hintStyle: TextStyle(color: Colors.grey[400])
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey[100]))
                              ),
                              child: TextField(
                                onChanged: (value){
                                   email = value;
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Enter your email",
                                    hintStyle: TextStyle(color: Colors.grey[400])
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey[100]))
                              ),
                              child: TextField(
                                onChanged: (value){
                                  phone = value;
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Enter your phone",
                                    hintStyle: TextStyle(color: Colors.grey[400])
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey[100]))
                              ),
                              child: TextField(
                                onChanged: (value){
                                  address = value;
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Enter your address",
                                    hintStyle: TextStyle(color: Colors.grey[400])
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8.0),
                              child: TextField(
                                onChanged: (value){
                                  password = value;
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey[400])
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                      SizedBox(height: 10,),
                      progress ? SpinKitRipple(color: primary,) : FadeAnimation(2, GestureDetector(
                        onTap: (){
                          signUp();
                        },
                        child: Container(
                          height: 50,
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
                            child: Text("Signup", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          ),
                        ),
                      )),
                      SizedBox(height: 10,),
                      FadeAnimation(1.5, GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                          },
                          child: Text("Already have account? Login", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),))),

                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
  void signUp() async {
    if(name == null || email == null || address == null || password == null || phone == null) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Warning"),
            content: Text("Fields cannot be empty"),
          )
      );
    }
    else{
      try{
        setState(() {
          progress = true;
        });
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        DocumentReference documentReference = Firestore.instance.collection("Users").document(email);
        Map<String, dynamic> users = {
          "Name": name,
          "Email": email,
          "Phone": phone,
          "Address": address,
          "image": null,
          "restaurants": []
        };
        documentReference.setData(users).whenComplete(() {
          print("$email created") ;
        }).then((value) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('name', name);
          prefs.setString('email', email);
          prefs.setString('phone', phone);
          prefs.setString('address', address);
          prefs.setString('pic', null);
        });
        setState(() {
          progress = false;
        });
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
       }catch(e){
        setState(() {
          progress = false;
        });
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Warning"),
              content: Text("Invalid email and password"+e.toString()),
            )
        );
      }
    }
  }
}