import 'package:alquran/app/data/models/juz.dart' as juz;
import 'package:alquran/app/data/models/surah.dart';
import 'package:alquran/app/constant/color.dart';
import 'package:alquran/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    if (Get.isDarkMode) {
      controller.isDark.value = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Al-Qur'an Apps",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(Routes.SEARCH);
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Hi!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Selamat Datang di Al-Qur'an Apps",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              GetBuilder<HomeController>(
                builder: (c) => FutureBuilder<Map<String, dynamic>?>(
                  future: c.getLastRead(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [appPurpleLight, appPurpleVibrant]),
                            borderRadius: BorderRadius.circular(20)),
                        child: Stack(
                          children: [
                            Positioned(
                                right: 0,
                                bottom: -50,
                                child: SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: Image.asset(
                                      "assets/images/alquran-logo.png",
                                      fit: BoxFit.contain,
                                    ))),
                            const Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.menu_book_rounded,
                                        color: appWhtie,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Terakhir dibaca",
                                        style: TextStyle(color: appWhtie),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "Loading...",
                                    style: TextStyle(
                                        color: appWhtie, fontSize: 20),
                                  ),
                                  Text(
                                    "",
                                    style: TextStyle(color: appWhtie),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    Map<String, dynamic>? lastRead = snapshot.data;
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [appPurpleLight, appPurpleVibrant]),
                          borderRadius: BorderRadius.circular(20)),
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onLongPress: () {
                            if (lastRead != null) {
                              Get.defaultDialog(
                                  title: "Hapus",
                                  middleText:
                                      "yakin ingin menghapus terakhir dibaca ?",
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text("Cancel")),
                                    TextButton(
                                        onPressed: () {
                                          c.deleteBookmark(lastRead['id']);
                                        },
                                        child: Text("Hapus")),
                                  ]);
                            }
                          },
                          onTap: () {
                            Get.toNamed(Routes.DETAIL_SURAH, arguments: {
                              "name": lastRead!['surah']
                                  .toString()
                                  .replaceAll("+", "'"),
                              "number": lastRead['number_surah'],
                              "bookmark": lastRead,
                            });
                          },
                          child: Stack(
                            children: [
                              Positioned(
                                  right: 0,
                                  bottom: -50,
                                  child: SizedBox(
                                      width: 200,
                                      height: 200,
                                      child: Image.asset(
                                        "assets/images/alquran-logo.png",
                                        fit: BoxFit.contain,
                                      ))),
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.menu_book_rounded,
                                          color: appWhtie,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Terakhir dibaca",
                                          style: TextStyle(color: appWhtie),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      lastRead == null
                                          ? ""
                                          : lastRead['surah']
                                              .toString()
                                              .replaceAll("+", "'"),
                                      style: TextStyle(
                                          color: appWhtie, fontSize: 20),
                                    ),
                                    Text(
                                      lastRead == null
                                          ? "belum ada data"
                                          : "Juz ${lastRead['juz']} | Ayat ${lastRead['ayat']}",
                                      style: TextStyle(color: appWhtie),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const TabBar(tabs: [
                Tab(
                  text: "Surah",
                ),
                Tab(
                  text: "Juz",
                ),
                Tab(
                  text: "Bookmark",
                ),
              ]),
              Expanded(
                child: TabBarView(children: [
                  FutureBuilder<List<Surah>>(
                    future: controller.getAllSurah(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text("Tidak ada data"),
                        );
                      }
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Surah surah = snapshot.data![index];
                            return ListTile(
                              onTap: () {
                                Get.toNamed(Routes.DETAIL_SURAH, arguments: {
                                  "name": surah.name!.transliteration!.id,
                                  "number": surah.number!,
                                });
                              },
                              leading: Obx(() => Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(controller
                                                  .isDark.isTrue
                                              ? "assets/images/list-logo-dark.png"
                                              : "assets/images/list-logo-light.png"))),
                                  child: Center(
                                      child: Text(
                                    "${surah.number}",
                                  )))),
                              title: Text(
                                "${surah.name?.transliteration?.id}",
                              ),
                              subtitle: Text(
                                "${surah.numberOfVerses} Ayat | ${surah.revelation?.id}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                              trailing: Text(
                                "${surah.name?.short}",
                              ),
                            );
                          });
                    },
                  ),
                  FutureBuilder<List<juz.Juz>>(
                    future: controller.getAllJuz(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text("Tidak ada data"),
                        );
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          juz.Juz detailJuz = snapshot.data![index];
                          String nameStart =
                              detailJuz.juzStartInfo?.split(" - ").first ?? "";
                          String nameEnd =
                              detailJuz.juzEndInfo?.split(" - ").first ?? "";
                          List<Surah> allSurahInJuz = [];
                          List<Surah> rawAllSurahInJuz = [];
                          for (Surah item in controller.allSurah) {
                            rawAllSurahInJuz.add(item);
                            if (item.name!.transliteration!.id == nameEnd) {
                              break;
                            }
                          }
                          for (Surah item
                              in rawAllSurahInJuz.reversed.toList()) {
                            allSurahInJuz.add(item);
                            if (item.name!.transliteration!.id == nameStart) {
                              break;
                            }
                          }

                          return ListTile(
                              onTap: () {
                                Get.toNamed(Routes.DETAIL_JUZ, arguments: {
                                  "juz": detailJuz,
                                  "surah": allSurahInJuz.reversed.toList(),
                                });
                              },
                              leading: Obx(() => Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(controller
                                                  .isDark.isTrue
                                              ? "assets/images/list-logo-dark.png"
                                              : "assets/images/list-logo-light.png"))),
                                  child: Center(
                                      child: Text(
                                    "${index + 1}",
                                  )))),
                              title: Text(
                                "Juz ${index + 1}",
                              ),
                              isThreeLine: true,
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    detailJuz.juzStartInfo ?? 'belum ada data',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  Text(detailJuz.juzEndInfo ?? 'belum ada data',
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                ],
                              ));
                        },
                      );
                    },
                  ),
                  GetBuilder<HomeController>(
                    builder: (c) {
                      return FutureBuilder<List<Map<String, dynamic>>>(
                        future: c.getBookmark(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.data!.isEmpty) {
                            return Center(
                              child: Text("Belum ada bookmark"),
                            );
                          }
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> data = snapshot.data![index];
                              return ListTile(
                                onTap: () {
                                  Get.toNamed(Routes.DETAIL_SURAH, arguments: {
                                    "name": data['surah']
                                        .toString()
                                        .replaceAll("+", "'"),
                                    "number": data['number_surah'],
                                    "bookmark": data,
                                  });
                                },
                                leading: Obx(() => Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(controller
                                                    .isDark.isTrue
                                                ? "assets/images/list-logo-dark.png"
                                                : "assets/images/list-logo-light.png"))),
                                    child: Center(
                                        child: Text(
                                      "${index + 1}",
                                    )))),
                                title: Text(
                                  data['surah'].toString().replaceAll("+", "'"),
                                ),
                                subtitle: Text(
                                  "Ayat ${data['ayat']} | via ${data['via']}",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                trailing: IconButton(
                                    onPressed: () {
                                      c.deleteBookmark(data['id']);
                                    },
                                    icon: Icon(Icons.delete)),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => controller.changeThemeMode(),
          child: Obx(
            () => Icon(
              Icons.color_lens,
              color: controller.isDark.isTrue ? appPurple : appWhtie,
            ),
          )),
    );
  }
}
