import UIKit

class WelcomeCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    weak var delegate: OnboardingDelegate?
    
    let backgroundImage: UIImageView = {
        return UIImageView(image: #imageLiteral(resourceName: "onboarding-background"))
    }()
    
    let titleLabel: UILabel = {
        let attributedText = NSMutableAttributedString(
            string: "Fatigue Self-Assessment",
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 22, weight: UIFontWeightSemibold)
            ]
        )

        let label = UILabel()
        label.attributedText = attributedText
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .dark
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Safety in the air begins on the ground."
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .medium
        return label
    }()
    
    let getStartedButton: UIButton = {
        let button = UIButton.createStyledButton(withColor: .violet)
        button.setTitle("Get started", for: .normal)
        return button
    }()
    
    let foregroundCloud: UIImageView = {
        return UIImageView(image: #imageLiteral(resourceName: "foreground-cloud"))
    }()
    
    func handleGetStartedButton() {
        delegate?.moveToNextPage()
    }
    
    func setupViews() {
        addSubview(backgroundImage)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(getStartedButton)
        addSubview(foregroundCloud)
        getStartedButton.addTarget(self, action: #selector(handleGetStartedButton), for: .touchUpInside)
        
        let aspectRatio = backgroundImage.image!.size.width / backgroundImage.image!.size.height
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        backgroundImage.widthAnchor.constraint(equalTo: heightAnchor, multiplier: aspectRatio).isActive = true
        backgroundImage.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        backgroundImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        let padding: CGFloat = 16
        titleLabel.anchorWithConstantsToTop(
            topAnchor,
            left: leftAnchor,
            right: rightAnchor,
            topConstant: 96,
            leftConstant: padding,
            rightConstant: padding
        )
        
        subtitleLabel.anchorWithConstantsToTop(
            titleLabel.bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            topConstant: padding,
            leftConstant: padding,
            rightConstant: padding
        )
        
        getStartedButton.anchorWithConstantsToTop(
            topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            topConstant: (frame.height - UIConstants.buttonHeight) / 2,
            leftConstant: (frame.width - UIConstants.buttonWidth) / 2,
            bottomConstant: (frame.height - UIConstants.buttonHeight) / 2,
            rightConstant: (frame.width - UIConstants.buttonWidth) / 2
        )

        foregroundCloud.anchorWithConstantsToTop(
            getStartedButton.bottomAnchor,
            left: getStartedButton.rightAnchor,
            topConstant: -31.5,
            leftConstant: -44
        )
    }
}
