import Foundation

class DailyReminderSetting : Setting {
    static var settingName: String = "Daily reminder"
    var details: String = String(describing: UserDefaults.standard.dailyReminder)
}
