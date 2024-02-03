import UIKit
import Flutter
import GoogleMaps //add for ios

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey("AIzaSyA2bFrlg_WpQrDzedTkhrR1pAE_iOQiqs4") //add this like for api key
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
