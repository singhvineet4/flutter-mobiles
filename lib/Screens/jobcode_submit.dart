import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recording_app/CommonFun/cliping_header.dart';
import 'package:recording_app/CommonFun/genralfunctions.dart';
import 'package:recording_app/CommonFun/progresshud.dart';
import 'package:recording_app/Sharedpref/shared_preference.dart';

import 'recording_home.dart';

class JobCodePage extends StatefulWidget {
  @override
  _JobCodePageState createState() => _JobCodePageState();
}

class _JobCodePageState extends State<JobCodePage> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  TextEditingController _jobCodeController = new TextEditingController();
  String loginToken;
  bool isApiCallProcess = false;

  @override
  void initState() {
    super.initState();

    SharedPref().getLoginToken().then((value) {
      setState(() {
        loginToken = value;
      });
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _jobCodeController.dispose();
    super.dispose();
  }

  Future<void> validationCode(BuildContext context) async {
    String userJobCode = _jobCodeController.text;
    if (userJobCode.isEmpty) {
      Generalfunction().showToast('Please enter job code');
    } else {
      setState(() {
        isApiCallProcess = true;
      });
      jobCodeAPI(_jobCodeController.text);
    }
  }

  jobCodeAPI(jobCode) async {
    Map data = {"job_code": jobCode};

    var response = await http.post(
        "https://www.hiringmirror.com/api/varify-job-code.php",
        body: data,
        headers: {
          'Authorization': 'Bearer $loginToken',
        });

    setState(() {
      isApiCallProcess = true;
    });

    if (response.statusCode == 200) {
      print(response.body + "ck----------------------------------- rk");

      var jsonData = json.decode(response.body);
      print("Job code and questions response" + jsonData.toString());
      var status = jsonData['status'];
      print("job code response status code" + status.toString());
      if (status != 401) {
        setState(() {
          isApiCallProcess = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyApp(jsonData, 1)),
        );
      } else {
        setState(() {
          isApiCallProcess = false;
        });
        Generalfunction().showToast('Job code did not match');
      }
    } else {
      setState(() {
        isApiCallProcess = false;
      });
      Generalfunction().showToast('Please enter valid job code.//server error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ProgressHUD(
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    decoration: BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage('images/background_login.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 70.0, bottom: 80.0),
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          'images/logo.png',
                          height: 150,
                          width: 200,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Please enter your job code, that we have sent on your email.",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  margin: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20.0),
                  child: Row(
                    children: <Widget>[
                      new Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15.0),
                        child: Icon(
                          Icons.code,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        height: 30.0,
                        width: 1.0,
                        color: Colors.grey.withOpacity(0.5),
                        margin: const EdgeInsets.only(left: 00.0, right: 10.0),
                      ),
                      new Expanded(
                        child: TextFormField(
                          controller: _jobCodeController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Job code',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  color: Colors.red,
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: 40,
                  child: RaisedButton(
                      onPressed: () {
                        validationCode(context);
                      },
                      child: Text(
                        "Next",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
