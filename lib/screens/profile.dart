import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/Animation/bottomAnimation.dart';
import 'package:customer/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as Path;

class Profile extends StatefulWidget {
  final String type;

  const Profile({Key key, this.type}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File _pickedImage;
  bool _status = true;
  bool loading = false;
  var email,url1,name,token;
  final FocusNode myFocusNode = FocusNode();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final sectionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
    getUser();
  }

  void _pickImage() async{
    final pickedImageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(_pickedImage.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(_pickedImage);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      print(fileURL + "afnan");
      setState(() {
        Firestore.instance.collection("Users").document(emailController.text).update({
           "image": fileURL,
        }).then((value){
          prefs.setString("pic", fileURL);
          url1 = fileURL;
          print("Data saved to firestore");
        });
      });
    });
  }

  Future<void> getUser() async{
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    setState(() {
      emailController.text = prefs.getString('email') == null ?"Your Email":prefs.getString('email');
      url1 = prefs.getString('pic');
      nameController.text = prefs.getString('name') == null ? "Your Username" :prefs.getString('name');
      phoneController.text = prefs.getString('phone') == null ? "Your Phone" :prefs.getString('phone');
      addressController.text = prefs.getString('address') == null ? "Your Address" : prefs.getString('address');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.type == "abc"? AppBar(
        title: Text("Profile"),
      ):null,
      body: Consumer<ThemeNotifier>(
          builder: (context,notifier,child) => Container(
            child: new ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(height: 10,),
                    WidgetAnimator(
                      GestureDetector(
                        onTap: (){
                          _pickImage();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CircleAvatar(
                            radius: 80,
                            backgroundColor: primary,
                            child: CircleAvatar(
                                backgroundColor: primary,
                                radius: 100,
                                backgroundImage: NetworkImage(url1 == null?'https://www.w3schools.com/howto/img_avatar.png':url1)
                            ),
                          ),
                        ),
                      ),
                    ),
                    new Container(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: 25.0,
                        ),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            WidgetAnimator(
                              Padding(
                                  padding: EdgeInsets.only(
                                    left: 25.0,
                                    right: 25.0,
                                  ),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Name',
                                            style: TextStyle(
                                                color: notifier.darkTheme ? Colors.white :primary,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: "Montserrat"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                            ),
                            WidgetAnimator(
                              GestureDetector(
                                onTap: () async{
                                  SharedPreferences  prefs = await SharedPreferences.getInstance();
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("Name",style: TextStyle(color: primary),),
                                        content: TextField(
                                          controller: nameController,
                                        ),
                                        actions: [
                                          FlatButton(
                                            child: Text("Update",style: TextStyle(color: Colors.white),),
                                            color: primary,
                                            onPressed: (){
                                               Firestore.instance.collection('Users').document(emailController.text).update({
                                                 'Name': nameController.text
                                               }).then((value){
                                                 setState(() {
                                                   prefs.setString('name', nameController.text);
                                                 });
                                               });
                                               Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      )
                                  );
                                },
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 2.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Flexible(
                                          child: new TextField(
                                            enabled: false,
                                            controller: nameController,
                                            decoration: const InputDecoration(
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                            WidgetAnimator(
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Email',
                                            style: TextStyle(
                                                color: notifier.darkTheme ? Colors.white :primary,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: "Montserrat"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                            ),
                            WidgetAnimator(
                              GestureDetector(
                                onTap: (){

                                },
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 2.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Flexible(
                                          child: new TextField(
                                            enabled: false,
                                            controller: emailController,
                                            decoration: const InputDecoration(
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                            WidgetAnimator(
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Phone',
                                            style: TextStyle(
                                                color: notifier.darkTheme ? Colors.white :primary,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: "Montserrat"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                            ),
                            WidgetAnimator(
                              GestureDetector(
                                onTap: () async{
                                  SharedPreferences  prefs = await SharedPreferences.getInstance();
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("Phone",style: TextStyle(color: primary),),
                                        content: TextField(
                                          controller: phoneController,
                                        ),
                                        actions: [
                                          FlatButton(
                                            child: Text("Update",style: TextStyle(color: Colors.white),),
                                            color: primary,
                                            onPressed: (){
                                              Firestore.instance.collection('Users').document(emailController.text).update({
                                                'Phone': phoneController.text
                                              }).then((value){
                                                setState(() {
                                                  prefs.setString('phone', phoneController.text);
                                                });
                                              });
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      )
                                  );
                                },
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 2.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Flexible(
                                          child: new TextField(
                                            enabled: false,
                                            controller: phoneController,
                                            decoration: const InputDecoration(
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ),

                            WidgetAnimator(
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Address',
                                            style: TextStyle(
                                                color: notifier.darkTheme ? Colors.white :primary,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: "Montserrat"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                            ),
                            WidgetAnimator(
                              GestureDetector(
                                onTap: () async{
                                  SharedPreferences  prefs = await SharedPreferences.getInstance();
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text("Address",style: TextStyle(color: primary),),
                                        content: TextField(
                                          controller: addressController,
                                        ),
                                        actions: [
                                          FlatButton(
                                            child: Text("Update",style: TextStyle(color: Colors.white),),
                                            color: primary,
                                            onPressed: (){
                                              Firestore.instance.collection('Users').document(emailController.text).update({
                                                'Address': addressController.text
                                              }).then((value){
                                                setState(() {
                                                  prefs.setString('address', addressController.text);
                                                });
                                              });
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      )
                                  );
                                },
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 2.0),
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Flexible(
                                          child: new TextField(
                                            enabled: false,
                                            controller: addressController,
                                            decoration: const InputDecoration(
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
      ),
    );
  }

  // update() async{
  //   if(nameController == null){
  //     print("Invalid Credentials");
  //     showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: Text("Warning"),
  //           content: Text("Invalid Credentials"),
  //         )
  //     );
  //   } else{
  //     try{
  //       setState(() {
  //         loading = true;
  //       });
  //       Map<String, String> body = {
  //         "name": nameController.text,
  //         "phone": null
  //       };
  //
  //       Response response = await post(
  //         "https://kpn.com.mm/api/update/user",
  //         headers: {
  //           "Content-Type": "application/json",
  //           'Authorization': 'Bearer $token',
  //         },
  //         body: jsonEncode(body),
  //       );
  //       print(response.body);
  //       final extractedData = json.decode(response.body);
  //       SharedPreferences  prefs = await SharedPreferences.getInstance();
  //       if(extractedData["error"] == false){
  //         setState(() {
  //           loading = false;
  //           nameController.text = extractedData["name"];
  //           prefs.setString('name', extractedData["name"]);
  //         });
  //         showDialog(
  //             context: context,
  //             builder: (context) => AlertDialog(
  //               title: Text("Update"),
  //               content: Text("Profile Updated"),
  //             )
  //         );
  //       }
  //       else{
  //         setState(() {
  //           loading = false;
  //         });
  //         print("Update Failed");
  //         showDialog(
  //             context: context,
  //             builder: (context) => AlertDialog(
  //               title: Text("Warning"),
  //               content: Text("Update failed please try again"),
  //             )
  //         );
  //       }
  //     }catch(e){
  //       setState(() {
  //         loading = false;
  //       });
  //       print("Update failed please try again");
  //       print(e.toString());
  //       showDialog(
  //           context: context,
  //           builder: (context) => AlertDialog(
  //             title: Text("Warning"),
  //             content: Text("Update failed please try again"),
  //           )
  //       );
  //     }
  //   }
  // }
  // updatePicture() async{
  //   if(_pickedImage == null){
  //     print("Invalid Credentials");
  //     showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: Text("Warning"),
  //           content: Text("Invalid Credentials"),
  //         )
  //     );
  //   } else{
  //     try{
  //       setState(() {
  //         loading = true;
  //       });
  //       Map<String, File> body = {
  //         "avatar": _pickedImage,
  //       };
  //
  //       Response response = await post(
  //         "https://kpn.com.mm/api/update/image",
  //         headers: {
  //           "Content-Type": "image/png",
  //           'Authorization': 'Bearer $token',
  //         },
  //         body: body,
  //       );
  //       print(response.body);
  //       final extractedData = json.decode(response.body);
  //       SharedPreferences  prefs = await SharedPreferences.getInstance();
  //       if(extractedData["error"] == false){
  //         setState(() {
  //           loading = false;
  //           print(extractedData);
  //         });
  //         showDialog(
  //             context: context,
  //             builder: (context) => AlertDialog(
  //               title: Text("Update"),
  //               content: Text("Profile Updated"),
  //             )
  //         );
  //       }
  //       else{
  //         setState(() {
  //           loading = false;
  //         });
  //         print("Update Failed");
  //         showDialog(
  //             context: context,
  //             builder: (context) => AlertDialog(
  //               title: Text("Warning"),
  //               content: Text("Update failed please try again"),
  //             )
  //         );
  //       }
  //     }catch(e){
  //       setState(() {
  //         loading = false;
  //       });
  //       print("Update failed please try again");
  //       print(e.toString());
  //       showDialog(
  //           context: context,
  //           builder: (context) => AlertDialog(
  //             title: Text("Warning"),
  //             content: Text("Update failed please try again"),
  //           )
  //       );
  //     }
  //   }
  // }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 30.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Save"),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () {

                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}