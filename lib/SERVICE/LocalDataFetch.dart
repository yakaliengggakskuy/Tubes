import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:waqtuu/MODELS/ListQuranModel/ListQuranModel.dart';
import 'package:waqtuu/MODELS/QuranModel/QuranModel.dart';

class LocalData {
  Future<ListQuranModel> listQuran() async {
    final response = await rootBundle.loadString('assets/data/ListOfSurah.json');
    final data = jsonDecode(response);
    return ListQuranModel.fromJson(data);
  }

  Future<QuranModel> Quran() async {
    final response = await rootBundle.loadString('assets/data/Surah.json');
    final data = jsonDecode(response);
    return QuranModel.fromJson(data);
  }
}