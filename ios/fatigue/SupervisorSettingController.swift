import ContactsUI
import UIKit
import PhoneNumberKit

class SupervisorSettingController: UITableViewController, UITextFieldDelegate, CNContactPickerDelegate {
    
    weak var delegate: SettingsDelegate?
    
    enum CellId: String {
        case supervisorName, supervisorEmail, supervisorPhone, pickFromContacts
    }
    
    enum Section: Int {
        case name = 0
        case contact = 1
        case pickFromContacts = 2
        case numberOfSections = 3
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
        supervisorNameTextField.delegate = self
        supervisorEmailTextField.delegate = self
        supervisorPhoneTextField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.numberOfSections.rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.name.rawValue:
            return 1
        case Section.contact.rawValue:
            return 2
        case Section.pickFromContacts.rawValue:
            return 1
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
        textField.textContentType = .familyName
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
        textField.textContentType = .emailAddress
        textField.placeholder = "Email"
        textField.text = UserDefaults.standard.supervisorEmail
        return textField
    }()
    
    let supervisorPhoneTextField: UITextField = {
        let textField = PhoneNumberTextField()
        textField.font = .systemFont(ofSize: 17)
        textField.backgroundColor = .clear
        textField.textColor = .dark
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .phonePad
        textField.placeholder = "Mobile"
        textField.textContentType = .telephoneNumber
        textField.text = UserDefaults.standard.supervisorPhone
        return textField
    }()
    
    lazy var pickFromContactsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Pick from Contacts", for: .normal)
        button.setTitleColor(.violet, for: .normal)
        button.addTarget(self, action: #selector(handlePickFromContactsButton), for: .touchUpInside)
        return button
    }()
    
    func handlePickFromContactsButton() {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        present(contactPicker, animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        supervisorNameTextField.populateName(fromContact: contact, completion: {
            self.supervisorEmailTextField.populateEmail(fromContact: contact, inTableViewController: self, withPopoverSourceView: self.supervisorEmailTextField, completion: {
                self.supervisorPhoneTextField.populatePhoneNumber(fromContact: contact, inViewController: self, withPopoverSourceView: self.supervisorPhoneTextField)
            })
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let (reuseIdentifier, view): (String, UIView) = {
            switch (indexPath.section, indexPath.row) {
            case (Section.name.rawValue, 0):
                return (CellId.supervisorName.rawValue, supervisorNameTextField)
            case (Section.contact.rawValue, 0):
                return (CellId.supervisorEmail.rawValue, supervisorEmailTextField)
            case (Section.contact.rawValue, 1):
                return (CellId.supervisorPhone.rawValue, supervisorPhoneTextField)
            case (Section.pickFromContacts.rawValue, 0):
                return (CellId.pickFromContacts.rawValue, pickFromContactsButton)
            default:
                fatalError("No cell assigned to IndexPath \(indexPath)")
            }
        }()
        let cell = UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
        cell.selectionStyle = .none
        cell.contentView.addSubview(view)
        cell.backgroundColor = .clear
        view.anchor(toCell: cell)
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
        
        delegate?.setSelectedCellDetails(toValue: name!)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        navigationController?.popViewController(animated: true)
        return false
    }
    
}
