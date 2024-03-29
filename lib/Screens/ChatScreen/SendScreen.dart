import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:havruta_project/Globals.dart';
import 'package:havruta_project/Screens/ChatScreen/ChatMessage.dart';
import 'package:havruta_project/Screens/Login/FadeAnimation.dart';

class SendScreen extends StatefulWidget {
  SendScreen(String dstMail, String dstName){
    this.dstMail = dstMail;
    this.dstName = dstName;
  }
  String dstMail,  dstName;
  @override
  _SendScreenState createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {

  ChatMessage chatMessage = new ChatMessage();
  final message = TextEditingController();
  String message_str = "";

  @override
  Widget build(BuildContext context) {
    chatMessage.src_mail = Globals.currentUser.email;
    chatMessage.dst_mail = widget.dstMail;
    chatMessage.avatar = Globals.currentUser.avatar;
    chatMessage.name = Globals.currentUser.name;
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        backgroundColor: Colors.teal[100],
        appBar: appBar(context),
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: Globals.scaler.getHeight(2)),
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "${chatMessage.name}",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.alef(fontSize: Globals.scaler.getTextSize(8.5), color: Colors.black),
                ),
              SizedBox(width: Globals.scaler.getWidth(1),),
              Text(
                ":מען",
                textAlign: TextAlign.center,
                style: GoogleFonts.alef(fontSize: Globals.scaler.getTextSize(8.5), color: Colors.black),
              ),
                SizedBox(width: Globals.scaler.getWidth(1),),
                Icon(
                  FontAwesomeIcons.user,
                  size: Globals.scaler.getTextSize(9),
                  color: Colors.orangeAccent,
                ),
                SizedBox(width: Globals.scaler.getWidth(5),)
              ]
          ),
          SizedBox(height: Globals.scaler.getHeight(0.3)),
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "${widget.dstName}",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.alef(fontSize: Globals.scaler.getTextSize(8.5), color: Colors.black),
                ),
                SizedBox(width: Globals.scaler.getWidth(1),),
                Text(
                  ":נמען",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.alef(fontSize: Globals.scaler.getTextSize(8.5), color: Colors.black),
                ),
                SizedBox(width: Globals.scaler.getWidth(1),),
                Icon(
                  FontAwesomeIcons.user,
                  size: Globals.scaler.getTextSize(9),
                  color: Colors.brown,
                ),
                SizedBox(width: Globals.scaler.getWidth(5),)
              ]
          ),
          SizedBox(height: Globals.scaler.getHeight(0.3)),
          newFiled(message, message_str, "כתוב כאן את ההודעה",
              FontAwesomeIcons.solidEnvelope, false),
          SizedBox(height: Globals.scaler.getHeight(2)),
          ElevatedButton(
            child: Text(
              "שלח",
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
              if (message.text.isEmpty){
                Flushbar(
                  title: 'שליחת הודעה',
                  message: 'לא ניתן לשלוח הודעה ריקה',
                  duration: Duration(seconds: 3),
                )..show(context);
                return;
              }
              chatMessage.message = message.text;
              bool isSend = await Globals.db.sendMessage(chatMessage);
              if (!isSend){
                Flushbar(
                  title: 'שליחת הודעה',
                  message: 'התרחשה שגיאה בשליחת ההודעה, נסה שוב',
                  duration: Duration(seconds: 3),
                )..show(context);
              }
              message.text = "";
              Flushbar(
                title: 'שליחת הודעה',
                message: 'ההודעה נשלחה בהצלחה',
                duration: Duration(seconds: 3),
              )..show(context);
            },
          ),
          SizedBox(height: Globals.scaler.getHeight(1))
        ],
      ),
    ),
    );
  }


  newFiled(controller, str, text, icon, cover) {
    return new  FadeAnimation(
        1.7, Column(children: <Widget>[
      SizedBox(height: Globals.scaler.getHeight(1)),
      Center(
        child: Container(
          alignment: AlignmentDirectional.center,
          width: Globals.scaler.getWidth(32),
          height: Globals.scaler.getHeight(14),
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
              keyboardType: TextInputType.multiline,
              maxLines: null,
              textAlign: TextAlign.center,
              controller: controller,
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
              }),
        ),
      ),
    ]));
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
              "שליחת הודעה",
              textAlign: TextAlign.center,
              style: GoogleFonts.alef(
                  fontWeight: FontWeight.bold,
                  fontSize: Globals.scaler.getTextSize(9),
                  color: Colors.teal[400]),
            ),
            SizedBox(width: Globals.scaler.getWidth(1),),
            Icon(FontAwesomeIcons.envelope, size: Globals.scaler.getTextSize(8), color: Colors.teal[400])
          ]),
        ));
  }
}
