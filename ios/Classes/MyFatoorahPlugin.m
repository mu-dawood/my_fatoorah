#import "MyFatoorahPlugin.h"
#import <my_fatoorah/my_fatoorah-Swift.h>

@implementation MyFatoorahPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMyFatoorahPlugin registerWithRegistrar:registrar];
}
@end
