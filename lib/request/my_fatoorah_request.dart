part of my_fatoorah;

///The request that will be send to may fatoorah api
///
///first thing we do is to fetch payment methods as discriped in their docs
///
///[https://myfatoorah.readme.io/docs/api-initiate-payment]
///
///Then we make the excute payment as discriped here
///
///[https://myfatoorah.readme.io/docs/api-execute-payment]
///
///if the request success we navigate to anew page that contains webview redirected to the returned url
///
/// if you need to pop immediately after payment done pass `finishAfterCallback` equal `true`
///
/// # Note
///
/// In case you are using the `invoiceItem`, the value sent in `invoiceAmount` should be equal to the total
/// sum value of the item `unitPrice` multiplied by the item Quantity ,
///
/// for example of you are having 1 item with price of 5 KD and quantity 3,
/// so the value of the `invoiceAmount` should be 15

class MyfatoorahRequest {
  String get url => token != null
      ? "https://api.myfatoorah.com"
      : "https://apitest.myfatoorah.com";

  /// url to use instead of my fatoorah url
  /// Must not be null if you run on the web
  /// if you set initiatePaymentUrl or executePayment you can set token equal to null
  /// and make these urls set the token from backend for security reasons
  /// This url must return the base response of my fatoorah without any edits
  final String initiatePaymentUrl;

  /// url to use instead of my fatoorah url
  /// Must not be null if you run on the web
  /// if you set initiatePaymentUrl or executePayment you can set token equal to null
  /// and make these urls set the token from backend for security reasons
  /// This url must return the base response of my fatoorah without any edits
  final String executePaymentUrl;

  /// this will controles what happen after payment done
  ///
  /// `AfterPaymentBehaviour.None` the default value , nothing will happen
  ///
  /// `AfterPaymentBehaviour.AfterCalbacksExecution` will pop after payment done and error or success callbacks finish
  ///
  /// `AfterPaymentBehaviour.BeforeCalbacksExecution` will pop after payment done and before error or success callbacks start
  final AfterPaymentBehaviour afterPaymentBehaviour;

  final _testToken =
      "7Fs7eBv21F5xAocdPvvJ-sCqEyNHq4cygJrQUFvFiWEexBUPs4AkeLQxH4pzsUrY3Rays7GVA6SojFCz2DMLXSJVqk8NG-plK-cZJetwWjgwLPub_9tQQohWLgJ0q2invJ5C5Imt2ket_-JAlBYLLcnqp_WmOfZkBEWuURsBVirpNQecvpedgeCx4VaFae4qWDI_uKRV1829KCBEH84u6LYUxh8W_BYqkzXJYt99OlHTXHegd91PLT-tawBwuIly46nwbAs5Nt7HFOozxkyPp8BW9URlQW1fE4R_40BXzEuVkzK3WAOdpR92IkV94K_rDZCPltGSvWXtqJbnCpUB6iUIn1V-Ki15FAwh_nsfSmt_NQZ3rQuvyQ9B3yLCQ1ZO_MGSYDYVO26dyXbElspKxQwuNRot9hi3FIbXylV3iN40-nCPH4YQzKjo5p_fuaKhvRh7H8oFjRXtPtLQQUIDxk-jMbOp7gXIsdz02DrCfQIihT4evZuWA6YShl6g8fnAqCy8qRBf_eLDnA9w-nBh4Bq53b1kdhnExz0CMyUjQ43UO3uhMkBomJTXbmfAAHP8dZZao6W8a34OktNQmPTbOHXrtxf6DS-oKOu3l79uX_ihbL8ELT40VjIW3MJeZ_-auCPOjpE3Ax4dzUkSDLCljitmzMagH2X8jN8-AYLl46KcfkBV";

  /// title for payment screen or popup window in web
  final String title;

  /// authorization token without bearer
  /// ### Leave it null to use test value
  final String token;

  String get authorizationToken => token ?? _testToken;

  ///Language of  displaying payment methods
  final ApiLanguage language;

