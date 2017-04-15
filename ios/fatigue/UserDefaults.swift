import Foundation

extension UserDefaults {
    
    enum UserDefaultsKeys: String {
        case career
    }
    
    func setCareer(_ career: Career) {
        set(career.rawValue, forKey: UserDefaultsKeys.career.rawValue)
        synchronize()
    }
    
    func getCareer() -> Career {
        return Career(rawValue: string(forKey: UserDefaultsKeys.career.rawValue)!) ?? .pilot
    }
}
