import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recording_app/CommonFun/cliping_header.dart';
import 'package:recording_app/CommonFun/genralfunctions.dart';
import 'package:recording_app/CommonFun/progresshud.dart';
import 'package:recording_app/Screens/jobcode_submit.dart';
import 'package:recording_app/Screens/signup_screen.dart';
import 'package:recording_app/Sharedpref/shared_preference.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  TextEditingController _useremailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  String errorText = '';
  IconData errorIcon;
  double errorContainerHeight = 0.0;
  bool isApiCallProcess = false;
  // Initially password is obscure
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _useremailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: ProgressHUD(
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
          child: new Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new ClipPath(clipper: MyClipper(), child: header()),
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0, top: 1),
                          child: Text(
                            "Email",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 16.0),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.5),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Row(
                            children: <Widget>[
                              new Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 15.0),
                                child: Icon(
                                  Icons.person_outline,
                                  color: Colors.grey,
                                ),
                              ),
                              Container(
                                height: 30.0,
                                width: 1.0,
                                color: Colors.grey.withOpacity(0.5),
                                margin: const EdgeInsets.only(
                                    left: 00.0, right: 10.0),
                              ),
                              new Expanded(
                                child: TextFormField(
                                  focusNode: emailFocusNode,
                                  controller: _useremailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter your email',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: Text(
                            "Password",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 16.0),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.5),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Row(
                            children: <Widget>[
                              new Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 15.0),
                                child: Icon(
                                  Icons.lock_open,
                                  color: Colors.grey,
                                ),
                              ),
                              Container(
                                height: 30.0,
                                width: 1.0,
                                color: Colors.grey.withOpacity(0.5),
                                margin: const EdgeInsets.only(
                                    left: 00.0, right: 10.0),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: _obscureText,
                                  focusNode: passwordFocusNode,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter your password',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                      color: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.4),
                                      icon: Icon(_obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 30.0),
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              /* GestureDetector(
                                onTap: () {},
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5, top: 10),
                                  child: Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),*/
                              Container(
                                width: 150,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    validation(context);
                                  },
                                  child: Container(
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xff580E33),
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 20, left: 20.0, right: 20.0),
                          child: Row(
                            children: <Widget>[
                              GestureDetector(
                                child: Container(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Don't have an account? Sign Up",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterPage()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          height: 40,
                          color: Colors.grey.withOpacity(0.10),
                          margin: const EdgeInsets.only(top: 50.0),
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(left: 20.0),
                                alignment: Alignment.center,
                                child: Text(
                                  "Thank you for using Hiring Mirror",
                                  //"DON'T HAVE AN ACCOUNT? Sign Up"
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget header() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.40,
      decoration: BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage('images/background_login.png'),
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 20.0, bottom: 80.0),
      child: Column(
        children: <Widget>[
          Image.asset(
            'images/logo.png',
            height: 170,
            width: 190,
          ),
        ],
      ),
    );
  }

  Future<void> validation(BuildContext context) async {
    String useremailvalue = _useremailController.text;
    String passwordValue = _passwordController.text;
    if (useremailvalue.isEmpty) {
      Generalfunction().showToast('Please enter email');
    } else if (!Generalfunction().validateEmail(useremailvalue)) {
      Generalfunction().showToast('Please enter valid email');
    } else if (passwordValue.isEmpty) {
      Generalfunction().showToast('Please enter password');
    } else if (passwordValue.length < 6) {
      Generalfunction().showToast('Please Enter password more than 6 digit');
    } else {
      setState(() {
        isApiCallProcess = true;
      });
      loginAPI(_useremailController.text, _passwordController.text, context);
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  loginAPI(String email, String password, context) async {
    Map data = {"email": email, 'password': password};
    var response = await http.post("https://www.hiringmirror.com/api/login.php",
        body: data);
    print(response.body.toString());
    setState(() {
      isApiCallProcess = true;
    });
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      print("login response" + jsonData.toString());
      var status = jsonData['code'];
      print("login response status code" + status.toString());

      if (status == '200') {
        var loginToken = jsonData['jwt'];
        var userId = jsonData['id'];
        print("login token" + loginToken.toString());
        print("user id" + userId.toString());

        SharedPref().setLoginToken(loginToken);
        SharedPref().setUserId(userId);
        setState(() {
          isApiCallProcess = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JobCodePage()),
        );
      } else {
        setState(() {
          isApiCallProcess = false;
        });
        Generalfunction().showToast('Email or password mismatch!');
      }
    } else {
      setState(() {
        isApiCallProcess = false;
      });
      Generalfunction().showToast('Email or password mismatch!');
    }
  }
}
