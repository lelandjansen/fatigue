import UIKit

class HistoryCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        historyTable.delegate = self
        historyTable.dataSource = self
        reloadHistory()
        setupViews()
    }
    
    var questionnaireResponses: [QuestionnaireResponse] = []
    
    func reloadHistory() {
        questionnaireResponses = QuestionnaireResponse.loadResponses().reversed()
        historyTable.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: HomePageControllerDelegate?
    
    lazy var navigationBar: UINavigationBar = {
        let navigationBar: UINavigationBar = UINavigationBar(
            frame: CGRect(x: 0, y: 0, width: self.frame.width, height: UIConstants.navigationBarHeight)
        )
        navigationBar.isTranslucent = true
        navigationBar.barTintColor = .light
        navigationBar.tintColor = .clear
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.dark]
        let navigationItem = UINavigationItem(title: "History")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        navigationBar.setItems([navigationItem], animated: false)
        navigationBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleNavigationBarTap)))
        return navigationBar
    }()
    
    func setNavigationBarColor(toColor color: UIColor) {
        navigationBar.barTintColor = color
        navigationBar.layoutIfNeeded()
    }
    
    func animateNavigationBar(toColor color: UIColor, withDuration duration: TimeInterval) {
        UIView.animate(
            withDuration: duration,
            animations: {
                self.navigationBar.barTintColor = color
                switch color {
                case UIColor.light:
                    self.navigationBar.tintColor = .clear
                default:
                    self.navigationBar.tintColor = .violet
                }
                self.navigationBar.layoutIfNeeded()
            }
        )
    }
    
    func handleNavigationBarTap() {
        delegate?.moveToHistoryPage()
    }
    
    func handleDone() {
        historyTable.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        delegate?.moveToHomePage()
    }
    
    let historyTable: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.allowsMultipleSelectionDuringEditing = false
        return tableView
    }()
    
    func setupViews() {
        addSubview(historyTable)
        addSubview(navigationBar)
        
        historyTable.anchorToTop(
            navigationBar.bottomAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
    }
    
    enum CellId: String {
        case historyTableCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let responseToDelete = questionnaireResponses[indexPath.row]
        questionnaireResponses.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        QuestionnaireResponse.delete(response: responseToDelete)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionnaireResponses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CellId.historyTableCell.rawValue) else {
                return UITableViewCell(style: .value1, reuseIdentifier: CellId.historyTableCell.rawValue)
            }
            return cell
        }()
        
        let questionnaireResponse = questionnaireResponses[indexPath.row]
        cell.textLabel?.text = dateFormatter.string(from: questionnaireResponse.date! as Date)
        cell.textLabel?.textColor = .dark
        cell.detailTextLabel?.text = String(describing: questionnaireResponse.riskScore)
        cell.detailTextLabel?.textColor = .medium
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .clear
        return cell
    }
}
