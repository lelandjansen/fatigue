import UIKit

class LegalCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    weak var delegate: OnboardingDelegate?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "A few formalities"
        label.font = .systemFont(ofSize: 22)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .dark
        return label
    }()
    
    let legalTextView: UITextView = {
        let view = UITextView()
        if let path = Bundle.main.path(forResource: "LEGAL", ofType: String()) {
            let fileManager = FileManager()
            let contents = fileManager.contents(atPath: path)
            let fileText = NSString(data: contents!, encoding: String.Encoding.utf8.rawValue)! as String
            view.text = fileText.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        view.isEditable = false
        view.font = .systemFont(ofSize: 14)
        view.textColor = .dark
        view.backgroundColor = .clear
        view.textAlignment = .justified
        return view
    }()
    
    let agreeButton: UIButton = {
        let button = UIButton.createStyledSelectButton(withColor: .violet)
        button.setTitle("I agree", for: .normal)
        return button
    }()
    
    func handleAgreeButton() {
        if self.agreeButton.isSelected {
            self.delegate?.moveToNextPage()
            return
        }
        let alertController = UIAlertController(title: "Confirmation", message: String(), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "I agree", style: .default, handler: { _ in
            self.agreeButton.isSelected = true
            self.delegate?.addNextPage()
            self.delegate?.moveToNextPage()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        delegate?.presentViewController(alertController)
    }
    
    func setupViews() {
        addSubview(titleLabel)
        addSubview(agreeButton)
        addSubview(legalTextView)
        let padding: CGFloat = 16
        titleLabel.anchorWithConstantsToTop(
            topAnchor,
            left: leftAnchor,
            right: rightAnchor,
            topConstant: 3 * padding,
            leftConstant: padding,
            rightConstant: padding
        )
        let buttonBottomPadding: CGFloat = 2 * padding
        agreeButton.anchorWithConstantsToTop(
            topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            topConstant: frame.height - UIConstants.buttonHeight - buttonBottomPadding,
            leftConstant: (frame.width - UIConstants.buttonWidth) / 2,
            bottomConstant: buttonBottomPadding,
            rightConstant: (frame.width - UIConstants.buttonWidth) / 2
        )
        agreeButton.addTarget(self, action: #selector(handleAgreeButton), for: .touchUpInside)
        legalTextView.anchorWithConstantsToTop(
            titleLabel.bottomAnchor,
            left: leftAnchor,
            bottom: agreeButton.topAnchor,
            right: rightAnchor,
            topConstant: padding,
            leftConstant: padding / 2,
            bottomConstant: padding,
            rightConstant: padding / 2
        )
    }
}
