import 'package:bloc/bloc.dart';
import 'package:wamo/model/wallpaper.dart';

class WallpaperEvent {}

abstract class WallpaperState {}

class WallpaperInitial extends WallpaperState {}

class WallpaperSearchEvent extends WallpaperEvent {}

class WallpaperLoaded extends WallpaperState {
  List<WallpaperImage>? wallpapers;
  bool? hasReachedMax;
  int page;

  WallpaperLoaded({this.wallpapers, this.hasReachedMax, required this.page});

  WallpaperLoaded copyWith({List<WallpaperImage>? wallpapers, bool? hasReachedMax, required int page}) {
    return WallpaperLoaded(wallpapers: wallpapers ?? this.wallpapers, hasReachedMax: hasReachedMax ?? this.hasReachedMax, page: page);
  }
}

class WallpaperBloc extends Bloc<WallpaperEvent, WallpaperState> {
  WallpaperBloc() : super(WallpaperInitial()) {
    on<WallpaperEvent>((event, emit) async {
      List<WallpaperImage> wallpapers;
      if (state is WallpaperInitial) {
        wallpapers = await WallpaperImage.getWallpaper(1);
        emit(WallpaperLoaded(wallpapers: wallpapers, hasReachedMax: false, page: 1));
      } else {
        if (event is WallpaperSearchEvent) {
        } else {}
        WallpaperLoaded wallpaperLoaded = state as WallpaperLoaded;
        wallpapers = await WallpaperImage.getWallpaper(wallpaperLoaded.page + 1);
        emit(wallpapers.isEmpty
            ? wallpaperLoaded.copyWith(hasReachedMax: true, page: wallpaperLoaded.page)
            : WallpaperLoaded(wallpapers: wallpaperLoaded.wallpapers! + wallpapers, hasReachedMax: false, page: wallpaperLoaded.page + 1));
      }
    });
  }
}
