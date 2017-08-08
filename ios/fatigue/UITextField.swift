import Contacts
import UIKit

extension UITextField {
    func populateName(fromContact contact: CNContact, completion: (() -> Swift.Void)? = nil) {
        self.text = CNContactFormatter.string(from: contact, style: .fullName)
        completion?()
    }
    
    func populateEmail(fromContact contact: CNContact, inTableViewController tableViewController: UIViewController, withPopoverSourceView popoverSourceView: UIView?, completion: (() -> Swift.Void)? = nil) {
        if contact.emailAddresses.isEmpty {
            self.text = String()
            completion?()
            return
        }
        else if contact.emailAddresses.count == 1 {
            self.text = String(describing: contact.emailAddresses.first!.value)
            completion?()
            return
        }
        let alertController = UIAlertController(title: "Email", message: String(), preferredStyle: .actionSheet)
        for email in contact.emailAddresses {
            let address = String(describing: email.value)
            let title = { () -> String in
                if let label = email.label {
                    return "\(address) – \(CNLabeledValue<NSString>.localizedString(forLabel: label))"
                }
                else {
                    return address
                }
            }()
            alertController.addAction(UIAlertAction(title: title, style: .default , handler: { _ in
                self.text = address
                completion?()
            }))
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            completion?()
        }))
        if let view = popoverSourceView {
            alertController.popoverPresentationController?.sourceView = view
            alertController.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.minX, y: view.bounds.maxY, width: 0, height: 0)
            alertController.popoverPresentationController?.permittedArrowDirections = [.up, .down]
        }
        OperationQueue.main.addOperation() {
            tableViewController.present(alertController, animated: true)
        }
    }
    
    func populatePhoneNumber(fromContact contact: CNContact, inViewController viewController: UIViewController, withPopoverSourceView popoverSourceView: UIView?, completion: (() -> Swift.Void)? = nil) {
        if contact.phoneNumbers.isEmpty {
            self.text = String()
            completion?()
            return
        }
        else if contact.phoneNumbers.count == 1 {
            self.text = String(describing: contact.phoneNumbers.first!.value.stringValue)
            completion?()
            return
        }
        let alertController = UIAlertController(title: "Phone number", message: String(), preferredStyle: .actionSheet)
        for phoneNumber in contact.phoneNumbers {
            let number = phoneNumber.value.stringValue
            let title = { () -> String in
                if let label = phoneNumber.label {
                    return "\(number) – \(CNLabeledValue<NSString>.localizedString(forLabel: label))"
                }
                else {
                    return number
                }
            }()
            alertController.addAction(UIAlertAction(title: title, style: .default, handler: { _ in
                self.text = number
                completion?()
            }))
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            completion?()
        }))
        if let view = popoverSourceView {
            alertController.popoverPresentationController?.sourceView = view
            alertController.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.minX, y: view.bounds.maxY, width: 0, height: 0)
            alertController.popoverPresentationController?.permittedArrowDirections = [.up, .down]
            
        }
        OperationQueue.main.addOperation() {
            viewController.present(alertController, animated: true)
        }
    }
}
