import UIKit

class SettingsController: UITableViewController, SettingsDelegate {
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.dark]
        navigationController?.navigationBar.tintColor = .violet
        
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
        ReminderSetting(),
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
                let controller = NameSettingController()
                controller.delegate = self
                return controller
            case is OccupationSetting:
                let controller = OccupationSettingController()
                controller.delegate = self
                return controller
            case is ReminderSetting:
                let controller = ReminderSettingController()
                controller.delegate = self
                return controller
            case is SupervisorSetting:
                let controller = SupervisorSettingController()
                controller.delegate = self
                return controller
            case is AboutSetting:
                return AboutSettingController()
            case is LegalSetting:
                return LegalSettingController()
            default:
                fatalError("Selection is not one of the available settings")
            }
        }()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func setSelectedCellDetails(toValue value: String) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            items[selectedIndexPath.row].details = value
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
            tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
        }
    }
    
    func presentViewController(_ viewController: UIViewController) {
        present(viewController, animated: true)
    }
    
    func dismissSettings() {
        dismiss(animated: true)
    }
}
