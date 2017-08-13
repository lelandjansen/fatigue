import UIKit

class LegalSettingView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let legalTextView: UITextView = {
        let view = UITextView()
        if let path = Bundle.main.path(forResource: "LEGAL", ofType: String()) {
            let fileManager = FileManager()
            let contents = fileManager.contents(atPath: path)
            let fileText = NSString(data: contents!, encoding: String.Encoding.utf8.rawValue)! as String
            view.text = fileText.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        view.isEditable = false
        view.font = .systemFont(ofSize: 14)
        view.textColor = .dark
        view.backgroundColor = .clear
        view.textAlignment = .justified
        return view
    }()
    
    func setupViews() {
        addSubview(legalTextView)
        let padding: CGFloat = 16
        legalTextView.anchorWithConstantsToTop(
            topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            topConstant: padding,
            leftConstant: padding / 2,
            bottomConstant: padding,
            rightConstant: padding / 2
        )
        
    }
    
}
