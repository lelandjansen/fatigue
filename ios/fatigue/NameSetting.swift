import Foundation

class NameSetting : Setting {
    
    var settingName: String = "Name"
    
    var details: String = UserDefaults.standard.name ?? String()
    
}
