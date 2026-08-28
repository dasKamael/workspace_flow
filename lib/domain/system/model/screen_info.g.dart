// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScreenInfo _$ScreenInfoFromJson(Map<String, dynamic> json) => _ScreenInfo(
  index: (json['index'] as num).toInt(),
  visibleX: (json['visibleX'] as num).toDouble(),
  visibleY: (json['visibleY'] as num).toDouble(),
  visibleWidth: (json['visibleWidth'] as num).toDouble(),
  visibleHeight: (json['visibleHeight'] as num).toDouble(),
  isMain: json['isMain'] as bool,
  diagonalInches: (json['diagonalInches'] as num?)?.toDouble(),
);

Map<String, dynamic> _$ScreenInfoToJson(_ScreenInfo instance) => <String, dynamic>{
  'index': instance.index,
  'visibleX': instance.visibleX,
  'visibleY': instance.visibleY,
  'visibleWidth': instance.visibleWidth,
  'visibleHeight': instance.visibleHeight,
  'isMain': instance.isMain,
  'diagonalInches': instance.diagonalInches,
};
