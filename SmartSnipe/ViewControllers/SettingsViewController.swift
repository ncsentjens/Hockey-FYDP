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

class SettingsViewController: UITableViewController {
    
    private let settingsViewModel: SettingsViewModel = SettingsViewModel(
        numberOfSlotsThatOpen: 1,
        timeBetweenOpenings: 4,
        currentMode: "All Corners"
        )

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: .zero, style: .grouped)
        self.tableView.separatorColor = .white
        self.view.backgroundColor = .black
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.gray]
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
        header.textLabel?.textColor = .white
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        header.backgroundView = backgroundView
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = UITableViewCell(style: .value1, reuseIdentifier: "standard_settings_cell")

        cell.backgroundColor = .black
        cell.textLabel?.textColor = .lightGray
        cell.tintColor = .red
        cell.accessoryView = UIImageView(image: UIImage(named: "chevron"), highlightedImage: nil)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Time Between Openings"
            cell.detailTextLabel?.text = String(self.settingsViewModel.timeBetweenOpenings) + " s"
            cell.imageView?.image = UIImage(named: "timer")
        case 1:
            cell.textLabel?.text = "# of Slots That Open at a Time"
            cell.detailTextLabel?.text = String(self.settingsViewModel.numberOfSlotsThatOpen)
            cell.imageView?.image = UIImage(named: "open")
        case 2:
            cell.textLabel?.text = "Current Mode"
            cell.detailTextLabel?.text = self.settingsViewModel.currentMode
            cell.imageView?.image = UIImage(named: "goal")
        default:
            fatalError("Unexpected index")
        }
        return cell
    }
}

