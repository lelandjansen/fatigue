import UIKit

protocol OnboardingDelegate: class {
    func moveToNextPage()
    func presentViewController(_ viewController: UIViewController)
}
