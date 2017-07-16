import Foundation

protocol Question {
    var id: Questionnaire.QuestionId { get }
    var question: String { get }
    var details: String { get set }
    var description: String { get }
    var options: [String] { get }
    var selection: String { get set }
    var riskScoreContribution: (String) -> Int32 { get set }
}
