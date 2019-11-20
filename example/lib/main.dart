import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_fatoorah/my_fatoorah.dart';
import 'package:my_fatoorah/requests/configRequest.dart';
import 'package:my_fatoorah/requests/initiatePaymentRequest.dart';
import 'package:my_fatoorah/requests/excutePaymentRequest.dart';
import 'package:my_fatoorah/responses/paymentMethod.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loading = true;
  List<PaymentMethod> paymentMethods = [];
  @override
  void initState() {
    super.initState();
    MyFatoorah.config(ConfigRequest(
      baseUrl: "https://apitest.myfatoorah.com",
      title: "الدفع الإلكترونى",
      iosCancelButton: "إلغاء",
      token:
          "7Fs7eBv21F5xAocdPvvJ-sCqEyNHq4cygJrQUFvFiWEexBUPs4AkeLQxH4pzsUrY3Rays7GVA6SojFCz2DMLXSJVqk8NG-plK-cZJetwWjgwLPub_9tQQohWLgJ0q2invJ5C5Imt2ket_-JAlBYLLcnqp_WmOfZkBEWuURsBVirpNQecvpedgeCx4VaFae4qWDI_uKRV1829KCBEH84u6LYUxh8W_BYqkzXJYt99OlHTXHegd91PLT-tawBwuIly46nwbAs5Nt7HFOozxkyPp8BW9URlQW1fE4R_40BXzEuVkzK3WAOdpR92IkV94K_rDZCPltGSvWXtqJbnCpUB6iUIn1V-Ki15FAwh_nsfSmt_NQZ3rQuvyQ9B3yLCQ1ZO_MGSYDYVO26dyXbElspKxQwuNRot9hi3FIbXylV3iN40-nCPH4YQzKjo5p_fuaKhvRh7H8oFjRXtPtLQQUIDxk-jMbOp7gXIsdz02DrCfQIihT4evZuWA6YShl6g8fnAqCy8qRBf_eLDnA9w-nBh4Bq53b1kdhnExz0CMyUjQ43UO3uhMkBomJTXbmfAAHP8dZZao6W8a34OktNQmPTbOHXrtxf6DS-oKOu3l79uX_ihbL8ELT40VjIW3MJeZ_-auCPOjpE3Ax4dzUkSDLCljitmzMagH2X8jN8-AYLl46KcfkBV",
    )).then((d) {
      intaitePayment();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale("ar"),
      supportedLocales: [
        const Locale('ar'),
      ],
      home: Scaffold(
        appBar: AppBar(
          title: Text(loading ? "دفع ماى فاتورة" : "إختر طريقة الدفع"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: intaitePayment,
          child: Icon(Icons.sync),
        ),
        body: Column(
          children: <Widget>[
            if (loading == true) LinearProgressIndicator(),
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  PaymentMethod method = paymentMethods[index];
                  return ListTile(
                    onTap: () {
                      excutePayment(method.paymentMethodId);
                    },
                    leading: Image.network(method.imageUrl),
                    title: Text(method.paymentMethodAr),
                    trailing: Text(method.currencyIso),
                    subtitle: Text(
                        "العمولة : ${method.serviceCharge.toStringAsFixed(2)}"),
                  );
                },
                itemCount: paymentMethods.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void intaitePayment() {
    setState(() {
      loading = true;
    });
    MyFatoorah.initiatePayment(InitiatePaymentRequest(invoiceAmount: 100))
        .then((data) {
      setState(() {
        paymentMethods.clear();
        paymentMethods.addAll(data);
        loading = false;
      });
    }).catchError((e) {
      setState(() {
        loading = false;
      });
    });
  }

  void excutePayment(int id) {
    MyFatoorah.executePayment(ExcutePaymentRequest(
      callBackUrl: "http://google.com",
      errorUrl: "http://google.com",
      invoiceAmount: 100,
      paymentMethod: id,
    ));
  }
}
