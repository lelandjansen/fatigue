import UIKit

class QuestionnaireController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    enum CellId: String {
        case question
        case results
    }
    
    let questions: [Question] = {
        return [
            Question(
                question: "How long have you slept in the past 24 hours?",
                details: String(),
                options: (0...12).map{String($0)} + ["> 12"]
            ),
            Question(
                question: "How long have you slept in the past 48 hours?",
                details: String(),
                options: (0...24).map{String($0)} + ["> 24"]
            ),
            Question(
                question: "How many hours will you be awake after the aircraft is shut down?",
                details: String(),
                options: (0...16).map{String($0)} + ["> 16"]
            ),
            Question(
                question: "Through how many time zones have you traveled in the past 3 days?",
                details: String(),
                options: (0...(14-(-12))).map{String($0)}
            ),
            Question(
                question: "Are you flying with another pilot?",
                details: String(),
                options: ["Yes", "No"]
            ),
            Question(
                question: "How many hours will you be flying today?", // you and your copilot?
                details: String(),
                options: (0...12).map{String($0)} + ["> 12"]
            ),
            Question(
                question: "Have you experienced elevated stress recently?",
                details: "Home life, client pressure, team dynamic, etc.",
                options: ["Yes", "No"]
            ),
            Question(
                question: "Have you been on tour for more than 75% of your planned deployment?",
                details: String(),
                options: ["Yes", "No"]
            ),
            Question(
                question: "Are you ill?",
                details: "Cold, headache, flu, etc.",
                options: ["Yes", "No"]
            )
        ]
    }()
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .blue
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = self.questions.count + 1
        pc.pageIndicatorTintColor = UIColor(white: 2/3, alpha: 1/2)
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
        collectionView.register(QuestionCell.self, forCellWithReuseIdentifier: CellId.question.rawValue)
        collectionView.register(ResultsCell .self, forCellWithReuseIdentifier: CellId.results.rawValue)
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
            let resultsCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.results.rawValue, for: indexPath) as! ResultsCell
            resultsCell.results = Results(withRiskScore: 12, forCareer: .pilot)
            return resultsCell
        }
        
        let questionCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.question.rawValue, for: indexPath) as! QuestionCell
        
        let question = questions[indexPath.item]
        questionCell.question = question
        return questionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
}
