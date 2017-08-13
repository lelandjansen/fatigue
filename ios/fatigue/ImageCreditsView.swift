import UIKit

class ImageCreditsView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    weak var delegate: ImageCreditsDelegate?
    
    let creditsLabel: UILabel = {
        let label = UILabel()
        label.text = "Aircraft, clouds, and mountain images designed by Freepik. Air traffic control tower image designed by Graphiqastock/Freepik. Images modified with permission."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.textColor = .dark
        return label
    }()
    
    let websiteButton: UIButton = {
        let button = UIButton()
        button.setTitle("http://www.freepik.com", for: .normal)
        button.setTitleColor(.violet, for: .normal)
        button.addTarget(self, action: #selector(handleWebsiteButton), for: .touchUpInside)
        return button
    }()
    
    func handleWebsiteButton() {
        delegate?.openUrl(URL(string: websiteButton.title(for: .normal)!)!)
    }
    
    func setupViews() {
        addSubview(creditsLabel)
        addSubview(websiteButton)
        
        let padding: CGFloat = 16
        creditsLabel.anchorWithConstantsToTop(
            nil,
            left: leftAnchor,
            bottom: centerYAnchor,
            right: rightAnchor,
            leftConstant: padding,
            bottomConstant: padding / 2,
            rightConstant: padding
        )
        
        websiteButton.anchorWithConstantsToTop(
            centerYAnchor,
            left: leftAnchor,
            right: rightAnchor,
            topConstant: padding / 2,
            leftConstant: padding,
            rightConstant: padding
        )
    }
}
