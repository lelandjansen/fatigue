import UIKit

class DailyReminderSettingView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let dailyReminderLabel: UILabel = {
        let label = UILabel()
        label.text = "Daily reminder time"
        label.textAlignment = .center
        return label
    }()
    
    func setupViews() {
        addSubview(dailyReminderLabel)
        
        dailyReminderLabel.anchorToTop(
            topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
    }
    
}
