import UIKit

class ReminderCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        notificationTimeLabel.text = off
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var off = "Off"
    
    weak var delegate: OnboardingDelegate?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Daily reminder"
        label.font = .systemFont(ofSize: 22)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .dark
        return label
    }()
    
    let notificationTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .medium
        return label
    }()
    
    lazy var timePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.setDate(Calendar.current.date(from: UserDefaults.standard.reminderTime)!, animated: true)
        datePicker.heightAnchor.constraint(equalToConstant: datePicker.frame.height).isActive = true
        datePicker.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    let scheduleReminderButton: UIButton = {
        let button = UIButton.createStyledButton(withColor: .violet)
        button.setTitle("Schedule reminder", for: .normal)
        button.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight).isActive = true
        button.widthAnchor.constraint(equalToConstant: UIConstants.buttonWidth).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let skipButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: UIFontWeightSemibold)
        button.setTitleColor(.medium, for: .normal)
        button.setTitleColor(UIColor.medium.withAlphaComponent(1/2), for: .highlighted)
        button.setTitle("Skip", for: .normal)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func handleSetReminderButton() {
        registerLocalNotifications(
            completionIfGranted: {
                OperationQueue.main.addOperation() {
                    self.handleReminderEnabled()
                    self.delegate?.addNextPage()
                    self.delegate?.moveToNextPage()
                }
            },
            completionIfNotGranted: {
                OperationQueue.main.addOperation() {
                    self.handleNotificationPermissionsNotGranted()
                }
            }
        )
    }
    
    func handleSkipButton() {
        notificationTimeLabel.text = off
        disableLocalNotifications()
        delegate?.addNextPage()
        delegate?.moveToNextPage()
    }
    
    func timePickerValueChanged() {
        if UserDefaults.standard.reminderEnabled {
            handleReminderEnabled()
        }
    }
    
    func handleReminderEnabled() {
        let time = timePicker.date
        if let timeString = String(describingTime: time) {
            notificationTimeLabel.text = timeString
        }
        scheduleLocalNotifications(atTime: Calendar.current.dateComponents([.minute, .hour], from: time))
    }
    
    func handleNotificationPermissionsNotGranted() {
        notificationTimeLabel.text = off
        disableLocalNotifications()
        let alertController = UIAlertController(title: "Notifications not permitted", message: "Notifications can be enabled in Settings.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { _ in
            let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)!
            UIApplication.shared.open(settingsUrl, options: [:])
        }))
        delegate?.presentViewController(alertController)
    }
    
    func setupViews() {
        let padding: CGFloat = 16
        let stackView = UIStackView(arrangedSubviews: [timePicker, scheduleReminderButton, skipButton])
        stackView.axis = .vertical
        stackView.spacing = padding
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        addSubview(titleLabel)
        addSubview(notificationTimeLabel)
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.anchorWithConstantsToTop(
            topAnchor,
            left: leftAnchor,
            right: rightAnchor,
            topConstant: 3 * padding,
            leftConstant: padding,
            rightConstant: padding
        )
        notificationTimeLabel.anchorWithConstantsToTop(
            titleLabel.bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            topConstant: 19,
            leftConstant: padding,
            rightConstant: padding
        )
        timePicker.addTarget(self, action: #selector(timePickerValueChanged), for: .valueChanged)
        scheduleReminderButton.addTarget(self, action: #selector(handleSetReminderButton), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(handleSkipButton), for: .touchUpInside)
    }
}
