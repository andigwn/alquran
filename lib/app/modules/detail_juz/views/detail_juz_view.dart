import 'package:alquran/app/constant/color.dart';
import 'package:alquran/app/data/models/juz.dart' as juz;
import 'package:alquran/app/data/models/surah.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_juz_controller.dart';

class DetailJuzView extends GetView<DetailJuzController> {
  final juz.Juz juzDetail = Get.arguments["juz"];
  final List<Surah> allSurahInThisJuz = Get.arguments["surah"];
  DetailJuzView({super.key});
  @override
  Widget build(BuildContext context) {
    // allSurahInThisJuz.forEach((element) {
    //   print(element.name!.transliteration!.id);
    // });
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: appWhtie,
            )),
        title: Text(
          'Juz ${juzDetail.juz}',
          style: TextStyle(color: appWhtie),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(20),
            itemCount: juzDetail.verses?.length ?? 0,
            itemBuilder: (context, index) {
              if (juzDetail.verses == null || juzDetail.verses?.length == 0) {
                return Center(child: Text("tidak ada data"));
              }
              juz.Verse ayat = juzDetail.verses![index];
              if (index != 0) {
                if (ayat.number?.inSurah == 1) {
                  controller.index++;
                }
              }
              juz.Verse verse = ayat;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (verse.number?.inSurah == 1)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          //  Get.defaultDialog(
                          //     backgroundColor: Get.isDarkMode ? appPurpleDark : appWhtie,
                          //     title: "Tafsir ${surah.name?.transliteration?.id}",
                          //     titleStyle: const TextStyle(fontWeight: FontWeight.bold),
                          //     content: Text(
                          //       surah.tafsir?.id ?? 'Tidak ada tafsir pada surah ini ',
                          //       textAlign: TextAlign.justify,
                          //       style: TextStyle(
                          //           color: Get.isDarkMode ? appWhtie : Colors.black),
                          //     ),
                          //     contentPadding: const EdgeInsets.all(20)),
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [appPurpleLight, appPurpleVibrant]),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Text(
                                      "${allSurahInThisJuz[controller.index].name!.transliteration!.id}",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: appWhtie)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: appPurpleVibrant.withOpacity(0.3)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.contain,
                                        image: AssetImage(Get.isDarkMode
                                            ? "assets/images/list-logo-dark.png"
                                            : "assets/images/list-logo-light.png"))),
                                child: Center(
                                    child: Text("${verse.number?.inSurah}")),
                              ),
                              Text(
                                "${allSurahInThisJuz[controller.index].name!.transliteration!.id}",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 17),
                              )
                            ],
                          ),
                          GetBuilder<DetailJuzController>(
                            builder: (c) => Row(
                              children: [
                                (verse.kondisiAudio == 'stop')
                                    ? IconButton(
                                        onPressed: () {
                                          c.playAudio(verse);
                                        },
                                        icon: const Icon(Icons.play_arrow))
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          (verse.kondisiAudio == 'playing')
                                              ? IconButton(
                                                  onPressed: () {
                                                    c.pauseAudio(verse);
                                                  },
                                                  icon: const Icon(Icons.pause))
                                              : IconButton(
                                                  onPressed: () {
                                                    c.resumeAudio(verse);
                                                  },
                                                  icon: const Icon(
                                                      Icons.play_arrow)),
                                          IconButton(
                                              onPressed: () {
                                                c.stopAudio(verse);
                                              },
                                              icon: const Icon(Icons.stop)),
                                        ],
                                      ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    textAlign: TextAlign.end,
                    "${ayat.text?.arab}",
                    style: const TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    textAlign: TextAlign.end,
                    "${ayat.text?.transliteration?.en}",
                    style: const TextStyle(
                        fontSize: 18, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    textAlign: TextAlign.justify,
                    "${ayat.translation?.id}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
