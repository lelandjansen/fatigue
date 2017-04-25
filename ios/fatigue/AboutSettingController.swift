import UIKit

class AboutSettingController: UIViewController {
    
    lazy var aboutSettingView: UIView = {
        let view = AboutSettingView(frame: self.view.frame)
        view.backgroundColor = .light
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = AboutSetting.settingName
        setupViews()
    }
    
    
    func setupViews() {
        view.addSubview(aboutSettingView)
        
        aboutSettingView.anchorToTop(
            view.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor
        )
    }
    
}
