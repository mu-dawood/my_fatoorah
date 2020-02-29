import '../my_fatoorah.dart';
import 'base_response.dart';

class InitiatePaymentResponse
    extends MyFatoorahResponse<InitiatePaymentResponseData> {
  InitiatePaymentResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);
  @override
  InitiatePaymentResponseData mapData(Map<String, dynamic> json) {
    return InitiatePaymentResponseData.fromJson(json);
  }
}

class InitiatePaymentResponseData {
  List<PaymentMethod> paymentMethods;
  InitiatePaymentResponseData.fromJson(Map<String, dynamic> json) {
    if (json['PaymentMethods'] != null) {
      paymentMethods = new List<PaymentMethod>();
      json['PaymentMethods'].forEach((v) {
        paymentMethods.add(new PaymentMethod.fromJson(v));
      });
    }
  }
}

class PaymentMethod {
  int paymentMethodId;
  String _paymentMethodAr;
  String _paymentMethodEn;
  String get paymentMethod =>
      language == ApiLanguage.Arabic ? _paymentMethodAr : _paymentMethodEn;
  String paymentMethodCode;
  bool isDirectPayment;
  double serviceCharge;
  double _totalAmount;
  double get totalAmount => _totalAmount + serviceCharge;
  String currencyIso;
  String imageUrl;
  ApiLanguage language;

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    paymentMethodId = int.tryParse(json['PaymentMethodId']?.toString() ?? "");
    _paymentMethodAr = json['PaymentMethodAr'] ?? "";
    _paymentMethodEn = json['PaymentMethodEn'] ?? "";
    paymentMethodCode = json['PaymentMethodCode'] ?? "";
    isDirectPayment = json['IsDirectPayment'] == true;
    serviceCharge =
        double.tryParse(json['ServiceCharge']?.toString() ?? "0") ?? 0;
    _totalAmount = double.tryParse(json['TotalAmount']?.toString() ?? "0") ?? 0;
    currencyIso = json['CurrencyIso'] ?? "";
    imageUrl = json['ImageUrl'] ?? "";
  }
  PaymentMethod withLangauge(ApiLanguage language) {
    return this..language = language;
  }
}
