import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:svg_icon/svg_icon.dart';
import 'package:waqtuu/SCREEN/Qibla/QiblaPages.dart';
import 'package:waqtuu/SCREEN/Quran/ListQuran.dart';
import 'package:waqtuu/SCREEN/WaktuShalat/WaktuShalat.dart';

class HomePages extends StatefulWidget {
  const HomePages({Key? key}) : super(key: key);

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  final hadishaian = [
    '“Tidak sempurna iman seseorang, sehingga dia mencintai saudaranya seperti mencintai dirinya sendiri.”',
    '“Sebagian dari kebaikan Islam, seseorang meninggalkan sesuatu yang tidak berguna.”',
    '“Barangsiapa beriman kepada Allah dan hari akhirat maka hendaklah memuliakan tamu.”',
    '“Kebanyakan dosa anak-anak Adam itu ada pada lisannya.”',
    '“Orang yang menunjukkan jalan kebaikan, mendapat pahala seperti yang melakukannya.”',
    '“Sesungguhnya sebagian akhlaq Islam adalah rasa malu.”',
    '“Sesungguhnya Allah itu indah dan mencintai keindahan.”',
    '“Senyum engkau dihadapan saudaramu adalah sedekah.”',
    '“Kebersihan itu sebagian dari iman.”',
    '“Setiap kebaikan adalah sedekah,”',
    '“Shalat adalah tiang agama.”',
    '“Surga itu ada dibawah telapak kaki Ibu."',
    '"Kita adalah makhluk yang suka menyalahkan dari luar, tidak menyadari bahwa masalah biasanya dari dalam."',
    '"Jangan berduka, apa pun yang hilang darimu akan kembali lagi dalam wujud lain."',
    '"Barangsiapa diharamkan atasnya kasih sayang, maka segala bentuk kebaikan akan dihilangkan darinya."',
    '"Barangsiapa yang tidak mensyukuri yang sedikit, maka ia tidak akan mampu mensyukuri sesuatu yang banyak."',
    '"Selalu ada pahala bagi setiap pelaku kebaikan kepada seluruh makhluk hidup."',
    '"Aku tak pernah sekalipun menyesali diamku. Tapi berkali-kali menyesali bicaraku."',
  ];

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.sort,
              color: Colors.grey,
            ),
          ),
          title: Text(
            'WAQTU',
            style: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.settings_outlined,
                  color: Colors.grey,
                ))
          ],
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  height: 100,
                  width: MediaQuery.of(context).size.width / 1.2,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          if (DateTime.now().hour >= 18 &&
                              DateTime.now().hour <= 24)
                            Color.fromARGB(255, 113, 129, 133)
                          else
                            Color(0xFFD7F3FA),
                          Color.fromARGB(255, 130, 197, 214)
                        ],
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                        stops: [0.0, 0.7],
                      ),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (DateTime.now().hour >= 5 &&
                                DateTime.now().hour <= 11)
                              Text(
                                'menuju sholat dzuhur',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white),
                              )
                            else if (DateTime.now().hour >= 11 &&
                                DateTime.now().hour <= 14)
                              Text(
                                'menuju sholat ashar',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white),
                              )
                            else if (DateTime.now().hour >= 14 &&
                                DateTime.now().hour <= 17)
                              Text(
                                'menuju sholat maghrib',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white),
                              )
                            else if (DateTime.now().hour >= 17 &&
                                DateTime.now().hour <= 18)
                              Text(
                                'menuju sholat isya',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white),
                              )
                            else
                              Text(
                                'menuju sholat subuh',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white),
                              ),
                            StreamBuilder(
                              stream: Stream.periodic(Duration(seconds: 1)),
                              builder: (context, snapshot) {
                                return Text(
                                  DateFormat('HH:mm').format(DateTime.now()),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                            Text(
                              '${DateFormat('dd MMMM yyyy').format(DateTime.now())}',
                              style:
                                  TextStyle(fontSize: 13, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (DateTime.now().hour >= 0 &&
                                DateTime.now().hour <= 5)
                              Icon(
                                Icons.nights_stay_outlined,
                                size: 55,
                                color: Colors.white,
                              )
                            else if (DateTime.now().hour >= 5 &&
                                DateTime.now().hour <= 17)
                              Icon(
                                Icons.light_mode,
                                size: 55,
                                color: Colors.white,
                              )
                            else if (DateTime.now().hour >= 17 &&
                                DateTime.now().hour <= 24)
                              Icon(
                                Icons.dark_mode_outlined,
                                size: 55,
                                color: Colors.white,
                              )
                            else
                              SizedBox()
                          ],
                        ),
                      )
                    ],
                  ),
                ), // akhir dari container waktu

                SizedBox(
                  height: 20,
                ),

                Container(
                  padding: EdgeInsets.only(left: 25),
                  width: MediaQuery.of(context).size.width / 1.1,
                  // color: Colors.amber,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WaktuShalat()));
                        },
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color.fromARGB(255, 49, 221, 150)),
                              child: SvgIcon(
                                'assets/svg/sujud.svg',
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Container(
                              child: Text(
                                'Waktu\nSholat',
                                style:
                                    TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListQuran()));
                        },
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color.fromARGB(255, 49, 221, 150)),
                              child: SvgIcon(
                                'assets/svg/quran.svg',
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Container(
                              child: Text(
                                'Qur`an\nOffline',
                                style:
                                    TextStyle(fontSize: 11, color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QiblaPages()));
                        },
                        child: Column(
                          children: [
                            Container(
                                padding: EdgeInsets.all(5),
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color.fromARGB(255, 49, 221, 150)),
                                child: Center(
                                    child: FaIcon(
                                  FontAwesomeIcons.kaaba,
                                  color: Colors.white,
                                  size: 30,
                                ))),
                            SizedBox(
                              height: 3,
                            ),
                            Container(
                              child: Text(
                                'Qiblah\n',
                                style:
                                    TextStyle(fontSize: 11, color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color.fromARGB(255, 49, 221, 150)),
                            //child: SvgIcon('assets/svg/tasbih.svg', color: Colors.white,),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Container(
                            child: Text(
                              'Dzikir\n',
                              style:
                                  TextStyle(fontSize: 11, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color.fromARGB(255, 49, 221, 150)),
                            //child: Icon(Icons.apps, color: Colors.white, size: 35,)
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Container(
                            child: Text(
                              'Do`a\nHarian',
                              style:
                                  TextStyle(fontSize: 11, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ), // bottom of atas

                SizedBox(
                  height: 10,
                ),

                Container(
                  padding: EdgeInsets.only(left: 25),
                  width: MediaQuery.of(context).size.width / 1.1,
                  // color: Colors.amber,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color.fromARGB(255, 49, 221, 150)),
                            //child: SvgIcon('assets/svg/sujud.svg', color: Colors.white,),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Container(
                            child: Text(
                              'Kisah\nNabi',
                              style:
                                  TextStyle(fontSize: 11, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color.fromARGB(255, 49, 221, 150)),
                            //child: SvgIcon('assets/svg/quran.svg', color: Colors.white,),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Container(
                            child: Text(
                              'Hadits\n',
                              style:
                                  TextStyle(fontSize: 11, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color.fromARGB(255, 49, 221, 150)),
                            //child: SvgIcon('assets/svg/allah.svg', color: Colors.white,),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Container(
                            child: Text(
                              'Kisah\nSahabat',
                              style:
                                  TextStyle(fontSize: 11, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color.fromARGB(255, 49, 221, 150)),
                            //child: SvgIcon('assets/svg/tasbih.svg', color: Colors.white,),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Container(
                            child: Text(
                              'Belajar\nShalat',
                              style:
                                  TextStyle(fontSize: 11, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color.fromARGB(255, 49, 221, 150)),
                            //child: SvgIcon('assets/svg/tasbih.svg', color: Colors.white,),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Container(
                            child: Text(
                              'Arah\nKiblat',
                              style:
                                  TextStyle(fontSize: 11, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ), // bottom of menu

                SizedBox(
                  height: 100,
                ),

                GestureDetector(
                  onTap: () {
                    print('object');
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Kutipan Hari ini'),
                        Text('>'),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                Container(
                    width: MediaQuery.of(context).size.width / 1.15,
                    height: MediaQuery.of(context).size.width / 2.5,
                    child: CarouselSlider.builder(
                      options: CarouselOptions(
                          initialPage: 1,
                          height: 100,
                          scrollDirection: Axis.vertical,
                          pauseAutoPlayOnTouch: true,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 500)),
                      itemCount: hadishaian.length,
                      itemBuilder: (context, index, realindex) {
                        return Container(
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.symmetric(vertical: 1),
                            height: 200,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 49, 221, 150),
                                borderRadius: BorderRadius.circular(25)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${hadishaian[index]}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    )),
                                Text('scroll untuk melihat lebih',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ))
                              ],
                            ));
                      },
                    ))
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 60,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.headset_mic,
                    color: Colors.blueGrey,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.coffee_maker_outlined,
                    color: Colors.blueGrey,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.star_half,
                    color: Colors.blueGrey,
                  )),
            ],
          ),
        ));
  }
}
