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
  double get totalWithoutCharge => _totalAmount;
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
  PaymentMethod withLangauge(ApiLanguage _language) {
    return PaymentMethod.fromJson({})
      .._paymentMethodAr = _paymentMethodAr
      .._paymentMethodEn = _paymentMethodEn
      ..paymentMethodCode = paymentMethodCode
      ..language = _language
      ..isDirectPayment = isDirectPayment
      ..serviceCharge = serviceCharge
      .._totalAmount = _totalAmount
      ..currencyIso = currencyIso
      ..imageUrl = imageUrl
      ..paymentMethodId = paymentMethodId;
  }
}
