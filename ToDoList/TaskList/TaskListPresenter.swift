import UIKit

final class TaskListPresenter {
    private var toDoList: [Task] = []
    
    private weak var viewController: TaskListViewControllerProtocol?
    private var router: TaskListRouterProtocol?
    private var todosFactory: TodosFactory?
    
    init(viewController: TaskListViewControllerProtocol) {
        self.viewController = viewController
        self.router = TaskListRouter(viewController)
        self.todosFactory = TodosFactory(todosLoader: TodosLoader(), delegate: self)
        todosFactory?.loadData()
    }
    
    func didSelectTask(at index: Int) {
        let task = getTask(at: index)
        router?.showTaskDetail(from: task, at: index) { [weak self] updatedTask, index in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.updateTask(at: index, to: updatedTask)
            }
        }
    }
    
    func getNumberOfTasks() -> Int {
        let count = toDoList.count
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.viewController?.setupCounterTasksLabel(with: count)
        }
        return count
    }
    
    func getTask(at index: Int) -> Task {
        return toDoList[index]
    }
    
    func getFilteredTasks(by query: String) {
        let filtered = self.toDoList.filter { task in
            task.title?.lowercased().contains(query) ?? false
        }
        DispatchQueue.main.async {
            self.toDoList = filtered
            self.viewController?.updateTableView()
        }
    }
    
    func addNewTask() {
        toDoList.append(
            CoreDataManager.shared.createTask(
                title: "Новая задача",
                details: "Описание",
                date: UserDateFormatter.configDate(for: Date.now),
                completed: false
            )
        )
    }
    
    func updateTask(at index: Int, to updatedTask: Task) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            CoreDataManager.shared.updateTask(from: self.toDoList[index], to: updatedTask)
            self.toDoList[index] = updatedTask
            self.viewController?.updateTableView()
        }
    }
    
    func deleteTask(at indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            CoreDataManager.shared.deleteTask(self.toDoList[indexPath.row])
            self.toDoList.remove(at: indexPath.row)
            self.viewController?.deleteFromTableView(at: indexPath)
        }
    }
    
    func configCell(for cell: TaskListCell, with indexPath: IndexPath) {
        cell.titleOfTaskLabel.attributedText = nil
        cell.titleOfTaskLabel.text = nil
        cell.descriptionOfTaskLabel.text = nil
        cell.dateOfCreationLabel.text = nil
        let currentTask = toDoList[indexPath.row]
        cell.isTaskComleted = currentTask.completed
        cell.titleOfTaskLabel.text = currentTask.title
        cell.descriptionOfTaskLabel.text = currentTask.details
        cell.dateOfCreationLabel.text = currentTask.date
        cell.setButton()
        cell.setLabels()
        cell.onStatusToggle = { [weak self] in
            guard let self = self else { return }
            let index = indexPath.row
            let taskBefore = self.toDoList[index]
            DispatchQueue.main.async {
                self.toDoList[index].completed.toggle()
                CoreDataManager.shared.updateTask(from: taskBefore, to: self.toDoList[index])
            }
        }
    }
}

extension TaskListPresenter: TodosFactoryDelegate {
    func didLoadTodos() {
        guard let todosFactory else { return }
        toDoList = todosFactory.tasks
        viewController?.updateTableView()
    }
    
    func didFailToLoadTodos(with error: Error) {
        print("Fail to load data: \(error)")
        toDoList = []
        viewController?.updateTableView()
    }
}
