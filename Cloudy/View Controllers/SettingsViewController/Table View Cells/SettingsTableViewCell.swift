import UIKit

class SettingsTableViewCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet var mainLabel: UILabel!

    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    // MARK: - Public API
    
    func configure(with presentable: SettingsPresentable) {
        mainLabel.text = presentable.text
        accessoryType = presentable.accessoryType
    }
    
}
