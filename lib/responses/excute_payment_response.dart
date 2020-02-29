import 'base_response.dart';

class ExcutePaymentResponse
    extends MyFatoorahResponse<ExcutePaymentResponseData> {
  ExcutePaymentResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);
  @override
  ExcutePaymentResponseData mapData(Map<String, dynamic> json) {
    return ExcutePaymentResponseData.fromJson(json);
  }
}

class ExcutePaymentResponseData {
  int invoiceId;
  bool isDirectPayment;
  String paymentURL;
  String customerReference;
  String userDefinedField;

  ExcutePaymentResponseData.fromJson(Map<String, dynamic> json) {
    invoiceId = int.tryParse(json['InvoiceId']?.toString() ?? "");
    isDirectPayment = json['IsDirectPayment'] == true;
    paymentURL = json['PaymentURL'] ?? "";
    customerReference = json['CustomerReference'] ?? "";
    userDefinedField = json['UserDefinedField'] ?? "";
  }
}
