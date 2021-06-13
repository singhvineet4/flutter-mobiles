import 'package:form_field_validator/form_field_validator.dart';

/*bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))'
      r'@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}*/

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Password is required'),
  // MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
  //PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: 'passwords must have at least one special character')
]);

final otpValidator = MultiValidator([
  RequiredValidator(errorText: 'OTP is required'),
  // MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
  //PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: 'passwords must have at least one special character')
]);

final usernameValidator = MultiValidator([
  RequiredValidator(errorText: 'User name is required'),
  //MinLengthValidator(8, errorText: 'user name must be at least 6 digits long'),
]);

final firstnameValidator = MultiValidator([
  RequiredValidator(errorText: 'First name is required'),
  //MinLengthValidator(8, errorText: 'user name must be at least 6 digits long'),
]);

final lastnameValidator = MultiValidator([
  RequiredValidator(errorText: 'Last name is required'),
  //MinLengthValidator(8, errorText: 'user name must be at least 6 digits long'),
]);
final locationValidator = MultiValidator([
  RequiredValidator(errorText: 'Location is required'),
  //MinLengthValidator(8, errorText: 'user name must be at least 6 digits long'),
]);

final addressValidator = MultiValidator([
  RequiredValidator(errorText: 'Address is required'),
  //MinLengthValidator(8, errorText: 'user name must be at least 6 digits long'),
]);

final phonenumberValidator = MultiValidator([
  RequiredValidator(errorText: 'phone number is required'),
  MinLengthValidator(10,
      errorText: 'phone number must be at least 10 digits long'),
]);
final genderValidator = MultiValidator([
  RequiredValidator(errorText: 'please select gender'),
]);
final emailValidator = MultiValidator([
  RequiredValidator(errorText: 'email is required'),
  // MinLengthValidator(6, errorText: 'password must be at least 6 digits long'),
  PatternValidator(r'(?=.*?[#?!@$%^&*-])',
      errorText: 'email must have at least one special character')
]);
/*
var email = "tony123_90874.coder@yahoo.co.in";
bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(email);
*/
