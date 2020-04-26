import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_fatoorah/my_fatoorah.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
      home: InnerPage(),
    );
  }
}

class InnerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("دفع ماى فاتورة"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text("قيمة الطلب هى 100 ريال سعودى"),
            SizedBox(height: 20),
            RaisedButton(
              onPressed: () {
                MyFatoorah.startPayment(
                  context: context,
                  request: MyfatoorahRequest(
                    currencyIso: Country.SaudiArabia,
                    initiatePaymentUrl:
                        "http://herajdates-001-site23.htempurl.com/api/Payment/InitiatePayment",
                    executePaymentUrl:
                        "http://herajdates-001-site23.htempurl.com/api/Payment/ExecutePayment",
                    successUrl:
                        "https://assets.materialup.com/uploads/473ef52c-8b96-46f7-9771-cac4b112ae28/preview.png",
                    errorUrl:
                        "https://www.digitalpaymentguru.com/wp-content/uploads/2019/08/Transaction-Failed.png",
                    invoiceAmount: 100,
                    language: ApiLanguage.Arabic,
                    token: null,
                    afterPaymentBehaviour:
                        AfterPaymentBehaviour.BeforeCalbacksExecution,
                  ),
                ).then((response) {
                  print(response);
                }).catchError((e) {
                  print(e);
                });
              },
              child: Text("دفع"),
            )
          ],
        ),
      ),
    );
  }
}
