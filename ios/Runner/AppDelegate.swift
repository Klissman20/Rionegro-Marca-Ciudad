import UIKit
import Flutter
import GoogleMaps
import CoreLocation

@main
@objc class AppDelegate: FlutterAppDelegate {

  let locationManager = CLLocationManager()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    locationManager.requestAlwaysAuthorization()
    GMSServices.provideAPIKey("AIzaSyDCq5iN_IbUdXcfHiwFRbGxmu1tFWG7sog")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
