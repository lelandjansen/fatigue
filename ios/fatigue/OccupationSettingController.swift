import UIKit

class OccupationSettingController: UITableViewController {
    
    weak var delegate: SettingsDelegate?
    
    enum CellId: String {
        case occupationCell
    }
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = OccupationSetting.settingName
        view.backgroundColor = .light
    }
    
    let items: [Occupation] = [
        .pilot,
        .engineer
    ]
    
    var occupation = UserDefaults.standard.occupation
    
    var selectedIndexPath: IndexPath?
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellId.occupationCell.rawValue) else {
                return UITableViewCell(style: .default, reuseIdentifier: CellId.occupationCell.rawValue)
            }
            return cell
        }()
        
        if items[indexPath.row] == occupation {
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
        
        occupation = items[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        selectedIndexPath = indexPath
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.occupation = occupation
        delegate?.setSelectedCellDetails(toValue: occupation.rawValue.capitalized)
    }    
}
