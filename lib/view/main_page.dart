import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wamo/bloc/wallpaper_bloc.dart';

import 'detail_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<WallpaperBloc>(context);
    controller.addListener(onScroll);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
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
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        width: MediaQuery.of(context).size.width / 1.25,
                        height: 50,
                        child: const TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
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
                                    GestureDetector(
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
                                    ),
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
            )
          ],
        ),
      ),
    );
  }
}
