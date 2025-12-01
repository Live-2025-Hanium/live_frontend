import 'package:json_annotation/json_annotation.dart';

part 'map_model.g.dart';

@JsonEnum(alwaysCreate: true)
enum PlaceCategory {
  @JsonValue('LEI')
  lei,
  @JsonValue('PSY')
  psy,
  @JsonValue('WEL')
  wel,
  @JsonValue('CSC')
  csc,
}

class LatLngPoint {
  final double lat;
  final double lng;
  final String? label;
  const LatLngPoint(this.lat, this.lng, {this.label});
}

extension PlaceCategoryExtension on PlaceCategory {
  String get displayName {
    switch (this) {
      case PlaceCategory.lei:
        return '여가시설';
      case PlaceCategory.psy:
        return '정신건강의학과';
      case PlaceCategory.wel:
        return '복지시설';
      case PlaceCategory.csc:
        return '상담센터';
    }
  }
}

class CategorySearchPayloadModel {
  final PlaceCategory category;
  final double lat;
  final double lng;
  final int radius;
  final int page;
  final int size;

  CategorySearchPayloadModel({
    required this.category,
    required this.lat,
    required this.lng,
    required this.radius,
    required this.page,
    required this.size,
  });
}

@JsonSerializable()
class CategorySearchResponseModel {
  final int totalElements;
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final bool hasNext;
  final List<PlaceDetailModel> content;

  CategorySearchResponseModel({
    required this.totalElements,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
    required this.hasNext,
    required this.content,
  });

  factory CategorySearchResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CategorySearchResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategorySearchResponseModelToJson(this);
}

@JsonSerializable()
class PlaceDetailModel {
  final int id;
  final String name;
  final CategoryModel category;
  final AddressModel address;
  final LocationModel location;
  final String phone;
  final List<HoursModel> hours;
  final String intro;
  final List<String> photos;
  final String source;

  PlaceDetailModel({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.location,
    required this.phone,
    required this.hours,
    required this.intro,
    required this.photos,
    required this.source,
  });

  factory PlaceDetailModel.fromJson(Map<String, dynamic> json) =>
      _$PlaceDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$PlaceDetailModelToJson(this);
}

@JsonSerializable()
class CategoryModel {
  final PlaceCategory code;
  final String name;
  CategoryModel({required this.code, required this.name});
  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}

@JsonSerializable()
class AddressModel {
  final String province;
  final String city;
  final String road;
  final String detail;

  AddressModel({
    required this.province,
    required this.city,
    required this.road,
    required this.detail,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);
  Map<String, dynamic> toJson() => _$AddressModelToJson(this);
}

@JsonSerializable()
class LocationModel {
  final double lat;
  final double lng;
  LocationModel({required this.lat, required this.lng});
  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);
  Map<String, dynamic> toJson() => _$LocationModelToJson(this);
}

@JsonSerializable()
class HoursModel {
  final String day;
  final String open;
  final String close;
  HoursModel({required this.day, required this.open, required this.close});
  factory HoursModel.fromJson(Map<String, dynamic> json) =>
      _$HoursModelFromJson(json);
  Map<String, dynamic> toJson() => _$HoursModelToJson(this);
}
