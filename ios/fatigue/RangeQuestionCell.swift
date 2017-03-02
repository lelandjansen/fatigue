import UIKit

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
