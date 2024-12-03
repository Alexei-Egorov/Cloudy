import UIKit

protocol WeatherDayPresentable {
    
    // MARK: - Properties
    
    var day: String { get }
    var date: String { get }
    var image: UIImage? { get }
    var windSpeed: String { get }
    var temperature: String { get }
    
}
