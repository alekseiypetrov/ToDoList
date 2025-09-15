import XCTest
@testable import ToDoList

final class TodosLoaderTests: XCTestCase {
    func testSuccessLoading() throws {
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = TodosLoader(networkClient: stubNetworkClient)
            
        let expectation = expectation(description: "Loading expectation")
            
        loader.loadTodos { result in
            switch result {
            case .success(let todos):
                XCTAssertEqual(todos.items.count, 2)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Unexpected failure")
            }
        }
        waitForExpectations(timeout: 1)
    }
        
    func testFailureLoading() throws {
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = TodosLoader(networkClient: stubNetworkClient)

        let expectation = expectation(description: "Loading expectation")
            
        loader.loadTodos { result in
            switch result {
            case .success(_):
                XCTFail("Unexpected success")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1)
    }
}
