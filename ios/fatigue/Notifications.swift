import UserNotifications

enum NotificationKeys: String {
    case dailyReminder
}

func registerLocalNotifications() {
    if #available(iOS 10.0, *) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            
        }
    }
    else {
        // Fallback on earlier versions
    }
}

func disableLocalNotifications() {
    UserDefaults.standard.reminderEnabled = false
    if #available(iOS 10.0, *) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
    }
    else {
        // Fallback on earlier versions
    }
}

func scheduleLocalNotifications(atTime time: DateComponents) {
    UserDefaults.standard.reminderEnabled = true
    UserDefaults.standard.reminderTime = time
    
    if #available(iOS 10.0, *) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Please complete today's self-assessment."
        content.sound = UNNotificationSound.default()
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: time, repeats: true)
        let request = UNNotificationRequest(identifier: NotificationKeys.dailyReminder.rawValue, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
    }
    else {
        // Fallback on earlier versions
    }
}
