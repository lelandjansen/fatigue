import Contacts
import UIKit

class OnboardingController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, OnboardingDelegate {
    override func viewDidLoad() {
        observeKeyboardNotifications()
        view.backgroundColor = .light
        setupViews()
        registerCells()
    }
    
    lazy var onboardingSequence: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
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
    
    var visibleCells: [CellId] = [
        .welcome,
        .legal,
    ]
    
    fileprivate func registerCells() {
        onboardingSequence.register(WelcomeCell.self, forCellWithReuseIdentifier: CellId.welcome.rawValue)
        onboardingSequence.register(LegalCell.self, forCellWithReuseIdentifier: CellId.legal.rawValue)
        onboardingSequence.register(OccupationCell.self, forCellWithReuseIdentifier: CellId.occupation.rawValue)
        onboardingSequence.register(ReminderCell.self, forCellWithReuseIdentifier: CellId.reminder.rawValue)
        onboardingSequence.register(ShareInformationCell.self, forCellWithReuseIdentifier: CellId.shareInformation.rawValue)
    }
    
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        UIView.animate(
            withDuration: 1/2,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: {
                self.view.frame = CGRect(x: 0, y: -76, width: self.view.frame.width, height: self.view.frame.height)
            }
        )
    }
    
    func keyboardWillHide() {
        UIView.animate(
            withDuration: 1/2,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: .curveEaseOut,
            animations: {
                self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            }
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch visibleCells[indexPath.row] {
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
        pageControl.numberOfPages = self.cells.count - 1
        return pageControl
    }()
    
    func setupViews() {
        view.addSubview(onboardingSequence)
        view.addSubview(pageControl)
        onboardingSequence.anchorToTop(
            view.topAnchor,
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
    
    func addNextPage() {
        let pageNumber = Int(onboardingSequence.contentOffset.x / view.frame.width)
        if visibleCells.count == pageNumber + 1 {
            visibleCells.append(cells[pageNumber + 1])
            onboardingSequence.reloadData()
        }
    }
    
    func moveToNextPage() {
        let pageNumber = Int(onboardingSequence.contentOffset.x / view.frame.width)
        if 0 == pageNumber {
            moveControlsOnScreen()
        }
        else {
            pageControl.currentPage += 1
        }
        let indexPath = IndexPath(item: pageNumber + 1, section: 0)
        onboardingSequence.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber - 1
        pageNumber == 0 ? moveControlsOffScreen() : moveControlsOnScreen()
    }
    
    func presentViewController(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }
    
    func alertNotificationsNotPermitted() {
        Notifications.alertNotificationsNotPermitted(inViewController: self)
    }

    func dismissOnboarding() {
        UserDefaults.standard.firstLaunch = false
        dismiss(animated: true)
    }
    
    func populate(nameTextFiled: UITextField, emailTextField: UITextField, phoneNumberTextField: UITextField, withContact contact: CNContact) {
        nameTextFiled.populateName(fromContact: contact, completion: {
            emailTextField.populateEmail(fromContact: contact, inTableViewController: self, withPopoverSourceView: emailTextField, completion: {
                phoneNumberTextField.populatePhoneNumber(fromContact: contact, inViewController: self, withPopoverSourceView: phoneNumberTextField)
            })
        })
    }
}
