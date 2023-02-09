// To parse this JSON data, do
//
//     final googleLocationDetailsResponse = googleLocationDetailsResponseFromJson(jsonString);

import 'dart:convert';

GoogleLocationDetailsResponse googleLocationDetailsResponseFromJson(String str) => GoogleLocationDetailsResponse.fromJson(json.decode(str));

String googleLocationDetailsResponseToJson(GoogleLocationDetailsResponse data) => json.encode(data.toJson());

class GoogleLocationDetailsResponse {
  GoogleLocationDetailsResponse({
    this.htmlAttributions,
    this.result,
    this.status,
  });

  List<dynamic> htmlAttributions;
  Result result;
  String status;

  factory GoogleLocationDetailsResponse.fromJson(Map<String, dynamic> json) => GoogleLocationDetailsResponse(
    htmlAttributions: List<dynamic>.from(json["html_attributions"].map((x) => x)),
    result: Result.fromJson(json["result"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "html_attributions": List<dynamic>.from(htmlAttributions.map((x) => x)),
    "result": result.toJson(),
    "status": status,
  };
}

class Result {
  Result({
    this.addressComponents,
    this.formattedAddress,
    this.geometry,
    this.placeId,
    this.reference,
    this.types,
    this.url,
    this.utcOffset,
    this.vicinity,
  });

  List<AddressComponent> addressComponents;
  String formattedAddress;
  Geometry geometry;
  String placeId;
  String reference;
  List<String> types;
  String url;
  int utcOffset;
  String vicinity;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    addressComponents: List<AddressComponent>.from(json["address_components"].map((x) => AddressComponent.fromJson(x))),
    formattedAddress: json["formatted_address"],
    geometry: Geometry.fromJson(json["geometry"]),
    placeId: json["place_id"],
    reference: json["reference"],
    types: List<String>.from(json["types"].map((x) => x)),
    url: json["url"],
    utcOffset: json["utc_offset"],
    vicinity: json["vicinity"],
  );

  Map<String, dynamic> toJson() => {
    "address_components": List<dynamic>.from(addressComponents.map((x) => x.toJson())),
    "formatted_address": formattedAddress,
    "geometry": geometry.toJson(),
    "place_id": placeId,
    "reference": reference,
    "types": List<dynamic>.from(types.map((x) => x)),
    "url": url,
    "utc_offset": utcOffset,
    "vicinity": vicinity,
  };
}

class AddressComponent {
  AddressComponent({
    this.longName,
    this.shortName,
    this.types,
  });

  String longName;
  String shortName;
  List<String> types;

  factory AddressComponent.fromJson(Map<String, dynamic> json) => AddressComponent(
    longName: json["long_name"],
    shortName: json["short_name"],
    types: List<String>.from(json["types"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "long_name": longName,
    "short_name": shortName,
    "types": List<dynamic>.from(types.map((x) => x)),
  };
}

class Geometry {
  Geometry({
    this.location,
    this.viewport,
  });

  Location location;
  Viewport viewport;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
    location: Location.fromJson(json["location"]),
    viewport: Viewport.fromJson(json["viewport"]),
  );

  Map<String, dynamic> toJson() => {
    "location": location.toJson(),
    "viewport": viewport.toJson(),
  };
}

class Location {
  Location({
    this.lat,
    this.lng,
  });

  double lat;
  double lng;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}

class Viewport {
  Viewport({
    this.northeast,
    this.southwest,
  });

  Location northeast;
  Location southwest;

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
    northeast: Location.fromJson(json["northeast"]),
    southwest: Location.fromJson(json["southwest"]),
  );

  Map<String, dynamic> toJson() => {
    "northeast": northeast.toJson(),
    "southwest": southwest.toJson(),
  };
}
