import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wamo/bloc/wallpaper_bloc.dart';
import 'package:wamo/model/wallpaper.dart';
import 'package:wamo/view/search_page.dart';

import 'detail_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();
  ScrollController controller = ScrollController();
  late WallpaperBloc bloc;

  void onScroll() {
    double maxScroll = controller.position.maxScrollExtent;
    double currentScroll = controller.position.pixels;

    if (currentScroll == maxScroll) {
      bloc.add(WallpaperEvent());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
    });
    _pageController.jumpToPage(value);
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<WallpaperBloc>(context);
    controller.addListener(onScroll);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Favorites",
            icon: Icon(Icons.favorite),
          ),
        ],
        onTap: _onTappedBar,
        selectedItemColor: Colors.blue,
        currentIndex: _selectedIndex,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
        children: [
          SingleChildScrollView(
            physics: const ScrollPhysics(),
            controller: controller,
            child: Column(
              children: [
                SizedBox(
                  height: (MediaQuery.of(context).size.width * 2 / 3),
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned(
                        top: -(MediaQuery.of(context).size.width * 2 / 4) / 10,
                        right: -(MediaQuery.of(context).size.width * 2 / 3) / 10,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        top: -(MediaQuery.of(context).size.width * 2 / 3) / 10,
                        left: (MediaQuery.of(context).size.width / 10),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: (MediaQuery.of(context).size.width * 2 / 10) / 10,
                        left: -(MediaQuery.of(context).size.width * 2 / 3) / 10,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage()));
                          },
                          child: Hero(
                            tag: "search",
                            child: Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(50),
                              child: Container(
                                padding: EdgeInsets.only(left: 20),
                                width: MediaQuery.of(context).size.width / 1.25,
                                height: 50,
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: const [
                                    Icon(Icons.search),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("Search Wallpaper"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<WallpaperBloc, WallpaperState>(
                  builder: (context, state) {
                    if (state is WallpaperInitial) {
                      return const Center(
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      );
                    } else {
                      WallpaperLoaded wallpaperLoaded = state as WallpaperLoaded;
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: (wallpaperLoaded.hasReachedMax!) ? wallpaperLoaded.wallpapers!.length : wallpaperLoaded.wallpapers!.length + 1,
                        itemBuilder: (context, index) {
                          if (index % 2 == 0) {
                            return Container();
                          }
                          return Column(
                            children: [
                              (index < wallpaperLoaded.wallpapers!.length - 1)
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => DetailPage(url: wallpaperLoaded.wallpapers![index].url, tag: index.toString()),
                                              ),
                                            );
                                          },
                                          child: Hero(
                                            tag: (index).toString(),
                                            child: Container(
                                                height: 300,
                                                width: 160,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage(wallpaperLoaded.wallpapers![index].url),
                                                    fit: BoxFit.fill,
                                                  ),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                margin: const EdgeInsets.all(5)),
                                          ),
                                        ),
                                        (wallpaperLoaded.wallpapers!.length != index)
                                            ? GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailPage(url: wallpaperLoaded.wallpapers![index + 1].url, tag: (index + 1).toString()),
                                                    ),
                                                  );
                                                },
                                                child: Hero(
                                                  tag: (index + 1).toString(),
                                                  child: Container(
                                                      height: 300,
                                                      width: 160,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: NetworkImage(wallpaperLoaded.wallpapers![index + 1].url),
                                                          fit: BoxFit.fill,
                                                        ),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      margin: const EdgeInsets.all(5)),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    )
                                  : const SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator.adaptive(),
                                    ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: Hive.openBox("wallpaperimages"),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  var wallpaperBox = Hive.box("wallpaperimages");
                  return ValueListenableBuilder(
                    valueListenable: wallpaperBox.listenable(),
                    builder: (context, Box wallpapers, _) => ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        WallpaperImage wallpaperImage = wallpaperBox.getAt(index);
                        if (index % 2 == 0) {
                          return Container();
                        }
                        return Column(
                          children: [
                            if (index != 0)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailPage(url: wallpaperImage.url, tag: index.toString()),
                                          ),
                                        );
                                      },
                                      child: Hero(
                                        tag: (index).toString(),
                                        child: Container(
                                            height: 300,
                                            width: 160,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(wallpaperImage.url),
                                                fit: BoxFit.fill,
                                              ),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            margin: const EdgeInsets.fromLTRB(10, 5, 10, 5)),
                                      ),
                                    ),
                                  ),
                                  (index != wallpaperBox.length - 1)
                                      ? Align(
                                          alignment: Alignment.centerRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailPage(url: wallpaperBox.getAt(index + 1).url, tag: (index + 1).toString()),
                                                ),
                                              );
                                            },
                                            child: Hero(
                                              tag: (index + 1).toString(),
                                              child: Container(
                                                  height: 300,
                                                  width: 160,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage(wallpaperBox.getAt(index + 1).url),
                                                      fit: BoxFit.fill,
                                                    ),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  margin: const EdgeInsets.fromLTRB(10, 5, 10, 5)),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              )
                            else
                              const SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator.adaptive(),
                              ),
                          ],
                        );
                      },
                    ),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
