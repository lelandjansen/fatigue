import UIKit

class ResultsCell: UICollectionViewCell {
    
    var results: Results? {
        didSet {
            guard let results = results else {
                return
            }
            
            let textColor: UIColor = .white
            
            let attributedText = NSMutableAttributedString(
                string: "Risk Score",
                attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 24, weight: UIFontWeightMedium),
                    NSForegroundColorAttributeName: textColor
                ]
            )
            
            attributedText.append(
                NSAttributedString(
                    string: "\n\(results.riskScore)",
                    attributes: [
                        NSFontAttributeName: UIFont.systemFont(ofSize: 88),
                        NSForegroundColorAttributeName: textColor
                    ]
                )
            )
            
            attributedText.append(
                NSAttributedString(
                    string: "\n\(results.remark)",
                    attributes: [
                        NSFontAttributeName: UIFont.systemFont(ofSize: 17),
                        NSForegroundColorAttributeName: textColor
                    ]
                )
            )
            
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
