class MyRoute {
  MyRoute({
    this.sdmem,
    this.ypldate,
    this.zid,
    this.yplrouteNummer,
    this.id,
    this.yplrouteNamebspr,
  });

  String? sdmem;
  String? ypldate;
  String? zid;
  String? yplrouteNummer;
  String? id;
  String? yplrouteNamebspr;

  factory MyRoute.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) {
      return MyRoute();
    }
    return MyRoute(
      sdmem: json["ysdmem^such"] ?? '',
      ypldate: json["ypldate"] ?? '',
      zid: json["zid"] ?? '',
      yplrouteNummer: json["yplroute^nummer"] ?? '',
      id: json["id"] ?? '',
      yplrouteNamebspr: json["yplroute^namebspr"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "ysdmem^such": sdmem ?? '',
        "ypldate": ypldate ?? '',
        "zid": zid ?? '',
        "yplroute^nummer": yplrouteNummer ?? '',
        "id": id ?? '',
        "yplroute^namebspr": yplrouteNamebspr ?? '',
      };
}