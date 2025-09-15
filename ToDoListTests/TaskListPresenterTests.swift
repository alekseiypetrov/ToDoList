import XCTest
@testable import ToDoList

final class TaskListViewControllerMock: TaskListViewControllerProtocol {
    func setupCounterTasksLabel(with number: Int?) {
    }
    
    func updateTableView() {
    }
    
    func deleteFromTableView(at indexPath: IndexPath) {
    }
}

final class TaskListPresenterTests: XCTestCase {
    private var toDoList: [MockTask] = []
    
    private func getFilteredTasks(by query: String) -> [MockTask] {
        return self.toDoList.filter { task in
            task.title?.lowercased().contains(query) ?? false
        }
        
    }
    
    func testFilteringTasks() throws {
        toDoList = [
            MockTask(title: "Утренняя зарядка", date: "01/09/2025"),
            MockTask(title: "Убраться дома", date: "01/09/2025"),
            MockTask(title: "Задача №3", date: "02/09/2025"),
            MockTask(title: "Приготовить ужин", date: "10/09/2025"),
            MockTask(title: "Сходить на тренировку", date: "11/09/2025"),
        ]
        
        let filtered = getFilteredTasks(by: "ЗА".lowercased())
        
        XCTAssert(filtered.count == 2)
    }
    
    func getTask(at index: Int) -> MockTask? {
        return index < toDoList.count ? toDoList[index] : nil
    }
    
    func testFailingGettingASingleTask() throws {
        toDoList = []
        
        let element = getTask(at: 5)
        
        XCTAssertNil(element)
    }
    
    
    func testSuccesGettingASingleTask() throws {
        toDoList = [
            MockTask(title: "Утренняя зарядка", date: "01/09/2025"),
            MockTask(title: "Убраться дома", date: "01/09/2025"),
            MockTask(title: "Задача №3", date: "02/09/2025"),
            MockTask(title: "Приготовить ужин", date: "10/09/2025"),
            MockTask(title: "Сходить на тренировку", date: "11/09/2025"),
        ]
        
        let element = getTask(at: 3)
        
        XCTAssertEqual(element!, toDoList[3])
    }
    
    func testGettingCountOfTasks() throws {
        let viewController = TaskListViewControllerMock()
        let presenter = TaskListPresenter(viewController: viewController)
        
        let count = presenter.getNumberOfTasks()
        
        XCTAssertEqual(count, 0)
    }
}


struct MockTask: Equatable {
    var title: String?
    let details: String = ""
    var date: String
    let completed: Bool = false
}
