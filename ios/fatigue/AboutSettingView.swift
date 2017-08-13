import UIKit
import AcknowList

class AboutSettingView : UIView {
    
    weak var delegate: AboutSettingDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let logoWebsiteUrl = URL(string: "http://www.iagsa.ca")
    let designedByUrl = URL(string: "https://www.lelandjansen.com")
    
    let logoImage: UIImageView = {
        return UIImageView(image: #imageLiteral(resourceName: "iagsa-logo-full-dark"))
    }()
    
    lazy var logoWebsiteButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setTitleColor(.violet, for: .normal)
        button.setTitleColor(UIColor.violet.withAlphaComponent(1/2), for: .highlighted)
        button.setTitle(self.logoWebsiteUrl?.absoluteString.stripHttp(), for: .normal)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLogoWebsiteButton), for: .touchUpInside)
        return button
    }()
    
    let designedByLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .dark
        label.text = "Designed by Leland Jansen"
        label.textAlignment = .center
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var designedByWebsiteButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setTitleColor(.violet, for: .normal)
        button.setTitleColor(UIColor.violet.withAlphaComponent(1/2), for: .highlighted)
        button.setTitle(self.designedByUrl?.absoluteString.stripHttp(), for: .normal)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleDesignedByWebsiteButton), for: .touchUpInside)
        return button
    }()
    
    let acknowledgementsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .medium
        label.text = "Acknowledgements"
        label.textAlignment = .center
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let contributorsButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(.violet, for: .normal)
        button.setTitleColor(UIColor.violet.withAlphaComponent(1/2), for: .highlighted)
        button.setTitle("Contributors", for: .normal)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleContributorsButton), for: .touchUpInside)
        return button
    }()
    
    let cocoaPodsButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(.violet, for: .normal)
        button.setTitleColor(UIColor.violet.withAlphaComponent(1/2), for: .highlighted)
        button.setTitle("CocoaPods", for: .normal)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleCocoaPodsButton), for: .touchUpInside)
        return button
    }()
    
    let imagesButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(.violet, for: .normal)
        button.setTitleColor(UIColor.violet.withAlphaComponent(1/2), for: .highlighted)
        button.setTitle("Images", for: .normal)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleImagesButton), for: .touchUpInside)
        return button
    }()
    
    func setupViews() {
        let padding: CGFloat = 16
        
        let logoStackView = UIStackView(arrangedSubviews: [logoImage, logoWebsiteButton])
        logoStackView.axis = .vertical
        logoStackView.spacing = padding / 2
        logoStackView.alignment = .center
        logoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let designedByStackView = UIStackView(arrangedSubviews: [designedByLabel, designedByWebsiteButton])
        designedByStackView.axis = .vertical
        designedByStackView.alignment = .center
        designedByStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStackView = UIStackView(arrangedSubviews: [logoStackView, designedByStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 5 * padding
        mainStackView.alignment = .center
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        let acknowledgementsStackView = UIStackView(arrangedSubviews: [contributorsButton, cocoaPodsButton, imagesButton])
        acknowledgementsStackView.axis = .horizontal
        acknowledgementsStackView.spacing = padding / 2
        acknowledgementsStackView.alignment = .center
        acknowledgementsStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(acknowledgementsStackView)
        acknowledgementsStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        acknowledgementsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1 * padding).isActive = true
        
        addSubview(acknowledgementsLabel)
        acknowledgementsLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        acknowledgementsLabel.bottomAnchor.constraint(equalTo: acknowledgementsStackView.topAnchor).isActive = true
    }
    
    func handleLogoWebsiteButton() {
        delegate?.openUrl(logoWebsiteUrl!)
    }
    
    func handleDesignedByWebsiteButton() {
        delegate?.openUrl(designedByUrl!)
    }
    
    func handleContributorsButton() {
        delegate?.pushViewController(ContributorsController())
    }
    
    func handleCocoaPodsButton() {
        let path = Bundle.main.path(forResource: "Pods-fatigue-acknowledgements", ofType: "plist")
        let acknowListViewController = AcknowListViewController(acknowledgementsPlistPath: path)
        delegate?.pushViewController(acknowListViewController)
    }
    
    func handleImagesButton() {
        delegate?.pushViewController(ImageCreditsController())
    }
}
