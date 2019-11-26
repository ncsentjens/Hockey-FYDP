//
//  SettingsViewController.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-06.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import UIKit

struct SettingsViewModel {
    // Slots that open each time.
    var numberOfSlotsThatOpen: Int
    // Time in seconds between opening
    var timeBetweenOpenings: Float
    
    var currentMode: String
}

protocol NumberOfSlotsThatOpenDelegate: class {
    func numberOfSlotsThatOpenUpdated(_ numberOfSlots: Int)
}

protocol TimeBetweenOpeningsDelegate: class {
    func timeBetweenOpeningsUpdated(_ timeBetweenOpenings: Float)
}

protocol CurrentModeDelegate: class {
    func currentModeUpdated(_ currentMode: String)
}

class SettingsViewController: UITableViewController {
    
    private let cellHeight: CGFloat = 48.0
    private let headerHeight: CGFloat = 52.0
    
    private var settingsViewModel = SettingsViewModel(
        numberOfSlotsThatOpen: 1,
        timeBetweenOpenings: 4,
        currentMode: "All Corners")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: .zero, style: .grouped)
        self.tableView.separatorColor = SSColors.grainYellow
        self.view.backgroundColor = SSColors.raisinBlack
        self.navigationController?.navigationBar.barTintColor = SSColors.raisinBlack
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : SSColors.grainYellow]
        self.navigationItem.title = "Settings"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "standard_settings_cell")
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "standard_header")
        
    }
}

extension SettingsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UITableViewHeaderFooterView(reuseIdentifier: "standard_header")
        header.textLabel?.text = "Configuration"
        header.textLabel?.textColor = SSColors.platinum
        let backgroundView = UIView()
        backgroundView.backgroundColor = SSColors.raisinBlack
        header.backgroundView = backgroundView
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = UITableViewCell(style: .value1, reuseIdentifier: "standard_settings_cell")

        cell.backgroundColor = SSColors.raisinBlack
        cell.textLabel?.textColor = SSColors.lightGray
        cell.tintColor = .red
        cell.accessoryView = UIImageView(image: UIImage(named: "chevron"), highlightedImage: nil)
        
        switch indexPath.row {
        case 0:
            self.configure(cell: cell,
                           text: "Time Between Openings",
                           detailText: String(self.settingsViewModel.timeBetweenOpenings) + " s",
                           imagaName: "timer")
        case 1:
            self.configure(cell: cell,
                           text: "# of Slots That Open at a Time",
                           detailText: String(self.settingsViewModel.numberOfSlotsThatOpen),
                           imagaName: "open")
        case 2:
            self.configure(cell: cell,
                           text: "Current Mode",
                           detailText: self.settingsViewModel.currentMode,
                           imagaName: "goal")
        default:
            fatalError("Unexpected index")
        }
        return cell
    }
    
    private func configure(cell: UITableViewCell, text: String, detailText: String, imagaName: String) {
        cell.textLabel?.text = text
        cell.detailTextLabel?.text = detailText
        cell.imageView?.image = UIImage(named: imagaName)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let viewModel = EditSettingsViewModel(
                navigationTitleText: "Time Between Openings",
                descriptionText: "Edit the number of seconds between slot openings.",
                pickerValues: ["0.5", "1.0", "1.5", "2.0", "2.5"],
                selectedPickerValue: "1.0")
            let timeBetweenOpenings = TimeBetweenOpeningsViewController(viewModel: viewModel)
            timeBetweenOpenings.delegate = self
            self.navigationController?.pushViewController(timeBetweenOpenings, animated: true)
        case 1:
            let viewModel = EditSettingsViewModel(
                navigationTitleText: "Slots That Open",
                descriptionText: "Edit the number of slots that open at a time.",
                pickerValues: ["1", "2"],
                selectedPickerValue: "1")
            let editSlotsViewController = SlotsThatOpenViewController(viewModel: viewModel)
            editSlotsViewController.delegate = self
            self.navigationController?.pushViewController(editSlotsViewController, animated: true)
        case 2:
            let viewModel = EditSettingsViewModel(
                navigationTitleText: "Current Mode",
                descriptionText: "Edit the current shooting mode.",
                pickerValues: ["All Corners", "Top Shelf Only"],
                selectedPickerValue: "All Corners")
            let editModeViewController = CurrentModeViewController(viewModel: viewModel)
            editModeViewController.delegate = self
            self.navigationController?.pushViewController(editModeViewController, animated: true)
        default:
            break
        }
    }
}

extension SettingsViewController: TimeBetweenOpeningsDelegate {
    func timeBetweenOpeningsUpdated(_ timeBetweenOpenings: Float) {
        self.settingsViewModel.timeBetweenOpenings = timeBetweenOpenings
        self.tableView.reloadData()
    }
    
    
}

extension SettingsViewController: NumberOfSlotsThatOpenDelegate {
    func numberOfSlotsThatOpenUpdated(_ numberOfSlots: Int) {
        self.settingsViewModel.numberOfSlotsThatOpen = numberOfSlots
        self.tableView.reloadData()
    }
    
    
}

extension SettingsViewController: CurrentModeDelegate {
    func currentModeUpdated(_ currentMode: String) {
        self.settingsViewModel.currentMode = currentMode
        self.tableView.reloadData()
    }
}
