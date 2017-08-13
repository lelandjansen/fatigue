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
    
    weak var delegate: QuestionnaireDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private static let circleRadius = UIConstants.buttonWidth * 3 / 8
    
    let riskScoreTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: UIFontWeightSemibold)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .dark
        return label
    }()
    
    let riskScoreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 88, weight: UIFontWeightLight)
        label.textAlignment = .center
        label.textColor = .light
        label.bounds = CGRect(x: 0, y: 0, width: circleRadius, height: circleRadius)
        label.layer.cornerRadius = circleRadius
        label.layer.backgroundColor = UIColor.medium.cgColor
        label.layer.masksToBounds = true
        return label
    }()
    
    let remarkLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .medium
        return label
    }()
    
    let releaseToViewScoreLabel: UILabel = {
        let label = UILabel()
        label.text = "Release to view score."
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .medium
        return label
    }()
    
    let shareButton: UIButton = {
        let button = UIButton.createStyledButton(withColor: .violet)
        button.setTitle("Share", for: .normal)
        return button
    }()
    
    
    func setupViews() {
        addSubview(riskScoreTitleLabel)
        addSubview(releaseToViewScoreLabel)
        addSubview(riskScoreLabel)
        addSubview(remarkLabel)
        addSubview(shareButton)
        
        let sidePadding: CGFloat = 16
        
        riskScoreTitleLabel.text = "Risk Score"
        riskScoreTitleLabel.anchorWithConstantsToTop(
            topAnchor,
            left: leftAnchor,
            right: rightAnchor,
            topConstant: 10,
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
        riskScoreLabel.frame = CGRect(
            x: 0,
            y: 0,
            width: ResultCell.circleRadius * 2,
            height: ResultCell.circleRadius * 2
        )
        riskScoreLabel.anchorWithConstantsToTop(
            topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            topConstant: (self.frame.height - UIConstants.navigationBarHeight) / 2 - ResultCell.circleRadius,
            leftConstant: self.frame.width / 2 - ResultCell.circleRadius,
            bottomConstant:  (self.frame.height + UIConstants.navigationBarHeight) / 2 - ResultCell.circleRadius,
            rightConstant: self.frame.width / 2 - ResultCell.circleRadius
        )
        
        remarkLabel.alpha = 0
        remarkLabel.anchorWithConstantsToTop(
            riskScoreTitleLabel.bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            topConstant: 16,
            leftConstant: sidePadding,
            rightConstant: sidePadding
        )
        
        shareButton.frame = CGRect(
            x: (self.frame.width - UIConstants.buttonWidth) / 2,
            y: self.frame.height - (self.frame.width - UIConstants.buttonWidth) / 2 - UIConstants.buttonHeight,
            width: UIConstants.buttonWidth,
            height: UIConstants.buttonHeight
        )
        shareButton.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
    }
    
    
    
    func incrementRiskScore(forTimer timer: Timer) {
        let target = result!.riskScore
        let number = Int32(riskScoreLabel.text!)!
        
        if number < target {
            riskScoreLabel.text = String(describing: number + 1)
        }
        else {
            timer.invalidate()
            animatePresentRemark()
        }
    }
    
    
    func animateBackgroundColor(forLabel label: UILabel, toColor color: UIColor, withDuration duration: TimeInterval) {
        UIView.animate(
            withDuration: duration,
            animations: {
                label.layer.backgroundColor = color.cgColor
            }
        )
    }
    
    
    func animateCountUpRiskScore() {
        let timeInterval: TimeInterval = min(1.0/10.0, 1.0/Double(result!.riskScore))
        let backgroundColor = determineBackgroundColorFromRiskScore()
        
        animateBackgroundColor(
            forLabel: riskScoreLabel,
            toColor: backgroundColor,
            withDuration: timeInterval * TimeInterval(result!.riskScore)
        )
        
        Timer.scheduledTimer(
            timeInterval: timeInterval,
            target: self,
            selector: #selector(incrementRiskScore(forTimer:)),
            userInfo: nil,
            repeats: true
        ).fire()
    }
    
    func determineBackgroundColorFromRiskScore() -> UIColor {
        switch (result?.qualitativeRisk)! {
        case .low:
            return .green
        case .medium:
            return .yellow
        case .high:
            return .yellow
        case .veryHigh:
            return .red
        }
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
        shareButton.alpha = 1
    }
    
    func ghostElements() {
        let ghostAlpha: CGFloat = 1/2
        riskScoreTitleLabel.alpha = ghostAlpha
        riskScoreLabel.alpha = 0
        releaseToViewScoreLabel.alpha = 1
        shareButton.alpha = ghostAlpha
    }
    
    
    func handleShare() {
        delegate?.shareResponse(withPopoverSourceView: shareButton)
    }
}
