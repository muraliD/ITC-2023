import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:itc_community/screens/home/fragments/dashboard_page.dart';
import 'package:itc_community/screens/home/fragments/profile_page.dart';
import 'package:itc_community/screens/home/fragments/ranks_page.dart';
import 'package:itc_community/screens/home/fragments/withdraws_page.dart';
import 'package:itc_community/utils/my_colors.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:itc_community/screens/authentication/login_page.dart';
import 'package:itc_community/data/preferences.dart';
import 'package:itc_community/models/login_response.dart';

class DrawerItem {
  String title;
  IconData icon;
  bool isSelect;
  DrawerItem(this.title, this.icon, this.isSelect);
}

class MenuScreen extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("DashBoard", Icons.home, true),
    new DrawerItem("Ranks", Icons.grid_on, false),
    new DrawerItem("Withdraw", Icons.credit_card, false),
    new DrawerItem("Profile", Icons.person, false),
    new DrawerItem("Logout", Icons.logout, false)
  ];

  @override
  _MenuScreen createState() => _MenuScreen();
}

class _MenuScreen extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();

    Preferences.initSharedPreference();
  }

  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new DashboardFragment();
      case 1:
        return new RanksFragment();
      case 2:
        return new WithdrawsFragment();
      case 3:
        return new ProfileFragment();

      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    if (index == 4) {
      Preferences.initSharedPreference();

      Preferences.clearPreference();

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route route) => false);
      // Navigator.of(context).pop();
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) =>  LoginScreen(),
      //   ),
      // );
    } else {
      setState(() => _selectedDrawerIndex = index);
      Navigator.of(context).pop(); // close the drawer
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = Preferences.getUserDetails();

    var decoded = json.decode(user!);

    final payload = UserL.fromJson(decoded);

    var name = payload.name;
    var plan_name = payload.plan_name;
    var profilepic = payload.profilePic;
    var id = "ITC " + payload.id.toString();

    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(Column(
        children: [
          new ListTile(
            leading: new Icon(d.icon,
                color:
                    i == _selectedDrawerIndex ? Colors.indigo : Colors.black),
            title: Align(
              child: new Text(d.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    height: 2,
                    //line height 200%, 1= 100%, were 0.9 = 90% of actual line height
                    color: i == _selectedDrawerIndex
                        ? Colors.indigo
                        : Colors.black,
                    //font color
                    //background color

                    //make underline
                    decorationStyle: TextDecorationStyle.double,
                    //double underline
                    decorationColor: Colors.brown,
                    //text decoration 'underline' color
                    decorationThickness: 1.5, //decoration 'underline' thickness
                  )),
              alignment: Alignment(-1.2, 0),
            ),
            selected: i == _selectedDrawerIndex,
            onTap: () => _onSelectItem(i),
          ),
          Divider()
        ],
      ));
    }

    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Row(
          children: [
            Image.asset(
              'assets/images/itc_logo.png',
              scale: 40,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.drawerItems[_selectedDrawerIndex].title,
              style: TextStyle(color: Colors.white), //<-- SEE HERE
            ),
          ],
        ),
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        // title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
        // actions: [ //actions widget in appbar
        //   // IconButton(
        //   //     icon: Icon(Icons.camera),
        //   //     onPressed: (){
        //   //       //code to execute when this button is pressed
        //   //     }
        //   // ),
        //
        //   IconButton(
        //       icon: Icon(Icons.person),
        //       onPressed: (){
        //         //code to execute when this button is pressed
        //       }
        //   ),
        //   //more widgets to place here
        // ],
      ),
      drawer: SafeArea(
        child: new Drawer(
          child: Container(
            color: Colors.white,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: HexColor(MyColors.colorLogin),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                          height: 44,
                          child: Image.asset('assets/images/itc_logo.png')),
                    ),
                  ),
                ),
                Container(
                  color: HexColor(MyColors.colorLogin),
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(profilepic!),
                        ),
                      ),
                      Text(name!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text(plan_name!,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.white)),
                      Text(id!,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.white)),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
                Container(child: new Column(children: drawerOptions))
              ],
            ),
          ),
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}
