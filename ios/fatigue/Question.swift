import Foundation

protocol Question {
    var question: String { get }
    var details: String { get }
    var options: [String] { get }
    var selection: String { get set }
}


class YesNoQuestion: Question, QuestionnaireItem {
    enum Answer: String {
        case none = "", yes = "Yes", no = "No"
    }
    
    var question: String
    var details: String
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
    
    init(question: String, details: String = String(), nextItemIfYes: QuestionnaireItem, nextItemIfNo: QuestionnaireItem) {
        self.question = question
        self.details = details
        self.nextItemIfYes = nextItemIfYes
        self.nextItemIfNo = nextItemIfNo
    }
    
    init(question: String, details: String = String(), nextItem: QuestionnaireItem) {
        self.question = question
        self.details = details
        self.nextItemIfYes = nextItem
        self.nextItemIfNo = nextItem
    }
    
    init(question: String, details: String = String()) {
        self.question = question
        self.details = details
    }
}


class RangeQuestion: Question, QuestionnaireItem {
    enum Units: String {
        case none = "", hours = "hrs"
    }
    
    var question: String
    var details: String
    var options: [String]
    var selection: String
    let units: Units
    var nextItem: QuestionnaireItem?
    
    init(question: String, details: String = String(), options: [UInt], selection: UInt, units: Units = .none, nextItem: QuestionnaireItem?) {
        self.question = question
        self.details = details
        self.options = options.map{String($0)}
        self.selection = String(selection)
        self.units = units
        self.nextItem = nextItem
    }
}
