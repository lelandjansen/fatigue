import UIKit

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
        delegate?.updateQuestionnaireOrder()
        delegate?.moveToNextPage()
    }
    
    func handleNo() {
        selection = .no
        delegate?.updateQuestionnaireOrder()
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
