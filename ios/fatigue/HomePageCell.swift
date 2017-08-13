import UIKit

class HomePageCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    weak var delegate: HomePageControllerDelegate?
    
    let logoImage: UIImageView = {
        return UIImageView(image: #imageLiteral(resourceName: "iagsa-logo-full-dark"))
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
    
    let beginButton: UIButton = {
        let button = UIButton.createStyledButton(withColor: .violet)
        button.setTitle("Begin", for: .normal)
        return button
    }()
    
    let settingsButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: UIFontWeightSemibold)
        button.setTitleColor(.medium, for: .normal)
        button.setTitleColor(UIColor.medium.withAlphaComponent(1/2), for: .highlighted)
        button.setTitle("Settings", for: .normal)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupViews() {
        addSubview(logoImage)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(beginButton)
        addSubview(settingsButton)
        
        let padding: CGFloat = 16
        logoImage.anchorWithConstantsToTop(
            nil,
            left: leftAnchor,
            bottom: topAnchor,
            right: rightAnchor,
            leftConstant: (self.frame.width - logoImage.frame.width) / 2,
            bottomConstant: padding,
            rightConstant: (self.frame.width - logoImage.frame.width) / 2
        )
        
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
        
        beginButton.frame = CGRect(
            x: (self.frame.size.width - UIConstants.buttonWidth) / 2,
            y: (self.frame.size.height + UIConstants.tableViewRowHeight + UIConstants.navigationBarHeight - UIConstants.buttonHeight - UIConstants.buttonSpacing + 38) / 2,
            width: UIConstants.buttonWidth,
            height: UIConstants.buttonHeight
        )
        beginButton.addTarget(self, action: #selector(handleBeginButton), for: .touchUpInside)
        settingsButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        settingsButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: UIConstants.tableViewRowHeight + UIConstants.buttonHeight + UIConstants.buttonSpacing).isActive = true
        settingsButton.addTarget(self, action: #selector(handleSettingsButton), for: .touchUpInside)
    }
    
    func handleBeginButton() {
        delegate?.presentQuestionnaire()
    }
    
    func handleSettingsButton() {
        delegate?.presentSettings()
    }
}
