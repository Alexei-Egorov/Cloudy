import UIKit
import CoreLocation

protocol LocationsViewControllerDelegate: AnyObject {
    func controller(_ controller: LocationsViewController, didSelectLocation location: CLLocation)
}

class LocationsViewController: UIViewController {

    // MARK: - Constants

    private let segueAddLocationView = "SegueAddLocationView"

    // MARK: - Properties

    @IBOutlet var tableView: UITableView!

    // MARK: -

    var currentLocation: CLLocation?

    // MARK: -
    
    var favorites = UserDefaults.locations

    // MARK: -

    private var hasFavorites: Bool {
        favorites.count > 0
    }

    // MARK: -

    weak var delegate: LocationsViewControllerDelegate?

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Locations"
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }

        switch identifier {
        case segueAddLocationView:
            if let addLocationViewController = segue.destination as? AddLocationViewController{
                addLocationViewController.delegate = self
            } else {
                fatalError("Unexpected Destination View Controller")
            }
        default: break
        }
    }

    // MARK: - Actions

    @IBAction func unwindToLocationsViewController(segue: UIStoryboardSegue) {}

}

extension LocationsViewController: UITableViewDataSource {

    private enum Section: Int, CaseIterable {

        // MARK: - Cases
        
        case current
        case favorite

        // MARK: - Properties

        var title: String {
            switch self {
            case .current: return "Current Location"
            case .favorite: return "Favorite Locations"
            }
        }

        var numberOfRows: Int {
            switch self {
            case .current: return 1
            case .favorite: return 0
            }
        }

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            fatalError("Unexpected Section")
        }

        switch section {
        case .current:
            return 1
        case .favorite:
            return max(favorites.count, 1)
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = Section(rawValue: section) else {
            fatalError("Unexpected Section")
        }
        
        return section.title
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Unexpected Section")
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.reuseIdentifier, for: indexPath) as? LocationTableViewCell else {
            fatalError("Unable to Dequeue Location Table View Cell")
        }

        var viewModel: LocationPresentable?

        switch section {
        case .current:
            if let currentLocation = currentLocation {
                viewModel = LocationViewModel(location: currentLocation)
            } else {
                cell.mainLabel.text = "Current Location Unknown"
            }
        case .favorite:
            if favorites.count > 0 {
                let favorite = favorites[indexPath.row]
                viewModel = LocationViewModel(location: favorite.location, locationAsString: favorite.name)
            } else {
                cell.mainLabel.text = "No Favorites Found"
            }
        }

        if let viewModel = viewModel {
            cell.configure(withViewModel: viewModel)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Unexpected Section")
        }

        switch section {
        case .current: return false
        case .favorite: return hasFavorites
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let location = favorites[indexPath.row]
        favorites.remove(at: indexPath.row)
        UserDefaults.removeLocation(location)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

}

extension LocationsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Unexpected Section")
        }

        var location: CLLocation?

        switch section {
        case .current:
            if let currentLocation = currentLocation {
                location = currentLocation
            }
        case .favorite:
            if hasFavorites {
                location = favorites[indexPath.row].location
            }
        }

        if let newLocation = location {
            delegate?.controller(self, didSelectLocation: newLocation)
            dismiss(animated: true)
        }
    }

}

extension LocationsViewController: AddLocationViewControllerDelegate {

    func controller(_ controller: AddLocationViewController, didAddLocation location: Location) {
        UserDefaults.addLocation(location)
        favorites.append(location)
        tableView.reloadData()
    }

}
