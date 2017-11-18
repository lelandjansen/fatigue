import Foundation

class RoleSetting: Setting {
    static var settingName: String = "Role"
    var details: String = UserDefaults.standard.role.rawValue.capitalized
}
