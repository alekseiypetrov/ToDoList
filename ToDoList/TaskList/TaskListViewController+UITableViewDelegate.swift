import UIKit

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectTask(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let cell = tableView.cellForRow(at: indexPath) as? TaskListCell else { return nil }
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: { return self.createPreviewVC(for: cell) }
        ) { _ in
            let edit = UIAction(title: "Редактировать", image: UIImage(named: "edit")) { [weak self] _ in
                guard let self = self else { return }
                self.presenter.didSelectTask(at: indexPath.row)
            }
            let share = UIAction(title: "Поделиться", image: UIImage(named: "export")) { [weak self] _ in
                guard let title = cell.titleOfTaskLabel.text,
                      let date = cell.dateOfCreationLabel.text,
                      let description = cell.descriptionOfTaskLabel.text,
                      let self = self
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
            let delete = UIAction(title: "Удалить", image: UIImage(named: "trash"), attributes: .destructive) { [weak self] _ in
                guard let self = self else { return }
                self.presenter.deleteTask(at: indexPath)
            }
            return UIMenu(title: "", children: [edit, share, delete])
        }
    }
    
    private func createPreviewVC(for taskListCell: TaskListCell) -> UIViewController? {
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
