import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}

struct NetworkClient: NetworkRouting {
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                handler(.failure(error))
                return
            }
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            guard let data = data else { return }
            handler(.success(data))
        }
        task.resume()
    }
}

struct StubNetworkClient: NetworkRouting {
    enum TestError: Error {
        case test
    }
    
    let emulateError: Bool
    
    var expectedResponce: Data {
        """
        {
            "todos" : [
                {
                    "id" : 1,
                    "todo" : "Do something nice for someone you care about",
                    "completed" : false,
                    "userId" : 152
                },
                {
                    "id" : 2,
                    "todo" : "Memorize a poem",
                    "completed" : true,
                    "userId" : 13
                }
            ],
            "total" : 254,
            "skip" : 0,
            "limit" : 30
        }
        """.data(using: .utf8) ?? Data()
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        if emulateError {
            handler(.failure(TestError.test))
        } else {
            handler(.success(expectedResponce))
        }
    }
}
