import UIKit
import AcknowList

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
    
    let acknowledgementsLabel: UILabel = {
        let label = UILabel()
        label.text = "Acknowledgements"
        label.textAlignment = .center
        label.textColor = .medium
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    let imageAssetsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Image assets", for: .normal)
        button.setTitleColor(.violet, for: .normal)
        button.addTarget(self, action: #selector(handleImageAssetsButton), for: .touchUpInside)
        return button
    }()
    
    let thirdPartySoftwareButton: UIButton = {
        let button = UIButton()
        button.setTitle("Third-party software", for: .normal)
        button.setTitleColor(.violet, for: .normal)
        button.addTarget(self, action: #selector(handleThirdPartySoftwareButton), for: .touchUpInside)
        return button
    }()
    
    func setupViews() {
        addSubview(aboutLabel)
        addSubview(thirdPartySoftwareButton)
        addSubview(imageAssetsButton)
        addSubview(acknowledgementsLabel)
        
        aboutLabel.anchorToTop(
            topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
        
        let padding: CGFloat = 16
        thirdPartySoftwareButton.anchorWithConstantsToTop(
            nil,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            topConstant: padding / 4,
            leftConstant: padding,
            bottomConstant: padding,
            rightConstant: padding
        )
        
        imageAssetsButton.anchorWithConstantsToTop(
            nil,
            left: leftAnchor,
            bottom: thirdPartySoftwareButton.topAnchor,
            right: rightAnchor,
            topConstant: padding / 4,
            leftConstant: padding,
            bottomConstant: padding / 4,
            rightConstant: padding
        )
        
        acknowledgementsLabel.anchorWithConstantsToTop(
            nil,
            left: leftAnchor,
            bottom: imageAssetsButton.topAnchor,
            right: rightAnchor,
            leftConstant: padding,
            bottomConstant: padding / 4,
            rightConstant: padding
        )
    }
    
    func handleImageAssetsButton() {
        delegate?.pushViewController(ImageCreditsController())
    }
    
    func handleThirdPartySoftwareButton() {
        let path = Bundle.main.path(forResource: "Pods-fatigue-acknowledgements", ofType: "plist")
        let acknowListViewController = AcknowListViewController(acknowledgementsPlistPath: path)
        delegate?.pushViewController(acknowListViewController)
    }
}
