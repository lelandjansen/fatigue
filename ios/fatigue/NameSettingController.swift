import UIKit

class NameSettingController: UITableViewController, UITextFieldDelegate {

    weak var delegate: SettingsDelegate?
    
    enum CellId: String {
        case nameCell
    }
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NameSetting.settingName
        view.backgroundColor = .light
        nameTextField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nameTextField.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 17)
        textField.backgroundColor = .clear
        textField.textColor = .dark
        textField.autocapitalizationType = .words
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.placeholder = "Your name"
        textField.text = UserDefaults.standard.name
        return textField
    }()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: CellId.nameCell.rawValue)
        cell.selectionStyle = .none
        cell.contentView.addSubview(nameTextField)
        cell.backgroundColor = .clear
        
        nameTextField.anchor(toCell: cell)
        
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let name = nameTextField.text?.trimmingCharacters(in: .whitespaces)
        UserDefaults.standard.name = name
        delegate?.setSelectedCellDetails(toValue: name!)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        navigationController?.popViewController(animated: true)
        return false
    }
    
}
