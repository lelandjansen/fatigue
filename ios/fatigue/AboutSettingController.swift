import UIKit
import SafariServices

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
    
    func pushViewController(_ viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func openUrl(_ url: URL) {
        present(SFSafariViewController(url: url), animated: true)
    }
}
