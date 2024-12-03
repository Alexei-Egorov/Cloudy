import Foundation

struct WeatherDayData: Decodable {

    // MARK: - Properties
    
    let time: Date
    let icon: String
    let windSpeed: Double
    let temperatureMin: Double
    let temperatureMax: Double

}
