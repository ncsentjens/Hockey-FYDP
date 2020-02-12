//
//  CurrentSessionCell.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-12.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import Foundation
import UIKit

struct SessionViewModel: Codable {
    var shots: Int
    var goals: Int
    var averageShotSpeed: Float
    var averageReactionTime: Float
    var fastestShot: Float
    var quickestReactionTime:Float
    var sessionDate: Date = Date()
    
    enum CodingKeys: String, CodingKey {
        case shots
        case goals
        case averageShotSpeed = "average_shot_speed"
        case averageReactionTime = "average_reaction_time"
        case fastestShot = "fastest_shot"
        case quickestReactionTime = "quickest_reaction_time"
    }
    
    func shootingPercentage() -> Float {
        return round((Float(self.goals) / Float(self.shots) * 10 * 100)) / 10
    }
}

class CurrentSessionCell: UITableViewCell {
    let descriptionLabel = UILabel()
    let stackView = UIStackView()
    let goalsLabel = LeftRightLabel()
    let shotsLabel = LeftRightLabel()
    let accuracyLabel = LeftRightLabel()
    let shotSpeedLabel = LeftRightLabel()
    let reactionTimeLabel = LeftRightLabel()
    let fastestShotLabel = LeftRightLabel()
    let quickestReactionTimeLabel = LeftRightLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = SSColors.raisinBlack
        
        self.stackView.spacing = 8
        self.stackView.axis = .vertical
        
        self.descriptionLabel.textColor = SSColors.platinum
        self.descriptionLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        self.descriptionLabel.text = "Current Session"
        
        self.buildCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSeparator() {
        let separator = SeparatorView()
        self.stackView.addArrangedSubview(separator)
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor, constant: 12),
            separator.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor, constant: -12)
        ])
    }
    
    private func buildCell() {
        [self.stackView, self.descriptionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
        
        [self.goalsLabel, self.shotsLabel, self.accuracyLabel, self.shotSpeedLabel, self.reactionTimeLabel, self.fastestShotLabel, self.quickestReactionTimeLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSeparator()
            self.stackView.addArrangedSubview($0)
            NSLayoutConstraint.activate([
                $0.heightAnchor.constraint(equalToConstant: UIFont.preferredFont(forTextStyle: .body).lineHeight + 4)
            ])
        }
        self.addSeparator()
        
        NSLayoutConstraint.activate([
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: SSMargins.large),
            self.descriptionLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: SSMargins.large),
            self.stackView.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: SSMargins.large),
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: SSMargins.large),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -SSMargins.large),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -SSMargins.large)
        ])
    }
    
    func applyViewModel(viewModel: SessionViewModel) {
        // Goals Label
        self.goalsLabel.set(leftText: "Goals", rightText: String(viewModel.goals))
        
        // Shots Label
        self.shotsLabel.set(leftText: "Shots", rightText: String(viewModel.shots))
        
        // Accuracy Label
        let shootingPercentage: Float
        if (viewModel.shots == 0) {
            shootingPercentage = 0.0
        } else {
            shootingPercentage = Float(viewModel.goals) / Float(viewModel.shots) * 100
        }
        let accuracyText = String(viewModel.goals) + "/" + String(viewModel.shots) + " (" + String(shootingPercentage) + "%)"
        self.accuracyLabel.set(leftText: "Accuracy", rightText: accuracyText)
        
        // Shot speed label
        let shotSpeedText = String(viewModel.averageShotSpeed) + " mph"
        self.shotSpeedLabel.set(leftText: "Average Shot Speed", rightText: shotSpeedText)
        
        // Reaction time label
        let reactionTimeText = String(viewModel.averageReactionTime) + " s"
        self.reactionTimeLabel.set(leftText: "Average Reaction Time", rightText: reactionTimeText)
        
        // Fastest shot label
        let fastestShotText = String(viewModel.fastestShot) + " mph"
        self.fastestShotLabel.set(leftText: "Fastest Shot", rightText: fastestShotText)
        
        // Quicket reaction time label
        self.quickestReactionTimeLabel.set(leftText: "Quickest Reaction Time", rightText: String(viewModel.quickestReactionTime) + " s")
    }
}
