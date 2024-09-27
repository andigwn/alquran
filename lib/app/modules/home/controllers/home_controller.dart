import 'dart:convert';

import 'package:alquran/app/constant/color.dart';
import 'package:alquran/app/data/db/bookmark.dart';
import 'package:alquran/app/data/models/juz.dart';
import 'package:alquran/app/data/models/surah.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

class HomeController extends GetxController {
  List<Surah> allSurah = [];
  RxBool isDark = false.obs;

  DatabaseManager database = DatabaseManager.instance;

  Future<Map<String, dynamic>?> getLastRead() async {
    Database db = await database.db;
    List<Map<String, dynamic>> dataLastRead =
        await db.query("bookmark", where: "last_read = 1");
    if (dataLastRead.isEmpty) {
      // tidak ada data last read
      return null;
    } else {
      // ada data
      return dataLastRead.first;
    }
  }

  void deleteBookmark(int id) async {
    Database db = await database.db;
    await db.delete("bookmark", where: "id = $id");
    update();
    Get.back();
    Get.snackbar("Berhasil", "last read berhasil dihapus",
        colorText: appWhtie, backgroundColor: appPurpleLight);
  }

  Future<List<Map<String, dynamic>>> getBookmark() async {
    Database db = await database.db;
    List<Map<String, dynamic>> allBookmarks = await db.query("bookmark",
        where: "last_read = 0", orderBy: "number_surah");
    return allBookmarks;
  }

  void changeThemeMode() async {
    Get.isDarkMode ? Get.changeTheme(themeLight) : Get.changeTheme(themeDark);
    isDark.toggle();

    final box = GetStorage();
    if (Get.isDarkMode) {
      // dark --> light
      box.remove("themeDark");
    } else {
      // light --> dark
      box.write("themeDark", true);
    }
  }

  // get all surah
  Future<List<Surah>> getAllSurah() async {
    Uri url = Uri.parse("https://api.quran.gading.dev/surah");
    var res = await http.get(url);
    List data = (jsonDecode(res.body) as Map<String, dynamic>)["data"];

    if (data.isEmpty) {
      return [];
    } else {
      allSurah = data.map((e) => Surah.fromJson(e)).toList();
      return allSurah;
    }
  }

  Future<List<Juz>> getAllJuz() async {
    List<Juz> allJuz = [];
    for (int i = 1; i <= 30; i++) {
      Uri url = Uri.parse("https://api.quran.gading.dev/juz/$i");
      var res = await http.get(url);
      Map<String, dynamic> data =
          (jsonDecode(res.body) as Map<String, dynamic>)["data"];

      Juz juz = Juz.fromJson(data);
      allJuz.add(juz);
    }
    return allJuz;
  }
}
