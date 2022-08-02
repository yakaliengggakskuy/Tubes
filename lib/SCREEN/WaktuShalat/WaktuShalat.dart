import 'dart:io';

import 'package:adhan/adhan.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/weather.dart';

class WaktuShalat extends StatefulWidget {
  const WaktuShalat({Key? key}) : super(key: key);

  @override
  State<WaktuShalat> createState() => _WaktuShalatState();
}

class _WaktuShalatState extends State<WaktuShalat> {
  WeatherFactory wf = new WeatherFactory("b24f187152d5cec97d6753cf00ee510d",
      language: Language.INDONESIAN);

  var location = new Location();

  late LocationData _locationData;

  String cityName = '';
  String WeatherName = '';
  String WeatherIcon = '';
  String WeatherTemp = '';
  String WeatherSpeed = '';
  String WeatherHumidity = '';

  int subuhAlarmID = 1;
  int dzuhurAlarmID = 2;
  int asharAlarmID = 3;
  int maghribAlarmID = 4;
  int isyaAlarmID = 5;

  final audioPlayer = AudioPlayer();
  late PrayerTimes _prayerTimes;

  bool getLocation = false;

  //bool alarm adzan
  bool subuh = false;
  bool dzuhur = false;
  bool ashar = false;
  bool maghrib = false;
  bool isya = false;

