import Foundation

extension Double {

    var toCelcius: Double {
        (self - 32.0) / 1.8
    }

    var toKPH: Double {
        self * 1.609344
    }

}
