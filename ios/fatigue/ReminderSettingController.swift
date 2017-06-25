import UIKit
import UserNotifications

class ReminderSettingController: UITableViewController, SettingDelegate {
    
    weak var delegate: SettingsController?
    
    enum CellTypes: String {
        case toggle, time, timePicker
    }
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            cell.detailTextLabel?.text = timeFormatter.string(from: timePicker.date)
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
        super.viewWillDisappear(animated)
        let details = reminderToggle.isOn ? timeFormatter.string(from: timePicker.date) : ReminderSetting.reminderOff
        delegate?.setSelectedCellDetails(toValue: details)
    }
    
    func reminderToggleValueChanged() {
        tableView.beginUpdates()
        if reminderToggle.isOn {
            tableView.insertRows(
                at: [IndexPath(row: items.index(of: .time)!, section: 0),
                     IndexPath(row: items.index(of: .timePicker)!, section: 0)],
                with: .automatic
            )
            scheduleLocalNotifications(
                atTime: Calendar.current.dateComponents([.minute, .hour], from: timePicker.date))
        }
        else {
            tableView.deleteRows(
                at: [IndexPath(row: items.index(of: .time)!, section: 0),
                     IndexPath(row: items.index(of: .timePicker)!, section: 0)],
                with: .automatic
            )
            disableLocalNotifications()
        }
        tableView.endUpdates()
    }
    
    func timePickerValueChanged() {
        let cell = tableView.cellForRow(at: IndexPath(row: items.index(of: .time)!, section: 0))
        cell?.detailTextLabel?.text = timeFormatter.string(from: timePicker.date)
        scheduleLocalNotifications(
            atTime: Calendar.current.dateComponents([.minute, .hour], from: timePicker.date))
    }
}
