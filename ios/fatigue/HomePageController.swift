import UIKit
import MessageUI

class HomePageController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePageControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.backgroundColor = .light
        collectionView?.scrollsToTop = false
        registerCells()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.firstLaunch {
            present(OnboardingController(), animated: false)
        }
    }
    
    enum CellId: String {
        case homePage, history
    }
    
    let cells = [HomePageCell(), HistoryCell()]
    
    fileprivate func registerCells() {
        collectionView?.register(HomePageCell.self, forCellWithReuseIdentifier: CellId.homePage.rawValue)
        collectionView?.register(HistoryCell.self, forCellWithReuseIdentifier: CellId.history.rawValue)
    }
    
    func presentQuestionnaire() {
        let questionnaireController = QuestionnaireController()
        questionnaireController.homePageDelegate = self
        present(questionnaireController, animated: true, completion: {
            if !UserDefaults.standard.rangeQuestionTutorialShown {
                questionnaireController.showRangeQuestionTutorial()
            }
        })
    }
    
    func presentSettings() {
        let navigationController = UINavigationController(rootViewController: SettingsController())
        present(navigationController, animated: true)
        
    }
    
    func dismissSettings() {
        dismiss(animated: true)
    }
    
    func moveToHomePage() {
        collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredVertically, animated: true)
        if let historyCell = collectionView?.visibleCells.first(where: {$0 is HistoryCell}) as? HistoryCell {
            historyCell.scrollToTop()
            historyCell.historyTable.isScrollEnabled = false
            historyCell.historyTable.setEditing(false, animated: true)
        }
    }
    
    func moveToHistoryPage() {
        collectionView?.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredVertically, animated: true)
    }
    
    func refreshHistory() {
        if let historyCell = collectionView?.visibleCells.first(where: {$0 is HistoryCell}) as? HistoryCell {
            historyCell.reloadHistory()
        }
    }
    
    func shareHistoryItem(_ questionnaireResponse: QuestionnaireResponse, withPopoverSourceView popoverSourceView: UIView?, completion: (() -> ())? = nil) {
        Share.share(
            questionnaireResponse: questionnaireResponse,
            inViewController: self,
            withPopoverSourceView: popoverSourceView,
            forMFMailComposeViewControllerDelegate: self,
            forMFMessageComposeViewControllerDelegate: self,
            completion: {
                completion?()
            }
        )
    }
    
    func confirmDeleteHistoryItem(_ questionnaireResponse: QuestionnaireResponse, forTableView tableView: UITableView, atIndexPath indexPath: IndexPath, withPopoverSourceView popoverSourceView: UIView?, deleteCompletion: ((UITableView, IndexPath) -> ())?) {
        let actionController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionController.title = "Delete history item?"
        actionController.popoverPresentationController?.permittedArrowDirections = .right
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            DispatchQueue.main.async {
                deleteCompletion?(tableView, indexPath)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            DispatchQueue.main.async {
                tableView.setEditing(false, animated: true)
            }
        }
        if let sourceView = popoverSourceView {
            actionController.popoverPresentationController?.sourceView = sourceView
            actionController.popoverPresentationController?.sourceRect = CGRect(x: sourceView.bounds.maxX, y: sourceView.bounds.minY, width: 5, height: sourceView.bounds.height)
        }
        for button in [deleteAction, cancelAction] {
            actionController.addAction(button)
        }
        present(actionController, animated: true)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if .zero == scrollView.contentOffset {
            moveToHomePage()
        }
        else {
            if let historyCell = collectionView?.visibleCells.first(where: {$0 is HistoryCell}) as? HistoryCell {
                historyCell.historyTable.isScrollEnabled = true
                if !UserDefaults.standard.userTriedEditingRow {
                    historyCell.showRowEditTutorial()
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let historyCell = collectionView?.visibleCells.first(where: {$0 is HistoryCell}) as? HistoryCell {
            let offset = view.frame.height - UIConstants.navigationBarHeight - UIConstants.tableViewRowHeight * 3 / 2  - 10
            let index = (collectionView?.contentOffset.y)! < offset ? 0 : 1
            historyCell.animateNavigationBar(
                toColor: cells[index] is HistoryCell ? .white : .light,
                withDuration: 1 / 4
            )
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch cells[indexPath.row] {
        case is HomePageCell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.homePage.rawValue, for: indexPath) as! HomePageCell
            cell.delegate = self
            return cell
        case is HistoryCell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.history.rawValue, for: indexPath) as! HistoryCell
            cell.delegate = self
            cell.historyTable.isScrollEnabled = false
            return cell
        default:
            fatalError("Cell is not one of the supported types")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0:
            return CGSize(width: view.frame.width, height: view.frame.height - UIConstants.navigationBarHeight - UIConstants.tableViewRowHeight * 3 / 2)
        default:
            return CGSize(width: view.frame.width, height: view.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
