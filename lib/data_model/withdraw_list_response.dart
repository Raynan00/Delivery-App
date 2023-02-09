// To parse this JSON data, do
//
//     final withdrawListResponse = withdrawListResponseFromJson(jsonString);

import 'dart:convert';

WithdrawListResponse withdrawListResponseFromJson(String str) => WithdrawListResponse.fromJson(json.decode(str));

String withdrawListResponseToJson(WithdrawListResponse data) => json.encode(data.toJson());

class WithdrawListResponse {
  WithdrawListResponse({
    this.data,
    this.links,
    this.meta,
  });

  List<Withdraw> data;
  Links links;
  Meta meta;

  factory WithdrawListResponse.fromJson(Map<String, dynamic> json) => WithdrawListResponse(
    data: List<Withdraw>.from(json["data"].map((x) => Withdraw.fromJson(x))),
    links: Links.fromJson(json["links"]),
    meta: Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "links": links.toJson(),
    "meta": meta.toJson(),
  };
}

class Withdraw {
  Withdraw({
    this.id,
    this.amount,
    this.status,
    this.createdAt,
  });

  int id;
  String amount;
  String status;
  String createdAt;

  factory Withdraw.fromJson(Map<String, dynamic> json) => Withdraw(
    id: json["id"],
    amount: json["amount"],
    status: json["status"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "status": status,
    "created_at": createdAt,
  };
}

class Links {
  Links({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  String first;
  String last;
  dynamic prev;
  dynamic next;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    first: json["first"],
    last: json["last"],
    prev: json["prev"],
    next: json["next"],
  );

  Map<String, dynamic> toJson() => {
    "first": first,
    "last": last,
    "prev": prev,
    "next": next,
  };
}

class Meta {
  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  int currentPage;
  int from;
  int lastPage;
  List<Link> links;
  String path;
  int perPage;
  int to;
  int total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "links": List<dynamic>.from(links.map((x) => x.toJson())),
    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
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
