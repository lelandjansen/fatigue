import UIKit

class OccupationSettingController: UITableViewController, SettingDelegate {
    
    weak var delegate: SettingsController?
    
    enum CellId: String {
        case settingsCell
    }
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = OccupationSetting.settingName
        view.backgroundColor = .light
    }
    
    var items: [Occupation] = [
        .pilot,
        .engineer
    ]
    
    var selectedIndexPath: IndexPath?
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellId.settingsCell.rawValue) else {
                return UITableViewCell(style: .default, reuseIdentifier: CellId.settingsCell.rawValue)
            }
            return cell
        }()
        
        if items[indexPath.row] == UserDefaults.standard.occupation {
            cell.accessoryType = .checkmark
            selectedIndexPath = indexPath
        }
        else {
            cell.accessoryType = .none
        }
        
        cell.textLabel?.text = items[indexPath.row].rawValue.capitalized
        cell.textLabel?.textColor = .dark
        cell.backgroundColor = .clear
        cell.tintColor = .blue
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let lastSelectedIndexPath = selectedIndexPath {
            tableView.cellForRow(at: lastSelectedIndexPath)?.accessoryType = .none
        }
        
        let selection = items[indexPath.row]
        UserDefaults.standard.occupation = selection
        delegate?.setSelectedCellDetails(toValue: selection.rawValue.capitalized)
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        selectedIndexPath = indexPath
    }
    
}
