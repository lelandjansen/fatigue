import UIKit

class DailyReminderSettingController: UIViewController, SettingDelegate {
    
    weak var delegate: SettingsController?
    
    lazy var dailyReminderSettingView: UIView = {
        let view = DailyReminderSettingView(frame: self.view.frame)
        view.backgroundColor = .light
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = DailyReminderSetting.settingName
        
        setupViews()
    }
    
    
    func setupViews() {
        view.addSubview(dailyReminderSettingView)
        
        dailyReminderSettingView.anchorToTop(
            view.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor
        )
    }
    
}
