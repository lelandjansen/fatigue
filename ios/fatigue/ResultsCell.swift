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
    
    let saveButton: FatigueButton = {
        let button = FatigueButton()
        button.setTitle("Save", for: .normal)
        return button
    }()
    
    let shareButton: FatigueButton = {
        let button = FatigueButton()
        button.setTitle("Share and save", for: .normal)
        return button
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
        addSubview(saveButton)
        addSubview(shareButton)
        
        let sidePadding: CGFloat = 16
        
        riskScoreTitleLabel.anchorWithConstantsToTop(
            topAnchor,
            left: leftAnchor,
            right: rightAnchor,
            topConstant: 64,
            leftConstant: sidePadding,
            rightConstant: sidePadding
        )
        
        riskScoreLabel.anchorWithConstantsToTop(
            riskScoreTitleLabel.bottomAnchor,
            left: leftAnchor,
            bottom: nil,
            right: rightAnchor,
            topConstant: 32
        )
        
        remarkLabel.anchorWithConstantsToTop(
            riskScoreLabel.bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            topConstant: 32,
            leftConstant: sidePadding,
            rightConstant: sidePadding
        )
        
        let buttonSpacing: CGFloat = 16
        
        shareButton.anchorWithConstantsToTop(
            nil,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            leftConstant: 80,
            bottomConstant: 80,
            rightConstant: 80
        )
        
        saveButton.anchorWithConstantsToTop(
            nil,
            left: leftAnchor,
            bottom: shareButton.topAnchor,
            right: rightAnchor,
            leftConstant: 80,
            bottomConstant: buttonSpacing,
            rightConstant: 80
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
