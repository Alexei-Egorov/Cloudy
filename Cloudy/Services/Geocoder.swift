import CoreLocation

class Geocoder: LocationService {
    
    // MARK: - Properties
    
    private lazy var geocoder = CLGeocoder()
    
    // MARK: - Location Service
    
    func geocode(addressString: String, completion: @escaping Completion) {
        guard !addressString.isEmpty else {
            completion(.failure(.invalidAddressString))
            return
        }
        
        geocoder.geocodeAddressString(addressString) { placemarks, error in
            if let error {
                completion(.failure(.requestFailed(error)))
            } else if let placemarks {
                let locations = placemarks.compactMap { placemark -> Location? in
                    guard let name = placemark.name,
                          let location = placemark.location else {
                        return nil
                    }
                    return Location(name: name, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                }
                
                completion(.success(locations))
            }
        }
    }
}
