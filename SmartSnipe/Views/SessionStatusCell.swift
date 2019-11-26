//
//  SessionStatusCell.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-10.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import Foundation
import UIKit

class SessionsStatusCell: UITableViewCell {
    
    let descriptionLabel = UILabel()
    let netStatusLabel = UILabel()
    let sessionStartTimeLabel = UILabel()
    
    let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupCell()
        self.descriptionLabel.text = "Status"
    }
    
    private func setupCell() {
        self.contentView.backgroundColor = SSColors.raisinBlack
        
        self.stackView.axis = .vertical
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.alignment = UIStackView.Alignment.fill
        self.stackView.spacing = 6
        self.contentView.addSubview(self.stackView)
        
        self.descriptionLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        self.netStatusLabel.font = UIFont.preferredFont(forTextStyle: .body)
        self.sessionStartTimeLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        [self.descriptionLabel, self.netStatusLabel, self.sessionStartTimeLabel].forEach {
            $0.textColor = SSColors.platinum
            self.stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12)
        ])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCell(isNetConnected: Bool, start: Date?) {
        let date = Date()
        let calendar = Calendar.current

        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        let formattedDate = String(hour) + ":" + String(minute)
        
        let statusString = "Net Status: Connected"
        let statusAttributedString = NSMutableAttributedString(string: statusString, attributes: [NSAttributedString.Key.foregroundColor : SSColors.platinum])
        statusAttributedString.addAttributes([NSAttributedString.Key.foregroundColor : SSColors.grainYellow], range: NSMakeRange(0, "Net Status: ".count))
        self.netStatusLabel.attributedText = statusAttributedString
        
        let startTimeString = "Start Time: " + formattedDate
        let startTimeAttributedString = NSMutableAttributedString(string: startTimeString, attributes: [NSAttributedString.Key.foregroundColor : SSColors.platinum])
        startTimeAttributedString.addAttributes([NSAttributedString.Key.foregroundColor : SSColors.grainYellow], range: NSMakeRange(0, "Start Time: ".count))
        self.sessionStartTimeLabel.attributedText = startTimeAttributedString
    }
}
