import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:recording_app/CommonFun/cliping_header.dart';

class Generalfunction {
  get setState => null;

  Future<void> showToast(String msg) async {
    Fluttertoast.showToast(
        msg: '$msg',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 14.0);
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  Widget headerView(String headername) {
    return Container(
      decoration: BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage('images/background_login.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: new ClipPath(
        clipper: MyClipper(),
        child: Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(left: 20, top: 55.0, bottom: 55.0),
          child: Column(
            children: <Widget>[
              Text(
                '$headername',
                style: TextStyle(
                    color: Colors.white, fontSize: 22, fontFamily: 'Schyler'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showdialog(BuildContext context, isLoading) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: SizedBox(
              width: 320,
              height: 400,
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Text("Video uploaded successfully."),
            ),
            //content: Text("Video uploaded successfully."),
            /* actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],*/
          );
        });
  }
}
