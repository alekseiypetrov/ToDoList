import Foundation


class TodosFactory {
    private let todosLoader: TodosLoader
    private var tasks: [SingleTask] = []
    // делегат
    
    init(todosLoader: TodosLoader) {
        self.todosLoader = todosLoader
    }
    
    func loadData() {
        todosLoader.loadTodos { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let todosList):
                    self.tasks = todosList.items
//                    self.delegate?.didLoadDataFromServer()
                case .failure(let error): break
//                    self.delegate?.didFailToLoadData(with: error)
                }
            }
            
        }
    }
}
