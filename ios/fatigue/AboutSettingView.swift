import UIKit

class AboutSettingView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let aboutLabel: UILabel = {
        let label = UILabel()
        label.text = "About this app"
        label.textAlignment = .center
        return label
    }()
    
    func setupViews() {
        addSubview(aboutLabel)
        
        aboutLabel.anchorToTop(
            topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
    }
    
}
