import Foundation

class TodosLoader {
    private let networkClient: NetworkClient
    private var todosUrl: URL {
            guard let url = URL(string: "https://dummyjson.com/todos") else {
                preconditionFailure("Unable to construct todosUrl")
            }
            return url
        }
    
    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func loadTodos(handler: @escaping (Result<Tasks, Error>) -> Void) {
        networkClient.fetch(url: todosUrl) {result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let data):
                do {
                    let tasks = try JSONDecoder().decode(Tasks.self, from: data)
                    handler(.success(tasks))
                } catch {
                    handler(.failure(error))
                }
            }
        }
    }
}

