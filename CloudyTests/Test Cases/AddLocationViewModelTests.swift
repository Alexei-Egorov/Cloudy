import XCTest
import Combine
@testable import Cloudy

final class AddLocationViewModelTests: XCTestCase {
    
    // MARK: - Types
    
    private class MockLocationService: LocationService {
        
        func geocode(addressString: String, completion: @escaping Completion) {
            if addressString.isEmpty {
                completion(.success([]))
            } else {
                completion(.success([.brussels]))
            }
        }
    }
    
    var viewModel: AddLocationViewModel!
    
    var subscriptions = Set<AnyCancellable>()

    override func setUpWithError() throws {
        let locationService = MockLocationService()
        viewModel = AddLocationViewModel(locationService: locationService)
    }

    override func tearDownWithError() throws {
        
    }
    
    // MARK: - Tests for Locations Publisher
    
    func testLocationsPublisher_HasLocations() {
        let expectation  = self.expectation(description: "Has Locations")
        
        let expectedValues: [[Location]] = [
            [],
            [.brussels]
        ]
        
        viewModel.locationsPublisher
            .collect(2)
            .sink { result in
                if result == expectedValues {
                    expectation.fulfill()
                }
            }.store(in: &subscriptions)
        
        viewModel.query = "Brus"
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLocationsPublisher_NoLocations() {
        let expectation  = self.expectation(description: "No Locations")
        
        let expectedValues: [[Location]] = [
            [],
            []
        ]
        
        viewModel.locationsPublisher
            .collect(2)
            .sink { result in
                if result == expectedValues {
                    expectation.fulfill()
                }
            }.store(in: &subscriptions)
        
        viewModel.query = ""
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // MARK: - Tests for Location At Index
    
    func testLocationAtIndex_NotNil() {
        let expectation = self.expectation(description: "Location Not Nil")
        
        viewModel.locationsPublisher
            .collect(2)
            .sink { [weak self] _ in
                if let location = self?.viewModel.location(at: 0), location.name == Location.brussels.name {
                    expectation.fulfill()
                }
            }.store(in: &subscriptions)
        
        viewModel.query = "Brus"
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLocationAtIndex_Nil() {
        let expectation = self.expectation(description: "Location Nil")
        
        viewModel.locationsPublisher
            .collect(2)
            .sink { [weak self] _ in
                if  self?.viewModel.location(at: 0) == nil {
                    expectation.fulfill()
                }
            }.store(in: &subscriptions)
        
        viewModel.query = ""
        
        wait(for: [expectation], timeout: 1.0)
    }
}

fileprivate extension Location {
    
    static var brussels: Location {
        Location(name: "Brussels", latitude: 50.8503, longitude: 4.3517)
    }
}
