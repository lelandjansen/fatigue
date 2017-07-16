import UIKit

class ContributorsController: UIViewController {
    let contributorsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        if let path = Bundle.main.path(forResource: "CONTRIBUTORS", ofType: String()) {
            let fileManager = FileManager()
            let contents = fileManager.contents(atPath: path)
            let fileText = NSString(data: contents!, encoding: String.Encoding.utf8.rawValue)! as String
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.paragraphSpacingBefore = label.font.pointSize / 2
            let text = fileText.trimmingCharacters(in: .whitespacesAndNewlines)
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(
                NSParagraphStyleAttributeName,
                value: paragraphStyle,
                range: NSMakeRange(0, attributedString.length)
            )
            label.attributedText = attributedString
        }
        label.textColor = .dark
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.numberOfLines = 0
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Acknowledgements"
        view.backgroundColor = .light
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(contributorsLabel)
        let padding: CGFloat = 16
        contributorsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding).isActive = true
        contributorsLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -1 * padding).isActive = true
        contributorsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
