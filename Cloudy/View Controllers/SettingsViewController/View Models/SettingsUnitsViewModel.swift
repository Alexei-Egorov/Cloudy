import UIKit

struct SettingsUnitsViewModel {

    // MARK: - Properties

    let unitsNotation: UnitsNotation

    // MARK: - Public API

    var text: String {
        switch unitsNotation {
        case .imperial: return "Imperial"
        case .metric: return "Metric"
        }
    }

    var accessoryType: UITableViewCell.AccessoryType {
        if UserDefaults.unitsNotation == unitsNotation {
            return .checkmark
        } else {
            return .none
        }
    }
    
}

extension SettingsUnitsViewModel: SettingsPresentable {

}
