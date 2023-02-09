// To parse this JSON data, do
//
//     final productReviewResponse = productReviewResponseFromJson(jsonString);

import 'dart:convert';

ProductReviewResponse productReviewResponseFromJson(String str) => ProductReviewResponse.fromJson(json.decode(str));

String productReviewResponseToJson(ProductReviewResponse data) => json.encode(data.toJson());

class ProductReviewResponse {
  ProductReviewResponse({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int currentPage;
  List<Review> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  String path;
  int perPage;
  dynamic prevPageUrl;
  var to;
  var total;

  factory ProductReviewResponse.fromJson(Map<String, dynamic> json) => ProductReviewResponse(
    currentPage: json["current_page"],
    data: List<Review>.from(json["data"].map((x) => Review.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": List<dynamic>.from(links.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class Review {
  Review({
    this.id,
    this.rating,
    this.comment,
    this.updatedAt,
    this.userId,
    this.name,
    this.avatar,
    this.productName,
    this.status
  });

  int id;
  int rating;
  String comment;
  DateTime updatedAt;
  var userId;
  String name;
  String avatar;
  String productName;
  var status;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json["id"],
    rating: json["rating"],
    comment: json["comment"],
    updatedAt: DateTime.parse(json["updated_at"]),
    userId: json["user_id"],
    name: json["name"],
    productName: json["product_name"],
    avatar: json["avatar"],
    status: json["status"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "rating": rating,
    "comment": comment,
    "updated_at": updatedAt.toIso8601String(),
    "user_id": userId,
    "name": name,
    "avatar": avatar,
    "product_name": productName,
    "status":status
  };
}

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  String url;
  String label;
  bool active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"] == null ? null : json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url == null ? null : url,
    "label": label,
    "active": active,
  };
}
