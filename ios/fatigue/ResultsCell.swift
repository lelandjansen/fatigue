import UIKit

class ResultCell: UICollectionViewCell {
    
    var result: Result? {
        didSet {
            guard let result = result else {
                return
            }
            
            remarkLabel.text = result.remark
        }
    }
    
    weak var delegate: QuestionnaireControllerDelegate?
    
    
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
    
    let releaseToViewScoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Release to view score."
        label.font = UIFont.systemFont(ofSize: 24)
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
    
    
    func setupViews() {
        addSubview(riskScoreTitleLabel)
        addSubview(releaseToViewScoreLabel)
        addSubview(riskScoreLabel)
        addSubview(remarkLabel)
        addSubview(saveButton)
        addSubview(shareButton)
        
        let sidePadding: CGFloat = 16
        
        riskScoreTitleLabel.text = "Risk Score"
        riskScoreTitleLabel.anchorWithConstantsToTop(
            topAnchor,
            left: leftAnchor,
            right: rightAnchor,
            topConstant: 64,
            leftConstant: sidePadding,
            rightConstant: sidePadding
        )
        
        releaseToViewScoreLabel.alpha = 0
        releaseToViewScoreLabel.anchorToTop(
            topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
        
        riskScoreLabel.text = String(describing: 0)
        riskScoreLabel.anchorWithConstantsToTop(
            riskScoreTitleLabel.bottomAnchor,
            left: leftAnchor,
            bottom: nil,
            right: rightAnchor,
            topConstant: 32
        )
        
        remarkLabel.alpha = 0
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
        shareButton.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
        
        saveButton.anchorWithConstantsToTop(
            nil,
            left: leftAnchor,
            bottom: shareButton.topAnchor,
            right: rightAnchor,
            leftConstant: 80,
            bottomConstant: buttonSpacing,
            rightConstant: 80
        )
        saveButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
    }
    
    
    
    func incrementRiskScore(forTimer timer: Timer) {
        let target = result!.riskScore
        let number = Int(riskScoreLabel.text!)!
        
        if number < target {
            riskScoreLabel.text = String(describing: number + 1)
        }
        else {
            timer.invalidate()
            animatePresentRemark()
        }
    }
    
    
    func animateCountUpRiskScore() {
        let timeInterval: TimeInterval = min(1.0/10.0, 1.0/Double(result!.riskScore))
        
        Timer.scheduledTimer(
            timeInterval: timeInterval,
            target: self,
            selector: #selector(incrementRiskScore(forTimer:)),
            userInfo: nil,
            repeats: true
        ).fire()
        
        
    }

    
    func animatePresentRemark() {
        UIView.animate(
            withDuration: 1/4,
            animations: {
                self.presentRemark()
            }
        )
    }
    
    func presentRemark() {
        remarkLabel.alpha = 1
    }
    
    func animateRemoveElementGhosting() {
        UIView.animate(
            withDuration: 1/4,
            animations: {
                self.removeElementGhosting()
            }
        )
    }
    
    func removeElementGhosting() {
        riskScoreTitleLabel.alpha = 1
        riskScoreLabel.alpha = 1
        releaseToViewScoreLabel.alpha = 0
        saveButton.alpha = 1
        shareButton.alpha = 1
    }
    
    func ghostElements() {
        let ghostAlpha: CGFloat = 1/2
        riskScoreTitleLabel.alpha = ghostAlpha
        riskScoreLabel.alpha = 0
        releaseToViewScoreLabel.alpha = 1
        saveButton.alpha = ghostAlpha
        shareButton.alpha = ghostAlpha
    }
    
    
    func handleSave() {
        delegate?.goToHomePage()
    }
    
    func handleShare() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
