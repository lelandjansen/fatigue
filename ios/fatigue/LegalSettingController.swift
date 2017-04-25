import UIKit

class LegalSettingController: UIViewController {

    lazy var legalSettingView: UIView = {
        let view = LegalSettingView(frame: self.view.frame)
        view.backgroundColor = .light
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = LegalSetting.settingName
        setupViews()
    }
    
    
    func setupViews() {
        view.addSubview(legalSettingView)
        
        legalSettingView.anchorToTop(
            view.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor
        )
    }
    
}
