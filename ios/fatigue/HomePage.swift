import UIKit

class HomePage: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: HomePageControllerDelegate?
    
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
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .dark
        return label
    }()
    
    let beginQuestionnaireButton: UIButton = {
        let button = UIButton.createStyledButton(withColor: .blue)
        button.setTitle("Begin", for: .normal)
        button.addTarget(self, action: #selector(handleBeginQuestionnaireButton), for: .touchUpInside)
        return button
    }()
    
    let settingsButton: UIButton = {
        let button = UIButton.createStyledButton()
        button.setTitle("Settings", for: .normal)
        return button
    }()
    
    
    func setupViews() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(beginQuestionnaireButton)
        addSubview(settingsButton)
        
        let sidePadding: CGFloat = 16
        
        titleLabel.anchorWithConstantsToTop(
            topAnchor,
            left: leftAnchor,
            right: rightAnchor,
            topConstant: 94,
            leftConstant: sidePadding,
            rightConstant: sidePadding
        )
        
        subtitleLabel.anchorWithConstantsToTop(
            titleLabel.bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            topConstant: 16,
            leftConstant: sidePadding,
            rightConstant: sidePadding
        )
        
        beginQuestionnaireButton.frame = CGRect(
            x: (self.frame.size.width - UIConstants.buttonWidth) / 2,
            y: (self.frame.size.height - UIConstants.buttonHeight - UIConstants.buttonSpacing) / 2,
            width: UIConstants.buttonWidth,
            height: UIConstants.buttonHeight
        )
        
        settingsButton.frame = CGRect(
            x: (self.frame.size.width - UIConstants.buttonWidth) / 2,
            y: (self.frame.size.height + UIConstants.buttonHeight + UIConstants.buttonSpacing) / 2,
            width: UIConstants.buttonWidth,
            height: UIConstants.buttonHeight
        )
        
    }
    
    func handleBeginQuestionnaireButton() {
        delegate?.presentQuestionnaire()
    }
    
    
}
