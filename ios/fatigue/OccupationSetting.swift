import Foundation

class OccupationSetting: Setting {
    static var settingName: String = "Occupation"
    var details: String = UserDefaults.standard.occupation.rawValue.capitalized
}
