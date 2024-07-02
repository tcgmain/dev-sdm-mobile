class GetGoodManagementID {
    GetGoodManagementID({
        this.such,
        this.id,
        this.nummer,
    });
 
    String? such;
    String? id;
    String? nummer;
   
    factory GetGoodManagementID.fromJson(Map<String, dynamic> json) => GetGoodManagementID(
        such: json["such"],
        id :  json["id"],
        nummer :  json["nummer"],

    );
 
    Map<String, dynamic> toJson() => {
        "such" : such,
        "id" : id,
        "nummer": nummer,
    };
}