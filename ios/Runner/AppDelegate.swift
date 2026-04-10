import UIKit
<<<<<<< HEAD
import Flutter
import GoogleMaps
=======
import GoogleMaps   // 👈 ADD THIS
>>>>>>> 91563b6 (push ios update)

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
<<<<<<< HEAD
    GMSServices.provideAPIKey("AIzaSyCrmEOP4JyFCozu7n85BIZqn_8LarJq_iI")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
=======

    GMSServices.provideAPIKey("AIzaSyCrmEOP4JyFCozu7n85BIZqn_8LarJq_iI") // 👈 ADD THIS LINE

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
>>>>>>> 91563b6 (push ios update)
}