# my_fatoorah

My Fatoorah Payment
# Screenshots
![Simulator Screen Shot - iPhone 11 Pro - 2020-10-19 at 01 45 05](https://user-images.githubusercontent.com/31937782/96389030-5780b800-11ad-11eb-9f0f-3bedc05466bf.png)
[Simulator Screen Shot - iPhone 11 Pro - 2020-10-19 at 01 46 33](https://user-images.githubusercontent.com/31937782/96389044-68312e00-11ad-11eb-900d-9b2eea73e087.png)
![Simulator Screen Shot - iPhone 11 Pro - 2020-10-19 at 01 46 58](https://user-images.githubusercontent.com/31937782/96389054-754e1d00-11ad-11eb-98dd-3d4e791dc64d.png)

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
