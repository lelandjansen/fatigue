import UIKit

class OccupationCell: UICollectionViewCell {
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
        label.text = "What is your occupation?"
        label.font = .systemFont(ofSize: 22)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .dark
        return label
    }()
    
    lazy var pilotButton: UIButton = {
        let button = UIButton.createStyledSelectButton(withColor: .violet)
        button.setTitle(Occupation.pilot.rawValue.capitalized, for: .normal)
        button.addTarget(self, action: #selector(handlePilotButton), for: .touchUpInside)
        return button
    }()
    
    lazy var engineerButton: UIButton = {
        let button = UIButton.createStyledSelectButton(withColor: .violet)
        button.setTitle(Occupation.engineer.rawValue.capitalized, for: .normal)
        button.addTarget(self, action: #selector(handleEngineerButton), for: .touchUpInside)
        return button
    }()
    
    var selection: Occupation = .none {
        didSet {
            switch selection {
            case .pilot:
                pilotButton.isSelected = true
                engineerButton.isSelected = false
            case .engineer:
                pilotButton.isSelected = false
                engineerButton.isSelected = true
            default:
                pilotButton.isSelected = false
                engineerButton.isSelected = false
            }
            UserDefaults.standard.occupation = selection
        }
    }
    
    func handlePilotButton() {
        selection = .pilot
        delegate?.addNextPage()
        delegate?.moveToNextPage()
    }
    
    func handleEngineerButton() {
        selection = .engineer
        delegate?.addNextPage()
        delegate?.moveToNextPage()
    }
    
    func setupViews() {
        addSubview(titleLabel)
        addSubview(pilotButton)
        addSubview(engineerButton)
        let padding: CGFloat = 16
        titleLabel.anchorWithConstantsToTop(
            topAnchor,
            left: leftAnchor,
            right: rightAnchor,
            topConstant: 3 * padding,
            leftConstant: padding,
            rightConstant: padding
        )
        pilotButton.anchorWithConstantsToTop(
            topAnchor,
            left: leftAnchor,
            bottom: centerYAnchor,
            right: rightAnchor,
            topConstant: (frame.height - UIConstants.buttonSpacing) / 2 - UIConstants.buttonHeight,
            leftConstant: (frame.width - UIConstants.buttonWidth) / 2,
            bottomConstant: UIConstants.buttonSpacing / 2,
            rightConstant: (frame.width - UIConstants.buttonWidth) / 2
        )
        engineerButton.anchorWithConstantsToTop(
            centerYAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            topConstant: UIConstants.buttonSpacing / 2,
            leftConstant: (frame.width - UIConstants.buttonWidth) / 2,
            bottomConstant: (frame.height - UIConstants.buttonSpacing) / 2 - UIConstants.buttonHeight,
            rightConstant: (frame.width - UIConstants.buttonWidth) / 2
        )
    }
}
