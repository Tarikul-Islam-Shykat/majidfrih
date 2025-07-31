// Add this CityModel class at the bottom of your PostController file
// or create a separate file: lib/models/city_model.dart

class CityModel {
  final String name;
  final String isoCode;
  final String countryCode;
  final String latitude;
  final String longitude;

  CityModel({
    required this.name,
    required this.isoCode,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      name: json['name'] ?? '',
      isoCode: json['isoCode'] ?? '',
      countryCode: json['countryCode'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isoCode': isoCode,
      'countryCode': countryCode,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  String toString() => name;
}
