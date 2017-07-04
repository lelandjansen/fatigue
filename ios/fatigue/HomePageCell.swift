import UIKit

class HomePageCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: HomePageControllerDelegate?
    
    let logoImage: UIImageView = {
        return UIImageView(image: #imageLiteral(resourceName: "iagsa_logo"))
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
        label.textColor = .dark
        return label
    }()
    
    let beginQuestionnaireButton: UIButton = {
        let button = UIButton.createStyledButton(withColor: .violet)
        button.setTitle("Begin", for: .normal)
        return button
    }()
    
    let settingsButton: UIButton = {
        let button = UIButton.createStyledButton()
        button.setTitle("Settings", for: .normal)
        return button
    }()
    
    
    func setupViews() {
        addSubview(logoImage)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(beginQuestionnaireButton)
        addSubview(settingsButton)
        
        logoImage.anchorWithConstantsToTop(
            nil,
            left: leftAnchor,
            bottom: topAnchor,
            right: rightAnchor,
            leftConstant: (self.frame.width - logoImage.frame.width) / 2,
            bottomConstant: 16,
            rightConstant: (self.frame.width - logoImage.frame.width) / 2
        )
        
        let padding: CGFloat = 16
        titleLabel.anchorWithConstantsToTop(
            topAnchor,
            left: leftAnchor,
            right: rightAnchor,
            topConstant: 94,
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
        
        beginQuestionnaireButton.frame = CGRect(
            x: (self.frame.size.width - UIConstants.buttonWidth) / 2,
            y: (self.frame.size.height + UIConstants.tableViewRowHeight + UIConstants.navigationBarHeight - UIConstants.buttonHeight - UIConstants.buttonSpacing) / 2,
            width: UIConstants.buttonWidth,
            height: UIConstants.buttonHeight
        )
        beginQuestionnaireButton.addTarget(self, action: #selector(handleBeginButton), for: .touchUpInside)
        
        settingsButton.frame = CGRect(
            x: (self.frame.size.width - UIConstants.buttonWidth) / 2,
            y: (self.frame.size.height + UIConstants.tableViewRowHeight + UIConstants.navigationBarHeight + UIConstants.buttonHeight + UIConstants.buttonSpacing) / 2,
            width: UIConstants.buttonWidth,
            height: UIConstants.buttonHeight
        )
        settingsButton.addTarget(self, action: #selector(handleSettingsButton), for: .touchUpInside)
    }
    
    func handleBeginButton() {
        delegate?.presentQuestionnaire()
    }
    
    func handleSettingsButton() {
        delegate?.presentSettings()
    }
}
