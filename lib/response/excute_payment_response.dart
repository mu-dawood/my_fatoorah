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
  int? invoiceId;
  late bool isDirectPayment;
  late String paymentURL;
  late String customerReference;
  late String userDefinedField;

  _ExcutePaymentResponseData.fromJson(Map<String, dynamic> json) {
    invoiceId = int.tryParse(
        (json['InvoiceId'] ?? json['invoiceId'])?.toString() ?? "");
    isDirectPayment =
        json['IsDirectPayment'] == true || json['isDirectPayment'] == true;
    paymentURL = json['PaymentURL'] ?? json['paymentURL'] ?? "";
    customerReference =
        json['CustomerReference'] ?? json['customerReference'] ?? "";
    userDefinedField =
        json['UserDefinedField'] ?? json['userDefinedField'] ?? "";
  }
}
