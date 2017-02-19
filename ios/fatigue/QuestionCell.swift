import UIKit

class QuestionCell: UICollectionViewCell {
    
    var question: Question? {
        didSet {
            guard let question = question else {
                return
            }
            
            let textColor: UIColor = .white
            
            let attributedText = NSMutableAttributedString(
                string: question.question,
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 24, weight: UIFontWeightRegular),
                    NSForegroundColorAttributeName: textColor
                ]
            )
            
            if !question.details.isEmpty {
                attributedText.append(
                    NSAttributedString(
                        string: "\n\(question.details)",
                        attributes: [
                            NSFontAttributeName: UIFont.systemFont(ofSize: 17),
                            NSForegroundColorAttributeName: textColor
                        ]
                    )
                )
            }
            
            let length = attributedText.string.characters.count
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            attributedText.addAttribute(
                NSParagraphStyleAttributeName,
                value: paragraphStyle,
                range: NSRange(location: 0, length: length)
            )
            
            textView.attributedText = attributedText
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    
        
    let textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.backgroundColor = .clear
        return tv
    }()
    
    
    
    func setupViews() {
        addSubview(textView)
        
        textView.anchorWithConstantsToTop(
            topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            topConstant: 64,
            leftConstant: 16,
            rightConstant: 16
        )
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
