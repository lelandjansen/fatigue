import UIKit

class ResultCell: UICollectionViewCell {
    
    var result: Result? {
        didSet {
            guard let result = result else {
                return
            }
            
            setupText(forResult: result)
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    
    let riskScoreTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFontWeightSemibold)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    let riskScoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 88, weight: UIFontWeightLight)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let remarkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    
    func setupText(forResult result: Result) {
        riskScoreTitleLabel.text = "Risk Score"
        riskScoreLabel.text = String(result.riskScore)
        remarkLabel.text = result.remark
    }
    
    
    func setupViews() {
        addSubview(riskScoreTitleLabel)
        addSubview(riskScoreLabel)
        addSubview(remarkLabel)
        
        let sidePadding: CGFloat = 16
        
        riskScoreTitleLabel.anchorWithConstantsToTop(
            topAnchor,
            left: leftAnchor,
            right: rightAnchor,
            topConstant: 64,
            leftConstant: sidePadding,
            rightConstant: sidePadding
        )
        
        riskScoreLabel.anchorToTop(
            topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
        
        remarkLabel.anchorWithConstantsToTop(
            riskScoreTitleLabel.bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            topConstant: 45,
            leftConstant: sidePadding,
            rightConstant: sidePadding
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
