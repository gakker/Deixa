import UIKit
import Flutter
import GoogleMaps
import Firebase

// import Braintree
@UIApplicationMain

@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      GMSServices.provideAPIKey("AIzaSyChT7iBjqvTKOK4VdtaOa9nZiSqNk38z_I")
      Analytics.setAnalyticsCollectionEnabled(true)
      
        // if FirebaseApp.app() == nil {
        FirebaseApp.configure()
    // }    
    
    FirebaseApp.app()?.isDataCollectionDefaultEnabled = true
      GeneratedPluginRegistrant.register(with: self)
        // BTAppContextSwitcher.setReturnURLScheme("com.deixa.test.payments")
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    // override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    //     if url.scheme == "com.deixa.test.payments" {
    //         return BTAppContextSwitcher.handleOpenURL(url)
    //     }
        
    //     return false
    // }

}
