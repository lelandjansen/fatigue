import UIKit

class OccupationSettingView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let occupationLabel: UILabel = {
        let label = UILabel()
        label.text = "Pilot or engineer"
        label.textAlignment = .center
        return label
    }()
    
    func setupViews() {
        addSubview(occupationLabel)
        
        occupationLabel.anchorToTop(
            topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
    }
    
}
