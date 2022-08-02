import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readmore/readmore.dart';
import 'package:waqtuu/MODELS/QuranModel/QuranModel.dart' as quran;
import 'package:waqtuu/SCREEN/Quran/Tafsir.dart';
import 'package:waqtuu/SERVICE/LocalDataFetch.dart';

class QuranPages extends StatefulWidget {
  final int quranNumber;

  const QuranPages({required this.quranNumber, Key? key}) : super(key: key);

  @override
  State<QuranPages> createState() => _QuranPagesState();
}

class _QuranPagesState extends State<QuranPages> {
  quran.QuranModel data = quran.QuranModel();
  LocalData localData = LocalData();

  final audioPlayer = AudioPlayer();

  List result = [];

  bool isFetch = false;
  bool audioPlaying = false;
  String query = '';
  int nilaiIndex = 0;
  late int quranNumber;

  _getData() async {
    data = await localData.Quran();
    setState(() {
      isFetch = true;
      quranNumber = widget.quranNumber - 1;
    });
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
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.grey),
          title: isFetch
              ? Text(
                  data.data![quranNumber].name!.transliteration!.id.toString(),
                  style: TextStyle(
                      color: Colors.green[300],
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                )
              : Text(
                  'Loading..',
                  style: TextStyle(
                      color: Colors.green[300],
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
          actions: [
            isFetch
                ? GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      showModalBottomSheet<dynamic>(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return FractionallySizedBox(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))),
                                child: Wrap(
                                  direction: Axis.vertical,
                                  runAlignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.1,
                                      height: 250,
                                      padding: EdgeInsets.all(10),
                                      child: SingleChildScrollView(
                                        physics: BouncingScrollPhysics(),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                'Surah ${data.data![quranNumber].name!.transliteration!.id} atau yang memiliki arti ${data.data![quranNumber].name!.translation!.id}, terdiri dari ${data.data![quranNumber].numberOfVerses} ayat dan tergolong surah ${data.data![quranNumber].revelation!.id}'),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Tafsir Surah',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                                '${data.data![quranNumber].tafsirSurah!.id}'),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              'Tekan diluar kotak untuk menutup',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 11),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.only(
                          top: 15, bottom: 15, right: 5, left: 10),
                      child: Container(
                        width: 80,
                        decoration: BoxDecoration(
                            color: Colors.lightBlue[50],
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                            child: Text(
                          'info surah',
                          style: TextStyle(
                              fontSize: 11, color: Colors.lightBlue[300]),
                        )),
                      ),
                    ),
                  )
                : SizedBox()
          ],
        ),
        body: isFetch
            ? Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 50, right: 50, top: 5, bottom: 5),
                      child: Container(
                        padding: EdgeInsets.only(left: 15, right: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(40)),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              query = value;
                              _searching(
                                query,
                              );
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: 'Cari ayat',
                              hintStyle: TextStyle(fontSize: 15),
                              border: InputBorder.none,
                              suffixIcon: Icon(Icons.search)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    query.isEmpty ? _onQuery() : _onSearch()
                  ],
                ),
              )
            : SizedBox());
  }

  _searching(String input) {
    result = data.data![quranNumber].verses!
        .where((element) => element.number!.inSurah.toString() == input)
        .toList();
  }

  _onSearch() {
    return Expanded(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: result.length,
        itemBuilder: (context, index) {
          var quran = result[index];
          return Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(bottom: 10),
            color:
                quran.number!.inSurah.isEven ? Colors.grey[50] : Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 13,
                        backgroundImage:
                            AssetImage('assets/images/ayat_frame.png'),
                        backgroundColor: Colors.transparent,
                        child: Text(
                          quran.number!.inSurah.toString(),
                          style: TextStyle(fontSize: 11, color: Colors.green),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              audioPlayer.stop();
                              HapticFeedback.vibrate();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TafsirPages(
                                            quranNumber: quranNumber,
                                            numberInSurah:
                                                quran.number!.inSurah!.toInt(),
                                          )));
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 5, right: 5, top: 2, bottom: 2),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.blueGrey,
                                  ),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                'Tafsir',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () async {
                              HapticFeedback.vibrate();
                              try {
                                final result =
                                    await InternetAddress.lookup('google.com');
                                if (result.isNotEmpty) {
                                  //plat audio
                                }
                              } catch (e) {
                                Fluttertoast.showToast(
                                    msg: 'Tidak terhubung internet');
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: nilaiIndex == index
                                      ? Colors.lightBlue
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(8)),
                              padding: EdgeInsets.all(3),
                              child: Icon(
                                Icons.play_arrow,
                                size: 16,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    quran.text!.arab.toString(),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 28,
                        fontFamily: 'Misbah',
                        height: 2,
                        color: Colors.blueGrey),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    width: MediaQuery.of(context).size.width,
                    // color: Colors.amber,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        //Text(quran.verses![index].translation!.id.toString(), style: TextStyle(fontSize: 12, color: Colors.grey),)
                        ReadMoreText(
                          quran.translation!.id.toString(),
                          trimLines: 4,
                          colorClickableText: Colors.green,
                          trimCollapsedText: 'Lihat Lebih banyak',
                          trimExpandedText: ' Lihat lebih sedikit',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        )
                      ],
                    )),
              ],
            ),
          );
        },
      ),
    );
  }

  _onQuery() {
    return Expanded(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: data.data![quranNumber].verses!.length,
        itemBuilder: (context, index) {
          var quran = data.data![quranNumber];
          return Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(bottom: 10),
            color: index.isOdd ? Colors.grey[50] : Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 13,
                        backgroundImage:
                            AssetImage('assets/images/ayat_frame.png'),
                        backgroundColor: Colors.transparent,
                        child: Text(
                          quran.verses![index].number!.inSurah.toString(),
                          style: TextStyle(fontSize: 11, color: Colors.green),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              audioPlayer.stop();
                              HapticFeedback.vibrate();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TafsirPages(
                                            quranNumber: quranNumber,
                                            numberInSurah: quran
                                                .verses![index].number!.inSurah!
                                                .toInt(),
                                          )));
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 5, right: 5, top: 2, bottom: 2),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.blueGrey,
                                  ),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                'Tafsir',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () async {
                              HapticFeedback.vibrate();
                              try {
                                final result =
                                    await InternetAddress.lookup('google.com');
                                if (result.isNotEmpty) {}
                              } catch (e) {
                                Fluttertoast.showToast(
                                    msg: 'Tidak terhubung Internet');
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: nilaiIndex == index
                                      ? Colors.lightBlue
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(8)),
                              padding: EdgeInsets.all(3),
                              child: Icon(
                                Icons.play_arrow,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    quran.verses![index].text!.arab.toString(),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 28,
                        fontFamily: 'Misbah',
                        height: 2,
                        color: Colors.blueGrey),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        ReadMoreText(
                          quran.verses![index].translation!.id.toString(),
                          trimLines: 4,
                          colorClickableText: Colors.green,
                          trimCollapsedText: 'Lihat Lebih banyak',
                          trimExpandedText: ' Lihat lebih sedikit',
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 12),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
