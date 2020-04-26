part of my_fatoorah;

abstract class _MyFatoorahResponse<T> {
  bool isSuccess;
  String message;
  List<_ValidationErrors> validationErrors;

  T data;

  _MyFatoorahResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'] == true || json['isSuccess'] == true;
    message = json['Message'] ?? json['message'] ?? "";
    if (json['ValidationErrors'] != null || json['validationErrors'] != null) {
      validationErrors = new List<_ValidationErrors>();
      (json['ValidationErrors'] ?? json['validationErrors']).forEach((v) {
        validationErrors.add(new _ValidationErrors.fromJson(v));
      });
    }
    data = json['Data'] != null || json['data'] != null
        ? mapData(json['Data'] ?? json['data'])
        : null;
  }

  T mapData(Map<String, dynamic> json);
}

class _ValidationErrors {
  String name;
  String error;
  _ValidationErrors.fromJson(Map<String, dynamic> json) {
    name = json['Name'] ?? json['name'] ?? "";
    error = json['Error'] ?? json['error'] ?? "";
  }
}
