import UIKit

class HistoryCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        historyTable.delegate = self
        historyTable.dataSource = self
        historyTable.allowsSelection = false
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
        let navigationItem = UINavigationItem(title: "Risk Score History")
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
    
    func scrollToTop() {
        historyTable.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    
    func handleDone() {
        scrollToTop()
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
        cell.textLabel?.text = String(describingDate: questionnaireResponse.date! as Date)
        cell.textLabel?.textColor = .dark
        cell.detailTextLabel?.text = String(describing: questionnaireResponse.riskScore)
        cell.detailTextLabel?.textColor = .medium
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let questionnaireResponse = questionnaireResponses[indexPath.row]
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.questionnaireResponses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            QuestionnaireResponse.delete(response: questionnaireResponse)
        }
        delete.backgroundColor = .red
        
        let share = UITableViewRowAction(style: .destructive, title: "Share") { (action, indexPath) in
            self.delegate?.share(questionnaireResponse: questionnaireResponse)
            tableView.setEditing(false, animated: true)
        }
        share.backgroundColor = .violet
        
        return [delete, share]
    }
}
