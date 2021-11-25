import 'package:bloc/bloc.dart';
import 'package:wamo/model/wallpaper.dart';

class WallpaperEvent {}

abstract class WallpaperState {}

class WallpaperInitial extends WallpaperState {}

class WallpaperSearchEvent extends WallpaperEvent {
  String? query;

  WallpaperSearchEvent({this.query});
}

class ResetEvent extends WallpaperEvent {}

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
  set state(newState) {
    state = newState;
  }

  WallpaperBloc() : super(WallpaperInitial()) {
    on<WallpaperEvent>((event, emit) async {
      List<WallpaperImage> wallpapers;
      if (event is ResetEvent) {
        emit(WallpaperInitial());
      } else {
        if (state is WallpaperInitial) {
          if (event is WallpaperSearchEvent) {
            wallpapers = await WallpaperImage.searchWallpaper(query: event.query!, page: 1);
          } else {
            wallpapers = await WallpaperImage.getWallpaper(1);
          }
          emit(WallpaperLoaded(wallpapers: wallpapers, hasReachedMax: false, page: 1));
        } else {
          WallpaperLoaded wallpaperLoaded;
          if (event is WallpaperSearchEvent) {
            wallpaperLoaded = state as WallpaperLoaded;
            wallpapers = await WallpaperImage.searchWallpaper(query: event.query!, page: wallpaperLoaded.page + 1);
          } else {
            wallpaperLoaded = state as WallpaperLoaded;
            wallpapers = await WallpaperImage.getWallpaper(wallpaperLoaded.page + 1);
          }
          emit(wallpapers.isEmpty
              ? wallpaperLoaded.copyWith(hasReachedMax: true, page: wallpaperLoaded.page)
              : WallpaperLoaded(wallpapers: wallpaperLoaded.wallpapers! + wallpapers, hasReachedMax: false, page: wallpaperLoaded.page + 1));
        }
      }
    });
  }
}
