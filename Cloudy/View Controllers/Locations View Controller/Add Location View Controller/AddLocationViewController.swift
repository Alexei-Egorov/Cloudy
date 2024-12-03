import UIKit
import Combine

protocol AddLocationViewControllerDelegate: AnyObject {
    func controller(_ controller: AddLocationViewController, didAddLocation location: Location)
}

class AddLocationViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: -
    
    private var viewModel: AddLocationViewModel!

    // MARK: -

    weak var delegate: AddLocationViewControllerDelegate?
    
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Location"

        viewModel = AddLocationViewModel(locationService: Geocoder())
        
        viewModel.locationsPublisher
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            }).store(in: &subscriptions)
        
        viewModel.$querying
            .sink(receiveValue: { [weak self] isQuerying in
                if isQuerying {
                    self?.activityIndicatorView.startAnimating()
                } else {
                    self?.activityIndicatorView.stopAnimating()
                }
            }).store(in: &subscriptions)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        searchBar.becomeFirstResponder()
    }

}

extension AddLocationViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfLocations
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.reuseIdentifier, for: indexPath) as? LocationTableViewCell else {
            fatalError("Unable to Dequeue Location Table View Cell")
        }

        if let viewModel = viewModel.viewModelForLocation(at: indexPath.row) {
            cell.configure(withViewModel: viewModel)
        }

        return cell
    }

}

extension AddLocationViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let location = viewModel?.location(at: indexPath.row) else {
            return
        }

        delegate?.controller(self, didAddLocation: location)

        navigationController?.popViewController(animated: true)
    }

}

extension AddLocationViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.query = searchText
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        viewModel.query = searchBar.text ?? ""
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.query = searchBar.text ?? ""
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.query = ""
    }

}
