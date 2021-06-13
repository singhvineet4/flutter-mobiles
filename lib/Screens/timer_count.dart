import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:recording_app/CommonFun/genralfunctions.dart';
import 'package:recording_app/CommonFun/progresshud.dart';
import 'package:recording_app/Screens/recording_home.dart';
import 'package:recording_app/Sharedpref/shared_preference.dart';

import 'success_page.dart';

class TimerCount extends StatefulWidget {
  final updateindex;
  final data;
  final index;
  TimerCount(this.updateindex, this.data, this.index);

  @override
  _TimerCountState createState() => _TimerCountState();
}

class _TimerCountState extends State<TimerCount> {
  int countdownTimer;
  String secondButtonText = 'Record video';
  String loginToken;
  String userId;
  bool isloading = false;
  int index;

  countDownTimer() async {
    for (int x = 3; x >= 0; x--) {
      await Future.delayed(Duration(seconds: 1)).then((_) {
        setState(() {
          countdownTimer = x;
        });
        if (x == 0) recordVideo();
      });
    }
  }

  recordVideo() async {
    // ignore: deprecated_member_use
    ImagePicker.pickVideo(source: ImageSource.camera)
        .then((File recordedVideo) {
      if (recordedVideo != null && recordedVideo.path != null) {
        setState(() {
          secondButtonText = 'saving in progress.....';
        });
        GallerySaver.saveVideo(recordedVideo.path).then((dynamic path) {
          print("video address---------------------" + recordedVideo.path);
        });
        _fetchVideo(recordedVideo, widget.data);
        print('final recorded video');
      }
    });
  }

  Future _fetchVideo(File filename, data) async {
    setState(() {
      isloading = true;
    });
    var headers = {'Authorization': 'Bearer $loginToken'};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://www.hiringmirror.com/api/video-interview-answer-upload.php'));
    request.fields.addAll({
      'interview_code': widget.data['interview_que'][index]['interview_code'],
      'interview_id': widget.data['interview_que'][index]['interview_id'],
      'que_id': widget.data['interview_que'][index]['queid'],
      'job_id': widget.data['interview_que'][index]['job_id'],
      'user_id': '$userId',
    });
    request.files
        .add(await http.MultipartFile.fromPath('video', filename.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      setState(() {
        isloading = false;
        index = index + 1;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => (widget.data['interview_que'].length > index)
                ? MyApp(widget.data, index)
                : Success()),
      );
      /* Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyApp(widget.data, index)),
      );*/ //need to change condition ckkk
    } else {
      print(response.reasonPhrase);
      Generalfunction().showToast(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    super.initState();
    SharedPref().getLoginToken().then((value) {
      print("Chandra kant login print" + value.toString());
      setState(() {
        loginToken = value;
      });
    });
    SharedPref().getUserId().then((value) {
      print("userid print" + value.toString());
      setState(() {
        userId = value;
      });
    });

    countDownTimer();
  }

  @override
  Widget build(BuildContext context) {
    var x;
    index = widget.index;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Text(
              (countdownTimer != null) ? countdownTimer.toString() : '',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 80,
                  fontWeight: FontWeight.bold),
            ),
          ),
          if (isloading && x != 0)
            Center(
                child: Card(
              child: Container(
                width: 100,
                height: 100,
                color: Colors.black54,
                child: ProgressHUD(
                    child: Text(
                      "Uploading..",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    color: Colors.red,
                    //opacity: 1,
                    inAsyncCall: isloading),
              ),
            ))
        ],
      ),
    );
  }
}
