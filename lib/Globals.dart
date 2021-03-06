import 'package:flutter/material.dart';
import 'package:havruta_project/DataBase_auth/mongo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DataBase_auth/User.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';

class Globals {
  static Mongo db;
  static bool isDbConnect = false;
  static User currentUser;
  static BuildContext context;
  static ScreenScaler scaler = new ScreenScaler();
  static CustomAppBar customAppBar = new CustomAppBar();
  static Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  static String maleAvatar =
      'https://mpng.subpng.com/20180418/whw/kisspng-computer-icons-professional-clipart-5ad7f6c3aafc17.2777946215241028517004.jpg';
  static String femaleAvatar =
      'https://i.pinimg.com/originals/a6/58/32/a65832155622ac173337874f02b218fb.png';
  static String boyAvatar =
      'https://www.clipartmax.com/png/middle/258-2582267_circled-user-male-skin-type-1-2-icon-male-user-icon.png';
  static String girlAvatar =
      'https://png.pngtree.com/element_our/20190529/ourmid/pngtree-circular-pattern-user-cartoon-avatar-image_1200102.jpg';
}


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double _pefferedHeight = 80.0;
  String title;
  Color gradientBegin, gradientEnd;

  CustomAppBar({this.title, this.gradientBegin, this.gradientEnd})
      : assert(title != null),
        assert(gradientBegin != null),
        assert(gradientEnd != null);

  Widget build(BuildContext context) {
    return Container(
      height: _pefferedHeight,
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 20.0),
      decoration: BoxDecoration(
          gradient:
          LinearGradient(colors: <Color>[gradientBegin, gradientEnd])),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          letterSpacing: 10.0,
          fontSize: 30.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(_pefferedHeight);
}