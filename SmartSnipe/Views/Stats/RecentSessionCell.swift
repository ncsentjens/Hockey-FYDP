//
//  RecentSessionsCell.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-28.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import Foundation
import UIKit

class RecentSessionCell: UITableViewCell {
    static let cellHeight: CGFloat = 42.0
    static let reuseIdentifierName: String = "recent_session_cell"
    
    static let columnWidth: CGFloat = 46.0
    static let dateWidth: CGFloat = 96.0
    
    private let dateLabel = UILabel()
    private let goalsLabel = UILabel()
    private let shotsLabel = UILabel()
    private let shotsPercentageLabel = UILabel()
    private let shotSpeedLabel = UILabel()
    private let reactionTimeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constructCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func constructCell() {
        self.contentView.backgroundColor = SSColors.lightGray
        [self.dateLabel,
         self.goalsLabel,
         self.shotsLabel,
         self.shotsPercentageLabel,
         self.shotSpeedLabel,
         self.reactionTimeLabel].forEach { label in
            label.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(label)
            label.textAlignment = .center
            label.font = UIFont.preferredFont(forTextStyle: .subheadline)
            label.textColor = SSColors.raisinBlack
            NSLayoutConstraint.activate([label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)])
        }
        
        NSLayoutConstraint.activate([dateLabel.widthAnchor.constraint(equalToConstant: RecentSessionCell.dateWidth)])
        
        [self.goalsLabel,
         self.shotsLabel,
         self.shotsPercentageLabel,
         self.shotSpeedLabel,
         self.reactionTimeLabel].forEach { label in
            NSLayoutConstraint.activate([label.widthAnchor.constraint(equalToConstant: RecentSessionCell.columnWidth)])
        }
        
        NSLayoutConstraint.activate([
            self.dateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: SSMargins.large),
            self.reactionTimeLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -SSMargins.large),
            self.shotSpeedLabel.trailingAnchor.constraint(equalTo: self.reactionTimeLabel.leadingAnchor),
            self.shotsPercentageLabel.trailingAnchor.constraint(equalTo: self.shotSpeedLabel.leadingAnchor),
            self.shotsLabel.trailingAnchor.constraint(equalTo: self.shotsPercentageLabel.leadingAnchor),
            self.goalsLabel.trailingAnchor.constraint(equalTo: self.shotsLabel.leadingAnchor)
        ])
    }
    
    func applySession(sessionViewModel: SessionViewModel, backgroundColor: UIColor) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let sessionMonth = dateFormatter.string(from: sessionViewModel.sessionDate)
        let calendar = Calendar.current
        let sessionDayOfMonth = calendar.dateComponents([.day], from: sessionViewModel.sessionDate).day ?? 1
        
        self.contentView.backgroundColor = backgroundColor
        self.dateLabel.text = sessionMonth + " " + String (sessionDayOfMonth)
        self.goalsLabel.text = String(sessionViewModel.goals)
        self.shotsLabel.text = String(sessionViewModel.shots)
        self.shotsPercentageLabel.text = String(sessionViewModel.shootingPercentage())
        self.shotSpeedLabel.text = String(sessionViewModel.averageShotSpeed)
        self.reactionTimeLabel.text = String(sessionViewModel.averageReactionTime)
    }
}
