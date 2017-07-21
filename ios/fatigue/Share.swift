import UIKit
import MessageUI

struct Share {
    static func share(questionnaireResponse: QuestionnaireResponse, inViewController viewController: UIViewController, withPopoverSourceView popoverSourceView: UIView?, forMFMailComposeViewControllerDelegate mfMailComposeViewControllerDelegate: MFMailComposeViewControllerDelegate, forMFMessageComposeViewControllerDelegate mfMessageComposeViewControllerDelegate: MFMessageComposeViewControllerDelegate) {
        let mailAction = UIAlertAction(title: "Mail", style: .default) { _ in
            self.sendEmail(
                withQuestionnaireResponse: questionnaireResponse,
                inViewController: viewController,
                forMFMailComposeViewControllerDelegate: mfMailComposeViewControllerDelegate
            )
        }
        let messagesAction = UIAlertAction(title: "Messages", style: .default) { _ in
            self.sendMessage(
                withQuestionnaireResponse: questionnaireResponse,
                inViewController: viewController,
                forMFMessageComposeViewControllerDelegate: mfMessageComposeViewControllerDelegate
            )
        }
        let otherAction = UIAlertAction(title: "Other...", style: .default) { _ in
            self.sendOther(
                withQuestionnaireResponse: questionnaireResponse,
                inViewController: viewController,
                withPopoverSourceView: popoverSourceView
            )
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let actionController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if let view = popoverSourceView {
            actionController.popoverPresentationController?.sourceView = view
            actionController.popoverPresentationController?.sourceRect = view.bounds
        }
        for button in [mailAction, messagesAction, otherAction, cancelAction] {
            actionController.addAction(button)
        }
        viewController.present(actionController, animated: true)
    }
    
    static func composeMessage(forQuestionnaireResponse questionnaireResponse: QuestionnaireResponse) -> String {
        var message: [String] = []
        if let name = UserDefaults.standard.name { message.append("Name: \(name)") }
        message.append("Occupation: \(UserDefaults.standard.occupation.rawValue.capitalized)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm zzz"
        message.append("Date: \(dateFormatter.string(from: questionnaireResponse.date! as Date))")
        message.append("Risk score: \(questionnaireResponse.riskScore as Int32)")
        return message.joined(separator: "\n")
    }
    
    static func sendEmail(withQuestionnaireResponse questionnaireResponse: QuestionnaireResponse, inViewController viewController: UIViewController, forMFMailComposeViewControllerDelegate mfMailComposeViewControllerDelegate: MFMailComposeViewControllerDelegate) {
        if !MFMailComposeViewController.canSendMail() {
            fatalError("Cannot send email")
        }
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = mfMailComposeViewControllerDelegate
        mailComposer.setToRecipients([UserDefaults.standard.supervisorEmail ?? String()])
        mailComposer.setSubject("Fatigue self-assessment")
        let message = composeMessage(forQuestionnaireResponse: questionnaireResponse)
        mailComposer.setMessageBody(message, isHTML: false)
        viewController.present(mailComposer, animated: true)
    }
    
    static func sendMessage(withQuestionnaireResponse questionnaireResponse: QuestionnaireResponse, inViewController viewController: UIViewController, forMFMessageComposeViewControllerDelegate mfMessageComposeViewControllerDelegate: MFMessageComposeViewControllerDelegate) {
        let messageComposer = MFMessageComposeViewController()
        messageComposer.messageComposeDelegate = mfMessageComposeViewControllerDelegate
        messageComposer.recipients = [UserDefaults.standard.supervisorPhone ?? String()]
        messageComposer.body = composeMessage(forQuestionnaireResponse: questionnaireResponse)
        viewController.present(messageComposer, animated: true)
    }
    
    static func sendOther(withQuestionnaireResponse questionnarieResponse: QuestionnaireResponse, inViewController viewController: UIViewController, withPopoverSourceView popoverSourceView: UIView?) {
        let message = composeMessage(forQuestionnaireResponse: questionnarieResponse)
        let activityViewController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [
            .addToReadingList,
            .airDrop,
            .assignToContact,
            .openInIBooks,
            .postToFacebook,
            .postToVimeo,
            .postToFlickr,
            .postToTencentWeibo,
            .postToTwitter,
            .postToVimeo,
            .postToWeibo,
            .saveToCameraRoll,
        ]
        if let view = popoverSourceView {
            activityViewController.popoverPresentationController?.sourceView = view
            activityViewController.popoverPresentationController?.sourceRect = view.bounds
        }
        viewController.present(activityViewController, animated: true)
    }
}
