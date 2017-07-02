import UIKit

class HomePageController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePageControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.backgroundColor = .light
        collectionView?.scrollsToTop = false
        registerCells()
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
        present(questionnaireController, animated: true, completion: nil)
    }
    
    func presentSettings() {
        let navigationController = UINavigationController(rootViewController: SettingsController())
        present(navigationController, animated: true, completion: nil)
        
    }
    
    func dismissSettings() {
        dismiss(animated: true, completion: nil)
    }
    
    func moveToHomePage() {
        collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredVertically, animated: true)
    }
    
    func moveToHistoryPage() {
        collectionView?.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredVertically, animated: true)
    }
    
    func refreshHistory() {
        if let historyCell = collectionView?.visibleCells.first(where: {$0 is HistoryCell}) as? HistoryCell {
            historyCell.reloadHistory()
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if .zero == scrollView.contentOffset {
            if let historyCell = collectionView?.visibleCells.first(where: {$0 is HistoryCell}) as? HistoryCell {
                (historyCell as HistoryCell).scrollToTop()
                (historyCell as HistoryCell).historyTable.isScrollEnabled = false
            }
        }
        else {
            if let historyCell = collectionView?.visibleCells.first(where: {$0 is HistoryCell}) as? HistoryCell {
                (historyCell as HistoryCell).historyTable.isScrollEnabled = true
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let historyCell = collectionView?.visibleCells.first(where: {$0 is HistoryCell}) as? HistoryCell {
            let offset = view.frame.height - UIConstants.navigationBarHeight - UIConstants.tableViewRowHeight - 10
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
            return CGSize(width: view.frame.width, height: view.frame.height - UIConstants.navigationBarHeight - UIConstants.tableViewRowHeight)
        default:
            return CGSize(width: view.frame.width, height: view.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
