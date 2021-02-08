import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/models/user_model.dart';
import 'package:grocery/provider/auth.dart';
import 'package:grocery/screens/login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HistoryDetails.dart';

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  User user;
  fetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User u = User.fromJson(json.decode(prefs.getString('response')));

    setState(() {
      user = u;
    });
  }

  Future<Null> _refreshLocalGallery() async {
    await new Future.delayed(new Duration(seconds: 2));
    final authprovider = Provider.of<AuthProvider>(context, listen: false);
    User u = await authprovider.getUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('reponse');
    prefs.setString('response', json.encode(u));
    setState(() {
      user = u;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: _refreshLocalGallery,
      child: SingleChildScrollView(
        child: user == null
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text(
                                user.data.name,
                                textAlign: TextAlign.left,
                                style: Theme.of(context).textTheme.headline3,
                              ),
                              Text(
                                user.data.email,
                                style: Theme.of(context).textTheme.caption,
                              )
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ),
                        SizedBox(
                            width: 55,
                            height: 55,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(300),
                              onTap: () {},
                              child: CircleAvatar(
                                backgroundColor: white,
                                backgroundImage: NetworkImage(
                                    "https://static.thenounproject.com/png/17241-200.png"),
                              ),
                            )),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color:
                                Theme.of(context).hintColor.withOpacity(0.15),
                            offset: Offset(0, 3),
                            blurRadius: 10)
                      ],
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.person),
                          title: Text(
                            "Profile Settings",
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          dense: true,
                          title: Text(
                            "Full Name",
                          ),
                          trailing: Text(
                            user.data.name,
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          dense: true,
                          title: Text(
                            "EMAIL",
                          ),
                          trailing: Text(
                            user.data.email,
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          dense: true,
                          title: Text(
                            "Phone",
                          ),
                          trailing: Text(
                            user.data.mobileNo,
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          dense: true,
                          title: Text(
                            "Address",
                          ),
                          trailing: Container(
                            width: MediaQuery.of(context).size.width * .6,
                            height: 50,
                            alignment: Alignment.centerRight,
                            child: AutoSizeText(
                              user.data.paddress??'no address provided',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Container(
                  //   margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  //   decoration: BoxDecoration(
                  //     color: white,
                  //     borderRadius: BorderRadius.circular(10),
                  //     boxShadow: [
                  //       BoxShadow(
                  //           color:
                  //               Theme.of(context).hintColor.withOpacity(0.15),
                  //           offset: Offset(0, 3),
                  //           blurRadius: 10)
                  //     ],
                  //   ),
                  //   child: ListView(
                  //     shrinkWrap: true,
                  //     primary: false,
                  //     children: <Widget>[
                  //       ListTile(
                  //         leading: Icon(Icons.credit_card),
                  //         title: Text(
                  //           "Payment Settings",
                  //           style: Theme.of(context).textTheme.bodyText1,
                  //         ),
                  //         // trailing: ButtonTheme(
                  //         //   padding: EdgeInsets.all(0),
                  //         //   minWidth: 50.0,
                  //         //   height: 25.0,
                  //         //   // child: PaymentSettingsDialog(
                  //         //   //   creditCard: _con.creditCard,
                  //         //   //   onChanged: () {
                  //         //   //     _con.updateCreditCard(_con.creditCard);
                  //         //   //     //setState(() {});
                  //         //   //   },
                  //         //   // ),
                  //         // ),
                  //       ),
                  //       // ListTile(
                  //       //   dense: true,
                  //       //   title: Text(
                  //       //     S.of(context).default_credit_card,
                  //       //     style: Theme.of(context).textTheme.bodyText2,
                  //       //   ),
                  //       //   trailing: Text(
                  //       //     _con.creditCard.number.isNotEmpty
                  //       //         ? _con.creditCard.number.replaceRange(0, _con.creditCard.number.length - 4, '...')
                  //       //         : '',
                  //       //     style: TextStyle(color: Theme.of(context).focusColor),
                  //       //   ),
                  //       // ),
                  //     ],
                  //   ),
                  // ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color:
                                Theme.of(context).hintColor.withOpacity(0.15),
                            offset: Offset(0, 3),
                            blurRadius: 10)
                      ],
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      primary: false,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.settings),
                          title: Text(
                            "App Settings",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                           changeScreen(context, HistoryDetails());
                          },
                          dense: true,
                          title: Row(
                            children: <Widget>[
                              Icon(
                                Icons.translate,
                                size: 22,
                                color: Theme.of(context).focusColor,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'History',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ],
                          ),
                          
                        ),
                        // ListTile(
                        //   onTap: () {
                           
                        //   },
                        //   dense: true,
                        //   title: Row(
                        //     children: <Widget>[
                        //       Icon(
                        //         Icons.place,
                        //         size: 22,
                        //         color: Theme.of(context).focusColor,
                        //       ),
                        //       SizedBox(width: 10),
                        //       Text(
                        //         "Delivery Address",
                        //         style: Theme.of(context).textTheme.bodyText2,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        ListTile(
                          onTap: () {
                           
                          },
                          dense: true,
                          title: Row(
                            children: <Widget>[
                              Icon(
                                Icons.help,
                                size: 22,
                                color: Theme.of(context).focusColor,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Help Support",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.clear();

                            changeScreenRepacement(context, ExistingCustomer());
                          },
                          dense: true,
                          title: Row(
                            children: <Widget>[
                              Icon(
                                Icons.exit_to_app,
                                size: 22,
                                color: Theme.of(context).focusColor,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Logout",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          dense: true,
                          title: Text(
                            "Version 1.0.0",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          trailing: Icon(
                            Icons.remove,
                            color:
                                Theme.of(context).focusColor.withOpacity(0.3),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
      ),
    ));
  }
}
