import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/Animation/FadeAnimation.dart';
import 'package:customer/screens/Signup.dart';
import 'package:customer/screens/home.dart';
import 'package:customer/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email,password;
  bool progress = false;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      // send();
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
                  height: 350,
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
                        height: 200,
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
                        height: 150,
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
                        height: 150,
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
                          margin: EdgeInsets.only(top: 50),
                          child: Center(
                            child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
                          ),
                        )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
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
                              child: TextField(
                                onChanged: (value){
                                  password = value;
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Enter your password",
                                    hintStyle: TextStyle(color: Colors.grey[400])
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                      SizedBox(height: 15,),
                      progress ? SpinKitRipple(color: primary,) :FadeAnimation(2, GestureDetector(
                        onTap: (){
                          signIn();
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
                            child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          ),
                        ),
                      )),
                      SizedBox(height: 15,),
                      FadeAnimation(1.5, GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Signup()));
                          },
                          child: Text("Don't have account? Register", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),))),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
  void signIn() async {
    final _auth = FirebaseAuth.instance;
    if(email == null || password == null) {
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
        final fuser = await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        DocumentReference documentReference = Firestore.instance.collection("Users").document(email);
        documentReference.get().then((datasnapshot) async {
          String phone = datasnapshot.data()["Phone"];
          String address = datasnapshot.data()["Address"];
          String name = datasnapshot.data()["Name"];
          String Email = datasnapshot.data()["Email"];
          String pic = datasnapshot.data()["image"];

          print(name);
          if(fuser != null) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('name', name);
            prefs.setString('email', Email);
            prefs.setString('phone', phone);
            prefs.setString('address', address);
            prefs.setString('pic', pic);
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
          }
          else{
            setState(() {
              progress = false;
            });
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Warning"),
                  content: Text("Invalid email and password"),
                )
            );
          }
        });
      }catch(e){
        setState(() {
          progress = false;
        });
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Warning"),
              content: Text("Invalid email and password"),
            )
        );
      }
    }
  }
}