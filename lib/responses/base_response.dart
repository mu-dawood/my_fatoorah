abstract class MyFatoorahResponse<T> {
  bool isSuccess;
  String message;
  List<ValidationErrors> validationErrors;

  T data;

  MyFatoorahResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['IsSuccess'] == true;
    message = json['Message'] ?? "";
    if (json['ValidationErrors'] != null) {
      validationErrors = new List<ValidationErrors>();
      json['ValidationErrors'].forEach((v) {
        validationErrors.add(new ValidationErrors.fromJson(v));
      });
    }
    data = json['Data'] != null ? mapData(json['Data']) : null;
  }

  T mapData(Map<String, dynamic> json);
}

class ValidationErrors {
  String name;
  String error;
  ValidationErrors.fromJson(Map<String, dynamic> json) {
    name = json['Name'] ?? "";
    error = json['Error'] ?? "";
  }
}
