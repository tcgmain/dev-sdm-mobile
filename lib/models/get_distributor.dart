class GetDistributor {
  GetDistributor({
    this.type,
    this.namebspr,
    this.id,
  });

  String? type;
  String? namebspr;
  String? id;

  factory GetDistributor.fromJson(Map<String, dynamic> json) => GetDistributor(
    type: json["ycustyp^namebspr"],
    namebspr: json["namebspr"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "ycustyp^namebspr": type,
    "namebspr": namebspr,
    "id": id,
  };
}

