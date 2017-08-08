import UIKit

protocol HomePageControllerDelegate: class {
    func presentQuestionnaire()
    func presentSettings()
    func moveToHomePage()
    func moveToHistoryPage()
    func refreshHistory()
    func shareHistoryItem(_ questionnaireResponse: QuestionnaireResponse, withPopoverSourceView popoverSourceView: UIView?, completion: (() -> ())?)
    func confirmDeleteHistoryItem(_ questionnaireResponse: QuestionnaireResponse, forTableView tableView: UITableView, atIndexPath indexPath: IndexPath, withPopoverSourceView popoverSourceView: UIView?, deleteCompletion: ((UITableView, IndexPath) -> ())?)
}
