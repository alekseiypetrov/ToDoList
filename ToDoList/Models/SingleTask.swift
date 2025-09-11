struct Tasks: Codable {
    let errorMessage: String
    let items: [SingleTask]
}

struct SingleTask: Codable {
    let title: Int
    let description: String
    let completed: Bool
    
    private enum CodingKeys: String, CodingKey {
        case title = "id"
        case description = "todo"
        case completed = "completed"
    }
}
