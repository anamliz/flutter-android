import 'package:hive/hive.dart';

part 'datum.g.dart';

@HiveType(typeId: 3)
class Datum extends HiveObject {
  @HiveField(0)
  String destId;

  @HiveField(1)
  String searchType;

  @HiveField(2)
  String cityName;

  @HiveField(3)
  int nrHotels;

  @HiveField(4)
  String region;

  @HiveField(5)
  String country;

  @HiveField(6)
  String? imageUrl;

  @HiveField(7)
  String type;

  @HiveField(8)
  String name;

  @HiveField(9)
  int hotels;

  @HiveField(10)
  String destType;

  @HiveField(11)
  String? appFilters;

  @HiveField(12)
  List<MetaMatch>? metaMatches;
  

  Datum({
    required this.destId,
    required this.searchType,
    required this.cityName,
    required this.nrHotels,
    required this.region,
    required this.country,
    this.imageUrl,
    required this.type,
    required this.name,
    required this.hotels,
    required this.destType,
    this.appFilters,
    this.metaMatches,
  }) : super();

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      destId: json['destId'] as String,
      searchType: json['searchType'] as String,
      cityName: json['cityName'] as String,
      nrHotels: json['nrHotels'] as int,
      region: json['region'] as String,
      country: json['country'] as String,
      imageUrl: json['imageUrl'] as String?,
      type: json['type'] as String,
      name: json['name'] as String,
      hotels: json['hotels'] as int,
      destType: json['destType'] as String,
      appFilters: json['appFilters'] as String?,
      metaMatches: json['metaMatches'] != null
          ? List<MetaMatch>.from((json['metaMatches'] as List<dynamic>)
              .map((x) => MetaMatch.fromJson(x as Map<String, dynamic>)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'destId': destId,
      'searchType': searchType,
      'cityName': cityName,
      'nrHotels': nrHotels,
      'region': region,
      'country': country,
      'imageUrl': imageUrl,
      'type': type,
      'name': name,
      'hotels': hotels,
      'destType': destType,
      'appFilters': appFilters,
      'metaMatches': metaMatches != null
          ? List<dynamic>.from(metaMatches!.map((x) => x.toJson()))
          : null,
    };
  }

  List<Datum> datums = [
    Datum(
      destId: '1',
      searchType: 'restaurant',
      cityName: 'K-ROAD JUJA',
      nrHotels: 200,
      region: 'Region X',
      country: 'Country Y',
      imageUrl: 'hotel.jpg',
      type: 'type',
      name: 'name',
      hotels: 1,
      destType: 'destType',
      appFilters: 'appFilters',
      metaMatches: [
        {'id': '1', 'type': 'type', 'isSeeded': 1, 'text': 'text'}
      ].map((x) => MetaMatch.fromJson(x)).toList(),
    ),
    Datum(
      destId: '2',
      searchType: 'cafe',
      cityName: 'Ocean Drive',
      nrHotels: 150,
      region: 'Region Z',
      country: 'Country X',
      imageUrl: 'cafe.jpg',
      type: 'type',
      name: 'name',
      hotels: 1,
      destType: 'destType',
      appFilters: 'appFilters',
      metaMatches: [],
    ),
    Datum(
      destId: '3',
      searchType: 'resort',
      cityName: 'Mountain Top',
      nrHotels: 300,
      region: 'Region Y',
      country: 'Country Z',
      imageUrl: 'resort.jpg',
      type: 'type',
      name: 'name',
      hotels: 1,
      destType: 'destType',
      appFilters: 'appFilters',
      metaMatches: [],
    ),
  ];

  static where(bool Function(dynamic datum) param0) {}

}





class MetaMatch {
  String id;
  String type;
  int isSeeded;
  String text;

  MetaMatch({
    required this.id,
    required this.type,
    required this.isSeeded,
    required this.text,
  });

  factory MetaMatch.fromJson(Map<String, dynamic> json) {
    return MetaMatch(
      id: json['id'] as String,
      type: json['type'] as String,
      isSeeded: json['isSeeded'] as int,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'isSeeded': isSeeded,
      'text': text,
    };
  }


  
}

