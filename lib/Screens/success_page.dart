import 'package:flutter/material.dart';

class Success extends StatefulWidget {
  @override
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Thanks for completing video interview,"
                  " someone from the recruitment team will be in touch with you shortly.. ",
                  style: TextStyle(
                      color: Colors.lightBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
/*
Navigator.pushReplacement(
context,
MaterialPageRoute(
builder: (context) => (widget.data['interview_que'].length <= index)
? MyApp(widget.data, index)
: Success()),
);*/
