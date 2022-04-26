part of my_fatoorah;

class _DirectPaymentResponse
    extends _MyFatoorahResponse<DirectPaymentResponseData> {
  _DirectPaymentResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);
  @override
  DirectPaymentResponseData mapData(Map<String, dynamic> json) {
    return DirectPaymentResponseData.fromJson(json);
  }
}

class DirectPaymentResponseData {
  late String status;
  late String errorMessage;
  late String paymentId;
  late String token;
  late String recurringId;
  late String paymentURL;
  late CardInfoResponse cardInfo;

  DirectPaymentResponseData.fromJson(Map<String, dynamic> json) {
    status = json['Status'] ?? json['status'];
    errorMessage = json['ErrorMessage'] ?? json['errorMessage'];
    paymentId = json['PaymentId'] ?? json['paymentId'];
    token = json['Token'] ?? json['token'];
    recurringId = json['RecurringId'] ?? json['recurringId'];
    paymentURL = json['PaymentURL'] ?? json['paymentURL'];
    cardInfo =
        CardInfoResponse.fromJson(json['CardInfo'] ?? json['cardInfo'] ?? {});
  }
}

class CardInfoResponse {
  CardInfoResponse.fromJson(Map<String, dynamic> json) {
    number = json["Number"] ?? json["number"];
    expiryMonth = json["ExpiryMonth"] ?? json["expiryMonth"];
    expiryYear = json["ExpiryYear"] ?? json["expiryYear"];
    brand = json["Brand"] ?? json["brand"];
    issuer = json["Issuer"] ?? json["issuer"];
  }

  late String number;
  late String expiryMonth;
  late String expiryYear;
  late String brand;
  late String issuer;
}
