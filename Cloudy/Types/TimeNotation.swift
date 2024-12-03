enum TimeNotation: Int {
    
    // MARK: - Cases
    
    case twelveHour
    case twentyFourHour
    
    // MARK: - Properties
    
    var dateFormat: String {
        switch self {
        case .twelveHour: return "hh:mm a"
        case .twentyFourHour: return "HH:mm"
        }
    }
    
}
