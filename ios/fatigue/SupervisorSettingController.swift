import UIKit

class SupervisorSettingController : UIViewController {
    
    let supervisorSetting = SupervisorSetting()
    
    lazy var supervisorSettingView: UIView = {
        let view = SupervisorSettingView(frame: self.view.frame)
        view.backgroundColor = .light
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = supervisorSetting.settingName
        
        setupViews()
    }
    
    
    func setupViews() {
        view.addSubview(supervisorSettingView)
        
        supervisorSettingView.anchorToTop(
            view.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor
        )
    }
    
}
