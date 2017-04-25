import Foundation

protocol Setting {
    static var settingName: String { get }
    var details: String { get set }
}
