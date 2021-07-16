part of my_fatoorah;

class DirectPayment {
  DirectPayment({
    required this.paymentType,
    this.saveToken,
    this.card,
    this.token,
    this.bypass3Ds,
  });

  String paymentType;
  bool? saveToken;
  CardInfo? card;
  String? token;
  bool? bypass3Ds;

  Map<String, dynamic> toJson() => {
        "PaymentType": paymentType,
        if (saveToken != null) "SaveToken": saveToken,
        if (card != null) "Card": card?.toJson(),
        if (token != null) "Token": token,
        if (bypass3Ds != null) "Bypass3DS": bypass3Ds,
      };
}

class CardInfo {
  CardInfo({
    required this.number,
    required this.expiryMonth,
    required this.expiryYear,
    required this.securityCode,
    required this.holderName,
  });

  String number;
  String expiryMonth;
  String expiryYear;
  String securityCode;
  String holderName;

  Map<String, dynamic> toJson() => {
        "Number": number,
        "ExpiryMonth": expiryMonth,
        "ExpiryYear": expiryYear,
        "SecurityCode": securityCode,
        "HolderName": holderName,
      };
}
