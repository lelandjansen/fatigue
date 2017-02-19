import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = QuestionnaireController()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        UserDefaults.standard.setCareer(.engineer)
        
        return true
    }
    
}
