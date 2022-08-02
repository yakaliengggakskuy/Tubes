
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:waqtuu/SCREEN/HomePages/HomePages.dart';

void main() async {  
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
    await AndroidAlarmManager.initialize();

    AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    '',
    [
      NotificationChannel(
          channelGroupKey: 'high_importance_channel_group',
          channelKey: 'high_importance_channel',
          channelName: 'High Importance',
          channelDescription: '',
          ledColor: Colors.white)
    ],
    // Channel groups are only visual and are not required
    channelGroups: [
      NotificationChannelGroup(
          channelGroupkey: 'high_importance_channel',
          channelGroupName: 'Basic group'),
    ],
    debug: true
  );
}

class MyApp extends StatefulWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins', backgroundColor: Colors.grey[200]),
      home: HomePages(),
    );
  }
}