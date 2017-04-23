import Foundation

class SupervisorSetting : Setting {
    
    var settingName: String = "Supervisor"
    
    var details: String = UserDefaults.standard.supervisorName ?? String()
    
}
