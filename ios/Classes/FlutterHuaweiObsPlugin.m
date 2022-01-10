#import "FlutterHuaweiObsPlugin.h"
#if __has_include(<flutter_huawei_obs/flutter_huawei_obs-Swift.h>)
#import <flutter_huawei_obs/flutter_huawei_obs-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_huawei_obs-Swift.h"
#endif

@implementation FlutterHuaweiObsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterHuaweiObsPlugin registerWithRegistrar:registrar];
}
@end
