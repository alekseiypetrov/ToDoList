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
    var tasks: [Task] = []
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
        if isFirstLaunch() {
            loadDataFromServer()
        }
        loadDataFromCoreData()
    }
    
    private func loadDataFromCoreData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tasks = CoreDataManager.shared.fetchTasks()
            self.delegate?.didLoadTodos()
        }
    }
    
    private func saveToCoreData(tasks: [SingleTask]) {
        for task in tasks {
            _ = CoreDataManager.shared.createTask(
                title: "Задача №\(task.id)",
                details: task.todo,
                date: UserDateFormatter.configDate(for: Date.now),
                completed: task.completed)
        }
    }
    
    private func loadDataFromServer() {
        todosLoader.loadTodos { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let todosList):
                    self.saveToCoreData(tasks: todosList.items)
                case .failure(let error): break
                    self.delegate?.didFailToLoadTodos(with: error)
                }
            }
        }
    }
}
