import UIKit

class OnboardingController: UICollectionViewController, UICollectionViewDelegateFlowLayout, OnboardingDelegate {
    override func viewDidLoad() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView?.collectionViewLayout = layout
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.backgroundColor = .light
        setupViews()
        registerCells()
    }
    
    enum CellId: String {
        case welcome, legal, occupation, reminder, shareInformation
    }
    
    let cells: [CellId] = [
        .welcome,
        .legal,
        .occupation,
        .reminder,
        .shareInformation,
    ]
    
    fileprivate func registerCells() {
        collectionView?.register(WelcomeCell.self, forCellWithReuseIdentifier: CellId.welcome.rawValue)
        collectionView?.register(LegalCell.self, forCellWithReuseIdentifier: CellId.legal.rawValue)
        collectionView?.register(OccupationCell.self, forCellWithReuseIdentifier: CellId.occupation.rawValue)
        collectionView?.register(ReminderCell.self, forCellWithReuseIdentifier: CellId.reminder.rawValue)
        collectionView?.register(ShareInformationCell.self, forCellWithReuseIdentifier: CellId.shareInformation.rawValue)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch cells[indexPath.row] {
        case .welcome:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.welcome.rawValue, for: indexPath) as! WelcomeCell
            cell.delegate = self
            return cell
        case .legal:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.legal.rawValue, for: indexPath) as! LegalCell
            cell.delegate = self
            return cell
        case .occupation:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.occupation.rawValue, for: indexPath) as! OccupationCell
            cell.delegate = self
            return cell
        case .reminder:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.reminder.rawValue, for: indexPath) as! ReminderCell
            cell.delegate = self
            return cell
        case .shareInformation:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId.shareInformation.rawValue, for: indexPath) as! ShareInformationCell
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    var pageControlBottomAnchor: NSLayoutConstraint?
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = UIColor.dark.withAlphaComponent(2 / 5)
        pageControl.currentPageIndicatorTintColor = .dark
        pageControl.defersCurrentPageDisplay = true
        pageControl.numberOfPages = self.cells.count
        return pageControl
    }()
    
    func setupViews() {
        view.addSubview(pageControl)
        pageControlBottomAnchor = pageControl.anchor(
            nil,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor,
            heightConstant: 32
        )[1]
        pageControlBottomAnchor?.constant = pageControlOffScreenPosition
    }
    
    fileprivate let pageControlOffScreenPosition: CGFloat = 40
    fileprivate func moveControlsOffScreen() {
        pageControlBottomAnchor?.constant = pageControlOffScreenPosition
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
    
    func moveToNextPage() {
        if pageControl.currentPage == pageControl.numberOfPages - 1 {
            return
        }
        if 0 == pageControl.currentPage {
            moveControlsOnScreen()
        }
        else if pageControl.currentPage == pageControl.numberOfPages - 2 {
            moveControlsOffScreen()
        }
        pageControl.currentPage += 1
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
        pageNumber == 0 || pageNumber == pageControl.numberOfPages - 1 ? moveControlsOffScreen() : moveControlsOnScreen()
    }
}
