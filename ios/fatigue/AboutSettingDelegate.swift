import UIKit

protocol AboutSettingDelegate: class {
    func pushViewController(_ viewController: UIViewController)
    func openUrl(_ url: URL)
}
