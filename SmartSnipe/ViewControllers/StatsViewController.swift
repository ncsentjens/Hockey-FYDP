//
//  StatsViewController.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-06.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import UIKit

struct StatsViewControllerViewModel {
    let historicalStats: HistoricalStatsViewModel
    let recentSessions: [SessionViewModel]
}

class StatsViewController: UITableViewController {
    private var viewModel: StatsViewControllerViewModel
     
    override init(style: UITableView.Style) {
        
        let historicalStats = HistoricalStatsViewModel(shotSpeed: 100.0,
                                                       shots: 100,
                                                       goals: 10,
                                                       reactionTime: 0.14)
        let recentSessions = [
            SessionViewModel(shots: 10, goals: 4, averageShotSpeed: 100.0, averageReactionTime: 0.14, sessionDate: Date()),
            SessionViewModel(shots: 11, goals: 8, averageShotSpeed: 80.0, averageReactionTime: 0.14, sessionDate: Date()),
            SessionViewModel(shots: 45, goals: 8, averageShotSpeed: 68.0, averageReactionTime: 0.14, sessionDate: Date()),
            SessionViewModel(shots: 19, goals: 12, averageShotSpeed: 100.0, averageReactionTime: 0.3, sessionDate: Date()),
        
        ]
        viewModel = StatsViewControllerViewModel(historicalStats: historicalStats,
                                                 recentSessions: recentSessions)
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = SSColors.raisinBlack
        self.tableView.sectionFooterHeight = 0
        
        self.navigationController?.navigationBar.barTintColor = SSColors.raisinBlack
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : SSColors.grainYellow]
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "standard_header")
        self.tableView.register(RecentSessionCell.self, forCellReuseIdentifier: RecentSessionCell.reuseIdentifierName)
        self.tableView.register(RecentSessionHeaderCell.self, forCellReuseIdentifier: RecentSessionHeaderCell.reuseIdentifierName)
        self.tableView.register(HistoricalStatsCell.self, forCellReuseIdentifier: HistoricalStatsCell.reuseIdentifier)
        self.navigationItem.title = "Stats"
        super.viewDidLoad()
    }
}

extension StatsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return self.viewModel.recentSessions.count > 0 ? self.viewModel.recentSessions.count + 1 : 0
        case 2:
            return 0
        default:
            fatalError("Unknown section")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
        case 1:
            if indexPath.row == 0 {
                return RecentSessionHeaderCell.cellHeight
            } else {
                return RecentSessionCell.cellHeight
            }
        case 2:
            return 0
        default:
            fatalError("Unknown section")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SSTableViewHeaderView.height
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SSTableViewHeaderView(reuseIdentifier: "standard_header")
        switch section {
        case 0:
            header.textLabel?.text = "Historical"
        case 1:
            header.textLabel?.text = "Recent Sessions"
        case 2:
            header.textLabel?.text = "Progress"
        default:
            fatalError("Unknown section")
        }
        return header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoricalStatsCell.reuseIdentifier) as? HistoricalStatsCell else {
                fatalError()
            }
            cell.applyViewModel(viewModel: self.viewModel.historicalStats)
            return cell
        case 1:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentSessionHeaderCell.reuseIdentifierName) as? RecentSessionHeaderCell else {
                    fatalError()
                }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentSessionCell.reuseIdentifierName) as? RecentSessionCell else {
                    fatalError()
                }
                let session = self.viewModel.recentSessions[indexPath.row - 1]
                cell.applySession(sessionViewModel: session,
                                  backgroundColor: indexPath.row % 2 == 0 ? SSColors.lightGray : SSColors.platinum)
                return cell
            }
        case 2:
            return UITableViewCell()
        default:
            fatalError("Unknown section")
        }
    }
}

