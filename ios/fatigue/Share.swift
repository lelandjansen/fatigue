import UIKit
import MessageUI

struct Share {
    static func share(questionnaireResponse: QuestionnaireResponse, inViewController viewController: UIViewController, withPopoverSourceView popoverSourceView: UIView?, withPermittedArrowDirections permittedArrowDirections: UIPopoverArrowDirection, forMFMailComposeViewControllerDelegate mfMailComposeViewControllerDelegate: MFMailComposeViewControllerDelegate, forMFMessageComposeViewControllerDelegate mfMessageComposeViewControllerDelegate: MFMessageComposeViewControllerDelegate, completion: (() -> ())? = nil) {
        let actionController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionController.popoverPresentationController?.permittedArrowDirections = permittedArrowDirections
        let mailAction = UIAlertAction(title: "Mail…", style: .default) { _ in
            self.sendEmail(
                withQuestionnaireResponse: questionnaireResponse,
                inViewController: viewController,
                forMFMailComposeViewControllerDelegate: mfMailComposeViewControllerDelegate,
                completion: completion
            )
        }
        let messagesAction = UIAlertAction(title: "Messages…", style: .default) { _ in
            self.sendMessage(
                withQuestionnaireResponse: questionnaireResponse,
                inViewController: viewController,
                forMFMessageComposeViewControllerDelegate: mfMessageComposeViewControllerDelegate,
                completion: completion
            )
        }
        let otherAction = UIAlertAction(title: "Other…", style: .default) { _ in
            self.sendOther(
                withQuestionnaireResponse: questionnaireResponse,
                inViewController: viewController,
                withPopoverSourceView: popoverSourceView,
                withPermittedArrowDirections: permittedArrowDirections,
                completion: completion
            )
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion?()
        }
        if let sourceView = popoverSourceView {
            actionController.popoverPresentationController?.sourceView = sourceView
            actionController.popoverPresentationController?.sourceRect = makePopoverSourceView(fromSourceView: sourceView, withPermittedArrowDirections: permittedArrowDirections)
        }
        for action in [mailAction, messagesAction, otherAction, cancelAction] {
            actionController.addAction(action)
        }
        viewController.present(actionController, animated: true)
    }
    
    static func composeMessage(forQuestionnaireResponse questionnaireResponse: QuestionnaireResponse) -> String {
        var message: [String] = []
        let name = UserDefaults.standard.name ?? ""
        if !name.isEmpty {
            message.append("Name: \(name)")
        }
        let role = UserDefaults.standard.role
        message.append("Role: \(role.rawValue.capitalized)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm zzz"
        message.append("Date: \(dateFormatter.string(from: questionnaireResponse.date! as Date))")
        let riskScore = questionnaireResponse.riskScore as Int32
        message.append("Fatigue self-assessment score: \(riskScore)")
        message.append("Action: \(Result.getRemark(forRiskScore: riskScore, role: role))")
        return message.joined(separator: "\n")
    }
    
    static func sendEmail(withQuestionnaireResponse questionnaireResponse: QuestionnaireResponse, inViewController viewController: UIViewController, forMFMailComposeViewControllerDelegate mfMailComposeViewControllerDelegate: MFMailComposeViewControllerDelegate, completion: (() -> ())? = nil) {
        if !MFMailComposeViewController.canSendMail() {
            fatalError("Cannot send email")
        }
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = mfMailComposeViewControllerDelegate
        mailComposer.setToRecipients([UserDefaults.standard.supervisorEmail ?? String()])
        let subject = "Fatigue self-assessment"
        let name = UserDefaults.standard.name ?? ""
        if name.isEmpty {
            mailComposer.setSubject("\(subject)")
        } else {
            mailComposer.setSubject("\(name): \(subject)")
        }
        let message = composeMessage(forQuestionnaireResponse: questionnaireResponse)
        mailComposer.setMessageBody(message, isHTML: false)
        viewController.present(mailComposer, animated: true, completion: completion)
    }
    
    static func sendMessage(withQuestionnaireResponse questionnaireResponse: QuestionnaireResponse, inViewController viewController: UIViewController, forMFMessageComposeViewControllerDelegate mfMessageComposeViewControllerDelegate: MFMessageComposeViewControllerDelegate, completion: (() -> ())? = nil) {
        if !MFMessageComposeViewController.canSendText() {
            fatalError("Cannot send message")
        }
        let messageComposer = MFMessageComposeViewController()
        messageComposer.messageComposeDelegate = mfMessageComposeViewControllerDelegate
        messageComposer.recipients = [UserDefaults.standard.supervisorPhone ?? String()]
        messageComposer.body = composeMessage(forQuestionnaireResponse: questionnaireResponse)
        viewController.present(messageComposer, animated: true, completion: completion)
    }
    
    static func sendOther(withQuestionnaireResponse questionnarieResponse: QuestionnaireResponse, inViewController viewController: UIViewController, withPopoverSourceView popoverSourceView: UIView?, withPermittedArrowDirections permittedArrowDirections: UIPopoverArrowDirection, completion: (() -> ())? = nil) {
        let message = composeMessage(forQuestionnaireResponse: questionnarieResponse)
        let activityViewController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityViewController.popoverPresentationController?.permittedArrowDirections = permittedArrowDirections
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
        if let sourceView = popoverSourceView {
            activityViewController.popoverPresentationController?.sourceView = sourceView
            activityViewController.popoverPresentationController?.sourceRect = makePopoverSourceView(fromSourceView: sourceView, withPermittedArrowDirections: permittedArrowDirections)
        }
        activityViewController.completionWithItemsHandler = { _ in
            completion?()
        }
        viewController.present(activityViewController, animated: true)
    }
    
    static fileprivate func makePopoverSourceView(fromSourceView sourceView: UIView, withPermittedArrowDirections permittedArrowDirections: UIPopoverArrowDirection) -> CGRect {
        let constant: CGFloat = 1
        switch permittedArrowDirections {
        case [.up]:
            return CGRect(x: sourceView.bounds.minX, y: sourceView.bounds.maxY - constant, width: sourceView.bounds.width, height: constant)
        case [.down]:
            return CGRect(x: sourceView.bounds.minX, y: sourceView.bounds.minY, width: sourceView.bounds.width, height: constant)
        case [.left]:
            return CGRect(x: sourceView.bounds.maxX - constant, y: sourceView.bounds.minY, width: 1, height: sourceView.bounds.height)
        case [.right]:
            return CGRect(x: sourceView.bounds.maxX, y: sourceView.bounds.minY, width: 1, height: sourceView.bounds.height)
        default:
            return CGRect(x: sourceView.bounds.minX, y: sourceView.bounds.minY, width: sourceView.bounds.width, height: sourceView.bounds.height)
        }
    }
}
