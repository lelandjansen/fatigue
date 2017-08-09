import Foundation

extension UserDefaults {
    
    enum UserDefaultsKeys: String {
        case firstLaunch,
            userTriedEditingRow,
            rangeQuestionTutorialShown,
            occupation,
            reminderEnabled,
            reminderHour,
            reminderMinute,
            name,
            supervisorName,
            supervisorEmail,
            supervisorPhone
    }
    
    var firstLaunch: Bool {
        get {
            return object(forKey: UserDefaultsKeys.firstLaunch.rawValue) as? Bool ?? true
        }
        
        set {
            set(newValue, forKey: UserDefaultsKeys.firstLaunch.rawValue)
            synchronize()
        }
    }
    
    var userTriedEditingRow: Bool {
        get {
            return object(forKey: UserDefaultsKeys.userTriedEditingRow.rawValue) as? Bool ?? false
        }
        
        set {
            set(newValue, forKey: UserDefaultsKeys.userTriedEditingRow.rawValue)
            synchronize()
        }
    }
    
    var rangeQuestionTutorialShown: Bool {
        get {
            return object(forKey: UserDefaultsKeys.rangeQuestionTutorialShown.rawValue) as? Bool ?? false
        }
        
        set {
            set(newValue, forKey: UserDefaultsKeys.rangeQuestionTutorialShown.rawValue)
            synchronize()
        }
    }
    
    var occupation: Occupation {
        get {
            return Occupation(rawValue: string(forKey: UserDefaultsKeys.occupation.rawValue) ?? Occupation.none.rawValue)!
        }

        set {
            set(newValue.rawValue, forKey: UserDefaultsKeys.occupation.rawValue)
            synchronize()
        }
    }
    
    
    var reminderEnabled: Bool {
        get {
            return object(forKey: UserDefaultsKeys.reminderEnabled.rawValue) as? Bool ?? false
        }
        
        set {
            set(newValue, forKey: UserDefaultsKeys.reminderEnabled.rawValue)
            synchronize()
        }
    }
    
    
    private var defaultReminderTime: DateComponents {
        var date = DateComponents()
        date.hour = 09
        date.minute = 00
        return date
    }
    
    var reminderTime: DateComponents {
        get {
            var date = DateComponents()
            date.hour = object(forKey: UserDefaultsKeys.reminderHour.rawValue) as? Int ?? defaultReminderTime.hour
            date.minute = object(forKey: UserDefaultsKeys.reminderMinute.rawValue) as? Int ?? defaultReminderTime.minute
            return date
        }
        
        set {
            set(newValue.hour ?? defaultReminderTime.hour, forKey: UserDefaultsKeys.reminderHour.rawValue)
            set(newValue.minute ?? defaultReminderTime.minute, forKey: UserDefaultsKeys.reminderMinute.rawValue)
            synchronize()
        }
    }
    
    
    var name: String? {
        get {
            return string(forKey: UserDefaultsKeys.name.rawValue)
        }
        
        set {
            set(newValue, forKey: UserDefaultsKeys.name.rawValue)
            synchronize()
        }
    }
    
    
    var supervisorName: String? {
        get {
            return string(forKey: UserDefaultsKeys.supervisorName.rawValue)
        }
        
        set {
            set(newValue, forKey: UserDefaultsKeys.supervisorName.rawValue)
            synchronize()
        }
    }

    
    var supervisorEmail: String? {
        get {
            return string(forKey: UserDefaultsKeys.supervisorEmail.rawValue)
        }
        
        set {
            set(newValue, forKey: UserDefaultsKeys.supervisorEmail.rawValue)
            synchronize()
        }
    }
    
    var supervisorPhone: String? {
        get {
            return string(forKey: UserDefaultsKeys.supervisorPhone.rawValue)
        }
        
        set {
            set(newValue, forKey: UserDefaultsKeys.supervisorPhone.rawValue)
            synchronize()
        }
    }
    
}
