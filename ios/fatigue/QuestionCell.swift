import UIKit

class QuestionCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    
    weak var delegate: QuestionnaireControllerDelegate?
    
    
    var question: Question? {
        didSet {
            guard let question = question else {
                return
            }
            
            setupText(forQuestion: question)
        }
    }
    
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    
    func setupText(forQuestion question: Question) {
        questionLabel.text = question.question
        detailsLabel.text = question.details
    }
    
    
    func setupViews() {
        addSubview(questionLabel)
        addSubview(detailsLabel)
        
        let sidePadding: CGFloat = 16
        
        questionLabel.anchorWithConstantsToTop(
            topAnchor,
            left: leftAnchor,
            right: rightAnchor,
            topConstant: 64,
            leftConstant: sidePadding,
            rightConstant: sidePadding
        )
        
        detailsLabel.anchorWithConstantsToTop(
            questionLabel.bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            topConstant: 16,
            leftConstant: sidePadding,
            rightConstant: sidePadding
        )
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class RangeQuestionCell : QuestionCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    
    var options: [String] = [String()]
    
    
    var optionIndex: Int = 0 {
        didSet {
            optionLabel.text = options[optionIndex]
            delegate?.setQuestionSelection(
                toValue: options[optionIndex],
                forCell: self
            )
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
    
    
    let optionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 88, weight: UIFontWeightLight)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    lazy var incrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(incrementOption), for: .touchUpInside)
        return button
    }()
    
    lazy var decrementButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(decrementOption), for: .touchUpInside)
        return button
    }()
    
    
    override func setupText(forQuestion question: Question) {
        super.setupText(forQuestion: question)
        
        optionLabel.text = (question as! RangeQuestion).selection
    }
    
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(optionLabel)
        addSubview(incrementButton)
        addSubview(decrementButton)
        
        optionLabel.anchorToTop(
            topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
        
        incrementButton.anchorToTop(
            topAnchor,
            left: leftAnchor,
            bottom: centerYAnchor,
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
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class YesNoQuestionCell : QuestionCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    
    override var question: Question? {
        didSet {
            guard let question = question, question is YesNoQuestion else {
                return
            }
            
            switch question.selection {
            case YesNoQuestion.Answer.yes.rawValue:
                selection = YesNoQuestion.Answer.yes
            case YesNoQuestion.Answer.no.rawValue:
                selection = YesNoQuestion.Answer.no
            default:
                selection = YesNoQuestion.Answer.none
            }
        }
    }
    
    
    var selection: YesNoQuestion.Answer = .none {
        didSet {
            switch selection {
            case .yes:
                selectYes()
                deselectNo()
            case .no:
                deselectYes()
                selectNo()
            default:
                deselectYes()
                deselectNo()
            }
            
            delegate?.setQuestionSelection(
                toValue: selection.rawValue,
                forCell: self
            )
        }
    }
    
    
    func selectYes() {
        yesButton.isSelected = true
        yesButton.backgroundColor = UIColor(white: 1, alpha: 3/20)
    }
    
    func deselectYes() {
        yesButton.isSelected = false
        yesButton.backgroundColor = .clear
    }
    
    func selectNo() {
        noButton.isSelected = true
        noButton.backgroundColor = UIColor(white: 1, alpha: 3/20)
    }
    
    func deselectNo() {
        noButton.isSelected = false
        noButton.backgroundColor = .clear
    }
    
    
    lazy var yesButton: FatigueButton = {
        let button = FatigueButton(type: .custom)
        button.setTitle(YesNoQuestion.Answer.yes.rawValue, for: .normal)
        button.addTarget(self, action: #selector(handleYes), for: .touchUpInside)
        return button
    }()
    
    lazy var noButton: FatigueButton = {
        let button = FatigueButton(type: .custom)
        button.setTitle(YesNoQuestion.Answer.no.rawValue, for: .normal)
        button.addTarget(self, action: #selector(handleNo), for: .touchUpInside)
        return button
    }()
    
    
    func handleYes() {
        selection = .yes
        delegate?.moveToNextPage()
    }
    
    func handleNo() {
        selection = .no
        delegate?.moveToNextPage()
    }
    
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(yesButton)
        addSubview(noButton)
        
        let buttonSpacing: CGFloat = 16
        
        yesButton.anchorWithConstantsToTop(
            nil,
            left: leftAnchor,
            bottom: centerYAnchor,
            right: rightAnchor,
            leftConstant: 80,
            bottomConstant: buttonSpacing/2,
            rightConstant: 80
        )
        
        noButton.anchorWithConstantsToTop(
            centerYAnchor,
            left: leftAnchor,
            right: rightAnchor,
            topConstant: buttonSpacing/2,
            leftConstant: 80,
            rightConstant: 80
        )
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
