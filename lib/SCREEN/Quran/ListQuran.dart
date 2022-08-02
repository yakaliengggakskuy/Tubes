import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:waqtuu/MODELS/ListQuranModel/ListQuranModel.dart';
import 'package:waqtuu/SCREEN/Quran/Quran.dart';
import 'package:waqtuu/SERVICE/LocalDataFetch.dart';

class ListQuran extends StatefulWidget {
  const ListQuran({Key? key}) : super(key: key);

  @override
  State<ListQuran> createState() => _ListQuranState();
}

class _ListQuranState extends State<ListQuran> {
  ListQuranModel data = ListQuranModel();
  LocalData localData = LocalData();
  List result = [];

  String query = '';
  int nilaiIndex = 0;
  bool isFetch = false;
  bool isPlaying = false;

  final audioPlayer = new AudioPlayer();

  _getData() async {
    data = await localData.listQuran();
    setState(() {
      isFetch = true;
    });
  }

  //'https://zulfikaralwi.my.id/wp-content/uploads/2022/02/${quran.number}.mp3'

  _playAudio(number) {
    if (isPlaying == false) {
      audioPlayer.play(UrlSource(
          'https://zulfikaralwi.my.id/wp-content/uploads/2022/02/${number}.mp3'));
      setState(() {
        isPlaying = true;
      });
    } else if (audioPlayer.state == PlayerState.paused) {
      audioPlayer.resume();
      setState(() {
        isPlaying = true;
      });
    } else {
      audioPlayer.pause();
      setState(() {
        isPlaying = false;
      });
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  void deactivate() {
    // ignore: todo
    // TODO: implement deactivate
    super.deactivate();
    audioPlayer.stop();
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
          'Qur`an',
          style: TextStyle(
              color: Color.fromARGB(255, 50, 172, 111),
              fontWeight: FontWeight.bold,
              fontSize: 15),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 10),
              width: MediaQuery.of(context).size.width / 1.3,
              height: 50,
              decoration: BoxDecoration(
                  color: Color.fromARGB(160, 225, 245, 254),
                  borderRadius: BorderRadius.circular(30)),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    query = value;
                    _searching(query);
                  });
                },
                style: TextStyle(color: Colors.lightBlue),
                decoration: InputDecoration(
                    hintText: 'Cari Surah',
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.lightBlue,
                    ),
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.lightBlue)),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            isFetch
                ? Expanded(
                    child: Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: query.isEmpty ? onQuery() : onSearch()),
                  )
                : Center(
                    child: Text('Loading...'),
                  )
          ],
        ),
      ),
    );
  }

  _searching(String input) {
    result = data.data!
        .where((quran) => quran.name!.transliteration!.id!
            .toLowerCase()
            .replaceAll('-', ' ')
            .contains(input.toLowerCase()))
        .toList();
  }

  onSearch() {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: result.length,
        itemBuilder: (context, index) {
          final quran = result[index];
          return Container(
              child: Column(
            children: [
              ListTile(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuranPages(
                                quranNumber: quran.number!.toInt(),
                              )));
                },
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/ayat_frame.png'),
                  backgroundColor: Colors.transparent,
                  child: Text(
                    quran.number.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.green[200]),
                  ),
                ),
                title: Row(
                  children: [
                    Text(
                      quran.name!.transliteration!.id
                          .toString()
                          .replaceAll('-', ' '),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () async {
                        try {
                          final result =
                              await InternetAddress.lookup('google.com');
                          if (result.isNotEmpty) {
                            setState(() {
                              nilaiIndex = index;
                            });
                            _playAudio(quran.number);
                          }
                        } catch (e) {
                          Fluttertoast.showToast(
                              msg: 'Tidak terhubung internet');
                        }
                      },
                      child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: Colors.lightBlue[50],
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isPlaying == true && nilaiIndex == index)
                                Container(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.pause,
                                    color: Colors.lightBlue,
                                    size: 15,
                                  ),
                                )
                              else
                                Container(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.music_note,
                                    color: Colors.lightBlue,
                                    size: 15,
                                  ),
                                )
                            ],
                          )),
                    )
                  ],
                ),
                subtitle: Text(
                  quran.name!.translation!.id.toString(),
                  style: TextStyle(fontSize: 12, color: Colors.lightBlue[300]),
                ),
                trailing: Text(
                  quran.name!.short.toString(),
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.blueGrey,
                      fontFamily: 'Misbah'),
                ),
              ),
            ],
          ));
        });
  }

  onQuery() {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: data.data!.length,
        itemBuilder: (context, index) {
          var quran = data.data![index];
          return Container(
              child: Column(
            children: [
              ListTile(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuranPages(
                                quranNumber: quran.number!.toInt(),
                              )));
                },
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/ayat_frame.png'),
                  backgroundColor: Colors.transparent,
                  child: Text(
                    quran.number.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.green[200]),
                  ),
                ),
                title: Row(
                  children: [
                    Text(
                      quran.name!.transliteration!.id
                          .toString()
                          .replaceAll('-', ' '),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        try {
                          final result =
                              await InternetAddress.lookup('google.com');
                          if (result.isNotEmpty) {
                            setState(() {
                              nilaiIndex = index;
                            });
                            _playAudio(quran.number);
                          }
                        } catch (e) {
                          Fluttertoast.showToast(
                              msg: 'Tidak terhubung internet');
                        }
                      },
                      child: Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: Colors.lightBlue[50],
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isPlaying == true && nilaiIndex == index)
                                Container(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.pause,
                                    color: Colors.lightBlue,
                                    size: 15,
                                  ),
                                )
                              else
                                Container(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.play_arrow,
                                    color: Colors.lightBlue,
                                    size: 15,
                                  ),
                                )
                            ],
                          )),
                    )
                  ],
                ),
                subtitle: Text(
                  quran.name!.translation!.id.toString(),
                  style: TextStyle(fontSize: 12, color: Colors.lightBlue[200]),
                ),
                trailing: Text(
                  quran.name!.short.toString(),
                  style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'Misbah',
                      color: Colors.blueGrey),
                ),
              ),
            ],
          ));
        });
  }
}
