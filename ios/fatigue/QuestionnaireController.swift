import UIKit


class QuestionnaireController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, QuestionnaireControllerDelegate {

    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        updateQuestionnaireOrder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    enum CellId: String {
        case rangeQuestion, yesNoQuestion, result
    }
    
    
    var questionnaireItems: [QuestionnaireItem] = [Questionnaire().questionnaireTreeRoot]
    
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
    
    
    lazy var navigationBar: UINavigationBar = {
        let navigationBar: UINavigationBar = UINavigationBar(
            frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: UIConstants.navigationBarHeight)
        )
        navigationBar.barTintColor = .light
        navigationBar.isTranslucent = false
        navigationBar.tintColor = .medium
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.dark]
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        let navigationItem = UINavigationItem(title: "Questionnaire")
        let closeItem = UIBarButtonItem(
            title: "Close",
            style: UIBarButtonItemStyle.plain,
            target: nil,
            action: #selector(dismissQuestionnaire)
        )
        navigationItem.leftBarButtonItem = closeItem
        navigationBar.setItems([navigationItem], animated: false)
        return navigationBar
    }()
    
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = UIColor.dark.withAlphaComponent(2 / 5)
        pageControl.currentPageIndicatorTintColor = .dark
        pageControl.defersCurrentPageDisplay = true
        return pageControl
    }()
    
    
    var pageControlBottomAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            topConstant: 0,
            leftConstant: 0,
            bottomConstant: 0,
            rightConstant: 0,
            widthConstant: 0,
            heightConstant: 32
        )[1]
        
        registerCells()
    }
    
    
    fileprivate func registerCells() {
        collectionView.register(RangeQuestionCell.self, forCellWithReuseIdentifier: CellId.rangeQuestion.rawValue)
        collectionView.register(YesNoQuestionCell.self, forCellWithReuseIdentifier: CellId.yesNoQuestion.rawValue)
        collectionView.register(ResultCell .self, forCellWithReuseIdentifier: CellId.result.rawValue)
    }
    
    
    fileprivate func moveControlsOffScreen() {
        self.pageControlBottomAnchor?.constant = 40
        
        UIView.animate(
            withDuration: 1/2,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: nil
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
            },
            completion: nil
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
    
    
    func dismissQuestionnaire() {
        dismiss(animated: true, completion: nil)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if resultCell != nil {
            resultCell?.ghostElements()
        }
    }
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let indexPath = collectionView.indexPath(for: collectionView.visibleCells.first!)
        let cell = collectionView.cellForItem(at: indexPath!)
        
        if cell is ResultCell {
            (cell as! ResultCell).animateCountUpRiskScore()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let indexPath = collectionView.indexPath(for: collectionView.visibleCells.first!)
        let cell = collectionView.cellForItem(at: indexPath!)
        
        if cell is ResultCell {
            (cell as! ResultCell).removeElementGhosting()
            (cell as! ResultCell).animateCountUpRiskScore()
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
    
    
    func computeRiskScore() -> Int {
        var riskScore = 0
        
        for question in questionnaireItems {
            if question is Question {
                let selection = (question as! Question).selection
                riskScore += (question as! Question).riskScoreContribution(selection)
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
            
            questionCell.question = questionnaireItems[indexPath.item] as! RangeQuestion
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
