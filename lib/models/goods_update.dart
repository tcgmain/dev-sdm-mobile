class GoodsUpdate {
  GoodsUpdate({  
    this. id,
    this. table,
    });

    String? id;
    List<dynamic>? table;

   factory GoodsUpdate.fromJson(Map<String, dynamic> json) => GoodsUpdate(
        id : json["id"],
        table : json["table"],
    );

    Map<String, dynamic> toJson() => {
        "id"      : id,
        "table"   : table,
    };
}
