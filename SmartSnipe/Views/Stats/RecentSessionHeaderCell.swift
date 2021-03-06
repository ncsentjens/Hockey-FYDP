//
//  RecentSessionHeaderCell.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-28.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import Foundation
import UIKit

class RecentSessionHeaderCell: UITableViewCell {
    static let cellHeight: CGFloat = 40.0
    static let reuseIdentifierName: String = "recent_session_header_cell"
    
    static let columnWidth: CGFloat = 38.0
    static let dateWidth: CGFloat = 96.0
    
    private let dateLabel = UILabel()
    private let goalsLabel = UILabel()
    private let shotsLabel = UILabel()
    private let shotsPercentageLabel = UILabel()
    private let shotSpeedLabel = UILabel()
    private let reactionTimeLabel = UILabel()
    private let fastestShotLabel = UILabel()
    private let quicketReactionTimeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constructCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func constructCell() {
        self.contentView.backgroundColor = SSColors.jet
        
        self.dateLabel.text = "Date"
        self.goalsLabel.text = "G"
        self.shotsLabel.text = "S"
        self.shotsPercentageLabel.text = "S%"
        self.shotSpeedLabel.text = "SS"
        self.reactionTimeLabel.text = "RT"
        self.fastestShotLabel.text = "FS"
        self.quicketReactionTimeLabel.text = "QR"
        
        [self.dateLabel,
         self.goalsLabel,
         self.shotsLabel,
         self.shotsPercentageLabel,
         self.shotSpeedLabel,
         self.reactionTimeLabel,
         self.fastestShotLabel,
         self.quicketReactionTimeLabel].forEach { label in
            label.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(label)
            label.textAlignment = .center
            label.font = UIFont.preferredFont(forTextStyle: .subheadline)
            label.textColor = SSColors.grainYellow
            NSLayoutConstraint.activate([label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)])
        }
        
        NSLayoutConstraint.activate([dateLabel.widthAnchor.constraint(equalToConstant: RecentSessionCell.dateWidth)])
        
        [self.goalsLabel,
         self.shotsLabel,
         self.shotsPercentageLabel,
         self.shotSpeedLabel,
         self.reactionTimeLabel,
         self.fastestShotLabel,
         self.quicketReactionTimeLabel].forEach { label in
            NSLayoutConstraint.activate([label.widthAnchor.constraint(equalToConstant: RecentSessionCell.columnWidth)])
        }
        
        NSLayoutConstraint.activate([
            self.dateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: SSMargins.large),
            self.quicketReactionTimeLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -SSMargins.large),
            self.fastestShotLabel.trailingAnchor.constraint(equalTo: self.quicketReactionTimeLabel.leadingAnchor),
            self.reactionTimeLabel.trailingAnchor.constraint(equalTo: self.fastestShotLabel.leadingAnchor),
            self.shotSpeedLabel.trailingAnchor.constraint(equalTo: self.reactionTimeLabel.leadingAnchor),
            self.shotsPercentageLabel.trailingAnchor.constraint(equalTo: self.shotSpeedLabel.leadingAnchor),
            self.shotsLabel.trailingAnchor.constraint(equalTo: self.shotsPercentageLabel.leadingAnchor),
            self.goalsLabel.trailingAnchor.constraint(equalTo: self.shotsLabel.leadingAnchor)
        ])
    }
}
