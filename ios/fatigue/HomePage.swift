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
            string: "Daily Fatigue",
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 24, weight: UIFontWeightSemibold)
            ]
        )
        
        attributedText.append(
            NSAttributedString(
                string: "\nSelf-Assessment",
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 24)
                ]
            )
        )
        
        let label = UILabel()
        label.attributedText = attributedText
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Safety in the air begins on the ground."
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    let beginQuestionnaireButton: FatigueButton = {
        let button = FatigueButton()
        button.setTitle("Begin questionnaire", for: .normal)
        button.addTarget(self, action: #selector(handleBeginQuestionnaireButton), for: .touchUpInside)
        return button
    }()
    
    let settingsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Settings", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor(white: 1, alpha: 1/2), for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
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
            topConstant: 64,
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
        
        // TODO: This is a hacky fix. Properly center button and other elements using AutoLayout.
        let buttonSize: CGFloat = 64
        beginQuestionnaireButton.anchorWithConstantsToTop(
            centerYAnchor,
            left: leftAnchor,
            bottom: centerYAnchor,
            right: rightAnchor,
            topConstant: -buttonSize/2,
            leftConstant: 80,
            bottomConstant: -buttonSize/2,
            rightConstant: 80
        )
        
        settingsButton.anchorToTop(
            beginQuestionnaireButton.bottomAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
    }
    
    func handleBeginQuestionnaireButton() {
        delegate?.presentQuestionnaire()
    }
    
    
}
