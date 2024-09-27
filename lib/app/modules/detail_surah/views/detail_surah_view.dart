import 'package:alquran/app/constant/color.dart';
import 'package:alquran/app/data/models/detail_surah.dart' as detail;
import 'package:alquran/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../controllers/detail_surah_controller.dart';

// ignore: must_be_immutable
class DetailSurahView extends GetView<DetailSurahController> {
  DetailSurahView({super.key});
  final homeC = Get.find<HomeController>();
  Map<String, dynamic>? bookmark;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            padding: const EdgeInsets.only(left: 10),
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        title: Text(
          "Surah ${Get.arguments['name']}",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<detail.DetailSurah>(
        future: controller.getDetailSurah(Get.arguments['number'].toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text("Tidak ada data"),
            );
          }
          if (Get.arguments['bookmark'] != null) {
            bookmark = Get.arguments['bookmark'];
            if (bookmark!['index_ayat'] > 1) {
              controller.scrollC.scrollToIndex(
                bookmark!['index_ayat'] + 2,
                preferPosition: AutoScrollPosition.begin,
              );
            }
          }
          print(bookmark);

          detail.DetailSurah surah = snapshot.data!;

          List<Widget> allAyat = List.generate(
            snapshot.data?.verses?.length ?? 0,
            (index) {
              detail.Verse? ayat = snapshot.data?.verses?[index];
              return AutoScrollTag(
                key: ValueKey(index + 2),
                index: index + 2,
                controller: controller.scrollC,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: appPurpleVibrant.withOpacity(0.3)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.contain,
                                      image: AssetImage(Get.isDarkMode
                                          ? "assets/images/list-logo-dark.png"
                                          : "assets/images/list-logo-light.png"))),
                              child: Center(child: Text("${index + 1}")),
                            ),
                            GetBuilder<DetailSurahController>(
                              builder: (c) => Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Get.defaultDialog(
                                            title: "BOOKMARK",
                                            middleText: "Pilih jenis bookmark",
                                            actions: [
                                              TextButton(
                                                  onPressed: () async {
                                                    await c.addBookmark(
                                                        true,
                                                        snapshot.data!,
                                                        ayat!,
                                                        index);
                                                    homeC.update();
                                                  },
                                                  child: Text("Last Read")),
                                              TextButton(
                                                  onPressed: () {
                                                    c.addBookmark(
                                                        false,
                                                        snapshot.data!,
                                                        ayat!,
                                                        index);
                                                  },
                                                  child: Text("Bookmark"))
                                            ]);
                                      },
                                      icon: const Icon(
                                          Icons.bookmark_add_outlined)),
                                  (ayat?.kondisiAudio == 'stop')
                                      ? IconButton(
                                          onPressed: () {
                                            c.playAudio(ayat);
                                          },
                                          icon: const Icon(Icons.play_arrow))
                                      : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            (ayat?.kondisiAudio == 'playing')
                                                ? IconButton(
                                                    onPressed: () {
                                                      c.pauseAudio(ayat!);
                                                    },
                                                    icon:
                                                        const Icon(Icons.pause))
                                                : IconButton(
                                                    onPressed: () {
                                                      c.resumeAudio(ayat!);
                                                    },
                                                    icon: const Icon(
                                                        Icons.play_arrow)),
                                            IconButton(
                                                onPressed: () {
                                                  c.stopAudio(ayat!);
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
                      "${ayat!.text?.arab}",
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
                ),
              );
            },
          );

          return ListView(
            controller: controller.scrollC,
            padding: EdgeInsets.all(20),
            children: [
              AutoScrollTag(
                key: ValueKey(0),
                index: 0,
                controller: controller.scrollC,
                child: GestureDetector(
                  onTap: () => Get.defaultDialog(
                      backgroundColor:
                          Get.isDarkMode ? appPurpleDark : appWhtie,
                      title: "Tafsir ${surah.name?.transliteration?.id}",
                      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
                      content: Text(
                        surah.tafsir?.id ?? 'Tidak ada tafsir pada surah ini ',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: Get.isDarkMode ? appWhtie : Colors.black),
                      ),
                      contentPadding: const EdgeInsets.all(20)),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [appPurpleLight, appPurpleVibrant]),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                              "${surah.name?.transliteration?.id?.toUpperCase()}",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: appWhtie)),
                          Text(
                              "( ${surah.name?.translation?.id?.toUpperCase()} )",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: appWhtie)),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                              "${surah.numberOfVerses} Ayat | ${surah.revelation?.id}",
                              style: const TextStyle(
                                  fontSize: 16, color: appWhtie)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              AutoScrollTag(
                key: ValueKey(1),
                index: 1,
                controller: controller.scrollC,
                child: SizedBox(
                  height: 20,
                ),
              ),
              ...allAyat,
            ],
          );
        },
      ),
    );
  }
}
