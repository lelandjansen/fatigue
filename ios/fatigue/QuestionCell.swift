import UIKit

class QuestionCell: UICollectionViewCell {
    
    var question: Question? {
        didSet {
            guard let question = question else {
                return
            }
    
            setupText(forQuestion: question)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
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
            topConstant: 4,
            leftConstant: sidePadding,
            rightConstant: sidePadding
        )
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



class RangeQuestionCell : QuestionCell {
    
    var options: [String] = [String()]
    
    var optionIndex: Int = 0
    
    override var question: Question? {
        didSet {
            guard let question = question, question is RangeQuestion else {
                return
            }
            
            options = question.options
            optionIndex = options.index(of: (question as! RangeQuestion).defaultOption)!
            
            setupText(forQuestion: question)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
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
        
        optionLabel.text = (question as! RangeQuestion).defaultOption
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
            optionLabel.text = options[optionIndex]
        }
    }
    
    
    func decrementOption() {
        if 0 < optionIndex {
            optionIndex -= 1
            optionLabel.text = options[optionIndex]
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
    
    
    let yesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(YesNoQuestion.Answer.yes.rawValue, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 24)
//        button.addTarget(self, action: #selector(...), for: .touchUpInside)
        return button
    }()
    
    
    let noButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(YesNoQuestion.Answer.no.rawValue, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 24)
//        button.addTarget(self, action: #selector(...), for: .touchUpInside)
        return button
    }()
    
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(yesButton)
        addSubview(noButton)
        
        yesButton.anchorToTop(
            nil,
            left: leftAnchor,
            bottom: centerYAnchor,
            right: rightAnchor
        )
        
        noButton.anchorToTop(
            centerYAnchor,
            left: leftAnchor,
            right: rightAnchor
        )
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
