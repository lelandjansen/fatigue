import UIKit

class RangeQuestionCell: QuestionCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var options: [String] = [String()]
    
    var optionIndex: Int = 0 {
        didSet {
            optionLabel.text = options[optionIndex]
            delegate?.setQuestionSelection(
                toValue: options[optionIndex],
                forCell: self
            )
            
            updateUnitsLabelText()
        }
    }
    
    func updateUnitsLabelText() {
        if (question as! RangeQuestion).units == .hours {
            unitsLabel.text = options[optionIndex] == "1" ? "hr" : "hrs"
            setUnitsLabelLeftAnchor()
        }
        else {
            unitsLabel.text = String()
        }
    }
    
    override var question: Question? {
        didSet {
            guard let question = question, question is RangeQuestion else {
                return
            }
            
            options = question.options
            optionIndex = options.index(of: (question as! RangeQuestion).selection)!
            
            setupText(forQuestion: question)
        }
    }
    
    lazy var rangeQuestionTutorialView: RangeQuestionTutorialView = {
        return RangeQuestionTutorialView(frame: self.frame)
    }()
    
    let optionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 88, weight: UIFontWeightLight)
        label.textAlignment = .center
        label.textColor = .medium
        return label
    }()
    
    let unitsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: UIFontWeightRegular)
        label.textAlignment = .left
        label.textColor = .medium
        return label
    }()
    
    lazy var incrementButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(incrementOption), for: .touchUpInside)
        return button
    }()
    
    lazy var decrementButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(decrementOption), for: .touchUpInside)
        return button
    }()
    
    fileprivate func setUnitsLabelLeftAnchor() {
        let singleDigitConstant: CGFloat = 28
        let doubleDigitConstant: CGFloat = 52
        var option: Float = abs(Float(Int(options[optionIndex]) ?? 1))
        option = (option < 1 ? 1 : option)
        let digitCount: CGFloat = CGFloat(floor(logf(option, base: 10) + 1))
        let leftConstant: CGFloat = singleDigitConstant + (doubleDigitConstant - singleDigitConstant) * (digitCount - 1)
        
        if leftAnchorConstraint != nil {
            self.removeConstraint(leftAnchorConstraint!)
        }
        
        leftAnchorConstraint = unitsLabel.leftAnchor.constraint(
            equalTo: centerXAnchor,
            constant: leftConstant
        )
        leftAnchorConstraint?.isActive = true
    }
    
    override func setupText(forQuestion question: Question) {
        super.setupText(forQuestion: question)
        optionLabel.text = (question as! RangeQuestion).selection
        updateUnitsLabelText()
    }
    
    var leftAnchorConstraint: NSLayoutConstraint?
    
    override func setupViews() {
        super.setupViews()
        addSubview(rangeQuestionTutorialView)
        addSubview(optionLabel)
        addSubview(unitsLabel)
        addSubview(incrementButton)
        addSubview(decrementButton)

        rangeQuestionTutorialView.anchorToTop(
            topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
        
        optionLabel.anchorWithConstantsToTop(
            topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            bottomConstant: UIConstants.navigationBarHeight
        )
        
        unitsLabel.anchorWithConstantsToTop(
            nil,
            bottom: centerYAnchor,
            bottomConstant: UIConstants.navigationBarHeight - 70
        )

        setUnitsLabelLeftAnchor()
        
        incrementButton.anchorToTop(
            topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
        
        decrementButton.anchorToTop(
            centerYAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
    }
    
    func incrementOption() {
        if optionIndex < options.count - 1 {
            optionIndex += 1
        }
    }
    
    func decrementOption() {
        if 0 < optionIndex {
            optionIndex -= 1
        }
    }
}
