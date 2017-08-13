import UIKit
import CoreData
import MessageUI

class QuestionnaireController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, QuestionnaireDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        updateQuestionnaireOrder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    enum CellId: String {
        case rangeQuestion, yesNoQuestion, result
    }
    
    var questionnaireItems: [QuestionnaireItem] = [Questionnaire().questionnaireTreeRoot]
    var smartSuggestions: SmartSuggestions?
    
    func setQuestionSelection(toValue value: String, forCell cell: UICollectionViewCell) {
        let indexPath = collectionView.indexPath(for: cell)
        guard indexPath != nil else {
            return
        }
        
        if questionnaireItems[indexPath!.item] is Question {
            var question = (questionnaireItems[indexPath!.item] as! Question)
            question.selection = value
        }
    }
    
    func updateQuestionnaireOrder() {
        var questionnaireItem = questionnaireItems.first!
        questionnaireItems = [questionnaireItem]
        
        while questionnaireItem.nextItem != nil {
            questionnaireItems.append(questionnaireItem.nextItem!)
            questionnaireItem = questionnaireItem.nextItem!
        }
        
        pageControl.numberOfPages = longestQuestionnaireSequence(fromStartQuestion: questionnaireItems.last!) + questionnaireItems.count
        
        collectionView.reloadData()
        self.view.layoutIfNeeded()
    }
    
    fileprivate func longestQuestionnaireSequence(fromStartQuestion startQuestion: QuestionnaireItem) -> Int {
        let (graph, destination) = graphFromQuestionnaire(fromQuestion: startQuestion)
        return LongestPath.length(forGraph: graph, toNode: destination)
    }
    
    fileprivate func graphFromQuestionnaire(fromQuestion question: QuestionnaireItem) -> (Dictionary<ObjectIdentifier, Set<ObjectIdentifier>>, ObjectIdentifier) {
        var graph = Dictionary<ObjectIdentifier, Set<ObjectIdentifier>>()
        var destination: ObjectIdentifier?
        
        func createGraph(fromNode node: QuestionnaireItem) {
            graph[objectIdentifier(node)] = []
            
            switch node {
            case let node as YesNoQuestion:
                graph[objectIdentifier(node)]!.insert(objectIdentifier(node.nextItemIfYes!))
                graph[objectIdentifier(node)]!.insert(objectIdentifier(node.nextItemIfNo!))
                createGraph(fromNode: node.nextItemIfYes!)
                createGraph(fromNode: node.nextItemIfNo!)
            case let node as RangeQuestion:
                graph[objectIdentifier(node)]!.insert(objectIdentifier(node.nextItem!))
                createGraph(fromNode: node.nextItem!)
            case let node as Result:
                destination = objectIdentifier(node)
            default:
                fatalError("Questionnaire item is not one of the supported types")
            }
        }
        
        createGraph(fromNode: question)
        return (graph, destination!)
    }
    
    fileprivate func objectIdentifier(_ node: QuestionnaireItem) -> ObjectIdentifier {
        switch node {
        case let node as YesNoQuestion:
            return ObjectIdentifier(node)
        case let node as RangeQuestion:
            return ObjectIdentifier(node)
        case let node as Result:
            return ObjectIdentifier(node)
        default:
            fatalError("Questionnaire item is not one of the supported types")
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .light
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let closeItem: UIBarButtonItem = {
        return UIBarButtonItem(
            title: "Close",
            style: UIBarButtonItemStyle.plain,
            target: nil,
            action: #selector(dismissQuestionnaireWithConfirmation)
        )
    }()
    
    lazy var navigationBar: UINavigationBar = {
        let navigationBar: UINavigationBar = UINavigationBar(
            frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: UIConstants.navigationBarHeight)
        )
        navigationBar.barTintColor = .light
        navigationBar.isTranslucent = false
        navigationBar.tintColor = .violet
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.dark]
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        let navigationItem = UINavigationItem(title: "Questionnaire")
        navigationItem.leftBarButtonItem = self.closeItem
        navigationBar.setItems([navigationItem], animated: false)
        return navigationBar
    }()
    
    func updateNavigationBarButtonItemsToDone() {
        let doneItem = UIBarButtonItem(
            title: "Done",
            style: UIBarButtonItemStyle.done,
            target: nil,
            action: #selector(self.dismissQuestionnaire)
        )
        let navigationItem = UINavigationItem(title: self.navigationBar.topItem?.title ?? String())
        navigationItem.rightBarButtonItem = doneItem
        self.navigationBar.setItems([navigationItem], animated: false)
    }
    
    var pageControlBottomAnchor: NSLayoutConstraint?
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = UIColor.dark.withAlphaComponent(2 / 5)
        pageControl.currentPageIndicatorTintColor = .dark
        pageControl.defersCurrentPageDisplay = true
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        smartSuggestions = SmartSuggestions(forQuestionnaireRoot: questionnaireItems.first!)
        
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(navigationBar)
        
        collectionView.anchorToTop(
            navigationBar.bottomAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor
        )
        
        pageControlBottomAnchor = pageControl.anchor(
            nil,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor,
            heightConstant: 32
            )[1]
        
        registerCells()
    }
    
    fileprivate func registerCells() {
        collectionView.register(RangeQuestionCell.self, forCellWithReuseIdentifier: CellId.rangeQuestion.rawValue)
        collectionView.register(YesNoQuestionCell.self, forCellWithReuseIdentifier: CellId.yesNoQuestion.rawValue)
        collectionView.register(ResultCell.self, forCellWithReuseIdentifier: CellId.result.rawValue)
    }
    
    fileprivate func moveControlsOffScreen() {
        pageControlBottomAnchor?.constant = 40
        UIView.animate(
            withDuration: 1/2,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: {
                self.view.layoutIfNeeded()
        }
        )
    }
    
    fileprivate func moveControlsOnScreen() {
        pageControlBottomAnchor?.constant = 0
        UIView.animate(
            withDuration: 1/2,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: {
                self.view.layoutIfNeeded()
        }
        )
    }
    
    func moveToPreviousPage() {
        if pageControl.currentPage == 0 {
            return
        }
        
        if pageControl.currentPage != pageControl.numberOfPages - 2 {
            moveControlsOnScreen()
        }
        
        pageControl.currentPage -= 1
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func moveToNextPage() {
        if pageControl.currentPage == pageControl.numberOfPages - 1 {
            return
        }
        
        if pageControl.currentPage == pageControl.numberOfPages - 2 {
            moveControlsOffScreen()
            collectionView.isScrollEnabled = false
        }
        
        pageControl.currentPage += 1
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func shareResponse(withPopoverSourceView popoverSourceView: UIView?) {
        if let latestResponse = QuestionnaireResponse.loadResponses().last {
            Share.share(
                questionnaireResponse: latestResponse,
                inViewController: self,
                withPopoverSourceView: popoverSourceView,
                forMFMailComposeViewControllerDelegate: self,
                forMFMessageComposeViewControllerDelegate: self
            )
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true)
    }
    
    weak var homePageDelegate: HomePageControllerDelegate?
    
    func dismissQuestionnaire() {
        homePageDelegate?.refreshHistory()
        dismiss(animated: true)
    }
    
    func dismissQuestionnaireWithConfirmation() {
        let alertController = UIAlertController(title: "Close questionnaire?", message: "Your progress will not be saved.", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Close", style: .destructive, handler: { _ in
            self.dismissQuestionnaire()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.popoverPresentationController?.barButtonItem = closeItem
        present(alertController, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if resultCell != nil {
            resultCell?.ghostElements()
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let cell = collectionView.cellForItem(at: IndexPath(row: pageControl.currentPage, section: 0))
        if cell is ResultCell {
            (cell as! ResultCell).animateCountUpRiskScore()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let cell = collectionView.cellForItem(at: IndexPath(row: pageControl.currentPage, section: 0))
        if cell is ResultCell {
            (cell as! ResultCell).removeElementGhosting()
            (cell as! ResultCell).animateCountUpRiskScore()
        }
    }
    
    func showRangeQuestionTutorial() {
        UserDefaults.standard.rangeQuestionTutorialShown = true
        let cell = collectionView.cellForItem(at: IndexPath(row: pageControl.currentPage, section: 0))
        if cell is RangeQuestionCell {
            (cell as! RangeQuestionCell).rangeQuestionTutorialView.showRangeQuestionTutorial()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
        
        if pageNumber == pageControl.numberOfPages - 1 {
            moveControlsOffScreen()
            collectionView.isScrollEnabled = false
        }
        else {
            moveControlsOnScreen()
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer {
            let velocity = (gestureRecognizer as! UIPanGestureRecognizer).velocity(in: view)
            return fabs(velocity.y) > fabs(velocity.x);
        }
        return false
    }
    
    func handleVerticalPan(gesture: UIPanGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.ended {
            collectionView.reloadData()
            return
        }
        guard gesture.view is RangeQuestionCell else {
            return
        }
        
        let tolerance: CGFloat = 40
        let yTranslation = gesture.translation(in: view).y
        if tolerance < yTranslation {
            (gesture.view as! RangeQuestionCell).decrementOption()
            gesture.setTranslation(.zero, in: view)
        }
        else if yTranslation < -tolerance {
            (gesture.view as! RangeQuestionCell).incrementOption()
            gesture.setTranslation(.zero, in: view)
        }
    }
    
    func computeRiskScore() -> Int32 {
        var riskScore: Int32 = 0
        for questionnaireItem in questionnaireItems {
            if questionnaireItem is Question {
                let question = questionnaireItem as! Question
                riskScore += question.riskScoreContribution(question.selection)
            }
        }
        return riskScore
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionnaireItems.count
    }
    
    var resultCell: ResultCell?
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if questionnaireItems[indexPath.item] is Result {
            updateNavigationBarButtonItemsToDone()
            QuestionnaireResponse.saveResponse(forQuestionnaireItems: questionnaireItems)
            let result = questionnaireItems[indexPath.item] as! Result
            result.riskScore = computeRiskScore()
            let resultCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.result.rawValue, for: indexPath) as! ResultCell
            resultCell.result = result
            resultCell.delegate = self
            self.resultCell = resultCell
            return resultCell
        }
        if questionnaireItems[indexPath.item] is RangeQuestion {
            let questionCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.rangeQuestion.rawValue, for: indexPath) as! RangeQuestionCell
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleVerticalPan(gesture:)))
            panGestureRecognizer.delegate = self
            let question = smartSuggestions?.makeSmartSuggestion(forQuestion: questionnaireItems[indexPath.item] as! Question)
            questionCell.question = question as! RangeQuestion
            questionCell.delegate = self
            questionCell.addGestureRecognizer(panGestureRecognizer)
            return questionCell
        }
        if questionnaireItems[indexPath.item] is YesNoQuestion {
            let questionCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.yesNoQuestion.rawValue, for: indexPath) as! YesNoQuestionCell
            questionCell.question = questionnaireItems[indexPath.item] as! YesNoQuestion
            questionCell.delegate = self
            return questionCell
        }
        fatalError("Questionnaire item is not one of the supported types")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - self.navigationBar.frame.height)
    }
}
