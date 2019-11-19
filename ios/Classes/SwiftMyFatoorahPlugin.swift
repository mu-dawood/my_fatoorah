import Flutter
import UIKit
import MFSDK

public class SwiftMyFatoorahPlugin: NSObject, FlutterPlugin , UINavigationControllerDelegate,MFInvoiceCreateStatusDelegate {
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
  }

  public func config(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
         do {
            
        } catch {
          
            print(error.localizedDescription)
        }
  }
  public func initiatePayment(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
  public func executePayment(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
