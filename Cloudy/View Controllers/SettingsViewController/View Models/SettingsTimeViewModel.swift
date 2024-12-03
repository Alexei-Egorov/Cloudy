import UIKit

struct SettingsTimeViewModel {

    // MARK: - Properties

    let timeNotation: TimeNotation

    // MARK: - Public API
    
    var text: String {
        switch timeNotation {
        case .twelveHour: return "12 Hour"
        case .twentyFourHour: return "24 Hour"
        }
    }
    
    var accessoryType: UITableViewCell.AccessoryType {
        if UserDefaults.timeNotation == timeNotation {
            return .checkmark
        } else {
            return .none
        }
    }

}

extension SettingsTimeViewModel: SettingsPresentable {

}
