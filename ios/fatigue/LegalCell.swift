import UIKit

class LegalCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: OnboardingDelegate?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "A few formalities before we begin"
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
        view.textColor = .dark
        view.backgroundColor = .clear
        view.textAlignment = .justified
        return view
    }()
    
    let agreeButton: UIButton = {
        let button = UIButton.createStyledButton(withColor: .violet)
        button.setTitle("I agree", for: .normal)
        return button
    }()
    
    func handleAgreeButton() {
        let alertController = UIAlertController(title: "Confirmation", message: String(), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Agree", style: .default, handler: { _ in
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
