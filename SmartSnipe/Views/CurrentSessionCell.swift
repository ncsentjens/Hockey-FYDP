//
//  CurrentSessionCell.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-12.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import Foundation
import UIKit

struct SessionViewModel {
    var shotsTaken: Int
    var shotsMade: Int
    var averageShotSpeed: Float
    var averageReactionTime: Float
}

class CurrentSessionCell: UITableViewCell {
    let descriptionLabel = UILabel()
    let stackView = UIStackView()
    let accuracyLabel = LeftRightLabel()
    let shotSpeedLabel = LeftRightLabel()
    let reactionTimeLabel = LeftRightLabel()
    
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
        
        [self.accuracyLabel, self.shotSpeedLabel, self.reactionTimeLabel].forEach {
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
        // Accuracy Label
        let shootingPercentage: Float
        if (viewModel.shotsTaken == 0) {
            shootingPercentage = 0.0
        } else {
            shootingPercentage = Float(viewModel.shotsMade) / Float(viewModel.shotsTaken) * 100
        }
        let accuracyText = String(viewModel.shotsMade) + "/" + String(viewModel.shotsTaken) + " (" + String(shootingPercentage) + "%)"
        self.accuracyLabel.set(leftText: "Accuracy", rightText: accuracyText)
        
        // Shot speed label
        let shotSpeedText = String(viewModel.averageShotSpeed) + " mph"
        self.shotSpeedLabel.set(leftText: "Average Shot Speed", rightText: shotSpeedText)
        
        // Reaction time label
        let reactionTimeText = String(viewModel.averageReactionTime) + " s"
        self.reactionTimeLabel.set(leftText: "Average Reaction Time", rightText: reactionTimeText)
    }
}
