import UserNotifications

enum NotificationKeys: String {
    case dailyReminder
}

func registerLocalNotifications() {
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        
    }
}

func disableLocalNotifications() {
    UserDefaults.standard.reminderEnabled = false
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.removeAllPendingNotificationRequests()
}

func scheduleLocalNotifications(atTime time: DateComponents) {
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
