part of my_fatoorah;

class ShippingConsignee {
  final String personName;
  final String mobile;
  final String emailAddress;
  final String lineAddress;
  final String cityName;
  final String? postalCode;
  final String countryCode;
  ShippingConsignee({
    required this.personName,
    required this.mobile,
    required this.emailAddress,
    required this.lineAddress,
    required this.cityName,
    this.postalCode,
    required this.countryCode,
  });

  Map<String, dynamic> toJson() {
    return {
      "PersonName": personName,
      "Mobile": mobile,
      "EmailAddress": emailAddress,
      "LineAddress": lineAddress,
      "CityName": cityName,
      "PostalCode": postalCode,
      "CountryCode": countryCode,
    };
  }
}
