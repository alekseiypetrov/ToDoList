import UIKit

final class TaskListCell: UITableViewCell {
    static let reuseIdentifier = "TaskListCell"
    static let textColorOfCompletedTask = UIColor(red: 77.0 / 255.0, green: 85.0 / 255.0, blue: 94.0 / 255.0, alpha: 1.0)
    static let textColorOfNotCompletedTask = UIColor.white
    static let completedTaskImage = UIImage(named: "completed_button")!
    static let notCompletedTaskImage = UIImage(named: "not_completed_button")!
    
    var isTaskComleted: Bool = false
    
    @IBOutlet weak var tickButton: UIButton!
    @IBOutlet weak var titleOfTaskLabel: UILabel!
    @IBOutlet weak var descriptionOfTaskLabel: UILabel!
    @IBOutlet weak var dateOfCreationLabel: UILabel!
    
    func setButton() {
        let image = isTaskComleted ? TaskListCell.completedTaskImage : TaskListCell.notCompletedTaskImage
        tickButton.setImage(image, for: .normal)
    }
    
    func setLabels() {
        let textColor = isTaskComleted ? TaskListCell.textColorOfCompletedTask : TaskListCell.textColorOfNotCompletedTask
        titleOfTaskLabel.textColor = textColor
        descriptionOfTaskLabel.textColor = textColor
        
        if isTaskComleted {
            let attributedString = NSMutableAttributedString(string: titleOfTaskLabel.text ?? "")
            attributedString.addAttribute(.strikethroughStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            titleOfTaskLabel.attributedText = attributedString
        } else {
            let string = titleOfTaskLabel.text
            titleOfTaskLabel.attributedText = nil
            titleOfTaskLabel.text = string
        }
    }
    
    @IBAction func didTickButtonClicked(_ sender: Any) {
        isTaskComleted.toggle()
        
        setButton()
        setLabels()
    }
}
