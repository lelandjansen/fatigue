import Foundation

class ReminderSetting : Setting {
    static var settingName: String = "Daily reminder"
    static var reminderOff: String = "Off"
    var details: String = {
        if (UserDefaults.standard.reminderEnabled) {
            let date = Calendar.current.date(from: UserDefaults.standard.reminderTime)!
            return timeFormatter.string(from: date)
        }
        return reminderOff
    }()
}
