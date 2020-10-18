# my_fatoorah

My Fatoorah Payment
# Screenshots
![](https://raw.githubusercontent.com/mo-ah-dawood/my_fatoorah/master/screen_1.png)
![](https://raw.githubusercontent.com/mo-ah-dawood/my_fatoorah/master/screen_2.png)
![](https://raw.githubusercontent.com/mo-ah-dawood/my_fatoorah/master/screen_3.png)


## Getting Started

## Installation

```bash
add this to your pubspec.yaml
my_fatoorah: any
```

## Config

### Ios

### add this line to your `Info.plist`

```xml
<key>io.flutter.embedded_views_preview</key>
<true/>
```

### if this url is not using ssl you have to use clear text traffic . put this value in your `manifest` for android

### and allow arbitrary loads in your `Info.plist` for ios

### Android

```xml
 <application
  ...
  android:usesCleartextTraffic="true"
  ...>
  ...
  </application>
```

### Ios

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## Usage

```dart
import 'package:my_fatoorah/my_fatoorah.dart';
...
 MyFatoorah.startPayment(
                  context: context,
                  request: MyfatoorahRequest(
                      currencyIso: Country.SaudiArabia,
                      successUrl:
                          "Your success call back",
                      errorUrl:
                          "Your error call back",
                      invoiceAmount: 100,
                      language: ApiLanguage.Arabic,
                      token: null,
                      afterPaymentBehaviour:AfterPaymentBehaviour.None, //See the describe for this property for more details
                      ),
                );

See the example for more details
```
## Another usage way
```dart
import 'package:my_fatoorah/my_fatoorah.dart';
...
 MyFatoorah(
        onResult:(response){
            print(res.status);
        }
        request: MyfatoorahRequest(
                      currencyIso: Country.SaudiArabia,
                      successUrl:
                          "Your success call back",
                      errorUrl:
                          "Your error call back",
                      invoiceAmount: 100,
                      language: ApiLanguage.Arabic,
                      token: null,
                      afterPaymentBehaviour:AfterPaymentBehaviour.None, //See the describe for this property for more details
                      ),
 );
```

### Notes

1. because my fatoorah sdk itself uses webview i removed all platform specified code and used webview plugin since v2
2. after payment done the web view redirect automatically to error or success url thats mean these url has to return html content
