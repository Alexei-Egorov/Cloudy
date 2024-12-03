import UIKit

protocol SettingsPresentable {

    // MARK: - Properties
    
    var text: String { get }
    
    // MARK: -
    
    var accessoryType: UITableViewCell.AccessoryType { get }

}
