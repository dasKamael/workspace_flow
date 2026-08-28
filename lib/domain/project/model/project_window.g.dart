// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_window.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectWindow _$ProjectWindowFromJson(Map<String, dynamic> json) => _ProjectWindow(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  screenIndex: (json['screenIndex'] as num).toInt(),
  x: (json['x'] as num).toDouble(),
  y: (json['y'] as num).toDouble(),
  width: (json['width'] as num).toDouble(),
  height: (json['height'] as num).toDouble(),
  bundleId: json['bundleId'] as String?,
  url: json['url'] as String?,
  documentPath: json['documentPath'] as String?,
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ProjectWindowToJson(_ProjectWindow instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'screenIndex': instance.screenIndex,
  'x': instance.x,
  'y': instance.y,
  'width': instance.width,
  'height': instance.height,
  'bundleId': instance.bundleId,
  'url': instance.url,
  'documentPath': instance.documentPath,
  'sortOrder': instance.sortOrder,
};
