import UIKit

class RoleSettingController: UITableViewController {
    
    weak var delegate: SettingsDelegate?
    
    enum CellId: String {
        case roleCell
    }
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = RoleSetting.settingName
        view.backgroundColor = .light
    }
    
    let items: [Role] = [
        .pilot,
        .engineer
    ]
    
    var role = UserDefaults.standard.role
    
    var selectedIndexPath: IndexPath?
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellId.roleCell.rawValue) else {
                return UITableViewCell(style: .default, reuseIdentifier: CellId.roleCell.rawValue)
            }
            return cell
        }()
        
        if items[indexPath.row] == role {
            cell.accessoryType = .checkmark
            selectedIndexPath = indexPath
        }
        else {
            cell.accessoryType = .none
        }
        
        cell.textLabel?.text = items[indexPath.row].rawValue.capitalized
        cell.textLabel?.textColor = .dark
        cell.backgroundColor = .clear
        cell.tintColor = .violet
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let lastSelectedIndexPath = selectedIndexPath {
            tableView.cellForRow(at: lastSelectedIndexPath)?.accessoryType = .none
        }
        
        role = items[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        selectedIndexPath = indexPath
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.role = role
        delegate?.setSelectedCellDetails(toValue: role.rawValue.capitalized)
    }    
}
