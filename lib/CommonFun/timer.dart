import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  CountDownController _controller = CountDownController();
  String secondButtonText = 'Record video';
  double textSize = 20;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // countDownTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer'),
        centerTitle: true,
      ),
      body: Center(
        child: CircularCountDownTimer(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 2,
          duration: 4,
          fillColor: Colors.amber,
          ringColor: Colors.white,
          controller: _controller,
          backgroundColor: Colors.white54,
          strokeWidth: 10.0,
          strokeCap: StrokeCap.round,
          isTimerTextShown: true,
          isReverse: true,
          onComplete: () {
            /* setState(() {
              MyApp().recordVideo();
            });*/
          },
          textStyle: TextStyle(fontSize: 50.0, color: Colors.black),
        ),
      ),
    );
  }
}
