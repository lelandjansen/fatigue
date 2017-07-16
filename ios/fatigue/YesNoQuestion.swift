import Foundation

class YesNoQuestion: Question, QuestionnaireItem {
    enum Answer: String {
        case none = "", yes = "Yes", no = "No"
    }
    
    var id: Questionnaire.QuestionId
    var question: String
    var details: String
    var description: String
    var options: [String] = [Answer.yes.rawValue, Answer.no.rawValue]
    var selection: String = Answer.none.rawValue {
        didSet {
            switch selection {
            case Answer.yes.rawValue:
                nextItem = nextItemIfYes
            case Answer.no.rawValue:
                nextItem = nextItemIfNo
            default:
                nextItem = nil
            }
        }
    }
    var nextItem: QuestionnaireItem?
    var nextItemIfYes: QuestionnaireItem?
    var nextItemIfNo: QuestionnaireItem?
    var riskScoreContribution: (String) -> Int32
    
    init(id: Questionnaire.QuestionId, question: String, details: String = String(), description: String, riskScoreContribution: @escaping (String) -> Int32, nextItemIfYes: QuestionnaireItem, nextItemIfNo: QuestionnaireItem) {
        self.id = id
        self.question = question
        self.details = details
        self.description = description
        self.riskScoreContribution = riskScoreContribution
        self.nextItemIfYes = nextItemIfYes
        self.nextItemIfNo = nextItemIfNo
    }
    
    init(id: Questionnaire.QuestionId, question: String, details: String = String(), description: String, riskScoreContribution: @escaping (String) -> Int32, nextItem: QuestionnaireItem) {
        self.id = id
        self.question = question
        self.details = details
        self.description = description
        self.riskScoreContribution = riskScoreContribution
        self.nextItemIfYes = nextItem
        self.nextItemIfNo = nextItem
    }
    
    init(id: Questionnaire.QuestionId, question: String, riskScoreContribution: @escaping (String) -> Int32, details: String = String(), description: String) {
        self.id = id
        self.question = question
        self.details = details
        self.description = description
        self.description = description
        self.riskScoreContribution = riskScoreContribution
    }
}
