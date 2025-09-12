struct Tasks: Codable {
    var items: [SingleTask]
    
    private enum CodingKeys: String, CodingKey {
        case items = "todos"
    }
}

struct SingleTask: Codable {
    let id: Int
    var todo: String
    var completed: Bool
}
