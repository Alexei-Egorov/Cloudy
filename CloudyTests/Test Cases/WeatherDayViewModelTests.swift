import XCTest
@testable import Cloudy

class WeatherDayViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    var viewModel: WeatherDayViewModel!
    
    // MARK: - Set Up & Tear Down
    
    override func setUpWithError() throws {
        let data = loadStub(name: "weather", extension: "json")
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let weatherData = try decoder.decode(WeatherData.self, from: data)
        
        viewModel = WeatherDayViewModel(weatherDayData: weatherData.dailyData[5])
    }

    override func tearDownWithError() throws {
        UserDefaults.standard.removeObject(forKey: "unitsNotation")
        UserDefaults.standard.removeObject(forKey: "temperatureNotation")
    }
    
    // MARK: - Tests for Day

    func testDay() {
        XCTAssertEqual(viewModel.day, "Saturday")
    }

    // MARK: - Tests for Date

    func testDate() {
        XCTAssertEqual(viewModel.date, "June 27")
    }

    // MARK: - Tests for Temperature

    func testTemperature_Fahrenheit() {
        let temperatureNotation: TemperatureNotation = .fahrenheit
        UserDefaults.standard.set(temperatureNotation.rawValue, forKey: "temperatureNotation")
        XCTAssertEqual(viewModel.temperature, "65 °F - 83 °F")
    }

    func testTemperature_Celsius() {
        let temperatureNotation: TemperatureNotation = .celsius
        UserDefaults.standard.set(temperatureNotation.rawValue, forKey: "temperatureNotation")
        XCTAssertEqual(viewModel.temperature, "18 °C - 28 °C")
    }

    // MARK: - Tests for Wind Speed

    func testWindSpeed_Imperial() {
        let unitsNotation: UnitsNotation = .imperial
        UserDefaults.standard.set(unitsNotation.rawValue, forKey: "unitsNotation")
        XCTAssertEqual(viewModel.windSpeed, "6 MPH")
    }

    func testWindSpeed_Metric() {
        let unitsNotation: UnitsNotation = .metric
        UserDefaults.standard.set(unitsNotation.rawValue, forKey: "unitsNotation")
        XCTAssertEqual(viewModel.windSpeed, "10 KPH")
    }

    // MARK: - Tests for Image

    func testImage() {
        let viewModelImage = viewModel.image
        let imageDataViewModel = viewModelImage!.pngData()!
        let imageDataReference = UIImage(named: "clear-day")!.pngData()!

        XCTAssertNotNil(viewModelImage)
        XCTAssertEqual(viewModelImage!.size.width, 236.0)
        XCTAssertEqual(viewModelImage!.size.height, 236.0)
        XCTAssertEqual(imageDataViewModel, imageDataReference)
    }
    
}
