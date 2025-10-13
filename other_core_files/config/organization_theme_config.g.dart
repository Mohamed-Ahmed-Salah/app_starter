// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_theme_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrganizationThemeConfigAdapter
    extends TypeAdapter<OrganizationThemeConfig> {
  @override
  final int typeId = 0;

  @override
  OrganizationThemeConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrganizationThemeConfig(
      organizationId: fields[0] as String,
      primaryColor: fields[1] as String,
      primaryColorSwatch: (fields[2] as Map).cast<String, String>(),
      secondaryColor: fields[3] as String,
      logoUrl: fields[4] as String,
      bannerUrl: fields[5] as String,
      companyName: fields[6] as String,
      apiVersion: fields[7] as String,
      fontFamily: fields[8] as String,
      version: fields[11] ?? 1,
    );
  }

  @override
  void write(BinaryWriter writer, OrganizationThemeConfig obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.organizationId)
      ..writeByte(1)
      ..write(obj.primaryColor)
      ..writeByte(2)
      ..write(obj.primaryColorSwatch)
      ..writeByte(3)
      ..write(obj.secondaryColor)
      ..writeByte(4)
      ..write(obj.logoUrl)
      ..writeByte(5)
      ..write(obj.bannerUrl)
      ..writeByte(6)
      ..write(obj.companyName)
      ..writeByte(7)
      ..write(obj.apiVersion)
      ..writeByte(8)
      ..write(obj.fontFamily)
      ..writeByte(11)
      ..write(obj.version);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganizationThemeConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
