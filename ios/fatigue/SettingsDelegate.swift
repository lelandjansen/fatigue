import UIKit

protocol SettingsDelegate: class {
    func setSelectedCellDetails(toValue value: String)
    func presentViewController(_ viewController: UIViewController)
}
