import 'package:flutter/material.dart';
import 'package:grocery/helpers/commons.dart';
import 'package:grocery/helpers/navigation.dart';
import 'package:grocery/provider/auth.dart';
import 'package:grocery/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ExistingCustomer extends StatefulWidget {
  final int area;
  final int cityId;
  final bool signup;
  final String title;
  ExistingCustomer({this.area, this.cityId, this.signup, this.title});

  @override
  _ExistingCustomerState createState() => _ExistingCustomerState();
}

class _ExistingCustomerState extends State<ExistingCustomer> {
  bool hasError = false;
  String errorMessage = '';
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    final authprovider = Provider.of<AuthProvider>(context);

    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back_ios),
      //     onPressed: () => changeScreen(context, LoginScreen()),
      //   ),
      //   title: Text(
      //     widget.title,
      //     style: TextStyle(color: white),
      //   ),
      //   backgroundColor: pcolor,
      // ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Welcome',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 250,
                    child: Image.asset(
                      'images/login.gif',

                      // ,scale: 2,
                    ),
                  ),
                  Text(
                    'LOGIN',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  FractionallySizedBox(
                    widthFactor: .8,
                    child: TextFormField(
                      controller: authprovider.userId,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.length == 0) {
                          _btnController.stop();
                          return 'cannot be empty';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'Enter email or phoneno.',
                          labelText: 'Email or Phone',
                          hintStyle: TextStyle(fontSize: 15)),
                    ),
                  ),
                 SizedBox(height: 20,),
                  FractionallySizedBox(
                    widthFactor: .8,
                    child: TextFormField(
                      controller: authprovider.password,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.length == 0) {
                          _btnController.stop();
                          return 'cannot be empty';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'Enter password',
                          labelText: 'Password',
                          hintStyle: TextStyle(fontSize: 15)),
                    ),
                  ),
                  hasError
                      ? Text(
                          errorMessage + "!!",
                          style: TextStyle(color: red),
                        )
                      : Text(''),
                  SizedBox(
                    height: 20,
                  ),
                  RoundedLoadingButton(
                    child: Text('Login',
                        style: TextStyle(color: Colors.white)),
                    controller: _btnController,
                    color: green,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        String message = await authprovider.login();
                        setState(() {
                          hasError=true;
                          errorMessage = message;
                        });
                        if (message == 'success') {
                          _btnController.success();
                          changeScreenRepacement(context, HomePage());
                        } else {
                          print(message);
                          _btnController.reset();
                        }
                      } else {
                        _btnController.reset();
                      }
                    },
                    width: 200,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
