class AddOrganizations {
    AddOrganizations({
       // this.ysdmpwd,
        this.namebspr,
        this.ymnginv,
        this.yselrec,
        this.yactiv,
        this.yemail,
        this.yphone1,
        this.yphone2,
        this.yaddressl1,
        this.yaddressl2,
        this.yaddressl3,
        this.yaddressl4,
        this.ygpslat,
        this.ygpslon,

    });

  // String? ysdmpwd;
    String? namebspr;
    String? ymnginv;
    String? yselrec;
    String? yactiv;
    String? yemail;
    String? yphone1;
    String? yphone2;
    String? yaddressl1;
    String? yaddressl2;
    String? yaddressl3;
    String? yaddressl4;
    String? ygpslat;
    String? ygpslon;
    factory AddOrganizations.fromJson(Map<String, dynamic> json) => AddOrganizations(
       // ysdmpwd: json["ysdmpwd"],
        namebspr   : json["namebspr"],
        ymnginv    : json["ymnginv"],
        yselrec    : json["yselrec"],
        yactiv     : json["yactiv"],
        yemail     : json["yemail"],
        yphone1    : json["yphone1"],
        yphone2    : json["yphone2"],
        yaddressl1 : json["yaddressl1"],
        yaddressl2 : json["yaddressl2"],
        yaddressl3 : json["yaddressl3"],
        yaddressl4 : json["yaddressl4"],
        ygpslat    : json["ygpslat"],
        ygpslon    : json["ygpslon"],

    );

    Map<String, dynamic> toJson() => {
        //"ysdmpwd": ysdmpwd,
        "namebspr"  : namebspr,
        "ymnginv"   : ymnginv,
        "yselrec"   : yselrec,
        "yactiv"    : yactiv,
        "yemail"    : yemail,
        "yphone1"   : yphone1,
        "yphone2"   : yphone2,
        "yaddressl1": yaddressl1,
        "yaddressl2": yaddressl2,
        "yaddressl3": yaddressl3,
        "yaddressl4": yaddressl4,
        "ygpslat"   : ygpslat,
        "ygpslon"   : ygpslon,
    };
}