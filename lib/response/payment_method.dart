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
    paymentMethodId = int.tryParse(
        (json['PaymentMethodId'] ?? json['paymentMethodId'])?.toString() ?? "");
    _paymentMethodAr = json['PaymentMethodAr'] ?? json['paymentMethodAr'] ?? "";
    _paymentMethodEn = json['PaymentMethodEn'] ?? json['paymentMethodEn'] ?? "";
    paymentMethodCode =
        json['PaymentMethodCode'] ?? json['paymentMethodCode'] ?? "";
    isDirectPayment =
        json['IsDirectPayment'] == true || json['isDirectPayment'] == true;
    serviceCharge = double.tryParse(
            (json['ServiceCharge'] ?? json['serviceCharge'])?.toString() ??
                "0") ??
        0;
    _totalAmount = double.tryParse(
            (json['TotalAmount'] ?? json['totalAmount'])?.toString() ?? "0") ??
        0;
    currencyIso = json['CurrencyIso'] ?? json['currencyIso'] ?? "";
    imageUrl = json['ImageUrl'] ?? json['imageUrl'] ?? "";
  }
  PaymentMethod withLangauge(ApiLanguage language) {
    return this..language = language;
  }
}
