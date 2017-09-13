import CoreData
import UIKit

extension QuestionnaireResponse {
    static let entityName = "QuestionnaireResponse"
    
    static func saveResponse(forQuestionnaireItems questionnaireItems: [QuestionnaireItem]) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let questionnaireResponse = NSEntityDescription.insertNewObject(forEntityName: QuestionnaireResponse.entityName, into: context) as! QuestionnaireResponse
        questionnaireResponse.date = NSDate()
        
        var riskScore: Int32 = 0
        for questionnaireItem in questionnaireItems {
            if questionnaireItem is Question {
                let question = questionnaireItem as! Question
                let questionResponse = NSEntityDescription.insertNewObject(forEntityName: QuestionResponse.entityName, into: context) as! QuestionResponse
                questionResponse.id = question.id.rawValue
                questionResponse.questionDescription = question.description
                questionResponse.riskScoreContribution = question.riskScoreContribution(question.selection)
                questionResponse.selection = question.selection
                questionnaireResponse.addToQuestionResponses(questionResponse)
                riskScore += question.riskScoreContribution(question.selection)
            }
        }
        questionnaireResponse.riskScore = riskScore
        do {
            try context.save()
        }
        catch {
            if let topViewController = UIApplication.topViewController() {
                let alert = UIAlertController(
                    title: "Unable to save questionnaire response.",
                    message: nil,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                topViewController.present(alert, animated: true)
            }
        }
    }
    
    static func loadResponses() -> [QuestionnaireResponse] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<QuestionnaireResponse> = QuestionnaireResponse.fetchRequest()
        do {
            return try context.fetch(request)
        }
        catch {
            if let topViewController = UIApplication.topViewController() {
                let alert = UIAlertController(
                    title: "Unable to load questionnaire responses.",
                    message: nil,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                topViewController.present(alert, animated: true)
            }
        }
        return []
    }
    
    static func delete(response: QuestionnaireResponse) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(response)
        do {
            try context.save()
        }
        catch {
            if let topViewController = UIApplication.topViewController() {
                let alert = UIAlertController(
                    title: "Unable to delete questionnaire response.",
                    message: nil,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                topViewController.present(alert, animated: true)
            }
        }
    }
    
    func maxWorkTimeExceeded(forRole role: Role) -> Bool {
        switch role {
        case .pilot:
            var flyingWithAnotherPilot = false
            for response in questionResponses! {
                if (response as! QuestionResponse).id == Questionnaire.QuestionId.numberOfPilots.rawValue {
                    flyingWithAnotherPilot = ((response as! QuestionResponse).selection == YesNoQuestion.Answer.yes.rawValue)
                    
                }
            }
            for response in questionResponses! {
                if (response as! QuestionResponse).id == Questionnaire.QuestionId.workTime.rawValue {
                    let hoursFlying = Int((response as! QuestionResponse).selection!)!
                    if flyingWithAnotherPilot {
                        return QuestionnaireDefaults.maxFlightTimeManyPilots < hoursFlying
                    } else {
                        return QuestionnaireDefaults.maxFlightTimeOnePilot < hoursFlying
                    }
                    
                }
            }
        case .engineer:
            for response in questionResponses! {
                if (response as! QuestionResponse).id == Questionnaire.QuestionId.workTime.rawValue {
                    let workTime = Int((response as! QuestionResponse).selection!)!
                    return workTime < QuestionnaireDefaults.maxWorkTimeEngineer
                }
            }
        case .none:
            fatalError("Role cannot be none")
        }
        fatalError("Could not determine if flight time was exceeded")
    }
}
