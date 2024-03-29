import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:havruta_project/Screens/FindMeAChavruta/Authenitcate.dart';
import 'package:havruta_project/Screens/HomePageScreen/home_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:objectid/objectid.dart';
import '../../Globals.dart';
import 'FadeAnimation.dart';
import 'package:flutter/material.dart';

class LoginMoreDetails extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<LoginMoreDetails> {
  final yeshiva = TextEditingController();
  String yeshiva_str = " ";
  final description = TextEditingController();
  String description_str = " ";
  final status = TextEditingController();
  String status_str = "סטטוס משפחתי";
  final AuthService authenticate = AuthService();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          backgroundColor: Colors.teal[100],
          appBar: appBar(context),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: Globals.scaler.getHeight(1)),
                Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "פרטים נוספים   ",
                      style: GoogleFonts.alef(
                          fontSize: Globals.scaler.getTextSize(8),
                          color: Colors.teal[400]),
                    )),
                imageProfile(),
                SizedBox(height: Globals.scaler.getHeight(1)),
                FadeAnimation(
                  1.7,
                  Container(
                      alignment: AlignmentDirectional.centerEnd,
                      width: Globals.scaler.getWidth(20),
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
                      child: DropdownButton<String>(
                        iconDisabledColor: Colors.teal,
                        isExpanded: true,
                        value: status_str,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: Globals.scaler.getTextSize(9),
                        // this increase the size
                        elevation: 100,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: Globals.scaler.getTextSize(8),
                        ),
                        underline: Container(),
                        onChanged: (String newValue) {
                          setState(() {
                            status_str = newValue;
                          });
                        },
                        items: <String>[
                          "סטטוס משפחתי",
                          "רווק/ה",
                          'נשוי/אה',
                          'גרוש/ה'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Center(
                                child:
                                    Text(value, textAlign: TextAlign.center)),
                          );
                        }).toList(),
                      )),
                ),
                newFiled(yeshiva, yeshiva_str, "ישיבה/מדרשה",
                    FontAwesomeIcons.book, 3.0),
                newFiled1(description, description_str, "פרטים שחשוב לך לשתף",
                    FontAwesomeIcons.list, 8.0),
                SizedBox(height: Globals.scaler.getHeight(1)),
                ElevatedButton(
                  child: Text(
                    "מצא לי חברותא ",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.abel(
                        fontSize: Globals.scaler.getTextSize(9),
                        color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      alignment: Alignment.center,
                      minimumSize: Size(Globals.scaler.getWidth(32),
                          Globals.scaler.getHeight(3)),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(38.0),
                      ),
                      primary: Colors.red,
                      // <-- Button color
                      onPrimary: Colors.teal),
                  onPressed: () async {
                    Globals.db.saveIdLocally();
                    yeshiva_str = yeshiva.text;
                    description_str = description.text;
                    Globals.currentUser.yeshiva = yeshiva_str ?? "";
                    Globals.currentUser.description = description_str ?? "";
                    Globals.currentUser.status =
                        status_str == "סטטוס משפחתי" ? "לא ידוע" : status_str;
                    if (Globals.currentUser.avatar == null)
                      Globals.currentUser.avatar =
                          'https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png';
                    Globals.db.updateUser(Globals.currentUser);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                ),
                SizedBox(height: Globals.scaler.getHeight(1)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        FlatButton(
          color: Colors.transparent,
          onPressed: () {
            showModalBottomSheet(
                context: context, builder: ((builder) => bottomSheet()));
          },
          child: CircleAvatar(
            radius: 60.0,
            backgroundColor: Colors.teal,
            backgroundImage: (Globals.currentUser.avatar != null)
                ? NetworkImage(Globals.currentUser.avatar)
                : null,
          ),
        ),
        Positioned(
          bottom: Globals.scaler.getHeight(2.2),
          right: Globals.scaler.getWidth(5.3),
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: Globals.scaler.getTextSize(11),
            ),
          ),
        ),
      ]),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: Globals.scaler.getHeight(5.5),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: Globals.scaler.getWidth(3),
        vertical: Globals.scaler.getHeight(1),
      ),
      child: Column(
        children: <Widget>[
          Text(
            "בחר תמונה",
            style: TextStyle(
              fontSize: Globals.scaler.getTextSize(8.5),
            ),
          ),
          SizedBox(
            height: Globals.scaler.getHeight(1),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () async {
                uploadImage(ImageSource.camera);
                Navigator.pop(context);
              },
              label: Text("מצלמה"),
            ),
            TextButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                uploadImage(ImageSource.gallery);
                Navigator.pop(context);
              },
              label: Text("גלריה"),
            ),
          ])
        ],
      ),
    );
  }

  Future<File> uploadImage(source) async {
    final _storage = FirebaseStorage.instance;
    PickedFile image;
    final picker = ImagePicker();
    dynamic result = await authenticate.signInAnon();
    if (result == null) {
      print("error signing in");
    } else {
      print('signed in');
    }
    image = await picker.getImage(source: source);
    var file = File(image.path);
    String fileName = ObjectId().toString();
    //check if an image was picked
    if (image != null) {
      var snapshot =
          await _storage.ref().child('Images/$fileName').putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        Globals.currentUser.avatar = downloadUrl;
      });
    } else {
      setState(() {
        Globals.currentUser.avatar =
            'https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png';
      });
    }
  }
}

newFiled(controller, str, text, icon, size) {
  return FadeAnimation(
    1.7,
    new Column(children: <Widget>[
      SizedBox(height: Globals.scaler.getHeight(1)),
      Center(
        child: Container(
          alignment: AlignmentDirectional.center,
          width: Globals.scaler.getWidth(32),
          height: Globals.scaler.getHeight(size),
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
              style: TextStyle(fontSize: Globals.scaler.getTextSize(7.5)),
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
              }),
        ),
      ),
    ]),
  );
}

newFiled1(controller, str, text, icon, size) {
  return FadeAnimation(
    1.7,
    new Column(children: <Widget>[
      SizedBox(height: Globals.scaler.getHeight(1)),
      Center(
        child: Container(
          alignment: AlignmentDirectional.center,
          width: Globals.scaler.getWidth(32),
          height: Globals.scaler.getHeight(size),
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
              maxLines: null,
              expands: true,
              textAlign: TextAlign.center,
              controller: controller,
              style: TextStyle(fontSize: Globals.scaler.getTextSize(7.5)),
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
              }),
        ),
      ),
    ]),
  );
}

appBar(BuildContext context) {
  ScreenScaler scaler = new ScreenScaler();
  return new AppBar(
      leadingWidth: 0,
      toolbarHeight: Globals.scaler.getHeight(2),
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
            "משתמש חדש  ",
            textAlign: TextAlign.center,
            style: GoogleFonts.alef(
                fontWeight: FontWeight.bold,
                fontSize: Globals.scaler.getTextSize(9),
                color: Colors.teal[400]),
          ),
          Icon(FontAwesomeIcons.userAlt,
              size: Globals.scaler.getTextSize(9), color: Colors.teal[400])
        ]),
      ));
}
