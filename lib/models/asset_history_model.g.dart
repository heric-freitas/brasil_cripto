// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssetHistoryModelAdapter extends TypeAdapter<AssetHistoryModel> {
  @override
  final int typeId = 1;

  @override
  AssetHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AssetHistoryModel(
      priceUsd: fields[0] as double,
      time: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AssetHistoryModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.priceUsd)
      ..writeByte(1)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssetHistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
