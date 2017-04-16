import Foundation

class OccupationSetting : Setting {
    
    var settingName: String = "Occupation"
    
    var details: String = UserDefaults().occupation.rawValue.capitalized
    
}
