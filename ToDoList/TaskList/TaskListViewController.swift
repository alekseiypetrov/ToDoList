import UIKit

final class TaskListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var counterTasksLabel: UILabel!
    
    private let showSingleTaskSegue = "ShowSingleTask"
    private var todosFactory: TodosFactory?
    var toDoList: [Task] = []
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todosFactory = TodosFactory(todosLoader: TodosLoader(), delegate: self)
        todosFactory?.loadData()
        tableView.separatorColor = .gray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        setupFooter()
    }
    
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
    
    func setupFooter() {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier, 
                identifier == showSingleTaskSegue
        else {
            super.prepare(for: segue, sender: sender)
            return
        }
        guard let viewController = segue.destination as? SingleTaskViewController,
              let indexPath = sender as? IndexPath
        else {
            assertionFailure("Invalid segue destination or sender")
            return
        }
        let chosenTask = toDoList[indexPath.row]
        viewController.titleString = chosenTask.title
        viewController.date = UserDateFormatter.configDate(for: Date.now)
        viewController.descriptionString = chosenTask.details
        viewController.taskIndex = indexPath.row
        viewController.task = chosenTask
        viewController.onSave = { [weak self] updatedTask, index in
            guard let self = self else { return }
            DispatchQueue.main.async {
                CoreDataManager.shared.updateTask(from: self.toDoList[index], to: updatedTask)
                self.toDoList[index] = updatedTask
                self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        }
    }
    
    @IBAction func addTaskButtonPressed(_ sender: Any) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let currentCountOfTasks = Int(self.counterTasksLabel.text!.split(separator: " ")[0]) ?? 0
            self.setupCounterTasksLabel(with: currentCountOfTasks + 1)
            self.toDoList.append(
                CoreDataManager.shared.createTask(
                    title: "Новая задача",
                    details: "Описание",
                    date: UserDateFormatter.configDate(for: Date.now),
                    completed: false
                )
            )
        }
        tableView.reloadData()
    }
    
    func configCell(for cell: TaskListCell, with indexPath: IndexPath) {
        cell.titleOfTaskLabel.attributedText = nil
        cell.titleOfTaskLabel.text = nil
        cell.descriptionOfTaskLabel.text = nil
        cell.dateOfCreationLabel.text = nil
        let currentTask = toDoList[indexPath.row]
        cell.isTaskComleted = currentTask.completed
        cell.titleOfTaskLabel.text = currentTask.title
        cell.descriptionOfTaskLabel.text = currentTask.details
        cell.dateOfCreationLabel.text = currentTask.date
        cell.setButton()
        cell.setLabels()
        cell.onStatusToggle = { [weak self] in
            guard let self = self else { return }
            let index = indexPath.row
            let taskBefore = self.toDoList[index]
            DispatchQueue.main.async {
                self.toDoList[index].completed.toggle()
                CoreDataManager.shared.updateTask(from: taskBefore, to: self.toDoList[index])
            }
        }
    }
}


extension TaskListViewController: TodosFactoryDelegate {
    func didLoadTodos() {
        guard let todosFactory else { return }
        toDoList = todosFactory.tasks
        tableView.reloadData()
    }
    
    func didFailToLoadTodos(with error: Error) {
        print("Fail to load data: \(error)")
        toDoList = []
    }
}
