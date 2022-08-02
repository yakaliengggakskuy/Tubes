import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class QiblaPages extends StatefulWidget {
  const QiblaPages({Key? key}) : super(key: key);

  @override
  State<QiblaPages> createState() => _QiblaPagesState();
}

class _QiblaPagesState extends State<QiblaPages> {
  bool isInternet = false;

  _checkPermission() async {
    var _permission = await FlutterQiblah.androidDeviceSensorSupport();
    if (_permission == null) {
      Fluttertoast.showToast(msg: 'Perangkat tidak mendukung');
    } else {
      print(_permission);
    }
  }

  _checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty) {
        setState(() {
          isInternet = true;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Tidak terhubung internet');
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _checkPermission();
    _checkInternet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlue[50],
        body: Container(
          color: Colors.lightBlue[50],
          height: MediaQuery.of(context).size.height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 1.8,
                decoration: isInternet
                    ? BoxDecoration(
                        image: DecorationImage(
                        image: NetworkImage(
                            'https://wallpaperaccess.com/full/1546338.jpg'),
                        fit: BoxFit.fitHeight,
                      ))
                    : BoxDecoration(color: Colors.lightBlue[50]),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Penunjuk arah kiblat',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        StreamBuilder(
                          stream: Stream.periodic(Duration(seconds: 1)),
                          builder: (context, snapshot) {
                            return Text(
                              DateFormat('HH:mm').format(DateTime.now()),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 31,
                                  fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                        Text(
                          DateFormat('EEEE, dd MMMM yyyy')
                              .format(DateTime.now()),
                          style: TextStyle(color: Colors.white, fontSize: 21),
                        )
                      ],
                    )),
                  ),
                ),
              ),
              Positioned(
                bottom: 0.1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.045,
                  padding: EdgeInsets.all(40),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40)),
                      color: Colors.white),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        bottom: 1,
                        child: Container(
                          padding:
                              EdgeInsets.only(left: 30, right: 30, bottom: 20),
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            'sejajarkan tanda panah dengan jarum kompas..\nkompas ini sedang dalam pengembangan, tidak 100% akurat dalam menunjukkan arah kiblat\n\nlaporkan kesalahan penunjukan kepada kami dengan mengirimkan detail laporan ke\n\nwaqtu.indonesia@gmail.com',
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 1,
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: Icon(
                            Icons.arrow_circle_up_sharp,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      StreamBuilder(
                        stream: FlutterQiblah.qiblahStream,
                        builder:
                            (context, AsyncSnapshot<QiblahDirection> snapshot) {
                          var direction = snapshot.data;
                          if (snapshot.hasData) {
                            return Transform.rotate(
                              angle: ((direction!.qiblah) * (pi / 180) * -1.06),
                              child: Container(
                                  child: Image.asset(
                                      'assets/images/jarum_kompas.png')),
                            );
                          } else {
                            return Text('Loading...');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
