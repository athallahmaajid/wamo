// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallpaper.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WallpaperImageAdapter extends TypeAdapter<WallpaperImage> {
  @override
  final int typeId = 1;

  @override
  WallpaperImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WallpaperImage(
      fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WallpaperImage obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WallpaperImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
