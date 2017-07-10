import UIKit
import PhoneNumberKit

class ShareInformationCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        userNameTextField.delegate = self
        supervisorNameTextField.delegate = self
        supervisorEmailTextField.delegate = self
        supervisorPhoneTextField.delegate = self
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: OnboardingDelegate?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Share information"
        label.font = .systemFont(ofSize: 22)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textColor = .dark
        return label
    }()
    
    lazy var keyboardToolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 48))
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [spacer, done]
        return toolbar
    }()
    
    lazy var shareInformationTable: UITableView = {
        let tableView = UITableView(frame: CGRect(), style: .grouped )
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 17)
        textField.backgroundColor = .clear
        textField.textColor = .dark
        textField.autocapitalizationType = .words
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.textContentType = .familyName
        textField.placeholder = "Full name"
        return textField
    }()
    
    let supervisorNameTextField: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 17)
        textField.backgroundColor = .clear
        textField.textColor = .dark
        textField.autocapitalizationType = .words
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.textContentType = .familyName
        textField.placeholder = "Full name"
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
        return textField
    }()
    
    lazy var supervisorPhoneTextField: UITextField = {
        let textField = PhoneNumberTextField()
        textField.font = .systemFont(ofSize: 17)
        textField.backgroundColor = .clear
        textField.textColor = .dark
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .phonePad
        textField.placeholder = "Mobile"
        textField.textContentType = .telephoneNumber
        textField.inputAccessoryView = self.keyboardToolbar
        return textField
    }()
    
    let saveButton: UIButton = {
        let button = UIButton.createStyledButton(withColor: .violet)
        button.setTitle("Save", for: .normal)
        return button
    }()
    
    func setupViews() {
        addSubview(titleLabel)
        addSubview(saveButton)
        addSubview(shareInformationTable)
        let padding: CGFloat = 16
        titleLabel.anchorWithConstantsToTop(
            topAnchor,
            left: leftAnchor,
            right: rightAnchor,
            topConstant: 3 * padding,
            leftConstant: padding,
            rightConstant: padding
        )
        saveButton.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        saveButton.heightAnchor.constraint(equalToConstant: UIConstants.buttonHeight).isActive = true
        saveButton.anchorWithConstantsToTop(
            nil,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            leftConstant: (frame.width - UIConstants.buttonWidth) / 2,
            bottomConstant: 2 * padding,
            rightConstant: (frame.width - UIConstants.buttonWidth) / 2
        )
        shareInformationTable.anchorWithConstantsToTop(
            titleLabel.bottomAnchor,
            left: leftAnchor,
            bottom: saveButton.topAnchor,
            right: rightAnchor,
            bottomConstant: padding
        )
    }
    
    func handleSaveButton() {
        let name = userNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        UserDefaults.standard.name = name
        let supervisorName = supervisorNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        UserDefaults.standard.supervisorName = supervisorName
        let email = supervisorEmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        UserDefaults.standard.supervisorEmail = email
        let phoneNumber = supervisorPhoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        UserDefaults.standard.supervisorPhone = phoneNumber
        delegate?.dismiss()
    }
    
    enum Section: Int {
        case user = 0
        case supervisor = 1
    }
    
    enum CellId: String {
        case userNameCell, supervisorNameCell, supervisorEmailCell, supervisorPhoneCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.user.rawValue:
            return 1
        case Section.supervisor.rawValue:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Section.user.rawValue:
            return "You"
        case Section.supervisor.rawValue:
            return "Supervisor"
        default:
            return String()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let (reuseIdentifier, textField): (String, UITextField) = {
            switch (indexPath.section, indexPath.row) {
            case (Section.user.rawValue, 0):
                return (CellId.userNameCell.rawValue, userNameTextField)
            case (Section.supervisor.rawValue, 0):
                return (CellId.supervisorNameCell.rawValue, supervisorNameTextField)
            case (Section.supervisor.rawValue, 1):
                return (CellId.supervisorEmailCell.rawValue, supervisorEmailTextField)
            case (Section.supervisor.rawValue, 2):
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return false
    }
    
    func dismissKeyboard() {
        endEditing(true)
    }
}
