import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:havruta_project/Screens/HomePageScreen/notificationModel.dart';
import 'package:havruta_project/Screens/HomePageScreen/NotificationView.dart';
import 'package:havruta_project/Globals.dart';
import 'dart:async';
import 'package:havruta_project/DataBase_auth/Notification.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class Notifications extends StatefulWidget {
  const Notifications({
    Key key,
  }) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final scrollController = ScrollController();

  notificationModel notifications;

  @override
  void initState() {
    notifications = notificationModel(false);
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        notifications.loadMore();
      }
    });
    super.initState();
    NotificationUser n = new NotificationUser();
    n.message = 'הצטרפ/ה לחברותא שלך';
    n.type = 'E';
    n.name = 'Yonatan Gat';
    n.destinationUser = 'michal@gmail.com';
    n.idEvent = new mongo.ObjectId.fromHexString('60bbda688b4c85a59e40886f');
    n.creatorUser = 'יונתן גת';
    n.creationDate = DateTime.now();
    //Globals.db.insertNotification(n);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: true, body: eventsScroll());
  }

  eventsScroll() {
    return Scrollbar(
        child: Material(
            color: Colors.grey.withOpacity(0.8),
            child: StreamBuilder(
              stream: notifications.stream,
              builder: (BuildContext _context, AsyncSnapshot _snapshot) {
                if (!_snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return RefreshIndicator(
                    onRefresh: notifications.refresh,
                    child: ListView.builder(
                      itemCount: _snapshot.data.length + 1,
                      itemBuilder: (BuildContext _context, int index) {
                        if (index < _snapshot.data.length) {
                          return Dismissible(
                              direction: DismissDirection.startToEnd,
                              resizeDuration: Duration(milliseconds: 200),
                              key: ObjectKey(_snapshot.data[index]),
                              onDismissed: (direction) async {
                                await Globals.db
                                    .deleteNotification(_snapshot.data[index]);
                                 //_snapshot.data.removeAt[index];
                                // TODO: implement your delete function and check direction if needed
                              },
                              child: NotificationView(
                                notification: _snapshot.data[index],
                              ));
                        } else if (notifications.hasMore) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 32.0),
                            child: Center(child: Text("אין לך התראות")),
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 32.0),
                          );
                        }
                      },
                    ),
                  );
                }
              },
            )));
  }
}
