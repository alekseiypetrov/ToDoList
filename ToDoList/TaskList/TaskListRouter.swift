import UIKit

protocol TaskListRouterProtocol: AnyObject {
    func showTaskDetail(from cell: Task, at index: Int, onSave: ((Task, Int) -> Void)?)
}

final class TaskListRouter: TaskListRouterProtocol {
    private var viewController: TaskListViewController?
    
    init(_ viewController: TaskListViewControllerProtocol?) {
        guard let viewController = viewController as? TaskListViewController
        else {
            self.viewController = nil
            return
        }
        self.viewController = viewController
    }
    
    func showTaskDetail(from cell: Task, at index: Int, onSave: ((Task, Int) -> Void)?) {
        let detailVC = SingleTaskBuilder.build(basedOn: cell, with: index, onSave: onSave)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
