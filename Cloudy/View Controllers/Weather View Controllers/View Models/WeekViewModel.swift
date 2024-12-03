import UIKit

struct WeekViewModel {

    // MARK: - Properties

    let weatherData: [WeatherDayData]

    // MARK: - Public API

    var numberOfSections: Int {
        1
    }

    var numberOfDays: Int {
        weatherData.count
    }
    
    func viewModel(for index: Int) -> WeatherDayViewModel {
        WeatherDayViewModel(weatherDayData: weatherData[index])
    }

}
