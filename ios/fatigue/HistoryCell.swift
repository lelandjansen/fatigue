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
        super.init(coder: aDecoder)
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
        if !questionnaireResponses.isEmpty {
            historyTable.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
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
    
    let mountainImage: UIImageView = {
        return UIImageView(image: #imageLiteral(resourceName: "mountains"))
    }()
    
    let helicopterImage: UIImageView = {
        return UIImageView(image: #imageLiteral(resourceName: "helicopter"))
    }()
    
    let creditLabel: UILabel = {
        let label = UILabel()
        label.text = "Designed by Leland Jansen"
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .light
        return label
    }()
    
    func setupViews() {
        addSubview(historyTable)
        addSubview(navigationBar)
        addSubview(mountainImage)
        addSubview(helicopterImage)
        addSubview(creditLabel)
        
        historyTable.anchorToTop(
            navigationBar.bottomAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
        
        let mountainOffset: CGFloat = 80
        let aspectRatio = mountainImage.image!.size.width / mountainImage.image!.size.height
        mountainImage.translatesAutoresizingMaskIntoConstraints = false
        mountainImage.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        mountainImage.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / aspectRatio).isActive = true
        mountainImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        mountainImage.topAnchor.constraint(equalTo: bottomAnchor, constant: mountainOffset).isActive = true
        
        let helicopterOffset: CGFloat = 25
        helicopterImage.anchorWithConstantsToTop(
            bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            topConstant: mountainOffset - 16,
            leftConstant: (self.frame.width - helicopterImage.frame.width) / 2 + helicopterOffset,
            rightConstant: (self.frame.width - helicopterImage.frame.width) / 2 - helicopterOffset
        )
        
        creditLabel.anchorWithConstantsToTop(
            bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            topConstant: mountainOffset + 80
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
        UserDefaults.standard.userTriedEditingRow = true
        let questionnaireResponse = questionnaireResponses[indexPath.row]
        let cell = historyTable.cellForRow(at: indexPath)!
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.delegate?.confirmDeleteHistoryItem(questionnaireResponse, forTableView: tableView, atIndexPath: indexPath, withPopoverSourceView: cell, deleteCompletion: self.deleteHistoryTableItem)
        }
        delete.backgroundColor = .red
        let share = UITableViewRowAction(style: .destructive, title: "Share") { (action, indexPath) in
            self.delegate?.shareHistoryItem(questionnaireResponse, withPopoverSourceView: cell, completion: { _ in
                tableView.setEditing(false, animated: true)
            })
        }
        share.backgroundColor = .violet
        return [delete, share]
    }
    
    func deleteHistoryTableItem(inTableView tableView: UITableView, atIndexPath indexPath: IndexPath) {
        let questionnaireResponse = questionnaireResponses[indexPath.row]
        questionnaireResponses.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        QuestionnaireResponse.delete(response: questionnaireResponse)
    }
    
    func showRowEditTutorial() {
        if questionnaireResponses.isEmpty {
            return
        }
        let translation: CGFloat = 32
        let indexPath = IndexPath(row: 0, section: 0)
        if let cell = historyTable.cellForRow(at: indexPath) {
            UIView.animate(
                withDuration: 1 / 3,
                delay: 1 / 2,
                options: [.allowAnimatedContent, .curveEaseInOut, .allowUserInteraction],
                animations: {
                    cell.frame = CGRect(x: cell.frame.origin.x - translation,
                                        y: cell.frame.origin.y,
                                        width: cell.bounds.width,
                                        height: cell.bounds.height)
                }
            ) { finished in
                if finished {
                    UIView.animate(
                        withDuration: 1 / 3,
                        animations: {
                            cell.frame = CGRect(x: cell.frame.origin.x + translation,
                                                y: cell.frame.origin.y,
                                                width: cell.bounds.width,
                                                height: cell.bounds.height)
                        }
                    )
                }
            }
        }
    }
}
