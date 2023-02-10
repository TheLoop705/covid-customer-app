import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:customer/screens/login.dart';
import 'package:customer/screens/profile.dart';
import 'package:customer/screens/qr_scan.dart';
import 'package:customer/screens/resturants.dart';
import 'package:customer/screens/setting.dart';
import 'package:customer/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FSBStatus drawerStatus;
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  List<Map<String,Object>> _pages = [
      {'title': 'QrCode'},
      {'title': 'Restaurants'},
      {'title': 'Profile'}
  ];
  int _selectedPageIndex = 0;

  void _selectPage(int index){
    setState(() {
      _selectedPageIndex = index;
    });
  }

  PageController pageController;
  int pageIndex = 0;
  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onItemSelected(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
    _pages = [
      {'title': 'QrCode'},
      {'title': 'Restaurants'},
      {'title': 'Profile'}
    ];
    getUser();
  }

  String name,email,phone,address,url;

  Future<void> getUser() async{
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email');
      url = prefs.getString('pic');
      name = prefs.getString('name');
      phone = prefs.getString('phone');
      address = prefs.getString('address');
      print(url);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FoldableSidebarBuilder(
        drawerBackgroundColor: primary,
        drawer: CustomDrawer(
          name: name,
          email: email,
          url: url,
          closeDrawer: (){
          setState(() {
            drawerStatus = FSBStatus.FSB_CLOSE;
          });
        },),
        screenContents: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  setState(() {
                    drawerStatus = drawerStatus == FSBStatus.FSB_OPEN ? FSBStatus.FSB_CLOSE : FSBStatus.FSB_OPEN;
                  });
                }
            ),
            backgroundColor: primary,
            centerTitle: true,
            title: Text(_pages[_selectedPageIndex]['title']),
            actions: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Restaurant"),
                      content: Text("Do you want to logout?"),
                      actions: [
                        FlatButton(
                          child: Text("Yes",style: TextStyle(color: primary),),
                          onPressed:  () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.remove('email');
                            prefs.remove('pic');
                            prefs.remove('name');
                            prefs.remove('phone');
                            prefs.remove('address');
                            _signOut(context);
                          },
                        ),
                        FlatButton(
                          child: Text("No",style: TextStyle(color: primary),),
                          onPressed:  () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(Icons.exit_to_app),
              ),
            ],
          ),
          body: PageView(
            children: <Widget>[
              QrCode(),
              ResturentsPage(),
              Profile()
            ],
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: onPageChanged,
          ),
          bottomNavigationBar: CurvedNavigationBar(
            key: _bottomNavigationKey,
            index: 0,
            height: 50.0,
            items: <Widget>[
              Icon(Icons.qr_code, size: 30,color: Colors.white,),
              Icon(Icons.restaurant, size: 30,color: Colors.white,),
              Icon(Icons.perm_identity, size: 30,color: Colors.white,),
            ],
            color: primary,
            buttonBackgroundColor: primary,
            backgroundColor: Colors.white,
            animationCurve: Curves.easeInOut,
            animationDuration: Duration(milliseconds: 600),
            onTap: (value){
              _selectPage(value);
              onItemSelected(value);
            },
            letIndexChange: (index) => true,
          ),
        ),
        status: drawerStatus,
      ),
    );
  }
  Future<void> _signOut(BuildContext context) async{
    await FirebaseAuth.instance.signOut().then((_) {
      Navigator.of(context).pop();
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    });
  }
}

class CustomDrawer extends StatelessWidget {

  final String url;
  final String name;
  final String email;
  final Function closeDrawer;

  const CustomDrawer({Key key, this.closeDrawer, this.url, this.name, this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Container(
      width: mediaQuery.size.width * 0.60,
      height: mediaQuery.size.height,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                width: double.infinity,
                height: 180,
                color: primary,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: primary,
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 50,
                          backgroundImage: NetworkImage(this.url == null ? 'https://www.w3schools.com/howto/img_avatar.png' : this.url)
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(this.name == null? "Username" : this.name,style: TextStyle(color: Colors.white),),
                    Text(this.email == null ? "Email" : this.email,style: TextStyle(color: Colors.white),)
                  ],
                )),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ResturentsPage(type: "abc",)));
              },
              leading: Icon(Icons.restaurant,color: Colors.white,),
              title: Text("Restaurant",style: TextStyle(color: Colors.white),),
            ),
            Divider(
              height: 1,
              color: Colors.white,
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(type: "abc",)));
              },
              leading: Icon(Icons.person,color: Colors.white,),
              title: Text("Profile",style: TextStyle(color: Colors.white),),
            ),
            Divider(
              height: 1,
              color: Colors.white,
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Setting()));
              },
              leading: Icon(Icons.settings,color: Colors.white,),
              title: Text("Settings",style: TextStyle(color: Colors.white),),
            ),
            Divider(
              height: 1,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}






