import Foundation
import UIKit
import CoreData

protocol TodosFactoryDelegate: AnyObject {
    func didLoadTodos()
    func didFailToLoadTodos(with: Error)
}


class TodosFactory {
    private let todosLoader: TodosLoading
    private weak var delegate: TodosFactoryDelegate?
    var tasks: [SingleTask] = []
    private let isFirstLaunchKey = "isFirstLaunch"
    
    init(todosLoader: TodosLoading, delegate: TodosFactoryDelegate) {
        self.todosLoader = todosLoader
        self.delegate = delegate
    }

    private func isFirstLaunch() -> Bool {
        let launchedBefore = UserDefaults.standard.bool(forKey: isFirstLaunchKey)
        if !launchedBefore {
            UserDefaults.standard.set(true, forKey: isFirstLaunchKey)
        }
        return !launchedBefore
    }
    
    func loadData() {
        loadDataFromServer()
//            self.isFirstLaunch() ? self.loadDataFromServer() : self.loadDataFromCoreData()
    }
    
    func loadDataFromCoreData() {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let request: NSFetchRequest<Task> = Task.fetchRequest()
//            
//        do {
//            let tasks = try context.fetch(request)
//            self.tasks = tasks
//        } catch {
//            print("Ошибка загрузки: \(error)")
//            self.tasks = []
//        }
    }
    
    func loadDataFromServer() {
        todosLoader.loadTodos { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let todosList):
                    self.tasks = todosList.items
                    self.delegate?.didLoadTodos()
                case .failure(let error): break
                    self.delegate?.didFailToLoadTodos(with: error)
                }
            }
            
        }
    }
}
