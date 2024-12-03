import Foundation

protocol LocationService {
    
    // MARK: - Type Aliases
    
    typealias Completion = (Result<[Location], LocationServiceError>) -> Void
    
    // MARK: - Methods
    
    func geocode(addressString: String, completion: @escaping Completion)
}

// MARK: - Types

enum LocationServiceError: Error {
    
    // MARK: - Cases
    
    case invalidAddressString
    case requestFailed(Error)
}
