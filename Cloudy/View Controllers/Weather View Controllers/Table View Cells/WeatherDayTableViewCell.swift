import UIKit

class WeatherDayTableViewCell: UITableViewCell {

    // MARK: - Properties

    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!

    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
    }

    // MARK: - Public API
    
    func configure(with presentable: WeatherDayPresentable) {
        iconImageView.image = presentable.image
        dayLabel.text = presentable.day
        dateLabel.text = presentable.date
        windSpeedLabel.text = presentable.windSpeed
        temperatureLabel.text = presentable.temperature
    }
    
}
