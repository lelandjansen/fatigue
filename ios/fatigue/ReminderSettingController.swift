import UIKit
import UserNotifications

class ReminderSettingController: UITableViewController {
    
    weak var delegate: SettingsDelegate?
    
    enum CellTypes: String {
        case toggle, time, timePicker
    }
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    let items: [CellTypes] = [
        .toggle,
        .time,
        .timePicker
    ]
    
    let reminderToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = UserDefaults.standard.reminderEnabled
        toggle.tintColor = .violet
        toggle.onTintColor = .green
        toggle.addTarget(self, action: #selector(reminderToggleValueChanged), for: .valueChanged)
        return toggle
    }()
    
    let timePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.setDate(Calendar.current.date(
            from: UserDefaults.standard.reminderTime)!, animated: true)
        datePicker.addTarget(self, action: #selector(timePickerValueChanged), for: .valueChanged)
        return datePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ReminderSetting.settingName
        view.backgroundColor = .light
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminderToggle.isOn ? items.count : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            let identifier = items[indexPath.row].rawValue
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) else {
                switch items[indexPath.row] {
                case .time:
                    return UITableViewCell(style: .value1, reuseIdentifier: identifier)
                default:
                    return UITableViewCell(style: .default, reuseIdentifier: identifier)
                }
            }
            return cell
        }()
        
        switch items[indexPath.row] {
        case .toggle:
            cell.accessoryView = reminderToggle
            cell.textLabel?.text = "Daily reminder"
        case .time:
            cell.textLabel?.text = "Time"
            cell.detailTextLabel?.text = String(describingTime: timePicker.date)!
        case .timePicker:
            cell.addSubview(timePicker)
            timePicker.anchorToTop(
                cell.topAnchor,
                left: cell.leftAnchor,
                bottom: cell.bottomAnchor,
                right: cell.rightAnchor
            )
        }
        
        cell.selectionStyle = .none;
        cell.textLabel?.textColor = .dark
        cell.detailTextLabel?.textColor = .medium
        cell.backgroundColor = .clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return items[indexPath.row] == .timePicker ? timePicker.frame.size.height : tableView.rowHeight
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Notifications.registerLocalNotifications(
            completionIfGranted: {
                OperationQueue.main.addOperation() {
                    if self.reminderToggle.isOn {
                        let time = String(describingTime: self.timePicker.date)!
                        self.delegate?.setSelectedCellDetails(toValue: time)
                    }
                    else {
                        self.handleReminderDisabled()
                        self.delegate?.setSelectedCellDetails(toValue: ReminderSetting.reminderOff)
                    }
                }
            },
            completionIfNotGranted: {
                OperationQueue.main.addOperation() {
                    self.handleReminderDisabled()
                    self.delegate?.setSelectedCellDetails(toValue: ReminderSetting.reminderOff)
                    
                }
            }
        )
        super.viewWillDisappear(animated)
    }
    
    func reminderToggleValueChanged() {
        let time = Calendar.current.dateComponents([.minute, .hour], from: timePicker.date)
        reminderToggle.isOn ? tryEnableReminder(atTime: time) : handleReminderDisabled()
    }
    
    func tryEnableReminder(atTime time: DateComponents) {
        Notifications.registerLocalNotifications(
            completionIfGranted: {
                OperationQueue.main.addOperation() {
                    self.handleReminderEnabled(atTime: time)
                }
            },
            completionIfNotGranted: {
                OperationQueue.main.addOperation() {
                    self.handleNotificationPermissionsNotGranted()
                }
            }
        )
    }
    
    func handleReminderEnabled(atTime time: DateComponents) {
        tableView.beginUpdates()
        let timeRow = IndexPath(row: items.index(of: .time)!, section: 0)
        if !tableView.hasRow(atIndexPath: timeRow) {
            tableView.insertRows(at: [timeRow], with: .automatic)
        }
        let timePickerRow = IndexPath(row: items.index(of: .timePicker)!, section: 0)
        if !tableView.hasRow(atIndexPath: timePickerRow) {
            tableView.insertRows(at: [timePickerRow], with: .automatic)
        }
        let timeCell = tableView.cellForRow(at: timeRow)
        timeCell?.detailTextLabel?.text = String(describingTime: timePicker.date)
        Notifications.scheduleLocalNotifications(atTime: time)
        tableView.endUpdates()
    }
    
    func handleReminderDisabled() {
        self.reminderToggle.isOn = false
        tableView.beginUpdates()
        Notifications.disableLocalNotifications()
        let timeRow = IndexPath(row: items.index(of: .time)!, section: 0)
        if tableView.hasRow(atIndexPath: timeRow) {
            tableView.deleteRows(at: [timeRow], with: .automatic)
        }
        let timePickerRow = IndexPath(row: items.index(of: .timePicker)!, section: 0)
        if tableView.hasRow(atIndexPath: timePickerRow) {
            tableView.deleteRows(at: [timePickerRow], with: .automatic)
        }
        tableView.endUpdates()
    }
    
    func handleNotificationPermissionsNotGranted() {
        Notifications.alertNotificationsNotPermitted(inViewController: self.parent, completion: {
            self.handleReminderDisabled()
        })
    }
    
    func timePickerValueChanged() {
        let time = Calendar.current.dateComponents([.minute, .hour], from: timePicker.date)
        tryEnableReminder(atTime: time)
    }
}
