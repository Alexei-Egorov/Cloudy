import UIKit

struct SettingsTemperatureViewModel {

    // MARK: - Properties

    let temperatureNotation: TemperatureNotation

    // MARK: - Public Interface

    var text: String {
        switch temperatureNotation {
        case .fahrenheit: return "Fahrenheit"
        case .celsius: return "Celsius"
        }
    }

    var accessoryType: UITableViewCell.AccessoryType {
        if UserDefaults.temperatureNotation == temperatureNotation {
            return .checkmark
        } else {
            return .none
        }
    }
    
}

extension SettingsTemperatureViewModel: SettingsPresentable {

}
