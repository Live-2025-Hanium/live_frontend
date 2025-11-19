// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategorySearchResponseModel _$CategorySearchResponseModelFromJson(
  Map<String, dynamic> json,
) => CategorySearchResponseModel(
  totalElements: (json['totalElements'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  currentPage: (json['currentPage'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
  hasNext: json['hasNext'] as bool,
  content: (json['content'] as List<dynamic>)
      .map((e) => PlaceDetailModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CategorySearchResponseModelToJson(
  CategorySearchResponseModel instance,
) => <String, dynamic>{
  'totalElements': instance.totalElements,
  'totalPages': instance.totalPages,
  'currentPage': instance.currentPage,
  'pageSize': instance.pageSize,
  'hasNext': instance.hasNext,
  'content': instance.content,
};

PlaceDetailModel _$PlaceDetailModelFromJson(
  Map<String, dynamic> json,
) => PlaceDetailModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  category: CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
  address: AddressModel.fromJson(json['address'] as Map<String, dynamic>),
  location: LocationModel.fromJson(json['location'] as Map<String, dynamic>),
  phone: json['phone'] as String,
  hours: (json['hours'] as List<dynamic>)
      .map((e) => HoursModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  intro: json['intro'] as String,
  photos: (json['photos'] as List<dynamic>).map((e) => e as String).toList(),
  source: json['source'] as String,
);

Map<String, dynamic> _$PlaceDetailModelToJson(PlaceDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'address': instance.address,
      'location': instance.location,
      'phone': instance.phone,
      'hours': instance.hours,
      'intro': instance.intro,
      'photos': instance.photos,
      'source': instance.source,
    };

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      code: $enumDecode(_$PlaceCategoryEnumMap, json['code']),
      name: json['name'] as String,
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'code': _$PlaceCategoryEnumMap[instance.code]!,
      'name': instance.name,
    };

const _$PlaceCategoryEnumMap = {
  PlaceCategory.lei: 'LEI',
  PlaceCategory.psy: 'PSY',
  PlaceCategory.wel: 'WEL',
  PlaceCategory.csc: 'CSC',
};

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) => AddressModel(
  province: json['province'] as String,
  city: json['city'] as String,
  road: json['road'] as String,
  detail: json['detail'] as String,
);

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) =>
    <String, dynamic>{
      'province': instance.province,
      'city': instance.city,
      'road': instance.road,
      'detail': instance.detail,
    };

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) =>
    LocationModel(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$LocationModelToJson(LocationModel instance) =>
    <String, dynamic>{'lat': instance.lat, 'lng': instance.lng};

HoursModel _$HoursModelFromJson(Map<String, dynamic> json) => HoursModel(
  day: json['day'] as String,
  open: json['open'] as String,
  close: json['close'] as String,
);

Map<String, dynamic> _$HoursModelToJson(HoursModel instance) =>
    <String, dynamic>{
      'day': instance.day,
      'open': instance.open,
      'close': instance.close,
    };
