import UIKit

class LegalSettingView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let legalLabel: UILabel = {
        let label = UILabel()
        label.text = "A few formalities"
        label.textAlignment = .center
        return label
    }()
    
    func setupViews() {
        addSubview(legalLabel)
        
        legalLabel.anchorToTop(
            topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
    }
    
}
