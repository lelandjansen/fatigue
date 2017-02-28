import Foundation

protocol QuestionnaireItem {
    var nextItem: QuestionnaireItem? { get set }
}

class HashableQuestionnaireItem: Hashable {
    var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
    
    static func == (lhs: HashableQuestionnaireItem, rhs: HashableQuestionnaireItem) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var questionnaireItem: QuestionnaireItem
    
    init(_ questionnaireItem: QuestionnaireItem) {
        self.questionnaireItem = questionnaireItem
    }
}
