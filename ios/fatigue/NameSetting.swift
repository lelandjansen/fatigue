import Foundation

class NameSetting: Setting {
    static var settingName: String = "Name"
    var details: String = UserDefaults.standard.name ?? String()
}
