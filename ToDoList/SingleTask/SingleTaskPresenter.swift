import UIKit

final class SingleTaskPresenter {
    var taskIndex: Int!
    var task: Task!
    var onSave: ((Task, Int) -> Void)?

    private weak var viewController: SingleTaskViewControllerProtocol?
    private var router: SingleTaskRouterProtocol?
    
    init(task: Task, taskIndex: Int, onSave: ((Task, Int) -> Void)?) {
        self.task = task
        self.taskIndex = taskIndex
        self.onSave = onSave
    }
    
    func setup(viewController: SingleTaskViewControllerProtocol) {
        self.viewController = viewController
        self.router = SingleTaskRouter(viewController)
        self.viewController?.setupLabels(from: task)
    }
    
    func didTappedBackButton(title: String, details: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.saveChanges(title: title, details: details)
        }
        router?.dismiss()
    }
    
    func saveChanges(title: String, details: String) {
        task.title = title
        task.details = details
        onSave?(task, taskIndex)
    }
}
