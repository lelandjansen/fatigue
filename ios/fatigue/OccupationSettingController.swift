import UIKit

class OccupationSettingController : UIViewController {
    
    let occupationSetting = OccupationSetting()
    
    lazy var occupationSettingView: UIView = {
        let view = OccupationSettingView(frame: self.view.frame)
        view.backgroundColor = .light
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = occupationSetting.settingName
        
        setupViews()
    }
    
    
    func setupViews() {
        view.addSubview(occupationSettingView)
        
        occupationSettingView.anchorToTop(
            view.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor
        )
    }
    
}
