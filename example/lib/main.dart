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
        actions: [
          IconButton(
              icon: Icon(Icons.payment),
              onPressed: () {
                MyFatoorah.startPayment(
                  context: context,
                  errorChild: Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.redAccent,
                      size: 50,
                    ),
                  ),
                  succcessChild: Center(
                    child: Icon(
                      Icons.done_all,
                      color: Colors.greenAccent,
                      size: 50,
                    ),
                  ),
                  request: MyfatoorahRequest(
                    currencyIso: Country.SaudiArabia,
                    successUrl:
                        "https://assets.materialup.com/uploads/473ef52c-8b96-46f7-9771-cac4b112ae28/preview.png",
                    errorUrl:
                        "https://www.digitalpaymentguru.com/wp-content/uploads/2019/08/Transaction-Failed.png",
                    invoiceAmount: 100,
                    language: ApiLanguage.Arabic,
                    token: null,
                  ),
                ).then((response) {
                  print(response);
                }).catchError((e) {
                  print(e);
                });
              })
        ],
      ),
      body: Builder(
        builder: (BuildContext context) {
          return MyFatoorah(
            request: MyfatoorahRequest(
              currencyIso: Country.SaudiArabia,
              successUrl:
                  "https://assets.materialup.com/uploads/473ef52c-8b96-46f7-9771-cac4b112ae28/preview.png",
              errorUrl:
                  "https://www.digitalpaymentguru.com/wp-content/uploads/2019/08/Transaction-Failed.png",
              invoiceAmount: 100,
              language: ApiLanguage.Arabic,
              token: null,
            ),
            errorChild: Center(
              child: Icon(
                Icons.error,
                color: Colors.redAccent,
                size: 50,
              ),
            ),
            succcessChild: Center(
              child: Icon(
                Icons.done_all,
                color: Colors.greenAccent,
                size: 50,
              ),
            ),
            onResult: (PaymentResponse res) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(res.status.toString()),
              ));
            },
          );
        },
      ),
    );
  }
}
