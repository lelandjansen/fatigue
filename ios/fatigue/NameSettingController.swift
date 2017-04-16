import UIKit

class NameSettingController : UIViewController {
    
    let nameSetting = NameSetting()
    
    lazy var nameSettingView: UIView = {
        let view = NameSettingView(frame: self.view.frame)
        view.backgroundColor = .light
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = nameSetting.settingName
        
        setupViews()
    }
    
    
    func setupViews() {
        view.addSubview(nameSettingView)
        
        nameSettingView.anchorToTop(
            view.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor
        )
    }

}
