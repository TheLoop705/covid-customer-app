import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/Animation/bottomAnimation.dart';
import 'package:customer/data.dart';
import 'package:customer/models/restaurants_model.dart';
import 'package:customer/screens/restaurant_detail.dart';
import 'package:customer/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResturentsPage extends StatefulWidget {
  final String type;

  const ResturentsPage({Key key, this.type}) : super(key: key);
  @override
  _ResturentsPageState createState() => _ResturentsPageState();
}

class _ResturentsPageState extends State<ResturentsPage> {
  List<restaurantModel> restaurants = [];
  List<restaurantModel> sortedRestaurants = [];
  @override
  initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      // send();
      setState(() {});
    });
    getRestaurants();
  }

  getRestaurants(){
    Firestore.instance.collection("Users").document(FirebaseAuth.instance.currentUser.email).collection("Restaurants").get().then((value){
      value.documents.forEach((element) {
         restaurants.add(restaurantModel(
             element.documentID,
             element['name'],
             element['phone'],
             element['location'],
             element['description'],
             element['pdf'],
             element['image']
         ));
      });
      print(restaurants);
      //restaurants.sort((a, b) => a.name.compareTo(b.name));
      restaurants.forEach((item) {
        var i = sortedRestaurants.indexWhere((x) => x.name == item.name);
        if (i <= -1) {
         setState(() {
           sortedRestaurants.add(item);
         });
        }
      });
      print(sortedRestaurants);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.type == "abc"?AppBar(
        title: Text("Restaurants"),
      ):null,
      body: ListView.builder(
          itemCount: sortedRestaurants.length,
          itemBuilder: (context,index) => WidgetAnimator(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.only(left:8.0,right: 8.0),
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantDetail(
                        name: sortedRestaurants[index].name,
                        location: sortedRestaurants[index].location,
                        phone: sortedRestaurants[index].phone,
                        image: sortedRestaurants[index].image,
                        pdf: sortedRestaurants[index].pdf,
                        description: sortedRestaurants[index].description,
                      )));
                    },
                    leading: CircleAvatar(
                        backgroundColor: primary,
                        radius: 50,
                        backgroundImage: NetworkImage(sortedRestaurants[index].image)
                    ),
                    title: Text(sortedRestaurants[index].name),
                    subtitle: Text(sortedRestaurants[index].location),
                  ),
                ),
              ),
            ),
          )
      )
    );
  }
}
