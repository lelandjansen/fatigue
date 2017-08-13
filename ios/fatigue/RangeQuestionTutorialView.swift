import UIKit

class RangeQuestionTutorialView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
        addSubview(tutorialCirlce)
        tutorialCirlce.alpha = 0
        tutorialCirlce.frame = CGRect(
            x: frame.width / 4 - tutorialCirlce.frame.width / 2,
            y: frame.height * 3 / 4 - tutorialCirlce.frame.height / 2,
            width: tutorialCirlce.frame.width,
            height: tutorialCirlce.frame.height
        )
    }
    
    lazy var tutorialCirlce: UIView = {
        let view = UIView()
        view.backgroundColor = .medium
        view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        view.layer.cornerRadius = view.frame.size.width / 2
        view.clipsToBounds = true
        return view
    }()
    
    func showRangeQuestionTutorial() {
        UIView.animateKeyframes(
            withDuration: 5,
            delay: 0,
            options: [.calculationModeCubic, .repeat, .autoreverse, .allowUserInteraction],
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: 2 / 8,
                    relativeDuration: 4 / 8,
                    animations: {
                        self.tutorialCirlce.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -1 * self.frame.height / 2)
                    }
                )
                UIView.addKeyframe(
                    withRelativeStartTime: 2 / 8,
                    relativeDuration: 1 / 8,
                    animations: {
                        self.tutorialCirlce.alpha = 1 / 2
                    }
                )
                UIView.addKeyframe(
                    withRelativeStartTime: 5 / 8,
                    relativeDuration: 1 / 8,
                    animations: {
                        self.tutorialCirlce.alpha = 0
                    }
                )
            }
        )
    }
}
