import Foundation

class UserDateFormatter {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    static func configDate(for date: Date) -> String {
        var stringDate = dateFormatter.string(from: date).split(separator: ".")
        if stringDate.count == 1 {
            return String(stringDate[0])
        }
        stringDate[2] = stringDate[2].dropFirst(2)
        return stringDate.joined(separator: "/")
    }
}
