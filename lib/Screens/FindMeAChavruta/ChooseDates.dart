import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:havruta_project/DataBase_auth/Event.dart';
import 'package:havruta_project/Screens/FindMeAChavruta/Authenitcate.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../../Globals.dart';
import 'package:havruta_project/Screens/Login/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ChooseDatesAlgo.dart';
import 'FindMeAChavruta3.dart';

class ChooseDates extends StatefulWidget {
  final Event event;

  ChooseDates({this.event});

  @override
  _ChooseDates createState() => _ChooseDates();
}

class _ChooseDates extends State<ChooseDates> {
  final AuthService authenticate = AuthService();

  DateTime firstDate = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  DateTime lastDate = DateTime.now();
  String frequency = "יומי";
  double eventDuration = 30;

  Future<void> _selectFirstDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: firstDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    DateTime now = DateTime.now();
    if (now.isAfter(picked)) {
      Flushbar(
        title: 'שגיאה',
        message: 'לא ניתן לבחור תאריך שעבר',
        duration: Duration(seconds: 3),
      )
        ..show(context);
      return;
    }
    if (picked != null && picked != firstDate)
      setState(() {
        firstDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
    await showTimePicker(context: context, initialTime: time);
    if (picked != null && picked != time)
      setState(() {
        time = picked;
      });
  }

  Future<void> _selectLastDate(BuildContext context) async {
    DateTime picked = firstDate;
    picked = await showDatePicker(
        context: context,
        initialDate: lastDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    final difference = picked
        .difference(firstDate)
        .inDays;
    if (difference > 365) {
      Flushbar(
        title: 'שגיאה',
        message: 'לא ניתן לקבוע שיעורים ליותר משנה',
        duration: Duration(seconds: 3),
      )
        ..show(context);
      return;
    }
    if (picked.isBefore(firstDate)) {
      Flushbar(
        title: 'שגיאה',
        message: 'תאריך אחרון חייב להיות לאחר תאריך ראשון',
        duration: Duration(seconds: 3),
      )
        ..show(context);
      return;
    }
    if (picked != null && picked != lastDate)
      setState(() {
        lastDate = picked;
      });
  }

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
            SizedBox(height: Globals.scaler.getHeight(2)),
            // First date
            Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "בחר תאריך לאירוע   ",
                  style:
                  GoogleFonts.alef(fontSize: 18, color: Colors.teal[400]),
                )),
            SizedBox(height: Globals.scaler.getHeight(0.5)),
            InkWell(
              onTap: () => _selectFirstDate(context),
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
                child: Text(DateFormat('dd - MM - yyyy').format(firstDate),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.varelaRound(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrangeAccent)),
              ),
            ),
            SizedBox(height: Globals.scaler.getHeight(1)),
            // Time
            Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "בחר שעה לאירוע   ",
                  style:
                  GoogleFonts.alef(fontSize: 18, color: Colors.teal[400]),
                )),
            SizedBox(height: Globals.scaler.getHeight(0.5)),
            InkWell(
              onTap: () => _selectTime(context),
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
                child: Text(time.format(context),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.varelaRound(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrangeAccent)),
              ),
            ),
            // Event Duration
            SizedBox(height: Globals.scaler.getHeight(1)),
            Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "בחר את משך השיעור (דקות)   ",
                  style:
                  GoogleFonts.alef(fontSize: 18, color: Colors.teal[400]),
                )),
            SizedBox(height: Globals.scaler.getHeight(0.5)),
            SfSlider(
              value: eventDuration,
              onChanged: (new_duration) {
                setState(() => eventDuration = new_duration);
              },
              min: 30,
              max: 180,
              showLabels: true,
              showTicks: true,
              enableTooltip: true,
              interval: 30,
              stepSize: 30,
              // divisions: 7,
              // label:  "${eventDuration.round().toString()}דקות ",
            ),
            SizedBox(height: Globals.scaler.getHeight(1)),
            // Frequency
            Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "בחר תדירות לאירוע   ",
                  style:
                  GoogleFonts.alef(fontSize: 18, color: Colors.teal[400]),
                )),
            SizedBox(height: Globals.scaler.getHeight(0.5)),
            InkWell(
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
                  child: DropdownButton<String>(
                    value: frequency,
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(50),
                    elevation: 100,
                    onChanged: (String newValue) {
                      setState(() {
                        frequency = newValue;
                      });
                    },
                    items: <String>['יומי', 'שבועי', 'חודשי', 'ללא']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Center(
                          child: Text(value,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.varelaRound(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrangeAccent)),
                        ),
                      );
                    }).toList(),
                  ),
                )),
            SizedBox(height: Globals.scaler.getHeight(1)),
            // Last date
            Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "בחר תאריך אחרון לאירוע   ",
                  style:
                  GoogleFonts.alef(fontSize: 18, color: Colors.teal[400]),
                )),
            SizedBox(height: Globals.scaler.getHeight(0.5)),
            InkWell(
              onTap: () => _selectLastDate(context),
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
                child: Text(DateFormat('dd - MM - yyyy').format(lastDate),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.varelaRound(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrangeAccent)),
              ),
            ),
            SizedBox(height: Globals.scaler.getHeight(2)),
            ElevatedButton(
              child: Text(
                "המשך",
                textAlign: TextAlign.center,
                style: GoogleFonts.abel(fontSize: 23, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                  alignment: Alignment.center,
                  minimumSize: Size(
                      Globals.scaler.getWidth(32), Globals.scaler.getHeight(3)),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(38.0),
                  ),
                  primary: Colors.teal,
                  // <-- Button color
                  onPrimary: Colors.teal),
              onPressed: () async {
                if (isDatesValid(firstDate, time, lastDate, context)) {
                  // Calculate dates
                  int frequencyInt = convertFrquency2Int(frequency);
                  List<DateTime> dates = calcDates(firstDate, time, lastDate, frequencyInt);
                  widget.event.dates = dates;
                  widget.event.duration = eventDuration.round();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FindMeAChavruta3(event: widget.event)),
                  );
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

int convertFrquency2Int(String frequency) {
  switch (frequency) {
    case 'יומי':
      {
        return 1;
      }
      break;
    case 'שבועי':
      {
        return 7;
      }
      break;
    case 'חודשי':
      {
        return 30;
      }
      break;
    case 'ללא':
      {
        return 0;
      }
  }
}

isDatesValid(DateTime firstDate, TimeOfDay time, DateTime lastDate,
    BuildContext context) {
  if (lastDate.isBefore(firstDate)) {
    Flushbar(
      title: 'שגיאה',
      message: 'תאריך אחרון חייב להיות לאחר תאריך ראשון',
      duration: Duration(seconds: 3),
    )
      ..show(context);
    return false;
  }
  return true;
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
            "?מתי תרצו ללמוד  ",
            textAlign: TextAlign.center,
            style: GoogleFonts.alef(
                fontWeight: FontWeight.bold,
                fontSize: Globals.scaler.getTextSize(9),
                color: Colors.teal[400]),
          ),
          Icon(FontAwesomeIcons.clock, size: 20, color: Colors.teal[400])
        ]),
      ));
}
