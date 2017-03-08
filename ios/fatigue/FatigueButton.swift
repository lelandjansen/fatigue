import UIKit

public class FatigueButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(.white, for: .normal)
        setTitleColor(UIColor(white: 1, alpha: 1/2), for: .highlighted)
        titleLabel!.font = UIFont.systemFont(ofSize: 20)
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        translatesAutoresizingMaskIntoConstraints = false
        addConstraint(
            NSLayoutConstraint(
                item: self,
                attribute: .height,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: 64
            )
        )
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
