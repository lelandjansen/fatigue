import UIKit

protocol QuestionnaireControllerDelegate: class {
    func setQuestionSelection(toValue value: String, forCell cell: UICollectionViewCell)
    func updateQuestionnaireOrder()
    func moveToPreviousPage()
    func moveToNextPage()
    func goToHomePage()
    func animateBackgroundColor(toColor color: UIColor, withDuration duration: TimeInterval)
}
