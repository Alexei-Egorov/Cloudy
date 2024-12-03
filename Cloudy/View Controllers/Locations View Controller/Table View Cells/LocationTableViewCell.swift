import UIKit

class LocationTableViewCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet var mainLabel: UILabel!

    // MARK: - Configuration

    func configure(withViewModel viewModel: LocationPresentable) {
        mainLabel.text = viewModel.text
    }

}
