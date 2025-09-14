import UIKit

protocol SingleTaskRouterProtocol: AnyObject {
    func dismiss()
}

final class SingleTaskRouter: SingleTaskRouterProtocol {
    private weak var viewController: SingleTaskViewController?
    
    init(_ viewController: SingleTaskViewControllerProtocol?) {
        guard let viewController = viewController as? SingleTaskViewController
        else {
            self.viewController = nil
            return
        }
        self.viewController = viewController
    }
    
    func dismiss() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
