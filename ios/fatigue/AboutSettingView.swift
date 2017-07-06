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
    
    let logoImage: UIImageView = {
        return UIImageView(image: #imageLiteral(resourceName: "iagsa-logo-full-dark"))
    }()
    
    let designedByLabel: UILabel = {
        let label = UILabel()
        label.text = "Designed by Leland Jansen"
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
        addSubview(logoImage)
        addSubview(designedByLabel)
        addSubview(thirdPartySoftwareButton)
        addSubview(imageAssetsButton)
        addSubview(acknowledgementsLabel)
        
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
        
        logoImage.anchorWithConstantsToTop(
            topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            topConstant: (self.frame.height - logoImage.frame.height) / 2,
            leftConstant: (self.frame.width - logoImage.frame.width) / 2,
            bottomConstant: (self.frame.height - logoImage.frame.height) / 2,
            rightConstant: (self.frame.width - logoImage.frame.width) / 2
        )
        
        designedByLabel.anchorToTop(
            logoImage.bottomAnchor,
            left: leftAnchor,
            bottom: acknowledgementsLabel.topAnchor,
            right: rightAnchor
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
