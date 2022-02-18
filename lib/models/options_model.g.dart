// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OptionsModelAdapter extends TypeAdapter<OptionsModel> {
  @override
  final int typeId = 1;

  @override
  OptionsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OptionsModel()
      ..name = fields[0] as String?
      ..weight = fields[1] == null ? 1 : fields[1] as int
      ..items =
          fields[2] == null ? [] : (fields[2] as List).cast<OptionsModel>();
  }

  @override
  void write(BinaryWriter writer, OptionsModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.weight)
      ..writeByte(2)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OptionsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
