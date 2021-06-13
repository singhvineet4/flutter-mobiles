import 'package:flutter/material.dart';

import 'timer_count.dart';

class MyApp extends StatefulWidget {
  final data;
  final index;
  MyApp(this.data, this.index);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String secondButtonText = 'Record video';
  double textSize = 20;
  int index = 0;

  @override
  void initState() {
    super.initState();
  }

// to update the index after one question
  updateIndex() {
    setState(() {
      index += 1;
    });
    return index;
  }

  @override
  Widget build(BuildContext context) {
    index = widget.index;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SafeArea(
            child: (widget.data['interview_que'] == null)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: <Widget>[
                      SizedBox(
                        height: 100,
                      ),
                      Text(
                        widget.data['Job Title'].toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        widget.data['job_code'].toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          widget.data['interview_que'][index]['question']
                              .toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 22),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TimerCount(updateIndex, widget.data, index),
                              ),
                            );
                          },
                          child: Text(secondButtonText,
                              style: TextStyle(
                                  fontSize: textSize, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
          ),
        ));
  }
}
