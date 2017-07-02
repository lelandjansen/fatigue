import UIKit
import AcknowList

class AboutSettingController: UIViewController, AboutSettingDelegate {
    
    lazy var aboutSettingView: UIView = {
        let view = AboutSettingView(frame: self.view.frame)
        view.delegate = self
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
    
    func pushAcknowledgementsViewController() {
        let path = Bundle.main.path(forResource: "Pods-fatigue-acknowledgements", ofType: "plist")
        let acknowListViewController = AcknowListViewController(acknowledgementsPlistPath: path)
        navigationController?.pushViewController(acknowListViewController, animated: true)
    }
}
