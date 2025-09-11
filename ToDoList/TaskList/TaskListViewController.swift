import UIKit

final class TaskListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var counterTasksLabel: UILabel!
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    private let showSingleTaskSegue = "ShowSingleTask"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counterTasksLabel.text = "0 задач"
        tableView.separatorColor = .gray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        setupFooter()
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
        viewController.titleString = "title"
        viewController.date = "date"
        viewController.descriptionString = "description"
    }
    
    @IBAction func addTaskButtonPressed(_ sender: Any) {
        let currentCountOfTasks = Int(counterTasksLabel.text!.split(separator: " ")[0]) ?? 0
        var word = ""
        if currentCountOfTasks == 0 {
            word = "задача"
        } else if currentCountOfTasks < 4 {
            word = "задачи"
        } else {
            word = "задач"
        }
        counterTasksLabel.text = "\(currentCountOfTasks + 1) \(word)"
        // реализация добавления задачи позже
    }
    
    private func configDate(for date: Date) -> String {
        var stringDate = dateFormatter.string(from: date).split(separator: ".")
        if stringDate[2].count > 2 {
            stringDate[2] = stringDate[2].dropFirst(2)
        }
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
    
    func createPreviewVC(for taskListCell: TaskListCell) -> UIViewController? {
        let previewVC = UIViewController()
        previewVC.view.backgroundColor = UIColor(red: 39.0 / 255.0, green: 39.0 / 255.0, blue: 41.0 / 255.0, alpha: 1.0)
        previewVC.view.layer.cornerRadius = 12.0
        previewVC.view.layer.masksToBounds = true
        
        let title = UILabel()
        let description = UILabel()
        let date = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        description.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
        previewVC.view.addSubview(title)
        previewVC.view.addSubview(description)
        previewVC.view.addSubview(date)
        
        title.textColor = .white
        description.textColor = .white
        description.numberOfLines = 2
        date.textColor = TaskListCell.textColorOfCompletedTask
        
        title.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        description.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        date.font = UIFont.systemFont(ofSize: 12, weight: .regular)

        title.text = taskListCell.titleOfTaskLabel.text
        description.text = taskListCell.descriptionOfTaskLabel.text
        date.text = taskListCell.dateOfCreationLabel.text
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: previewVC.view.topAnchor, constant: 12),
            title.leadingAnchor.constraint(equalTo: previewVC.view.leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: previewVC.view.trailingAnchor, constant: -16),
            title.heightAnchor.constraint(equalToConstant: 22),
            description.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 6),
            description.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            description.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            description.heightAnchor.constraint(greaterThanOrEqualToConstant: 16.0),
            description.heightAnchor.constraint(lessThanOrEqualToConstant: 32.0),
            date.topAnchor.constraint(equalTo: description.bottomAnchor, constant: 6),
            date.bottomAnchor.constraint(equalTo: previewVC.view.bottomAnchor, constant: -12),
            date.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            date.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            date.heightAnchor.constraint(equalToConstant: 16)
        ])
        let targetSize = CGSize(width: UIScreen.main.bounds.width - 40, height: UIView.layoutFittingCompressedSize.height)
        let fittingSize = previewVC.view.systemLayoutSizeFitting(targetSize,
                                                                 withHorizontalFittingPriority: .required,
                                                                 verticalFittingPriority: .fittingSizeLevel)
        previewVC.preferredContentSize = fittingSize
        return previewVC
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleTaskSegue, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let cell = tableView.cellForRow(at: indexPath) as? TaskListCell else { return nil }
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: { return self.createPreviewVC(for: cell) }
        ) { _ in
            let edit = UIAction(title: "Редактировать", image: UIImage(named: "edit")) { _ in
                self.performSegue(withIdentifier: self.showSingleTaskSegue, sender: indexPath)
            }
            let share = UIAction(title: "Поделиться", image: UIImage(named: "export")) { _ in
                guard let title = cell.titleOfTaskLabel.text,
                      let date = cell.dateOfCreationLabel.text,
                      let description = cell.descriptionOfTaskLabel.text
                else { return }
                let activityView = UIActivityViewController(
                    activityItems: [
                        """
                        \(title)
                        \(date)
                        \(description)
                        """],
                    applicationActivities: nil
                )
                self.present(activityView, animated: true)
            }
            let delete = UIAction(title: "Удалить", image: UIImage(named: "trash"), attributes: .destructive) { _ in
                // реализация удаления позже
                print("Удалить задачу: \(indexPath.row)")
            }
            return UIMenu(title: "", children: [edit, share, delete])
        }
    }
}
