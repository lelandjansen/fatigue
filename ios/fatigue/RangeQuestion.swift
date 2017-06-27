import Foundation

class RangeQuestion: Question, QuestionnaireItem {
    enum Units {
        case none, hours
    }
    
    var question: String
    var details: String
    var description: String
    var options: [String]
    var selection: String
    let units: Units
    var nextItem: QuestionnaireItem?
    var riskScoreContribution: (String) -> Int32
    
    
    init(question: String, details: String = String(), description: String, options: [UInt], selection: UInt, units: Units = .none, riskScoreContribution: @escaping (String) -> Int32, nextItem: QuestionnaireItem?) {
        self.question = question
        self.details = details
        self.description = description
        self.options = options.map{String($0)}
        self.selection = String(selection)
        self.units = units
        self.riskScoreContribution = riskScoreContribution
        self.nextItem = nextItem
    }
}
