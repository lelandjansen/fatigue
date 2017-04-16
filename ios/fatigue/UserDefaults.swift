import Foundation

extension UserDefaults {
    
    enum Keys: String {
        case occupation, dailyReminder, name, supervisorName, supervisorEmail, supervisorPhone
    }
    
    var occupation: Occupation {
        get {
            return Occupation(rawValue: string(forKey: Keys.occupation.rawValue)!) ?? .none
        }

        set {
            set(newValue.rawValue, forKey: Keys.occupation.rawValue)
            synchronize()
        }
    }
    
    
    var dailyReminder: Date {
        get {
            return object(forKey: Keys.dailyReminder.rawValue) as! Date
        }
        
        set {
            set(newValue, forKey: Keys.dailyReminder.rawValue)
            synchronize()
        }
    }
    
    
    var name: String? {
        get {
            return string(forKey: Keys.name.rawValue)
        }
        
        set {
            set(newValue, forKey: Keys.name.rawValue)
            synchronize()
        }
    }
    
    
    var supervisorName: String? {
        get {
            return string(forKey: Keys.supervisorName.rawValue)
        }
        
        set {
            set(newValue, forKey: Keys.supervisorName.rawValue)
            synchronize()
        }
    }

    
    var supervisorEmail: String? {
        get {
            return string(forKey: Keys.supervisorEmail.rawValue)
        }
        
        set {
            set(newValue, forKey: Keys.supervisorEmail.rawValue)
            synchronize()
        }
    }
    
    var supervisorPhone: String? {
        get {
            return string(forKey: Keys.supervisorPhone.rawValue)
        }
        
        set {
            set(newValue, forKey: Keys.supervisorPhone.rawValue)
            synchronize()
        }
    }
    
}
