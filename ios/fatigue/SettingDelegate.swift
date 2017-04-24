import Foundation

protocol SettingDelegate: class {
    weak var delegate: SettingsController? { get set }
}