  _getPermission() async {
    var _permission = await location.hasPermission();
    var _locationEnabled = await location.serviceEnabled();
    if (_permission == PermissionStatus.denied ||
        _permission == PermissionStatus.deniedForever) {
      _permission = await location.requestPermission();
    } else {
      setState(() {});
    }

    if (!_locationEnabled) {
      _locationEnabled = await location.requestService();
    } else {
      setState(() {});
    }

    if (_locationEnabled == false) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: 'waktu sholat membutuhkan akses lokasi');
      });
    } else {
      setState(() {});
    }

    _locationData = await location.getLocation();
    var address = await geo.GeocodingPlatform.instance.placemarkFromCoordinates(
        _locationData.latitude!.toDouble(),
        _locationData.longitude!.toDouble());
    Weather w = await wf.currentWeatherByLocation(
        _locationData.latitude!.toDouble(),
        _locationData.longitude!.toDouble());

    setState(() {
      getLocation = true;
      cityName = address.first.subAdministrativeArea.toString();
      WeatherName = w.weatherDescription.toString();
      WeatherIcon = w.weatherIcon.toString();
      WeatherTemp = w.temperature.toString();
      WeatherSpeed = w.windSpeed.toString();
      WeatherHumidity = w.humidity.toString();
    });

    final prefs = await SharedPreferences.getInstance();
    final myCoordinates = Coordinates(
        _locationData.latitude!.toDouble(),
        _locationData.longitude!
            .toDouble()); // Replace with your own location lat, lng.
    final params = CalculationMethod.singapore.getParameters();
    params.madhab = Madhab.shafi;
    _prayerTimes = PrayerTimes.today(myCoordinates, params);

    subuh = prefs.getBool('subuhKey') ?? false;
    dzuhur = prefs.getBool('dzuhurKey') ?? false;
    ashar = prefs.getBool('asharKey') ?? false;
    maghrib = prefs.getBool('maghribKey') ?? false;
    isya = prefs.getBool('isyaKey') ?? false;
  }

  _checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty) {
        _getPermission();
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'membutuhkan koneksi internet');
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _checkInternet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.transparent,
        title: Text(
          'Waktu Shalat',
          style: TextStyle(
              color: Color.fromARGB(255, 50, 172, 111),
              fontWeight: FontWeight.bold,
              fontSize: 15),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              getLocation
                  ? Container(
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_pin,
                          size: 18,
                          color: Colors.red,
                        ),
                        Text(
                          cityName,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ))
                  : Text('Loading...'),
              Container(
                  margin: EdgeInsets.only(top: 20),
                  padding:
                      EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
                  height: 150,
                  width: MediaQuery.of(context).size.width / 1.2,
                  decoration: BoxDecoration(
                      color: Colors.lightBlue[50],
                      borderRadius: BorderRadius.circular(25)),
                  child: getLocation
                      ? Row(children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Waktu Lokal',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                ),
                                StreamBuilder(
                                  stream: Stream.periodic(Duration(seconds: 1)),
                                  builder: (context, snapshot) {
                                    return Text(
                                      DateFormat('HH:mm')
                                          .format(DateTime.now()),
                                      style: TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold),
                                    );
                                  },
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 10,
                                        bottom: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.green[300],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      '${DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now())}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(8),
                              height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Cuaca Hari ini',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      Image(
                                        image: NetworkImage(
                                            'http://openweathermap.org/img/wn/${WeatherIcon}@2x.png'),
                                        height: 60,
                                      ),
                                      Text(WeatherTemp)
                                    ],
                                  ),
                                  Text(
                                    'Nampak ' + WeatherName,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Kecepatan angin: ${WeatherSpeed}m/s',
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.grey),
                                  ),
                                  Text(
                                    'Kelembaban udara: ${WeatherHumidity}%',
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ])
                      : SizedBox()),
              SizedBox(
                height: 30,
              ),
              getLocation
                  ? Container(
                      padding: EdgeInsets.only(left: 35),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        'Waktu Sholat',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ))
                  : SizedBox(),
              getLocation
                  ? Container(
                      margin: EdgeInsets.only(top: 15),
                      child: Column(
                        children: [
                          Column(children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10),
                              height: 70,
                              width: MediaQuery.of(context).size.width / 1.2,
                              decoration: BoxDecoration(
                                  color: subuh
                                      ? Colors.lightGreen[50]
                                      : Colors.lightBlue[50],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${DateFormat('HH:mm').format(_prayerTimes.fajr)}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Notif Adzan',
                                            style: TextStyle(fontSize: 8),
                                          ),
                                          Switch(
                                              value: subuh,
                                              onChanged: (value) async {
                                                setState(() {
                                                  subuh = value;
                                                });
                                                final prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                await prefs.setBool(
                                                    'subuhKey', value);
                                                if (subuh == true) {
                                                  if (DateTime.now().hour >
                                                          _prayerTimes
                                                              .fajr.hour &&
                                                      DateTime.now().minute >
                                                          _prayerTimes
                                                              .fajr.minute) {
                                                    AndroidAlarmManager
                                                        .periodic(
                                                            Duration(hours: 24),
                                                            subuhAlarmID,
                                                            alarmAdzanSubuh,
                                                            exact: true,
                                                            wakeup: true,
                                                            startAt: DateTime(
                                                                DateTime.now()
                                                                    .year,
                                                                DateTime.now()
                                                                    .month,
                                                                DateTime.now()
                                                                        .day +
                                                                    1,
                                                                _prayerTimes
                                                                    .fajr.hour,
                                                                _prayerTimes
                                                                    .fajr
                                                                    .minute),
                                                            rescheduleOnReboot:
                                                                true);
                                                  } else {
                                                    AndroidAlarmManager
                                                        .periodic(
                                                            Duration(hours: 24),
                                                            subuhAlarmID,
                                                            alarmAdzanSubuh,
                                                            exact: true,
                                                            wakeup: true,
                                                            startAt: DateTime(
                                                                DateTime.now()
                                                                    .year,
                                                                DateTime
                                                                        .now()
                                                                    .month,
                                                                DateTime
                                                                        .now()
                                                                    .day,
                                                                _prayerTimes
                                                                    .fajr.hour,
                                                                _prayerTimes
                                                                    .fajr
                                                                    .minute),
                                                            rescheduleOnReboot:
                                                                true);
                                                  }
                                                } else {
                                                  AndroidAlarmManager.cancel(
                                                      subuhAlarmID);
                                                }
                                              })
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              height: 30,
                              padding:
                                  EdgeInsets.only(left: 20, right: 10, top: 5),
                              decoration: BoxDecoration(
                                  color: subuh
                                      ? Colors.lightGreen[100]
                                      : Colors.lightBlue[100],
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20))),
                              child: Text(
                                'Subuh',
                                style: TextStyle(),
                              ),
                            )
                          ]), // kontainer waktu 1
                          SizedBox(
                            height: 5,
                          ),

                          Column(children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10),
                              height: 70,
                              width: MediaQuery.of(context).size.width / 1.2,
                              decoration: BoxDecoration(
                                  color: Colors.lightBlue[50],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat('HH:mm')
                                            .format(_prayerTimes.sunrise),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30),
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Icon(
                                            Icons.sunny_snowing,
                                            size: 40,
                                            color: Colors.yellow[700],
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              height: 30,
                              padding:
                                  EdgeInsets.only(left: 20, right: 10, top: 5),
                              decoration: BoxDecoration(
                                  color: Colors.lightBlue[100],
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20))),
                              child: Text(
                                'Matahari Terbit',
                                style: TextStyle(),
                              ),
                            )
                          ]), // kontainer waktu 1
                          SizedBox(
                            height: 5,
                          ),

                          Column(children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10),
                              height: 70,
                              width: MediaQuery.of(context).size.width / 1.2,
                              decoration: BoxDecoration(
                                  color: dzuhur
                                      ? Colors.lightGreen[50]
                                      : Colors.lightBlue[50],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat('HH:mm')
                                            .format(_prayerTimes.dhuhr),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Notif Adzan',
                                            style: TextStyle(fontSize: 8),
                                          ),
                                          Switch(
                                              value: dzuhur,
                                              onChanged: (value) async {
                                                setState(() {
                                                  dzuhur = value;
                                                  print(dzuhur);
                                                });
                                                final prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                await prefs.setBool(
                                                    'dzuhurKey', value);
                                                if (dzuhur == true) {
                                                  if (DateTime.now().hour >
                                                          _prayerTimes
                                                              .dhuhr.hour &&
                                                      DateTime.now().minute >
                                                          _prayerTimes
                                                              .dhuhr.minute) {
                                                    AndroidAlarmManager
                                                        .periodic(
                                                            Duration(hours: 24),
                                                            dzuhurAlarmID,
                                                            alarmAdzan,
                                                            exact: true,
                                                            wakeup: true,
                                                            startAt: DateTime(
                                                                DateTime.now()
                                                                    .year,
                                                                DateTime.now()
                                                                    .month,
                                                                DateTime.now()
                                                                        .day +
                                                                    1,
                                                                _prayerTimes
                                                                    .dhuhr.hour,
                                                                _prayerTimes
                                                                    .dhuhr
                                                                    .minute),
                                                            rescheduleOnReboot:
                                                                true);
                                                  } else {
                                                    AndroidAlarmManager
                                                        .periodic(
                                                            Duration(hours: 24),
                                                            dzuhurAlarmID,
                                                            alarmAdzan,
                                                            exact: true,
                                                            wakeup: true,
                                                            startAt: DateTime(
                                                                DateTime.now()
                                                                    .year,
                                                                DateTime
                                                                        .now()
                                                                    .month,
                                                                DateTime
                                                                        .now()
                                                                    .day,
                                                                _prayerTimes
                                                                    .dhuhr.hour,
                                                                _prayerTimes
                                                                    .dhuhr
                                                                    .minute),
                                                            rescheduleOnReboot:
                                                                true);
                                                  }
                                                } else {
                                                  AndroidAlarmManager.cancel(
                                                      dzuhurAlarmID);
                                                }
                                              })
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              height: 30,
                              padding:
                                  EdgeInsets.only(left: 20, right: 10, top: 5),
                              decoration: BoxDecoration(
                                  color: dzuhur
                                      ? Colors.lightGreen[100]
                                      : Colors.lightBlue[100],
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20))),
                              child: Text(
                                'Dzuhur',
                                style: TextStyle(),
                              ),
                            )
                          ]), // kontainer waktu 2
                          SizedBox(
                            height: 5,
                          ),

                          Column(children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10),
                              height: 70,
                              width: MediaQuery.of(context).size.width / 1.2,
                              decoration: BoxDecoration(
                                  color: ashar
                                      ? Colors.lightGreen[50]
                                      : Colors.lightBlue[50],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat('HH:mm')
                                            .format(_prayerTimes.asr),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Notif Adzan',
                                            style: TextStyle(fontSize: 8),
                                          ),
                                          Switch(
                                              value: ashar,
                                              onChanged: (value) async {
                                                setState(() {
                                                  ashar = value;
                                                  print(ashar);
                                                });
                                                final prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                await prefs.setBool(
                                                    'asharKey', value);
                                                if (ashar == true) {
                                                  if (DateTime.now().hour >
                                                          _prayerTimes
                                                              .asr.hour &&
                                                      DateTime.now().minute >
                                                          _prayerTimes
                                                              .asr.minute) {
                                                    AndroidAlarmManager
                                                        .periodic(
                                                            Duration(hours: 24),
                                                            asharAlarmID,
                                                            alarmAdzan,
                                                            exact: true,
                                                            wakeup: true,
                                                            startAt: DateTime(
                                                                DateTime.now()
                                                                    .year,
                                                                DateTime.now()
                                                                    .month,
                                                                DateTime.now()
                                                                        .day +
                                                                    1,
                                                                _prayerTimes
                                                                    .asr.hour,
                                                                _prayerTimes.asr
                                                                    .minute),
                                                            rescheduleOnReboot:
                                                                true);
                                                  } else {
                                                    AndroidAlarmManager
                                                        .periodic(
                                                            Duration(hours: 24),
                                                            asharAlarmID,
                                                            alarmAdzan,
                                                            exact: true,
                                                            wakeup: true,
                                                            startAt: DateTime(
                                                                DateTime.now()
                                                                    .year,
                                                                DateTime
                                                                        .now()
                                                                    .month,
                                                                DateTime
                                                                        .now()
                                                                    .day,
                                                                _prayerTimes
                                                                    .asr.hour,
                                                                _prayerTimes.asr
                                                                    .minute),
                                                            rescheduleOnReboot:
                                                                true);
                                                  }
                                                } else {
                                                  AndroidAlarmManager.cancel(
                                                      asharAlarmID);
                                                }
                                              })
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              height: 30,
                              padding:
                                  EdgeInsets.only(left: 20, right: 10, top: 5),
                              decoration: BoxDecoration(
                                  color: ashar
                                      ? Colors.lightGreen[100]
                                      : Colors.lightBlue[100],
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20))),
                              child: Text(
                                'Ashar',
                                style: TextStyle(),
                              ),
                            )
                          ]), // kontainer waktu 3
                          SizedBox(
                            height: 5,
                          ),

                          Column(children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10),
                              height: 70,
                              width: MediaQuery.of(context).size.width / 1.2,
                              decoration: BoxDecoration(
                                  color: maghrib
                                      ? Colors.lightGreen[50]
                                      : Colors.lightBlue[50],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat('HH:mm')
                                            .format(_prayerTimes.maghrib),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Notif Adzan',
                                            style: TextStyle(fontSize: 8),
                                          ),
                                          Switch(
                                              value: maghrib,
                                              onChanged: (value) async {
                                                setState(() {
                                                  maghrib = value;
                                                  print(maghrib);
                                                });
                                                final prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                await prefs.setBool(
                                                    'maghribKey', value);
                                                if (maghrib == true) {
                                                  if (DateTime.now().hour >
                                                          _prayerTimes
                                                              .maghrib.hour &&
                                                      DateTime.now().minute >
                                                          _prayerTimes
                                                              .maghrib.minute) {
                                                    AndroidAlarmManager
                                                        .periodic(
                                                            Duration(hours: 24),
                                                            maghribAlarmID,
                                                            alarmAdzan,
                                                            exact: true,
                                                            wakeup: true,
                                                            startAt: DateTime(
                                                                DateTime.now()
                                                                    .year,
                                                                DateTime.now()
                                                                    .month,
                                                                DateTime.now()
                                                                        .day +
                                                                    1,
                                                                _prayerTimes
                                                                    .maghrib
                                                                    .hour,
                                                                _prayerTimes
                                                                    .maghrib
                                                                    .minute),
                                                            rescheduleOnReboot:
                                                                true);
                                                  } else {
                                                    AndroidAlarmManager
                                                        .periodic(
                                                            Duration(hours: 24),
                                                            maghribAlarmID,
                                                            alarmAdzan,
                                                            exact: true,
                                                            wakeup: true,
                                                            startAt: DateTime(
                                                                DateTime.now()
                                                                    .year,
                                                                DateTime
                                                                        .now()
                                                                    .month,
                                                                DateTime
                                                                        .now()
                                                                    .day,
                                                                _prayerTimes
                                                                    .maghrib
                                                                    .hour,
                                                                _prayerTimes
                                                                    .maghrib
                                                                    .minute),
                                                            rescheduleOnReboot:
                                                                true);
                                                  }
                                                } else {
                                                  AndroidAlarmManager.cancel(
                                                      maghribAlarmID);
                                                }
                                              })
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              height: 30,
                              padding:
                                  EdgeInsets.only(left: 20, right: 10, top: 5),
                              decoration: BoxDecoration(
                                  color: maghrib
                                      ? Colors.lightGreen[100]
                                      : Colors.lightBlue[100],
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20))),
                              child: Text(
                                'Maghrib',
                                style: TextStyle(),
                              ),
                            )
                          ]), // kontainer waktu 4
                          SizedBox(
                            height: 5,
                          ),

                          Column(children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10),
                              height: 70,
                              width: MediaQuery.of(context).size.width / 1.2,
                              decoration: BoxDecoration(
                                  color: isya
                                      ? Colors.lightGreen[50]
                                      : Colors.lightBlue[50],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat('HH:mm')
                                            .format(_prayerTimes.isha),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Notif Adzan',
                                            style: TextStyle(fontSize: 8),
                                          ),
                                          Switch(
                                              value: isya,
                                              onChanged: (value) async {
                                                setState(() {
                                                  isya = value;
                                                });
                                                final prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                await prefs.setBool(
                                                    'isyaKey', value);
                                                if (isya == true) {
                                                  if (DateTime.now().hour >
                                                          _prayerTimes
                                                              .isha.hour &&
                                                      DateTime.now().minute >
                                                          _prayerTimes
                                                              .isha.minute) {
                                                    AndroidAlarmManager
                                                        .periodic(
                                                      Duration(hours: 24),
                                                      isyaAlarmID,
                                                      alarmAdzan,
                                                      exact: true,
                                                      wakeup: true,
                                                      startAt: DateTime(
                                                          DateTime.now().year,
                                                          DateTime.now().month,
                                                          DateTime.now().day +
                                                              1,
                                                          _prayerTimes
                                                              .isha.hour,
                                                          _prayerTimes
                                                              .isha.minute),
                                                      rescheduleOnReboot: true,
                                                    );
                                                  } else {
                                                    AndroidAlarmManager
                                                        .periodic(
                                                      Duration(hours: 24),
                                                      isyaAlarmID,
                                                      alarmAdzan,
                                                      exact: true,
                                                      wakeup: true,
                                                      startAt: DateTime(
                                                          DateTime.now().year,
                                                          DateTime.now().month,
                                                          DateTime.now().day,
                                                          _prayerTimes
                                                              .isha.hour,
                                                          _prayerTimes
                                                              .isha.minute),
                                                      rescheduleOnReboot: true,
                                                    );
                                                  }
                                                } else {
                                                  AndroidAlarmManager.cancel(
                                                      isyaAlarmID);
                                                }
                                              })
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              height: 30,
                              padding:
                                  EdgeInsets.only(left: 20, right: 10, top: 5),
                              decoration: BoxDecoration(
                                  color: isya
                                      ? Colors.lightGreen[100]
                                      : Colors.lightBlue[100],
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20))),
                              child: Text(
                                'Isha',
                                style: TextStyle(),
                              ),
                            )
                          ]), // kontainer waktu 1
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
              Container(
                  margin: EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: Text(
                    'data lokasi diambil langsung dari perangkat, waktu sholat yang sudah dikalkulasi sesuai dengan perhitungan dari Universitas ilmu islam dan sesuai lokasi perangkat sekarang',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  )),
              getLocation
                  ? SizedBox()
                  : Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Refresh jika Loading terlalu lama...',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.vibrate();
                            _checkInternet();
                          },
                          child: Container(
                              margin: EdgeInsets.only(top: 10),
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 5, top: 5),
                              decoration: BoxDecoration(
                                  color: Colors.lightBlue,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                'Refresh',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              )),
                        )
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}

void alarmAdzanSubuh() {
  AudioPlayer audioPlayer = AudioPlayer();
  audioPlayer.play(AssetSource('audio/adzan/adzan_subuh.mp3'));

  AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: 1,
        channelKey: 'high_importance_channel',
        title: '🕋 Waqtu Shalat',
        body: 'Memasuki Waktu Subuh pada lokasi anda',
        criticalAlert: true,
        displayOnBackground: true,
        displayOnForeground: true,
        wakeUpScreen: true),
  );
}

void alarmAdzan() {
  AudioPlayer audioPlayer = AudioPlayer();
  audioPlayer.play(AssetSource('audio/adzan/adzan_subuh.mp3'));

  AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: 2,
        channelKey: 'high_importance_channel',
        title: '🕋 Waqtu Shalat',
        body: 'Memasuki Waktu Sholat pada lokasi anda',
        criticalAlert: true,
        displayOnBackground: true,
        displayOnForeground: true,
        wakeUpScreen: true),
  );
}
