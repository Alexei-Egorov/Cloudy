import XCTest
@testable import Cloudy

class WeekViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    var viewModel: WeekViewModel!
    
    // MARK: - Set Up & Tear Down
    
    override func setUpWithError() throws {
        let data = loadStub(name: "weather", extension: "json")
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let weatherData = try decoder.decode(WeatherData.self, from: data)
        
        viewModel = WeekViewModel(weatherData: weatherData.dailyData)
    }

    override func tearDownWithError() throws {
        
    }
    
    // MARK: - Tests for Number of Sections
    
    func testNumberOfSections() {
        XCTAssertEqual(viewModel.numberOfSections, 1)
    }
    
    // MARK: - Tests for Number of Days

    func testNumberOfDays() {
        XCTAssertEqual(viewModel.numberOfDays, 8)
    }
    
    // MARK: - Tests for View Model for Index

    func testViewModelForIndex() {
        let weatherDayViewModel = viewModel.viewModel(for: 5)

        XCTAssertEqual(weatherDayViewModel.day, "Saturday")
        XCTAssertEqual(weatherDayViewModel.date, "June 27")
    }

}
