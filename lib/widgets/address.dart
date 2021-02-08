import 'dart:convert';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/models/user_model.dart';
import 'package:grocery/provider/auth.dart';
import 'package:grocery/widgets/OrderComplete.dart';
import 'package:grocery/screens/MyCart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Address extends StatefulWidget {
  final dynamic deliveryCharge;
  Address({Key key, this.deliveryCharge}) : super(key: key);

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  Position position;

  String msg = '';

  bool selected1=false;
  getLocation() async {
    position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    List<Placemark> newPlace = await Geolocator().placemarkFromCoordinates(
        position.latitude, position.longitude,
        localeIdentifier: 'en');
    Placemark placeMark = newPlace[0];
    String name = placeMark.name;
    String subLocality = placeMark.subLocality;
    String locality = placeMark.locality;
    String administrativeArea = placeMark.administrativeArea;
    String postalCode = placeMark.postalCode;
    String country = placeMark.country;
    setState(() {
      address =
          "$name, $subLocality, $locality, $administrativeArea $postalCode, $country";
    });
    final authprovider = Provider.of<AuthProvider>(context, listen: false);
    authprovider.updateAddress(address, position.longitude, position.latitude);
    // print(placemark.toString());
  }

  String address = '';
  User u;
  bool isLoading=true;
  fetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     u= User.fromJson(json.decode(prefs.getString('response')));
    setState(() {
      address = u.data.address + " " + u.data.pincode;
      isLoading=false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  bool selected = false;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Location"),
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => changeScreen(context, Checkout())),
          ),
          body: Stack(
            fit: StackFit.expand,
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Container(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          dense: true,
                          onTap: () => getLocation(),
                          leading: Container(
                            height: 50,
                            width: 50,
                            child: Image.asset('images/address.png'),
                          ),
                          title: Text(
                            'Use My Current Location',
                            style: Theme.of(context).textTheme.subtitle1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Text(
                        '--Or--',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              // border: Border.all(),
                              color: white,
                              boxShadow: [
                                BoxShadow(
                                    color: Theme.of(context)
                                        .hintColor
                                        .withOpacity(0.15),
                                    offset: Offset(0, 3),
                                    blurRadius: 10)
                              ],
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            dense: true,
                            isThreeLine: true,
                            selected: selected,
                            enabled: true,
                            onTap: () {
                              setState(() {
                                selected = !selected;
                              });
                            },
                            leading: selected
                                ? Icon(Icons.radio_button_checked)
                                : Icon(Icons.radio_button_unchecked),
                            title: Text('Current Location'),
                            subtitle: Text(
                              address,
                              style: Theme.of(context).textTheme.subtitle1,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              // border: Border.all(),
                              color: white,
                              boxShadow: [
                                BoxShadow(
                                    color: Theme.of(context)
                                        .hintColor
                                        .withOpacity(0.15),
                                    offset: Offset(0, 3),
                                    blurRadius: 10)
                              ],
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            dense: true,
                            isThreeLine: true,
                            selected: selected1,
                            enabled: true,
                            onTap: () {
                              final authprovider = Provider.of<AuthProvider>(
                                  context,
                                  listen: false);
                              authprovider.updateAddress(u.data.paddress??'',
                                  u.data.longitude??'', u.data.latitude??''); 
                              setState(() {
                                selected1 = !selected1;
                              });
                            },
                            leading: selected1
                                ? Icon(Icons.radio_button_checked)
                                : Icon(Icons.radio_button_unchecked),
                            title: Text('Permanent Address'),
                            subtitle: isLoading?Text('Loading...'):Text(
                              u.data.paddress??'',
                              style: Theme.of(context).textTheme.subtitle1,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              selected || selected1
                  ? Positioned(
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              msg,
                              style: TextStyle(color: red),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: RoundedLoadingButton(
                                color: green,
                                controller: _btnController,
                                child: Text(
                                  'Place Order',
                                  style: TextStyle(color: white),
                                ),
                                onPressed: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String token = prefs.getString('token');
                                  var response = await http.post(CREATEORDER,
                                      headers: {"Authorization": token});
                                  print(response.body);
                                  if (response.statusCode == 200) {
                                    _btnController.success();
                                    changeScreenRepacement(
                                        context,
                                        OrderSuccess(
                                            deliveryCharge:
                                                widget.deliveryCharge));
                                  } else {
                                    setState(() {
                                      msg =
                                          json.decode(response.body)['message'];
                                    });
                                    _btnController.error();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          )),
    );
  }
}
