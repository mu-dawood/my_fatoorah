class PaymentMethod {
  String _currencyIso;
  bool _isDirectPayment;
  String _imageUrl;
  String _paymentMethodAr;
  String _paymentMethodEn;
  int _paymentMethodId;
  double _serviceCharge;
  double _totalAmount;
  String get currencyIso => _currencyIso;
  bool get isDirectPayment => _isDirectPayment;
  String get imageUrl => _imageUrl;
  String get paymentMethodAr => _paymentMethodAr;
  String get paymentMethodEn => _paymentMethodEn;
  int get paymentMethodId => _paymentMethodId;
  double get serviceCharge => _serviceCharge;
  double get totalAmount => _totalAmount;

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    _currencyIso = json['CurrencyIso'] ?? "";
    _isDirectPayment = json['IsDirectPayment'] == true;
    _imageUrl = json['ImageUrl'] ?? "";
    _paymentMethodAr = json['PaymentMethodAr'] ?? "";
    _paymentMethodEn = json['PaymentMethodEn'] ?? "";
    _paymentMethodId = json['PaymentMethodId'];
    _serviceCharge =
        double.tryParse(json['ServiceCharge']?.toString() ?? "0.0");
    _totalAmount = double.tryParse(json['TotalAmount']?.toString() ?? "0.0");
  }
}
