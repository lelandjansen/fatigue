import UIKit

protocol OnboardingDelegate: class {
    func addNextPage()
    func moveToNextPage()
    func presentViewController(_ viewController: UIViewController)
    func dismiss()
    func alertNotificationsNotPermitted()
}
