import Foundation

protocol QuestionnaireItem {
    var nextItem: QuestionnaireItem? { get set }
}
