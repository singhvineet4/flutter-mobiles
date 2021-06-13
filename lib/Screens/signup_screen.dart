import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:recording_app/CommonFun/cliping_header.dart';
import 'package:recording_app/CommonFun/genralfunctions.dart';
import 'package:recording_app/CommonFun/progresshud.dart';
import 'package:recording_app/Screens/loginscreen.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final Color primaryColor = Colors.white;
  final Color backgroundColor = Colors.white;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _mobileController = new TextEditingController();
  TextEditingController _confirmPasswordController =
      new TextEditingController();
  TextEditingController _resumeController = new TextEditingController();
  String errorText = '';
  IconData errorIcon;
  double errorContainerHeight = 0.0;
  String fileName;
  String path = '';
  String massage;
  Map<String, String> paths;
  List<String> extensions = ['txt', 'pdf', 'doc'];
  bool isLoadingPath = false;
  FileType fileType;
  bool isApiCallProcess = false;
  bool value = true;
  @override
  void initState() {
    // print("ck" + paths.toString());
    // TODO: implement initState
    // emailVerification(_emailController.text, context);
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _resumeController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  dynamic openFileExplorer() async {
    setState(() => isLoadingPath = true);
    try {
      path = await FilePicker.getFilePath(
          type: fileType != null ? fileType : FileType.custom,
          allowedExtensions: ['txt', 'pdf', 'docx']);
      print('ck file path11' + path);
      paths = null;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {
      isLoadingPath = false;
      fileName = path != null
          ? path.split('/').last
          : paths != null
              ? paths.keys.toString()
              : '...';
      print("ck file path" + fileName.toString());
    });
  }

  userRegistration(
    String firstName,
    String lastName,
    String email,
    String mobNumber,
    String password,
    String confirmPass,
    path,
  ) async {
    setState(() {
      isApiCallProcess = true;
    });
    var request = http.MultipartRequest('POST',
        Uri.parse('https://www.hiringmirror.com/api/register-with-resume.php'));
    request.fields.addAll({
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'confirmPassword': confirmPass,
      'contact': mobNumber
    });

    // var path;
    request.files.add(await http.MultipartFile.fromPath('resume', path));

    http.StreamedResponse response = await request.send();
    setState(() {
      isApiCallProcess = true;
    });
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      setState(() {
        isApiCallProcess = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      /* Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyApp(widget.data, index)),
      );*/ //need to change condition ckkk
    } else {
      setState(() {
        isApiCallProcess = false;
      });
      print(response.reasonPhrase);
      Generalfunction().showToast(response.reasonPhrase);
    }
  }

  Future<String> emailVerification(String email, context) async {
    Map data = {
      "email": email,
    };
    var response = await http.post(
        "https://www.hiringmirror.com/api/varify-email-address.php",
        body: data);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var status = jsonData['code'];
      var massage = jsonData['message'];
      print('ckkk' + massage);
      if (status == '200') {
        //var massage = jsonData['message'];
        print("email verify massage" + massage.toString());
      }
    }
    if (response.statusCode == 401) {
      return 'Email already exist';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProgressHUD(
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
        child: new Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: this.backgroundColor,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new ClipPath(
                    clipper: MyClipper(),
                    child: Container(
                      decoration: BoxDecoration(
                        image: new DecorationImage(
                          image: new AssetImage('images/background_login.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 60.0, bottom: 60.0),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Image.asset(
                              'images/logo.png',
                              width: 170,
                              height: 150,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0, top: 1),
                    child: Text(
                      "First name",
                      style: TextStyle(color: Colors.grey, fontSize: 16.0),
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
                            Icons.code,
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          height: 30.0,
                          width: 1.0,
                          color: Colors.grey.withOpacity(0.5),
                          margin:
                              const EdgeInsets.only(left: 00.0, right: 10.0),
                        ),
                        new Expanded(
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter your first name',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0, top: 1),
                    child: Text(
                      "Last name",
                      style: TextStyle(color: Colors.grey, fontSize: 16.0),
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
                          margin:
                              const EdgeInsets.only(left: 00.0, right: 10.0),
                        ),
                        new Expanded(
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter your last name',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0, top: 1),
                    child: Text(
                      "Email",
                      style: TextStyle(color: Colors.grey, fontSize: 16.0),
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
                            Icons.email,
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          height: 30.0,
                          width: 1.0,
                          color: Colors.grey.withOpacity(0.5),
                          margin:
                              const EdgeInsets.only(left: 00.0, right: 10.0),
                        ),
                        new Expanded(
                          child: TextFormField(
                            controller: _emailController,
                            onChanged: (value) {
                              print("ckrk");
                              emailVerification(value, context).then((value) {
                                setState(() {
                                  massage = value;
                                  print(value);
                                });
                              });
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter email',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            //   onChanged: ,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (massage != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Text(
                        massage.toString(),
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0, top: 1),
                    child: Text(
                      "Mobile number",
                      style: TextStyle(color: Colors.grey, fontSize: 16.0),
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
                            Icons.mobile_friendly,
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          height: 30.0,
                          width: 1.0,
                          color: Colors.grey.withOpacity(0.5),
                          margin:
                              const EdgeInsets.only(left: 00.0, right: 10.0),
                        ),
                        new Expanded(
                          child: TextFormField(
                            controller: _mobileController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter mobile number',
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
                      style: TextStyle(color: Colors.grey, fontSize: 16.0),
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
                          margin:
                              const EdgeInsets.only(left: 00.0, right: 10.0),
                        ),
                        new Expanded(
                          child: TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter password',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0),
                    child: Text(
                      " Confirm Password",
                      style: TextStyle(color: Colors.grey, fontSize: 16.0),
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
                          margin:
                              const EdgeInsets.only(left: 00.0, right: 10.0),
                        ),
                        new Expanded(
                          child: TextField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter confirm password',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0, top: 1),
                    child: Text(
                      "Upload your resume",
                      style: TextStyle(color: Colors.grey, fontSize: 16.0),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.15,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: new RaisedButton(
                            color: Colors.lightBlue,
                            onPressed: () => openFileExplorer(),
                            child: new Text("Upload your resume"),
                          ),
                        ),
                        if (path != null || paths != null)
                          new Container(
                            height: 40,
                            color: Colors.white,
                            padding:
                                const EdgeInsets.only(bottom: 10.0, right: 20),
                            child: Container(
                                child: Text(path.toString().split('/').last)),
                          )
                        else
                          new Container(),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ), //SizedBox
                            Text(
                              'I have read and agree to all terms of \nservice of HiringMirror.com',
                              style: TextStyle(
                                  fontSize: 17.0, color: Colors.lightBlue),
                            ), //Text
                            //SizedBox
                            /** Checkbox Widget **/
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Checkbox(
                                activeColor: Colors.lightBlue,
                                value: this.value,
                                onChanged: (bool value) {
                                  setState(() {
                                    this.value = value;
                                  });
                                },
                              ),
                            ), //Checkbox
                          ], //<Widget>[]
                        ),
                      ), //Row
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30.0),
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
                              if (massage == null) validation();
                              //   validation(context);
                            },
                            child: Container(
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff580E33),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  void validation() {
    String emailValue = _emailController.text;
    String passwordValue = _passwordController.text;
    String confirmPassValue = _confirmPasswordController.text;
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String mobileNum = _mobileController.text;
    String paths = path.toString();

    if (firstName.isEmpty) {
      Generalfunction().showToast('Please enter first name');
    } else if (firstName.length < 3) {
      Generalfunction()
          .showToast('Please enter first name more then 3 character long');
    } else if (lastName.isEmpty) {
      Generalfunction().showToast('Please enter last name');
    } else if (lastName.length < 3) {
      Generalfunction()
          .showToast('Please enter last name more then 3 character long');
    } else if (emailValue.isEmpty) {
      Generalfunction().showToast('Please enter email');
    } else if (!Generalfunction().validateEmail(emailValue)) {
      Generalfunction().showToast('Please enter valid email');
    } else if (mobileNum.isEmpty) {
      Generalfunction().showToast('Please enter mobile number');
    } else if (passwordValue.isEmpty) {
      Generalfunction().showToast('Please enter password');
    } else if (passwordValue.length < 6) {
      Generalfunction().showToast('Please enter password more than 6 digit');
    } else if (confirmPassValue.isEmpty) {
      Generalfunction().showToast('Please enter password again');
    } else if (passwordValue != confirmPassValue) {
      Generalfunction()
          .showToast('Password and confirm password did not match');
    } else if (paths.isEmpty) {
      Generalfunction().showToast('Please select your resume');
    } else {
      userRegistration(
        _firstNameController.text,
        _lastNameController.text,
        _emailController.text,
        _mobileController.text,
        _passwordController.text,
        _confirmPasswordController.text,
        path,
      );
      //api call here
      // Generalfunction().showToast('Registration successfully');
    }
  }
}
