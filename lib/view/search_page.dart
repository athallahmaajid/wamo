import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wamo/bloc/wallpaper_bloc.dart';
import 'package:wamo/view/detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchQuery = TextEditingController();
  ScrollController scrollController = ScrollController();
  late WallpaperBloc bloc;
  late int itemIndex;
  bool isPressed = false;

  void onScroll() {
    double maxScroll = scrollController.position.maxScrollExtent;
    double currentScroll = scrollController.position.pixels;

    if (currentScroll == maxScroll) {
      bloc.add(WallpaperSearchEvent(query: searchQuery.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(onScroll);
    return BlocProvider<WallpaperBloc>(
      create: (context) {
        bloc = WallpaperBloc();
        return bloc;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          controller: scrollController,
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),
                      Hero(
                        tag: "search",
                        child: Material(
                          elevation: 3,
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(5, 3, 5, 0),
                            width: MediaQuery.of(context).size.width / 1.25,
                            height: 50,
                            child: TextField(
                              autofocus: true,
                              controller: searchQuery,
                              textInputAction: TextInputAction.search,
                              onSubmitted: (value) {
                                isPressed = true;
                                bloc.add(ResetEvent());
                                bloc.add(WallpaperSearchEvent(query: searchQuery.text));
                              },
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                border: InputBorder.none,
                                hintText: "Search Wallpaper",
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
                      if (isPressed) {
                        return const Center(
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    } else {
                      WallpaperLoaded wallpaperLoaded = state as WallpaperLoaded;
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: (wallpaperLoaded.hasReachedMax!) ? wallpaperLoaded.wallpapers!.length : wallpaperLoaded.wallpapers!.length + 1,
                        itemBuilder: (context, index) {
                          itemIndex = index;
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
        ),
      ),
    );
  }
}
