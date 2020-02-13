//
//  SettingsViewController.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-06.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import UIKit

struct SettingsViewModel: Codable {
    // Time in seconds between opening
    var timeBetweenOpenings: Float
    // Time in seconds that slot is open for
    var timeSlotIsOpen: Float
    // Slots that open each time.
    var numberOfSlotsThatOpen: Int
    // Net shooting mode
    var currentMode: ShootingMode
    
    enum CodingKeys: String, CodingKey {
        case timeBetweenOpenings = "time_between_openings"
        case timeSlotIsOpen = "time_slot_is_open"
        case numberOfSlotsThatOpen = "number_of_slots_that_open"
        case currentMode = "current_mode"
    }
    
}

protocol NumberOfSlotsThatOpenDelegate: class {
    func numberOfSlotsThatOpenUpdated(_ numberOfSlots: Int)
}

protocol TimeBetweenOpeningsDelegate: class {
    func timeBetweenOpeningsUpdated(_ timeBetweenOpenings: Float)
}

protocol TimeSlotsOpenDelegate: class {
    func timeSlotsOpenUpdated(_ timeOpen: Float)
}

protocol CurrentModeDelegate: class {
    func currentModeUpdated(_ currentMode: String)
}

class SettingsViewController: UITableViewController {
    
    private let cellHeight: CGFloat = 48.0
    private var settingsViewModel = SettingsViewModel(timeBetweenOpenings: 4,
                                                      timeSlotIsOpen: 1.5,
                                                      numberOfSlotsThatOpen: 1,
                                                      currentMode: ShootingMode.allSlots)
    
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
        return 4
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SSTableViewHeaderView(reuseIdentifier: "standard_header")
        header.textLabel?.text = "Configuration"
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SSTableViewHeaderView.height
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
                           text: "Time Slot is Open",
                           detailText: String(self.settingsViewModel.timeSlotIsOpen) + " s",
                           imagaName: "hourglass")
        case 2:
            self.configure(cell: cell,
                           text: "# of Slots That Open at a Time",
                           detailText: String(self.settingsViewModel.numberOfSlotsThatOpen),
                           imagaName: "open")
        case 3:
            self.configure(cell: cell,
                           text: "Current Mode",
                           detailText: self.settingsViewModel.currentMode.formattedText,
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
                pickerValues: ["0.5", "1.0", "1.5", "2.0", "2.5", "3.0", "3.5", "4.0", "4.5", "5.0", "5.5", "6.0", "6.5", "7.0"],
                selectedPickerValue: String(self.settingsViewModel.timeBetweenOpenings))
            let timeBetweenOpenings = TimeBetweenOpeningsViewController(viewModel: viewModel)
            timeBetweenOpenings.delegate = self
            self.navigationController?.pushViewController(timeBetweenOpenings, animated: true)
        case 1:
            let viewModel = EditSettingsViewModel(
                navigationTitleText: "Time Slot is Open",
                descriptionText: "Edit the number of seconds the slot is open.",
                pickerValues: ["0.5", "1.0", "1.5", "2.0", "2.5", "3.0"],
                selectedPickerValue: String(self.settingsViewModel.timeSlotIsOpen))
            let timeSlotsOpen = TimeSlotsOpenViewController(viewModel: viewModel)
            timeSlotsOpen.delegate = self
            self.navigationController?.pushViewController(timeSlotsOpen, animated: true)
        case 2:
            let viewModel = EditSettingsViewModel(
                navigationTitleText: "Slots That Open",
                descriptionText: "Edit the number of slots that open at a time.",
                pickerValues: ["1", "2"],
                selectedPickerValue: String(self.settingsViewModel.numberOfSlotsThatOpen))
            let editSlotsViewController = SlotsThatOpenViewController(viewModel: viewModel)
            editSlotsViewController.delegate = self
            self.navigationController?.pushViewController(editSlotsViewController, animated: true)
        case 3:
            let viewModel = EditSettingsViewModel(
                navigationTitleText: "Current Mode",
                descriptionText: "Edit the current shooting mode.",
                pickerValues: [ShootingMode.allSlots.formattedText, ShootingMode.topCorners.formattedText],
                selectedPickerValue: self.settingsViewModel.currentMode.formattedText)
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

extension SettingsViewController: TimeSlotsOpenDelegate {
    func timeSlotsOpenUpdated(_ timeOpen: Float) {
        self.settingsViewModel.timeSlotIsOpen = timeOpen
        self.tableView.reloadData()
        SSBluetoothManager.sharedManager.updateSettings(settingsViewModel: self.settingsViewModel)
    }
}

extension SettingsViewController: NumberOfSlotsThatOpenDelegate {
    func numberOfSlotsThatOpenUpdated(_ numberOfSlots: Int) {
        self.settingsViewModel.numberOfSlotsThatOpen = numberOfSlots
        self.tableView.reloadData()
        SSBluetoothManager.sharedManager.updateSettings(settingsViewModel: self.settingsViewModel)
    }
}

extension SettingsViewController: CurrentModeDelegate {
    func currentModeUpdated(_ currentMode: String) {
        self.settingsViewModel.currentMode = ShootingMode(formattedText: currentMode) ?? .allSlots
        self.tableView.reloadData()
        SSBluetoothManager.sharedManager.updateSettings(settingsViewModel: self.settingsViewModel)
    }
}
