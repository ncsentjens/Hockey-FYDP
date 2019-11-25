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
    let accuracyLabel = UILabel()
    let shotSpeedLabel = UILabel()
    let reactionTimeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = .black
        
        self.stackView.spacing = 8
        self.stackView.axis = .vertical
        
        self.descriptionLabel.textColor = .lightGray
        self.descriptionLabel.text = "Current Session"
        
        self.accuracyLabel.text = "Accuracy: 4/10 (40%)"
        self.shotSpeedLabel.text = "Average Shot Speed: 68 mph"
        self.reactionTimeLabel.text = "Average Reaction Time: 0.3 seconds"
        
        [accuracyLabel, shotSpeedLabel, reactionTimeLabel].forEach {
            $0.textColor = .white
        }
        
        self.buildCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildCell() {
        [self.stackView, self.descriptionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
        
        [self.accuracyLabel, self.shotSpeedLabel, self.reactionTimeLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.stackView.addArrangedSubview($0)
        }
        
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
