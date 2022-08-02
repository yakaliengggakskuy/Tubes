import 'package:flutter/material.dart';
import 'package:waqtuu/MODELS/QuranModel/QuranModel.dart' as quran;
import 'package:waqtuu/SERVICE/LocalDataFetch.dart';

class TafsirPages extends StatefulWidget {
  final int quranNumber;
  final int numberInSurah;
  const TafsirPages(
      {required this.quranNumber, required this.numberInSurah, Key? key})
      : super(key: key);

  @override
  State<TafsirPages> createState() => _TafsirPagesState();
}

class _TafsirPagesState extends State<TafsirPages> {
  quran.QuranModel data = quran.QuranModel();
  LocalData localData = LocalData();

  late int quranNumber;
  late int numberInSurah;
  bool isFetch = false;

  _gerData() async {
    data = await localData.Quran();
    setState(() {
      isFetch = true;
      quranNumber = widget.quranNumber;
      numberInSurah = widget.numberInSurah - 1;
    });
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    _gerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            'Tafsir ayat',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          iconTheme: IconThemeData(color: Colors.grey),
        ),
        body: isFetch
            ? SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        width: MediaQuery.of(context).size.width / 1.1,
                        decoration: BoxDecoration(
                            color: Colors.lightGreen[50],
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Tafsir ' +
                                      data.data![quranNumber].name!
                                          .transliteration!.id
                                          .toString() +
                                      ' ayat ke ${numberInSurah + 1}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  data.data![quranNumber].verses![numberInSurah]
                                      .text!.arab
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontFamily: 'Misbah',
                                      height: 2),
                                  textAlign: TextAlign.right,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tafsir Pendek',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              data.data![quranNumber].verses![numberInSurah]
                                  .tafsir!.id!.short
                                  .toString(),
                              textAlign: TextAlign.justify,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tafsir Panjang',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(
                              data.data![quranNumber].verses![numberInSurah]
                                  .tafsir!.id!.long
                                  .toString(),
                              textAlign: TextAlign.justify,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Sumber: sutanlab Api x Kemenag',
                        style: TextStyle(color: Colors.grey[600], fontSize: 11),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox());
  }
}
