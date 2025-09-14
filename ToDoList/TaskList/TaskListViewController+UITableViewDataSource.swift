import UIKit

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCell = tableView.dequeueReusableCell(withIdentifier: TaskListCell.reuseIdentifier, for: indexPath)
        guard let taskListCell = currentCell as? TaskListCell else {
            return TaskListCell()
        }
        presenter.configCell(for: taskListCell, with: indexPath)
        return taskListCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfTasks()
    }
}
