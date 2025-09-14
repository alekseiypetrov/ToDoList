import UIKit

extension TaskListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            didLoadTodos()
            tableView.reloadData()
        } else {
            isSearching = true
            let query = searchText.lowercased()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self = self else { return }
                let filtered = self.toDoList.filter { task in
                    task.title?.lowercased().contains(query) ?? false
                }
                DispatchQueue.main.async {
                    self.toDoList = filtered
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
