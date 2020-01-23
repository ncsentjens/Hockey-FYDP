//
//  HistoricalStatsCell.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-28.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import Foundation
import UIKit

struct HistoricalStatsViewModel {
    let shotSpeed: Float
    let shots: Int
    let goals: Int
    let reactionTime: Float
    
    func shootingPercentage() -> Float {
        return round((Float(self.goals) / Float(self.shots) * 10 * 100)) / 10
    }
}

class HistoricalStatsCell: UITableViewCell {
    static let cellHeight: CGFloat = 100
    static let reuseIdentifier = "historical_stat_cell"
    
    private let stackView = UIStackView()
    
    private let goalsLabel: StatsLabelView
    private let shotsLabel: StatsLabelView
    private let shootingPercentageLabel: StatsLabelView
    private let shotsSpeedLabel: StatsLabelView
    private let reactionTimeLabel: StatsLabelView
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        goalsLabel = StatsLabelView(frame: .zero)
        shotsLabel = StatsLabelView(frame: .zero)
        shootingPercentageLabel = StatsLabelView(frame: .zero)
        shotsSpeedLabel = StatsLabelView(frame: .zero)
        reactionTimeLabel = StatsLabelView(frame: .zero)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.constructCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func constructCell() {
        self.contentView.addSubview(self.stackView)
        self.contentView.backgroundColor = SSColors.jet
        [self.goalsLabel, self.shotsLabel, self.shootingPercentageLabel, self.shotsSpeedLabel, self.reactionTimeLabel].forEach { label in
            label.translatesAutoresizingMaskIntoConstraints = false
            self.stackView.addArrangedSubview(label)
            NSLayoutConstraint.activate([
                label.widthAnchor.constraint(equalToConstant: 60),
                label.heightAnchor.constraint(equalToConstant: 70)
            ])
            
        }
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.axis = .horizontal
        self.stackView.alignment = .top
        self.stackView.distribution = .fillEqually
        
        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: SSMargins.large),
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: SSMargins.large),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -SSMargins.large),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -SSMargins.large)
        ])
    }
    
    func applyViewModel(viewModel: HistoricalStatsViewModel) {
        self.goalsLabel.apply(statName: "G", statValue: String(viewModel.goals))
        self.shotsLabel.apply(statName: "S", statValue: String(viewModel.shots))
        self.shootingPercentageLabel.apply(statName: "S%", statValue: String(viewModel.shootingPercentage()))
        self.shotsSpeedLabel.apply(statName: "SS", statValue: String(viewModel.shotSpeed))
        self.reactionTimeLabel.apply(statName: "RT", statValue: String(viewModel.reactionTime))
    }
}
