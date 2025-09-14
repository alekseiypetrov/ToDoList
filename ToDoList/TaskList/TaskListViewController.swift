import UIKit

protocol TaskListViewControllerProtocol: AnyObject {
    func setupCounterTasksLabel(with number: Int?)
    func updateTableView()
    func deleteFromTableView(at indexPath: IndexPath)
}

final class TaskListViewController: UIViewController, TaskListViewControllerProtocol {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var footerView: UIView!
    @IBOutlet private weak var counterTasksLabel: UILabel!
    
    var presenter: TaskListPresenter!
    
    // MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = TaskListPresenter(viewController: self)
        tableView.separatorColor = .gray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        setupFooter()
    }
    
    // MARK: - Updating UI
    
    func setupCounterTasksLabel(with number: Int?) {
        guard let number else {
            counterTasksLabel.text = "0 задач"
            return
        }
        var word = ""
        if number == 1 {
            word = "задача"
        } else if 1 < number && number < 5 {
            word = "задачи"
        } else {
            word = "задач"
        }
        counterTasksLabel.text = "\(number) \(word)"
    }
    
    func updateTableView() {
        tableView.reloadData()
    }
    
    func deleteFromTableView(at indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    private func setupFooter() {
        footerView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(footerView)

        NSLayoutConstraint.activate([
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 84),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @IBAction private func addTaskButtonPressed(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.presenter.addNewTask()
            self.tableView.reloadData()
        }
    }
}
