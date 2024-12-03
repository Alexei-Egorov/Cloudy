import Combine
import Foundation

class AddLocationViewModel {

    // MARK: - Properties

    @Published var query: String = ""
    
    // MARK: -

    @Published private(set) var querying = false
    
    // MARK: -
    
    private var locations: [Location] {
        get {
            locationsSubject.value
        }
        set {
            locationsSubject.value = newValue
        }
    }

    var locationsPublisher: AnyPublisher<[Location], Never> {
        locationsSubject.eraseToAnyPublisher()
    }

    private let locationsSubject = CurrentValueSubject<[Location], Never>([])

    var hasLocations: Bool {
        numberOfLocations > 0
    }
    
    var numberOfLocations: Int {
        locations.count
    }

    // MARK: -

    private let locationService: LocationService
    
    // MARK: -
    
    private var subscriptions: Set<AnyCancellable> = []

    // MARK: - Initialization

    init(locationService: LocationService) {
        self.locationService = locationService
        
        setupBindings()
    }

    // MARK: - Public API
    
    func location(at index: Int) -> Location? {
        guard index < locations.count else {
            return nil
        }
        
        return locations[index]
    }

    func viewModelForLocation(at index: Int) -> LocationPresentable? {
        guard let location = location(at: index) else {
            return nil
        }
        
        return LocationViewModel(location: location.location, locationAsString: location.name)
    }
    
    // MARK: - Helper Methods
    
    private func setupBindings() {
        $query
            .removeDuplicates()
            .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
            .sink { [weak self] (addressString) in
                self?.geocode(addressString: addressString)
            }.store(in: &subscriptions)
    }

    private func geocode(addressString: String?) {
        guard let addressString = addressString, !addressString.isEmpty else {
            locations = []
            return
        }
        
        querying = true
        
        locationService.geocode(addressString: addressString) { [weak self] (result) in
            self?.querying = false
            
            switch result {
            case .success(let locations):
                self?.locations = locations
            case .failure(let error):
                self?.locations = []
                
                print("Unable to Forward Geocode Address: \(error)")
            }
        }
    }
    
}
