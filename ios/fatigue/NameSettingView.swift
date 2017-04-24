import UIKit

class NameSettingView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "User's name"
        label.textAlignment = .center
        return label
    }()
    
    func setupViews() {
        addSubview(nameLabel)
        
        nameLabel.anchorToTop(
            topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
    }
    
}
