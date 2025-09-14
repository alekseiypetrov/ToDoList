import UIKit

final class SingleTaskBuilder {
    static func build(basedOn cell: Task, with index: Int, onSave: ((Task, Int) -> Void)?) -> SingleTaskViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(
            identifier: "SingleTask"
        ) as? SingleTaskViewController 
        else {
            fatalError("Cannot instantiate SingleTaskViewController from storyboard")
        }
        let presenter = SingleTaskPresenter(task: cell, taskIndex: index, onSave: onSave)
        viewController.presenter = presenter
        return viewController
    }
}
