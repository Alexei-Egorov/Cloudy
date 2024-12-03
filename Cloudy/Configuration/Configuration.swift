import Foundation

struct Defaults {

    static let Latitude: Double = 51.400592
    static let Longitude: Double = 4.760970

}

struct WeatherServiceRequest {
    
    // MARK: - Properties
    
    private let apiKey = "tnperxfip8renk2hlzcccwetbnesby"
    private let baseUrl = URL(string: "https://cocoacasts.com/clearsky/")!
    
    // MARK: -
    
    let latitude: Double
    let longitude: Double
    
    // MARK: - Public API
    
    var url: URL {
        guard var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false) else {
            fatalError("Unable to Create URL Components for Weather Service Request")
        }
        
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "long", value: "\(longitude)")
        ]
        
        guard let url = components.url else {
            fatalError("Unable to Create URL for Weather Service Request")
        }
        
        return url
    }
    
}
