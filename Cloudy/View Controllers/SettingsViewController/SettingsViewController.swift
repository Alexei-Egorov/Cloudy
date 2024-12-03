import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func controllerDidChangeTimeNotation(controller: SettingsViewController)
    func controllerDidChangeUnitsNotation(controller: SettingsViewController)
    func controllerDidChangeTemperatureNotation(controller: SettingsViewController)
}

class SettingsViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet var tableView: UITableView!

    // MARK: -

    weak var delegate: SettingsViewControllerDelegate?

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        setupView()
    }

    // MARK: - View Methods

    private func setupView() {
        tableView.separatorInset = UIEdgeInsets.zero
    }

}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {

    private enum Section: Int, CaseIterable {
        
        // MARK: - Cases
        
        case time
        case units
        case temperature

        // MARK: - Properties
        
        var numberOfRows: Int {
            2
        }

    }

    // MARK: - Table View Data Source Methods

    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            fatalError("Unexpected Section")
        }
        
        return section.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Unexpected Section")
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.reuseIdentifier, for: indexPath) as? SettingsTableViewCell else {
            fatalError("Unable to Dequeue Settings Table View Cell")
        }

        let viewModel: SettingsPresentable = {
            switch section {
            case .time:
                guard let timeNotation = TimeNotation(rawValue: indexPath.row) else {
                    fatalError("Unexpected Index Path")
                }
                return SettingsTimeViewModel(timeNotation: timeNotation)
            case .units:
                guard let unitsNotation = UnitsNotation(rawValue: indexPath.row) else {
                    fatalError("Unexpected Index Path")
                }
                return SettingsUnitsViewModel(unitsNotation: unitsNotation)
            case .temperature:
                guard let temperatureNotation = TemperatureNotation(rawValue: indexPath.row) else { fatalError("Unexpected Index Path") }
                return SettingsTemperatureViewModel(temperatureNotation: temperatureNotation)
            }
        }()
        
        cell.configure(with: viewModel)
        
        return cell
    }

    // MARK: - Table View Delegate Methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let section = Section(rawValue: indexPath.section) else {
            fatalError("Unexpected Section")
        }

        switch section {
        case .time:
            let timeNotation = UserDefaults.timeNotation
            guard indexPath.row != timeNotation.rawValue else { return }
            if let newTimeNotation = TimeNotation(rawValue: indexPath.row) {
                UserDefaults.timeNotation = newTimeNotation
                delegate?.controllerDidChangeTimeNotation(controller: self)
            }
        case .units:
            let unitsNotation = UserDefaults.unitsNotation
            guard indexPath.row != unitsNotation.rawValue else { return }
            
            if let newUnitsNotation = UnitsNotation(rawValue: indexPath.row) {
                UserDefaults.unitsNotation = newUnitsNotation
                delegate?.controllerDidChangeUnitsNotation(controller: self)
            }
        case .temperature:
            let temperatureNotation = UserDefaults.temperatureNotation
            guard indexPath.row != temperatureNotation.rawValue else { return }

            if let newTemperatureNotation = TemperatureNotation(rawValue: indexPath.row) {
                UserDefaults.temperatureNotation = newTemperatureNotation
                delegate?.controllerDidChangeTemperatureNotation(controller: self)
            }
        }

        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
    }

}
