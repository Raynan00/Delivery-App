// To parse this JSON data, do
//
//     final chartResponse = chartResponseFromJson(jsonString);

import 'dart:convert';

List<ChartResponse> chartResponseFromJson(String str) => List<ChartResponse>.from(json.decode(str).map((x) => ChartResponse.fromJson(x)));

String chartResponseToJson(List<ChartResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChartResponse {
  ChartResponse({
    this.total,
    this.date,
  });

  double total;
  String date;

  factory ChartResponse.fromJson(Map<String, dynamic> json) => ChartResponse(
    total: json["total"].toDouble(),
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "date": date,
  };
}
