part of my_fatoorah;

class _ExecutePaymentResponse
    extends _MyFatoorahResponse<ExecutePaymentResponseData> {
  _ExecutePaymentResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);
  @override
  ExecutePaymentResponseData mapData(Map<String, dynamic> json) {
    return ExecutePaymentResponseData.fromJson(json);
  }
}

class ExecutePaymentResponseData {
  int? invoiceId;
  late bool isDirectPayment;
  late String paymentURL;
  late String customerReference;
  late String userDefinedField;

  ExecutePaymentResponseData.fromJson(Map<String, dynamic> json) {
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
