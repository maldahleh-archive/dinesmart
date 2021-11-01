import UIKit
import Sentry

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Client.shared = try? Client(dsn: "https://2dd1b49d5c8c400aaa60e9f2c86214a8@sentry.io/1509662")
        try? Client.shared?.startCrashHandler()
        
        return true
    }
}