  /// The amount you are seeking to charge the customer and accepts decimal value e.g. 2.500
  final double invoiceAmount;

  /// Callback that will be called after payment success note that this url prefered to return html content with
  /// success message
  ///
  /// The api will call this url with a query string `paymentId` so the back end developer can validate
  /// the payment  by folowing this docs
  ///
  /// [https://myfatoorah.readme.io/docs/api-payment-enquiry]
  ///
  /// # Note
  /// if this url is not using ssl you have to use clear text traffic . put this value in your `manifest`  for android
  /// and allow arbitrary loads in your `Info.plist` for ios
  ///
  /// ### Android
  /// ```xml
  ///  <application
  ///   ...
  ///   android:usesCleartextTraffic="true"
  ///   ...>
  ///   ...
  ///   </application>
  /// ```
  ///  ### Ios
  ///  ```xml
  ///  <key>NSAppTransportSecurity</key>
  ///  <dict>
  ///      <key>NSAllowsArbitraryLoads</key>
  ///      <true/>
  ///  </dict>
  /// ```

  final String successUrl;

  /// url to redirect in case of error  please see the note on successUrl
  final String errorUrl;

  /// The currency code that you need to charge your customer through
  final Country currencyIso;

  /// Customer mobile number country code
  final String mobileCountryCode;

  /// Customer mobile number
  final String customerMobile;
  final String customerEmail;
  final String customerName;

  ///Refers to the order or transaction ID in your own system and you can use for payment inquiry as well
  final String customerReference;

  ///Your customer civil ID that you can associate with the transaction if needed
  final String customerCivilId;

  ///A custom field that you may use as additional information to be stored with the transaction
  final String userDefinedField;

  final CustomerAddress customerAddress;

  ///The date you want the payment to be expired, if not passed the default is considered from the account profile in the portal
  final DateTime expiryDate;

  /// The supplier code you need to associate the invoice with, please refer to `Multi Vendors` feature
  ///
  /// [https://myfatoorah.readme.io/docs/multi-vendors]
  final String supplierCode;
  final List<InvoiceItem> invoiceItems;

  MyfatoorahRequest({
    @required this.token,
    @required this.language,
    @required this.invoiceAmount,
    @required this.successUrl,
    @required this.errorUrl,
    @required this.currencyIso,
    this.mobileCountryCode,
    this.initiatePaymentUrl,
    this.executePaymentUrl,
    this.customerMobile,
    this.title = "My fatoorah",
    this.customerName,
    this.customerEmail,
    this.customerReference,
    this.customerCivilId,
    this.userDefinedField,
    this.customerAddress,
    this.expiryDate,
    this.supplierCode,
    this.invoiceItems,
    this.afterPaymentBehaviour = AfterPaymentBehaviour.None,
  });
  Map<String, dynamic> excutePaymentRequest(int paymentMethod) {
    var data = {
      "PaymentMethodId": paymentMethod,
      "CustomerName": customerName,
      "DisplayCurrencyIso": _currencies[currencyIso],
      "MobileCountryCode": mobileCountryCode,
      "CustomerMobile": customerMobile,
      "CustomerEmail": customerEmail,
      "InvoiceValue": invoiceAmount,
      "CallBackUrl": successUrl,
      "ErrorUrl": errorUrl,
      "Language": _languages[language],
      "CustomerReference": customerReference,
      "CustomerCivilId": customerCivilId,
      "UserDefinedField": userDefinedField,
      "CustomerAddress": customerAddress?.toJson(),
      "ExpiryDate": expiryDate?.toUtc()?.toIso8601String(),
      "SupplierCode": supplierCode,
      "InvoiceItems": invoiceItems?.map<Map<String, dynamic>>((e) {
        return e.toJson();
      })?.toList(),
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }

  Map<String, dynamic> intiatePaymentRequest() {
    return {
      "currencyIso": _currencies[currencyIso],
      "invoiceAmount": invoiceAmount,
      "language": _languages[language],
    };
  }
}
