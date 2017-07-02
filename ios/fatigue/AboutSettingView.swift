import UIKit

class AboutSettingView : UIView {
    
    weak var delegate: AboutSettingDelegate?
    
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
    
    let acknowledgementsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Third-party acknowledgements", for: .normal)
        button.setTitleColor(.violet, for: .normal)
        button.addTarget(self, action: #selector(handleAcknowledgementsButton), for: .touchUpInside)
        return button
    }()
    
    func setupViews() {
        addSubview(aboutLabel)
        addSubview(acknowledgementsButton)
        
        aboutLabel.anchorToTop(
            topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
        
        acknowledgementsButton.anchorWithConstantsToTop(
            nil,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            leftConstant: 16,
            bottomConstant: 16,
            rightConstant: 16
        )
    }
    
    func handleAcknowledgementsButton() {
        delegate?.pushAcknowledgementsViewController()
    }
    
}
