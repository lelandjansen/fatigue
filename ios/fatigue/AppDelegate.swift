
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UserDefaults.standard.name = "Leland Jansen"
        UserDefaults.standard.occupation = .pilot
        UserDefaults.standard.dailyReminder = Date()
        UserDefaults.standard.supervisorName = "Bob Loblaw"
        UserDefaults.standard.supervisorEmail = "bloblaw@iagsa.ca"
        UserDefaults.standard.supervisorPhone = "+1 123-456-7890"
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = HomePageController()
        
        return true
    }
    
}
