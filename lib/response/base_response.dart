part of my_fatoorah;

abstract class _MyFatoorahResponse<T> {
  bool isSuccess;
  String message;
  List<_ValidationErrors> validationErrors;

  T data;

  _MyFatoorahResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'] == true;
    message = json['Message'] ?? "";
    if (json['ValidationErrors'] != null) {
      validationErrors = new List<_ValidationErrors>();
      json['ValidationErrors'].forEach((v) {
        validationErrors.add(new _ValidationErrors.fromJson(v));
      });
    }
    data = json['Data'] != null ? mapData(json['Data']) : null;
  }

  T mapData(Map<String, dynamic> json);
}

class _ValidationErrors {
  String name;
  String error;
  _ValidationErrors.fromJson(Map<String, dynamic> json) {
    name = json['Name'] ?? "";
    error = json['Error'] ?? "";
  }
}
