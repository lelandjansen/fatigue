import UIKit

class YesNoQuestionCell: QuestionCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
                yesButton.isSelected = true
                noButton.isSelected = false
            case .no:
                yesButton.isSelected = false
                noButton.isSelected = true
            default:
                yesButton.isSelected = false
                noButton.isSelected = false
            }
            
            delegate?.setQuestionSelection(
                toValue: selection.rawValue,
                forCell: self
            )
        }
    }
    
    
    lazy var yesButton: UIButton = {
        let button = UIButton.createStyledSelectButton(withColor: .violet)
        button.setTitle(YesNoQuestion.Answer.yes.rawValue, for: .normal)
        button.addTarget(self, action: #selector(handleYes), for: .touchUpInside)
        return button
    }()
    
    lazy var noButton: UIButton = {
        let button = UIButton.createStyledSelectButton(withColor: .violet)
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
        
        yesButton.frame = CGRect(
            x: (self.frame.size.width - UIConstants.buttonWidth) / 2,
            y: (self.frame.size.height - UIConstants.navigationBarHeight - UIConstants.buttonHeight - UIConstants.buttonSpacing) / 2,
            width: UIConstants.buttonWidth,
            height: UIConstants.buttonHeight
        )
        
        noButton.frame = CGRect(
            x: (self.frame.size.width - UIConstants.buttonWidth) / 2,
            y: (self.frame.size.height - UIConstants.navigationBarHeight + UIConstants.buttonHeight + UIConstants.buttonSpacing) / 2 ,
            width: UIConstants.buttonWidth,
            height: UIConstants.buttonHeight
        )
    }
}
