import Foundation

class DailyReminderSetting : Setting {
    
    var settingName: String = "Daily reminder"
    
    var details: String = String(describing: UserDefaults.standard.dailyReminder)
    
}
