//
//  CurrentSessionCell.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-12.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import Foundation
import UIKit

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
        
        self.accuracyLabel.set(leftText: "Accuracy", rightText: "4/10 (40%)")
        self.shotSpeedLabel.set(leftText: "Average Shot Speed", rightText: "68 mph")
        self.reactionTimeLabel.set(leftText: "Average Reaction Time", rightText: "0.3 Seconds")
        
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
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
            self.descriptionLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12),
            self.stackView.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 12),
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12)
        ])
    }
}
