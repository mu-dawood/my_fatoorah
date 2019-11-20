import Flutter
import UIKit
import MFSDK

public class SwiftMyFatoorahPlugin: NSObject, FlutterPlugin , UINavigationControllerDelegate {
  var results : FlutterResult!
  var navigationController: UINavigationController!
  override init(){
      super.init()
  }
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "my_fatoorah", binaryMessenger: registrar.messenger())
    let instance = SwiftMyFatoorahPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if(call.method.elementsEqual("config")){
        config(call,result);
    }
    else if(call.method.elementsEqual("initiatePayment")){
        initiatePayment(call,result);
    }
    else if(call.method.elementsEqual("executePayment")){
        executePayment(call,result);
    }
    else{
        result(FlutterMethodNotImplemented);
    }
  }

  public func config(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        let arguments = call.arguments as! NSDictionary
        let baseUrl = arguments["baseUrl"] as! String
        let token = arguments["token"] as! String
        let title = arguments["title"] as! String
        let cancelBtn = arguments["cancelButton"] as! String
        let toolBarTitleColor = arguments["toolBarTitleColor"] as! String
        let toolBarBackgroundColor = arguments["toolBarBackgroundColor"] as! String
        MFSettings.shared.configure(token: token, baseURL: baseUrl)
        let them = MFTheme(navigationTintColor: UIColor(hexString: toolBarTitleColor), navigationBarTintColor: UIColor(hexString: toolBarBackgroundColor), navigationTitle:title, cancelButtonTitle: cancelBtn)
        MFSettings.shared.setTheme(theme: them)
        result("Initialized")
      
  }


  public func initiatePayment(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
        let arguments = call.arguments as! NSDictionary
        let currencyIso = arguments["currencyIso"] as! String
        let language = arguments["language"] as! String
        let invoiceAmount = arguments["invoiceAmount"] as! Double
    
        let currency=MFCurrencyISO(rawValue: currencyIso) ?? MFCurrencyISO.saudiArabia_SAR
        let lang=MFAPILanguage(rawValue: language) ?? MFAPILanguage.english
        let initiatePayment = MFInitiatePaymentRequest(invoiceAmount: invoiceAmount, currencyIso: currency)
        MFPaymentRequest.shared.initiatePayment(request: initiatePayment, apiLanguage: lang) { [weak self] (response) in
            do{
            switch response {
            case .success(let initiatePaymentResponse):
               let encoder = JSONEncoder()
               let jsonData = try encoder.encode(initiatePaymentResponse)
               if let jsonString = String(data: jsonData, encoding: .utf8) {
                result(jsonString)
               }
            case .failure(let failError):
                result(FlutterError(code: "Failed",
                                    message: failError.errorDescription,
                        details: nil))
                }
                
            }
            catch {
                 result(FlutterError(code: "Exeption",
                             message: error.localizedDescription,
                             details: nil))
            }
        }

      
  }


  public func executePayment(_ call: FlutterMethodCall,_ result: @escaping FlutterResult) {
  
        let arguments = call.arguments as! NSDictionary
        let callBackUrl = arguments["callBackUrl"] as! String
        let errorUrl = arguments["errorUrl"] as! String
        let language = arguments["language"] as! String
        let invoiceAmount = arguments["invoiceAmount"] as! Double
        let paymentMethod = arguments["paymentMethod"] as! Int
         let lang=MFAPILanguage(rawValue: language) ?? MFAPILanguage.english
        let request = MFExecutePaymentRequest(invoiceValue: invoiceAmount, paymentMethod:paymentMethod,callBackUrl:callBackUrl,errorUrl:errorUrl)
        MFPaymentRequest.shared.executePayment(request: request, apiLanguage: lang) { [weak self] (response,invoiceId) in
            do{
            switch response {
            case .success(let executePaymentResponse):
               let encoder = JSONEncoder()
               let jsonData = try encoder.encode(executePaymentResponse)
               if let jsonString = String(data: jsonData, encoding: .utf8) {
                result(jsonString)
               }
            case .failure(let failError):
                result(FlutterError(code: "Failed",
                                    message: failError.errorDescription,
                        details: nil))
                }
            }
            catch {
                 result(FlutterError(code: "Exeption",
                             message: error.localizedDescription,
                             details: nil))
            }
        }
     
  }
}



extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
