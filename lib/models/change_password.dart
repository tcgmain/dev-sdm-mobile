class ChangePassword {
  ChangePassword({
    required this.success,
    required this.resultData,
    required this.message,
  });

  bool success;
  ResultData? resultData; // Make resultData nullable

  String message;

  factory ChangePassword.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      // Handle case where json is null (e.g., if API response was empty)
      return ChangePassword(
        success: false, // Assuming failure if response is null
        resultData: null,
        message: "", // Provide appropriate default message
      );
    }
    return ChangePassword(
      success: json["success"] ?? false,
      resultData: json["result_data"] != null ? ResultData.fromJson(json["result_data"]) : null,
      message: json["message"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "result_data": resultData?.toJson(), // Convert to JSON if resultData is not null
    "message": message,
  };
}

class ResultData {
  List<dynamic> table;

  ResultData({
    required this.table,
  });

  factory ResultData.fromJson(Map<String, dynamic> json) => ResultData(
    table: json["table"] != null ? List<dynamic>.from(json["table"]) : [],
  );

  Map<String, dynamic> toJson() => {
    "table": table,
  };
}
