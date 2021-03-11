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
      debugShowCheckedModeBanner: false,
      locale: Locale('ar'),
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
        title: Text('دفع ماى فاتورة'),
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
                    url: 'https://apitest.myfatoorah.com',
                    token:
                        'rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL',
                    currencyIso: Country.SaudiArabia,
                    successUrl:
                        'https://assets.materialup.com/uploads/473ef52c-8b96-46f7-9771-cac4b112ae28/preview.png',
                    errorUrl:
                        'https://www.digitalpaymentguru.com/wp-content/uploads/2019/08/Transaction-Failed.png',
                    invoiceAmount: 100,
                    language: ApiLanguage.Arabic,
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
            buildAppBar: (callback) => AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
              ),
            ),
            request: MyfatoorahRequest(
              // url: 'https://apitest.myfatoorah.com',
              // token:
              //     'rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL',

              token:
                  'hPVC1QwqrmPtDzjkOfgL0xnPHKDgY_e3z3_rZA4J8YHJBoi5lXhbFAXYvkKiLlQoXADhPr68Ju_zG2YLLxl9CcYhWlYK85iiLa-qCRYAS_3L-vqFgBWzauTTFN-ntNlWRfeQ8FUk1YNopOb5ZW3lSPBpwsZ7C3nXiOYPqsWKhk6UqloOW5xHficaQLrKrv_Ff9YcwYpFdQezFweASRMKWMSYFfya3AEifuy2Fgn4ALC1kj2MfGFD_-i6YRhOvrhQhN9xcLOTrwgoWV1m6V2R6UUYTAe9NLnaQVILoS6AFc9sU8h2gX_TPcOa0wPH_E0ZrMWHpwU9RUXHy7A0XpZUNB30VlqQeSyJ9apT5xtWzNg4_kk70LyuEJhE8GK9aJXV6TErMc04KV5G-eml51WY8WT2Mho6OCa2Yn5AA2JoIaBcoUrGRiHpORxnOeaWJTKUDV5LHAjNf5_3h9bXEQzk8cjGa0_0zJDMHZGPjl0jpVsISjTuNOlQSyQK1Sq_14VVLrqJYdY2R5oNGE1Zfuxlr2NXb7ll07ZDa9dOWu5-Wfa49KgDv418JluPFrfwpq3atT8jJ2WktxEUppUIQq-sDDuERbQwhJaEnfMI3UIXXgRn50XFjr14XMwRCJ8j6nHD8XE2cC7b_sdVvU8kJfg1onAvA_MhBbq_Z4wVX3to8WGBx32RswGMj12SV1pMSY-rM_FKsA',

              currencyIso: Country.SaudiArabia,
              successUrl:
                  'https://assets.materialup.com/uploads/473ef52c-8b96-46f7-9771-cac4b112ae28/preview.png',
              errorUrl:
                  'https://www.digitalpaymentguru.com/wp-content/uploads/2019/08/Transaction-Failed.png',
              invoiceAmount: 0.1,
              language: ApiLanguage.Arabic,
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
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(res.status.toString()),
              ));
            },
          );
        },
      ),
    );
  }
}
