import UIKit
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func saveContext() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func createTask(title: String, details: String, date: String, completed: Bool = false) -> Task {
        let task = Task(context: context)
        task.title = title
        task.details = details
        task.date = date
        task.completed = completed
        saveContext()
        return task
    }
    
    func fetchTasks() -> [Task] {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "completed", ascending: true),
            NSSortDescriptor(key: "date", ascending: false)
        ]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Ошибка загрузки: \(error)")
            return []
        }
    }
    
    func updateTask(from taskBefore: Task, to taskAfter: Task) {
        taskBefore.title = taskAfter.title
        taskBefore.details = taskAfter.details
        taskBefore.completed = taskAfter.completed
        saveContext()
    }
    
    func deleteTask(_ task: Task) {
        context.delete(task)
        saveContext()
    }
}
