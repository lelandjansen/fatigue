import UIKit

class SettingsController: UITableViewController {
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.dark]
        navigationController?.navigationBar.tintColor = .medium
        
        navigationItem.title = "Settings"
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissSettings))
        navigationItem.rightBarButtonItem = doneItem
        
        view.backgroundColor = .light
    }
    
    
    enum CellId: String {
        case cell
    }
    
    var items: [Setting] = [
        NameSetting(),
        OccupationSetting(),
        DailyReminderSetting(),
        SupervisorSetting(),
        AboutSetting(),
        LegalSetting(),
    ]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellId.cell.rawValue) else {
                return UITableViewCell(style: .value1, reuseIdentifier: CellId.cell.rawValue)
            }
            return cell
        }()
        
        cell.textLabel?.text = type(of: items[indexPath.row]).settingName
        cell.textLabel?.textColor = .dark
        cell.detailTextLabel?.text = items[indexPath.row].details
        cell.detailTextLabel?.textColor = .medium
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .clear
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller: UIViewController = {
            switch items[indexPath.row] {
            case is NameSetting:
                return NameSettingController()
            case is OccupationSetting:
                return OccupationSettingController()
            case is DailyReminderSetting:
                return DailyReminderSettingController()
            case is SupervisorSetting:
                return SupervisorSettingController()
            case is AboutSetting:
                return AboutSettingController()
            case is LegalSetting:
                return LegalSettingController()
            default:
                fatalError("Selection is not one of the available settings")
            }
        }()
        
        if controller is SettingDelegate {
            (controller as! SettingDelegate).delegate = self
        }
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func setSelectedCellDetails(toValue value: String?) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            items[selectedIndexPath.row].details = value ?? String()
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
            tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
        }
    }
    
    
    func dismissSettings() {
        dismiss(animated: true, completion: nil)
    }

}
