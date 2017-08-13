import UIKit

class QuestionCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    weak var delegate: QuestionnaireDelegate?
    
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
        label.font = .systemFont(ofSize: 22)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .dark
        return label
    }()
    
    let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .medium
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
            topConstant: 10,
            leftConstant: sidePadding,
            rightConstant: sidePadding
        )
        detailsLabel.anchorWithConstantsToTop(
            questionLabel.bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            topConstant: 19,
            leftConstant: sidePadding,
            rightConstant: sidePadding
        )
    }
}



