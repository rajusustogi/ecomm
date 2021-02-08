import 'dart:async';
import 'dart:convert';
import 'package:grocery/models/CartModel.dart';
import 'package:grocery/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum status { Uninitialized, Unauthenticated, Authenticating, Authenticated }

class AuthProvider with ChangeNotifier {
  status _status = status.Unauthenticated;
  final formkey = GlobalKey<FormState>();
  User res;
  status get Status => _status;
  TextEditingController userId = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController adddress = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController password = TextEditingController();

  TextEditingController otp = TextEditingController();
  //TextEditingController name = TextEditingController();
  AuthProvider.initialize() {
    _onStateChanged(res);
  }
  Future<User> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var response = await http.get(
      ME,
      headers: {"Authorization": token},
    );
    print(response.body);
    res = User.fromJson(json.decode(response.body));
    notifyListeners();
    return res;
  }

  Future<bool> updateAddress(address,longitude,latitude) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    var response = await http.put(ME, headers: {
      "Authorization": token
    }, body: {
      "address": address.toString(),
      "latitude":latitude.toString(),
      "longitude":longitude.toString()
    });
    print(response.body);
    if (response.statusCode == 200) {
      res = User.fromJson(json.decode(response.body));
      prefs.remove('reponse');
      prefs.setString('response', json.encode(res));
      return true;
    } else {
      print('failed');
      return false;
    }
  }

  Future<String> login() async {
    _status = status.Authenticating;
    notifyListeners();
    var response = await http.post(LOGIN, body: {
      "emailOrPhone": userId.text.trim(),
      "password": password.text.trim()
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      res = User.fromJson(json.decode(response.body));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('response', json.encode(res));
      prefs.setString('token', res.token);
      return 'success';
    } else {
      return json.decode(response.body)['message'];
    }
  }

  // Future<String> genOtpSignup() async {
  //   _status = status.Authenticating;
  //   notifyListeners();
  //   var response = await http.post(OTP, body: {"mobile_no": mobno.text.trim()});
  //   print('Response status: ${response.statusCode}');
  //   print('Response body: ${response.body}');
  //   if (response.statusCode == 200 &&
  //       json.decode(response.body)['data'] ==
  //           "OTP Generated, Kindly Register") {
  //     return json.decode(response.body)['otp'];
  //   } else {
  //     return 'Already Registered, Please Login';
  //   }
  // }

  Future<bool> inputotp(BuildContext context) async {
    var response = await http.post(LOGIN,
        body: {"mobile_no": userId.text.trim(), "otp": otp.text.trim()});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      _status = status.Authenticated;
      notifyListeners();
      res = User.fromJson(json.decode(response.body));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('response', json.encode(res));
      prefs.setString('token', res.token);
      // print(res.user.id);
      print('success');
      Provider.of<ProductModel>(context, listen: false).fetchProducts();

      return true;
    } else {
      print('failed');
      _status = status.Authenticating;
      notifyListeners();
      return false;
    }
  }

  // Future<bool> signup(cityId, locationId) async {
  //   var response = await http.post(SIGNUP, body: {
  //     "city_id": cityId,
  //     "location_id": locationId,
  //     "mobile_no": mobno.text.trim(),
  //     "otp": otp.text.trim()
  //   });
  //   print('Response status: ${response.statusCode}');
  //   print('Response body: ${response.body}');
  //   if (response.statusCode == 200) {
  //     _status = status.Authenticated;
  //     notifyListeners();
  //     res = Result.fromJson(json.decode(response.body));
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setString('response', json.encode(res));
  //     prefs.setString('token', res.token);

  //     print(res.user.id);
  //     print('success');
  //     return true;
  //   } else {
  //     print('failed');
  //     _status = status.Authenticating;
  //     notifyListeners();
  //     return false;
  //   }
  // }

  void clearController() {
    userId.text = "";
    otp.text = "";
    //email.text = "";
  }

  Future<void> _onStateChanged(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Result res = Result.fromJson(json.decode(prefs.getString('response')));
    // print(res.token);
    String token = prefs.getString('token');
    if (token == null) {
      _status = status.Unauthenticated;
    } else {
      _status = status.Authenticated;
      // _userModel = await _userServicse.getUserById(user.uid);
      // return _userModel;
    }
    notifyListeners();
  }
}
