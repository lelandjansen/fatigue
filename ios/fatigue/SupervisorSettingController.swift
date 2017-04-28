import UIKit

class SupervisorSettingController: UITableViewController, SettingDelegate, UITextFieldDelegate {
    
    weak var delegate: SettingsController?
    
    enum CellId: String {
        case supervisorNameCell, supervisorEmailCell, supervisorPhoneCell
    }
    
    enum Section: Int {
        case name = 0
        case contact = 1
    }
    
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NameSetting.settingName
        view.backgroundColor = .light
        supervisorNameTextField.delegate = self
        supervisorEmailTextField.delegate = self
        supervisorPhoneTextField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.name.rawValue:
            return 1
        case Section.contact.rawValue:
            return 2
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Section.name.rawValue:
            return "Name"
        case Section.contact.rawValue:
            return "Contact"
        default:
            return String()
        }
    }
    
    
    let supervisorNameTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 17)
        textField.backgroundColor = .clear
        textField.textColor = .dark
        textField.autocapitalizationType = .words
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        if #available(iOS 10.0, *) {
            textField.textContentType = .familyName
        }
        textField.placeholder = "Supervisor's name"
        textField.text = UserDefaults.standard.supervisorName
        return textField
    }()
    
    let supervisorEmailTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 17)
        textField.backgroundColor = .clear
        textField.textColor = .dark
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.keyboardType = .emailAddress
        if #available(iOS 10.0, *) {
            textField.textContentType = .emailAddress
        }
        textField.placeholder = "Email"
        textField.text = UserDefaults.standard.supervisorEmail
        return textField
    }()
    
    let supervisorPhoneTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 17)
        textField.backgroundColor = .clear
        textField.textColor = .dark
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .phonePad
        textField.placeholder = "Mobile"
        if #available(iOS 10.0, *) {
            textField.textContentType = .telephoneNumber
        }
        textField.text = UserDefaults.standard.supervisorPhone
        return textField
    }()
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let (reuseIdentifier, textField): (String, UITextField) = {
            switch (indexPath.section, indexPath.row) {
            case (Section.name.rawValue, 0):
                return (CellId.supervisorNameCell.rawValue, supervisorNameTextField)
            case (Section.contact.rawValue, 0):
                return (CellId.supervisorEmailCell.rawValue, supervisorEmailTextField)
            case (Section.contact.rawValue, 1):
                return (CellId.supervisorPhoneCell.rawValue, supervisorPhoneTextField)
            default:
                fatalError("No cell assigned to IndexPath \(indexPath)")
            }
        }()
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        cell.selectionStyle = .none
        cell.contentView.addSubview(textField)
        cell.backgroundColor = .clear
        
        textField.anchor(toCell: cell)
        
        return cell
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let name = supervisorNameTextField.text?.trimmingCharacters(in: .whitespaces)
        UserDefaults.standard.supervisorName = name
        
        let email = supervisorEmailTextField.text
        UserDefaults.standard.supervisorEmail = email
        
        let phone = supervisorPhoneTextField.text
        UserDefaults.standard.supervisorPhone = phone
        
        delegate?.setSelectedCellDetails(toValue: name)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        navigationController?.popViewController(animated: true)
        return false
    }
    
}
