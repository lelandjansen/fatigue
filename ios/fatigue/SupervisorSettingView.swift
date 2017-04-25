import UIKit

class SupervisorSettingView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let supervisorLabel: UILabel = {
        let label = UILabel()
        label.text = "Supervisor name, email, and phone number"
        label.textAlignment = .center
        return label
    }()
    
    func setupViews() {
        addSubview(supervisorLabel)
        
        supervisorLabel.anchorToTop(
            topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
    }
    
}
