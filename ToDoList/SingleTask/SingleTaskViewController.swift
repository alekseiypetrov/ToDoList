import UIKit

final class SingleTaskViewController: UIViewController {
    var taskIndex: Int!
    var task: SingleTask!
    var onSave: ((SingleTask, Int) -> Void)?

    var titleString: String? {
        didSet {
            guard isViewLoaded else {
                return
            }
            taskTitle.text = title
        }
    }
    var date: String? {
        didSet {
            guard isViewLoaded else {
                return
            }
            dateCreation.text = date
        }
    }
    var descriptionString: String? {
        didSet {
            guard isViewLoaded else {
                return
            }
            descriptionField.text = descriptionString
        }
    }
    
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var dateCreation: UILabel!
    @IBOutlet weak var descriptionField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let titleString, 
                let descriptionString,
                let date
        else { return }
        taskTitle.text = titleString
        descriptionField.text = descriptionString
        dateCreation.text = date
    }
    
    @IBAction func didBackButtonPressed(_ sender: Any) {
        task.todo = descriptionField.text
        onSave?(task, taskIndex)
        dismiss(animated: true, completion: nil)
    }
}
