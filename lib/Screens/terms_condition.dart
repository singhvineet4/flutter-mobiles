import 'package:flutter/material.dart';
import 'package:recording_app/CommonFun/progresshud.dart';
import 'package:recording_app/Screens/jobcode_submit.dart';

class Terms extends StatefulWidget {
  @override
  _TermsState createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  bool value = false;
  bool isApiCallProcess = false;

  @override
  //App widget tree
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Terms and conditions'),
          backgroundColor: Colors.greenAccent[400],
        ), //AppBar
        body: ProgressHUD(
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
          child: Center(
            /** Card Widget **/
            child: Card(
              child: Padding(
                padding: const EdgeInsets.only(),
                child: SizedBox(
                  width: 430,
                  height: 700,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ), //SizedBox
                          Text(
                            'I have read and agree to all Terms\n of Service',
                            style: TextStyle(fontSize: 16.0),
                          ), //Text
                          //SizedBox
                          /** Checkbox Widget **/
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Checkbox(
                              value: this.value,
                              onChanged: (bool value) {
                                setState(() {
                                  this.value = value;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => JobCodePage()),
                                  );
                                });
                              },
                            ),
                          ), //Checkbox
                        ], //<Widget>[]
                      ), //Row
                    ],
                  ), //Column
                ), //SizedBox
              ), //Padding
            ), //Card
          ),
        ), //Center//Center
      ), //Scaffold
    ); //MaterialApp
  }
}
