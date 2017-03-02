import Foundation

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
