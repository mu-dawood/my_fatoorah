part of my_fatoorah;

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
