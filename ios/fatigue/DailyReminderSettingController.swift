import UIKit

class DailyReminderSettingController : UIViewController {
    
    let dailyReminderSetting = DailyReminderSetting()
    
    lazy var dailyReminderSettingView: UIView = {
        let view = DailyReminderSettingView(frame: self.view.frame)
        view.backgroundColor = .light
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = dailyReminderSetting.settingName
        
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
