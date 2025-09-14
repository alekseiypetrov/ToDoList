import UIKit

protocol SingleTaskViewControllerProtocol: AnyObject {
    func setupLabels(from task: Task)
}

final class SingleTaskViewController: UIViewController, SingleTaskViewControllerProtocol {
    var presenter: SingleTaskPresenter!

    @IBOutlet private weak var taskTitle: UITextField!
    @IBOutlet private weak var dateCreation: UILabel!
    @IBOutlet private weak var descriptionField: UITextView!
    
    // MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setup(viewController: self)
    }
    
    // MARK: - Updating UI
    
    func setupLabels(from task: Task) {
        taskTitle.text = task.title
        descriptionField.text = task.details
        dateCreation.text = task.date
    }
    
    // MARK: - Actions
    
    @IBAction func didBackButtonPressed(_ sender: Any) {
        presenter.didTappedBackButton(
            title: taskTitle.text ?? "",
            details: descriptionField.text ?? ""
        )
    }
}
