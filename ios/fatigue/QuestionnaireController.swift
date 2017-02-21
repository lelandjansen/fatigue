import UIKit

class QuestionnaireController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    enum CellId: String {
        case rangeQuestion, yesNoQuestion, result
    }
    
    var questions: [Question] {
        get {
            return Questions().questions
        }
    }
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(colorLiteralRed: 91/255, green: 151/255, blue: 184/255, alpha: 1)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = self.questions.count + 1
        pc.pageIndicatorTintColor = UIColor(white: 1, alpha: 1/2)
        pc.currentPageIndicatorTintColor = .white
        return pc
    }()
    
    
    
    var pageControlBottomAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        
        collectionView.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
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
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
        
        (pageNumber == questions.count) ? moveControlsOffScreen() : moveControlsOnScreen()
    }
    
    
    
    fileprivate func moveControlsOffScreen() {
        pageControlBottomAnchor?.constant = 40
        
        UIView.animate(
            withDuration: 1/2,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: { self.view.layoutIfNeeded() },
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
            animations: { self.view.layoutIfNeeded() },
            completion: nil
        )
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questions.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == questions.count {
            let resultsCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.result.rawValue, for: indexPath) as! ResultCell
            resultsCell.result = Result(withRiskScore: 12)
            return resultsCell
        }
        
        if questions[indexPath.item] is RangeQuestion {
            let questionCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.rangeQuestion.rawValue, for: indexPath) as! RangeQuestionCell
            questionCell.question = questions[indexPath.item]
            return questionCell
        }
        
        if questions[indexPath.item] is YesNoQuestion {
            let questionCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.yesNoQuestion.rawValue, for: indexPath) as! YesNoQuestionCell
            questionCell.question = questions[indexPath.item]
            return questionCell
        }
        
        return UICollectionViewCell() // TODO: Raise error instead of returning blank cell?
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
}
