part of my_fatoorah;

class _ExcutePaymentResponse
    extends _MyFatoorahResponse<_ExcutePaymentResponseData> {
  _ExcutePaymentResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);
  @override
  _ExcutePaymentResponseData mapData(Map<String, dynamic> json) {
    return _ExcutePaymentResponseData.fromJson(json);
  }
}

class _ExcutePaymentResponseData {
  int invoiceId;
  bool isDirectPayment;
  String paymentURL;
  String customerReference;
  String userDefinedField;

  _ExcutePaymentResponseData.fromJson(Map<String, dynamic> json) {
    invoiceId = int.tryParse(json['InvoiceId']?.toString() ?? "");
    isDirectPayment = json['IsDirectPayment'] == true;
    paymentURL = json['PaymentURL'] ?? "";
    customerReference = json['CustomerReference'] ?? "";
    userDefinedField = json['UserDefinedField'] ?? "";
  }
}
