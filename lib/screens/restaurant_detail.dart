import 'package:auto_size_text/auto_size_text.dart';
import 'package:customer/Animation/bottomAnimation.dart';
import 'package:customer/screens/pdf_view.dart';
import 'package:customer/utils/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantDetail extends StatefulWidget {
  final String name;
  final String location;
  final String phone;
  final String description;
  final String image;
  final String pdf;

  const RestaurantDetail({Key key, this.name, this.location, this.phone, this.description, this.image, this.pdf}) : super(key: key);
  @override
  _RestaurantDetailState createState() => _RestaurantDetailState();
}

class _RestaurantDetailState extends State<RestaurantDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: ListView(
        children: [
          WidgetAnimator(
            Container(
                height: 300,
                child: Image.network(widget.image,fit: BoxFit.fitHeight,)),
          ),
          WidgetAnimator(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.phone,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                  ),
                ],
              ),
            ),
          ),
          WidgetAnimator(
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.location)
                ],
              ),
            ),
          ),
          WidgetAnimator(
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: AutoSizeText(widget.description,maxLines: 5)),
            ),
          ),
          WidgetAnimator(
             Padding(
              padding: const EdgeInsets.only(left:18.0,right: 18.0,top: 20,bottom: 10),
              child: FlatButton.icon(
                padding: EdgeInsets.only(top: 15,bottom: 15),
                  color: primary,
                  onPressed: (){
                  showMenu(widget.pdf);
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => PdfView(url: widget.pdf)));
                  },
                  icon: Icon(Icons.restaurant,color: Colors.white,),
                  label: Text("Restaurant's Menu",style: TextStyle(color: Colors.white),)
              ),
            ),
          )
        ],
      ),
    );
  }
  showMenu(String menuUrl) async {
    final url =  menuUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
