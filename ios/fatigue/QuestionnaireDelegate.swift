import UIKit

protocol QuestionnaireDelegate: class {
    func setQuestionSelection(toValue value: String, forCell cell: UICollectionViewCell)
    func updateQuestionnaireOrder()
    func moveToPreviousPage()
    func moveToNextPage()
    func dismissQuestionnaire()
    func shareResponse(withPopoverSourceView popoverSourceView: UIView?)
}
