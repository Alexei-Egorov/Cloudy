import Foundation

struct WeatherData: Decodable {

    // MARK: - Types
    
    enum CodingKeys: String, CodingKey {
        
        case latitude
        case longitude
        case daily
        case currently
        
    }
    
    enum CurrentlyCodingKeys: String, CodingKey {
        
        case time
        case icon
        case summary
        case windSpeed
        case temperature
        
    }
    
    enum DailyCodingKeys: String, CodingKey {
        
        case data
        
    }
    
    // MARK: - Properties
    
    let time: Date

    // MARK: -
    
    let latitude: Double
    let longitude: Double
    let windSpeed: Double
    let temperature: Double
    
    // MARK: -
    
    let icon: String
    let summary: String
    
    // MARK: -
    
    let dailyData: [WeatherDayData]

    // MARK: - Initialization

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        
        let daily = try container.nestedContainer(keyedBy: DailyCodingKeys.self, forKey: .daily)

        self.dailyData = try daily.decode([WeatherDayData].self, forKey: .data)

        let currently = try container.nestedContainer(keyedBy: CurrentlyCodingKeys.self, forKey: .currently)
        
        self.time = try currently.decode(Date.self, forKey: .time)
        
        self.windSpeed = try currently.decode(Double.self, forKey: .windSpeed)
        self.temperature = try currently.decode(Double.self, forKey: .temperature)
        self.icon = try currently.decode(String.self, forKey: .icon)
        self.summary = try currently.decode(String.self, forKey: .summary)
    }
    
}
