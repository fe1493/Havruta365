import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailer/smtp_server.dart';
import 'package:http/http.dart' as http;

import '../../Globals.dart';
import 'FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:toast/toast.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ForgetPassword> {
  final address = TextEditingController();
  String address_str = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.teal[100],
      appBar: appBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: Globals.scaler.getHeight(4)),
            newFiled(address, address_str, "כתובת המייל",
                FontAwesomeIcons.mailBulk, false),
            SizedBox(height: Globals.scaler.getHeight(2)),
            ElevatedButton(
              child: Text(
                "שלח את הסיסמא",
                textAlign: TextAlign.center,
                style: GoogleFonts.abel(fontSize: Globals.scaler.getTextSize(8), color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  alignment: Alignment.center,
                  minimumSize:
                  Size(Globals.scaler.getWidth(32), Globals.scaler.getHeight(3)),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(38.0),
                  ),
                  primary: Colors.teal,
                  // <-- Button color
                  onPrimary: Colors.teal),
              onPressed: () async {
                address_str = address.text;
                if(!(address_str.contains("@")&&address_str.contains("."))){
                  Toast.show('כתובת המייל לא חוקית', context,
                      duration: Toast.CENTER, gravity: 30);
                  return;
                }
                bool check = await Globals.db.isUserExist(address_str);
                if (check == true){
                  bool checkPass = await Globals.db.isPassNull(address_str);
                  if(checkPass== true) {
                    var newPassword = await Globals.db.changePasswordUser(
                        address_str);
                    sendMail(address_str, newPassword);
                    Toast.show('נשלח מייל עם הסיסמא החדשה', context,
                        duration: Toast.CENTER, gravity: 30);
                  }
                  else{
                    Toast.show('Google'+'יש לשנות את הסיסמא בפרופיל ', context,
                        duration: Toast.CENTER, gravity: 30);
                  }

                }
                else{
                  Toast.show('כתובת המייל לא קיימת', context,duration: Toast.CENTER,gravity: 30);
                }

              },
            ),
            SizedBox(height: Globals.scaler.getHeight(1))
          ],
        ),
      ),
    );
  }
}

newFiled(controller, str, text, icon, cover) {
  return new  FadeAnimation(
      1.7, Column(children: <Widget>[
    SizedBox(height: Globals.scaler.getHeight(1)),
    Center(
      child: Container(
        alignment: AlignmentDirectional.center,
        width: Globals.scaler.getWidth(32),
        height: Globals.scaler.getHeight(3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(30.0),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(1),
                offset: const Offset(0, 2),
                blurRadius: 8.0),
          ],
        ),
        child: TextField(
            textAlign: TextAlign.center,
            controller: controller,
            obscureText: cover,
            style: TextStyle(fontSize: 18),
            decoration: InputDecoration(
                suffixIcon: Icon(
                  icon,
                  size: Globals.scaler.getTextSize(8),
                  color: Colors.red,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: text),
            onChanged: (text) {
              str = controller.text;
              print(text);
            }),
      ),
    ),
  ]));
}

sendMail(String mailUser, String newPassword ) async {
  var url =
  Uri.parse('http://yonatangat.pythonanywhere.com/mail');
  var x =
    {
      "subject": "שינוי סיסמא - פרוייקט חברותא",
      "body": "הסיסמא החדשה שלך היא :    " +  newPassword ,
      "src": "havrutaproject@gmail.com",
      "src_pass": "havruta365",
      "dst": mailUser
    };
  print(x);
  var response = await http.post(url,
      body: json.encode(x),
      headers: {'Content-Type': 'application/json'});
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
}

appBar(BuildContext context) {
  ScreenScaler scaler = new ScreenScaler();

  return new AppBar(
      leadingWidth: 0,
      toolbarHeight: 40,
      elevation: 30,
      shadowColor: Colors.teal[400],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(0),
      )),
      backgroundColor: Colors.white,
      title: Container(
        width: scaler.getWidth(50),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Text(
            "שחזור סיסמא  ",
            textAlign: TextAlign.center,
            style: GoogleFonts.alef(
                fontWeight: FontWeight.bold,
                fontSize: Globals.scaler.getTextSize(9),
                color: Colors.teal[400]),
          ),
          Icon(FontAwesomeIcons.key, size: Globals.scaler.getTextSize(8), color: Colors.teal[400])
        ]),
      ));
}
