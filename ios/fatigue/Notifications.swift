import UIKit
import UserNotifications

class Notifications {
    enum NotificationKeys: String {
        case dailyReminder
    }
    
    static func registerLocalNotifications(completionIfGranted: @escaping () -> (), completionIfNotGranted: @escaping () -> ()) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            granted ? completionIfGranted() : completionIfNotGranted()
        }
    }
    
    static func disableLocalNotifications() {
        UserDefaults.standard.reminderEnabled = false
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    static func scheduleLocalNotifications(atTime time: DateComponents) {
        UserDefaults.standard.reminderEnabled = true
        UserDefaults.standard.reminderTime = time
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Please complete today's self-assessment."
        content.sound = UNNotificationSound.default()
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: true)
        let request = UNNotificationRequest(identifier: NotificationKeys.dailyReminder.rawValue, content: content, trigger: trigger)
        notificationCenter.add(request, withCompletionHandler: nil)
    }
    
    static func alertNotificationsNotPermitted(inViewController viewController: UIViewController?, completion: @escaping () -> () = {  }) {
        let alertController = UIAlertController(title: "Fatigue is not not permitted to send notifications", message: "Notifications can be enabled in Settings.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion()
        }))
        alertController.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { _ in
            completion()
            let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)!
            UIApplication.shared.open(settingsUrl, options: [:])
        }))
        viewController?.present(alertController, animated: true)
    }
}
