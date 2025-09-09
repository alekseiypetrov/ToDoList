import UIKit

class TaskListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = .gray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    private func configDate(for date: Date) -> String {
        var stringDate = dateFormatter.string(from: date).split(separator: ".")
        return stringDate.joined(separator: "/")
    }
    
    private func configCell(for cell: TaskListCell, with indexPath: IndexPath) {
        if indexPath.row % 6 == 0 {
            cell.descriptionOfTaskLabel.text = "Обработка создания, загрузки, редактирования, удаления и поиска задач должна выполняться в фоновом потоке с использованием GCD или NSOperation"
        }
        if indexPath.row % 4 == 0 {
            cell.isTaskComleted.toggle()
        }
        cell.setButton()
        cell.setLabels()
        cell.dateOfCreationLabel.text = configDate(for: Date.now)
    }
}


extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCell = tableView.dequeueReusableCell(withIdentifier: TaskListCell.reuseIdentifier, for: indexPath)
        guard let taskListCell = currentCell as? TaskListCell else {
            return TaskListCell()
        }
        
        configCell(for: taskListCell, with: indexPath)
        
        return taskListCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}

extension TaskListViewController: UITableViewDelegate {
}
