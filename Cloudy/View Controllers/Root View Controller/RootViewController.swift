import UIKit
import CoreLocation

final class RootViewController: UIViewController {

    // MARK: - Types
    
    private enum AlertType {
        
        case notAuthorizedToRequestLocation
        case failedToRequestLocation
        case noWeatherDataAvailable

    }
    
    // MARK: - Constants

    private let segueDayView = "SegueDayView"
    private let segueWeekView = "SegueWeekView"
    private let SegueSettingsView = "SegueSettingsView"
    private let segueLocationsView = "SegueLocationsView"

    // MARK: - Properties

    @IBOutlet private var dayViewController: DayViewController!
    @IBOutlet private var weekViewController: WeekViewController!

    // MARK: -

    private var currentLocation: CLLocation? {
        didSet {
            fetchWeatherData()
        }
    }

    // MARK: -
    
    private lazy var dataManager = DataManager()
    
    // MARK: -
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()

        locationManager.distanceFilter = 1000.0
        locationManager.desiredAccuracy = 1000.0

        return locationManager
    }()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNotificationHandling()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }

        switch identifier {
        case segueDayView:
            guard let destination = segue.destination as? DayViewController else {
                fatalError("Unexpected Destination View Controller")
            }

            destination.delegate = self

            self.dayViewController = destination
        case segueWeekView:
            guard let destination = segue.destination as? WeekViewController else {
                fatalError("Unexpected Destination View Controller")
            }

            destination.delegate = self

            self.weekViewController = destination
        case SegueSettingsView:
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected Destination View Controller")
            }

            guard let destination = navigationController.topViewController as? SettingsViewController else {
                fatalError("Unexpected Destination View Controller")
            }

            destination.delegate = self
        case segueLocationsView:
            guard let navigationController = segue.destination as? UINavigationController else {
                fatalError("Unexpected Destination View Controller")
            }

            guard let destination = navigationController.topViewController as? LocationsViewController else {
                fatalError("Unexpected Destination View Controller")
            }

            destination.delegate = self
            destination.currentLocation = currentLocation
        default: break
        }
    }

    // MARK: - Actions

    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {}

    // MARK: - Helper Methods

    private func setupNotificationHandling() {
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { [weak self] _ in
            self?.requestLocation()
        }
    }

    // MARK: -
    
    private func requestLocation() {
        locationManager.delegate = self

        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }

    private func fetchWeatherData() {
        guard let location = currentLocation else {
            return
        }
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        dataManager.weatherDataForLocation(latitude: latitude, longitude: longitude) { [weak self] (result) in
            switch result {
            case .success(let weatherData):
                self?.dayViewController.viewModel = DayViewModel(weatherData: weatherData)
                self?.weekViewController.viewModel = WeekViewModel(weatherData: weatherData.dailyData)
            case .failure:
                self?.presentAlert(of: .noWeatherDataAvailable)
                self?.dayViewController.viewModel = nil
                self?.weekViewController.viewModel = nil
            }
        }
    }
    
    // MARK: -
    
    private func presentAlert(of alertType: AlertType) {
        let title: String
        let message: String
        
        switch alertType {
        case .notAuthorizedToRequestLocation:
            title = "Unable to Fetch Weather Data for Your Location"
            message = "Cloudy is not authorized to access your current location. You can grant Cloudy access to your current location in the Settings application."
        case .failedToRequestLocation:
            title = "Unable to Fetch Weather Data for Your Location"
            message = "Cloudy is not able to fetch your current location due to a technical issue."
        case .noWeatherDataAvailable:
            title = "Unable to Fetch Weather Data"
            message = "Cloudy is unable to fetch weather data. Please make sure your device is connected over Wi-Fi or cellular."
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }

}

extension RootViewController: CLLocationManagerDelegate {

    // MARK: - Authorization

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways,
             .authorizedWhenInUse:
            manager.requestLocation()
        case .denied,
             .restricted:
            presentAlert(of: .notAuthorizedToRequestLocation)
        default:
            currentLocation = CLLocation(latitude: Defaults.Latitude, longitude: Defaults.Longitude)
        }
    }

    // MARK: - Location Updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
            manager.delegate = nil
            manager.stopUpdatingLocation()
        } else {
            currentLocation = CLLocation(latitude: Defaults.Latitude, longitude: Defaults.Longitude)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if currentLocation == nil {
            currentLocation = CLLocation(latitude: Defaults.Latitude, longitude: Defaults.Longitude)
        }
        presentAlert(of: .failedToRequestLocation)
    }

}

extension RootViewController: DayViewControllerDelegate {

    func controllerDidTapSettingsButton(controller: DayViewController) {
        performSegue(withIdentifier: SegueSettingsView, sender: self)
    }

    func controllerDidTapLocationButton(controller: DayViewController) {
        performSegue(withIdentifier: segueLocationsView, sender: self)
    }

}

extension RootViewController: WeekViewControllerDelegate {

    func controllerDidRefresh(controller: WeekViewController) {
        fetchWeatherData()
    }

}

extension RootViewController: SettingsViewControllerDelegate {

    func controllerDidChangeTimeNotation(controller: SettingsViewController) {
        dayViewController.reloadData()
        weekViewController.reloadData()
    }

    func controllerDidChangeUnitsNotation(controller: SettingsViewController) {
        dayViewController.reloadData()
        weekViewController.reloadData()
    }

    func controllerDidChangeTemperatureNotation(controller: SettingsViewController) {
        dayViewController.reloadData()
        weekViewController.reloadData()
    }

}

extension RootViewController: LocationsViewControllerDelegate {

    func controller(_ controller: LocationsViewController, didSelectLocation location: CLLocation) {
        currentLocation = location
    }

}
