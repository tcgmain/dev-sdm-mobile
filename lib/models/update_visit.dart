class UpdateVisits{
    UpdateVisits({
       // this.ysdmpwd,
        this.such,
        this.ysdmempv,
        this.yorg,
        this.yvrout,
        this.yvdat,
        this.yvtim,
        

    });

  // String? ysdmpwd;
    String? such;
    String? ysdmempv;
    String? yorg;
    String? yvrout;
    String? yvdat;
    String? yvtim;
    
    factory UpdateVisits.fromJson(Map<String, dynamic> json) => UpdateVisits(
       // ysdmpwd: json["ysdmpwd"],
        such   : json["such"],
        ysdmempv    : json["ysdmempv"],
        yorg    : json["yorg"],
        yvrout     : json["yvrout"],
        yvdat     : json["yvdat"],
        yvtim    : json["yvtim"],
       
    );

    Map<String, dynamic> toJson() => {
        "such"  : such,
        "ysdmempv"   : ysdmempv,
        "yorg"   : yorg,
        "yvrout"    : yvrout,
        "yvdat"    : yvdat,
        "yvtim"   : yvtim,
        
    };
}