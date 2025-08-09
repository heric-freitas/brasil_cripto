// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto_asset_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CryptoAssetModelAdapter extends TypeAdapter<CryptoAssetModel> {
  @override
  final int typeId = 0;

  @override
  CryptoAssetModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CryptoAssetModel(
      id: fields[0] as String,
      rank: fields[1] as String,
      symbol: fields[2] as String,
      name: fields[3] as String,
      supply: fields[4] as String,
      maxSupply: fields[5] as String?,
      marketCapUsd: fields[6] as String,
      volumeUsd24Hr: fields[7] as String,
      priceUsd: fields[8] as String,
      changePercent24Hr: fields[9] as String,
      vwap24Hr: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CryptoAssetModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.rank)
      ..writeByte(2)
      ..write(obj.symbol)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.supply)
      ..writeByte(5)
      ..write(obj.maxSupply)
      ..writeByte(6)
      ..write(obj.marketCapUsd)
      ..writeByte(7)
      ..write(obj.volumeUsd24Hr)
      ..writeByte(8)
      ..write(obj.priceUsd)
      ..writeByte(9)
      ..write(obj.changePercent24Hr)
      ..writeByte(10)
      ..write(obj.vwap24Hr);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CryptoAssetModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
