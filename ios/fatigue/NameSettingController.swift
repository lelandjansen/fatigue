import UIKit

class NameSettingController: UITableViewController, SettingDelegate, UITextFieldDelegate {

    weak var delegate: SettingsController?
    
    enum CellId: String {
        case nameCell
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
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Your name"
        textField.text = UserDefaults.standard.name
        return textField
    }()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellId.nameCell.rawValue) else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: CellId.nameCell.rawValue)
            cell.selectionStyle = .none
            cell.contentView.addSubview(nameTextField)
            cell.backgroundColor = .clear
            
            constrain(nameTextField, toCell: cell)
            
            return cell
        }
        
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let name = nameTextField.text?.trimmingCharacters(in: .whitespaces)
        UserDefaults.standard.name = name
        delegate?.setSelectedCellDetails(toValue: name)
    }
    
    
    func constrain(_ view: UIView, toCell cell: UITableViewCell, withMargin margin: CGFloat = 8) {
        let topConstraint = NSLayoutConstraint(
            item: view,
            attribute: .top,
            relatedBy: .equal,
            toItem: cell.contentView,
            attribute: .top,
            multiplier: 1,
            constant: margin
        )
        
        let leftConstraint = NSLayoutConstraint(
            item: view,
            attribute: .leading,
            relatedBy: .equal,
            toItem: cell.contentView,
            attribute: .leading,
            multiplier: 1,
            constant: margin
        )
        
        let bottomConstraint = NSLayoutConstraint(
            item: view,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: cell.contentView,
            attribute: .bottom,
            multiplier: 1,
            constant: -margin
        )
        
        let rightConstraint = NSLayoutConstraint(
            item: view,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: cell.contentView,
            attribute: .trailing,
            multiplier: 1,
            constant: -margin
        )
        
        cell.addConstraints([topConstraint, leftConstraint, bottomConstraint, rightConstraint])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        navigationController?.popViewController(animated: true)
        return false
    }
    
}
