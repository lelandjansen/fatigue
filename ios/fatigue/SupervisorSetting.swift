import Foundation

class SupervisorSetting: Setting {
    static var settingName: String = "Supervisor"
    var details: String = UserDefaults.standard.supervisorName ?? String()
}
