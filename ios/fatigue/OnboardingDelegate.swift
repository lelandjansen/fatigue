import Contacts
import UIKit

protocol OnboardingDelegate: class {
    func addNextPage()
    func moveToNextPage()
    func presentViewController(_ viewController: UIViewController)
    func dismissOnboarding()
    func alertNotificationsNotPermitted()
    func populate(nameTextFiled: UITextField, emailTextField: UITextField, phoneNumberTextField: UITextField, withContact contact: CNContact)
}
