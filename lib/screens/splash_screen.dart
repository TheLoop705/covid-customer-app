import 'dart:async';

import 'package:customer/Animation/FadeAnimation.dart';
import 'package:customer/Animation/bottomAnimation.dart';
import 'package:customer/screens/home.dart';
import 'package:customer/screens/login.dart';
import 'package:customer/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Timer(
        Duration(seconds:5),
            (){
            checkUser();
        }
    );
    // TODO: implement initState
    super.initState();
  }

  Future<void> checkUser() async{
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    var sessionEmail = prefs.getString('email');
    if(sessionEmail == null){
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
    else{
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 280,
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
                            child: Text("Restaurant", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
                          ),
                        )),
                      )
                    ],
                  ),
                ),
                WidgetAnimator(
                    SvgPicture.asset(
                      "assets/images/splash.svg",
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width * 0.4,
                      semanticsLabel: 'Restaurant'
                  ),
                ),
                WidgetAnimator(
                  SpinKitRipple(
                    color: primary,
                    size: 50.0,
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}
