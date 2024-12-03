import Foundation

extension UserDefaults {

    // MARK: - Types
    
    private enum Keys {
        static let locations = "locations"
        static let timeNotation = "timeNotation"
        static let unitsNotation = "unitsNotation"
        static let temperatureNotation = "temperatureNotation"
    }
    
    // MARK: - Time Notation

    class var timeNotation: TimeNotation {
        get {
            let storedValue = UserDefaults.standard.integer(forKey: Keys.timeNotation)
            return TimeNotation(rawValue: storedValue) ?? TimeNotation.twelveHour
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Keys.timeNotation)
        }
    }

    // MARK: - Units Notation
    
    class var unitsNotation: UnitsNotation {
        get {
            let storedValue = UserDefaults.standard.integer(forKey: Keys.unitsNotation)
            return UnitsNotation(rawValue: storedValue) ?? UnitsNotation.imperial
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Keys.unitsNotation)
        }
    }

    // MARK: - Temperature Notation
    
    class var temperatureNotation: TemperatureNotation {
        get {
            let storedValue = UserDefaults.standard.integer(forKey: Keys.temperatureNotation)
            return TemperatureNotation(rawValue: storedValue) ?? TemperatureNotation.fahrenheit
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Keys.temperatureNotation)
        }
    }

}

extension UserDefaults {

    // MARK: - Locations

    class var locations: [Location] {
        get {
            guard let dictionaries = UserDefaults.standard.array(forKey: Keys.locations) as? [ [String: Any] ] else {
                return []
            }
            return dictionaries.compactMap { Location(dictionary: $0) }
        }
        set {
            let dictionaries: [ [String: Any] ] = newValue.map { $0.asDictionary }
            UserDefaults.standard.set(dictionaries, forKey: Keys.locations)
        }
    }

    class func addLocation(_ location: Location) {
        var locations = self.locations
        locations.append(location)
        self.locations = locations
    }

    class func removeLocation(_ location: Location) {
        var locations = self.locations

        guard let index = locations.firstIndex(of: location) else {
            return
        }

        locations.remove(at: index)

        self.locations = locations
    }

}
