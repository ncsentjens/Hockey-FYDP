//
//  StatsLabelView.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-28.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import Foundation
import UIKit

class StatsLabelView: UIView {
    let statNameLabel = UILabel()
    let statLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.constructView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func constructView() {
        self.statNameLabel.textColor = SSColors.lightGray
        self.statLabel.textColor = SSColors.platinum
        
        self.statNameLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        self.statLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        
        [self.statLabel, self.statNameLabel].forEach { label in
            self.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([label.centerXAnchor.constraint(equalTo: self.centerXAnchor)])
        }
        NSLayoutConstraint.activate([
            self.statNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: SSMargins.small),
            self.statLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -SSMargins.small),
        ])
    }
    
    func apply(statName: String, statValue: String) {
        self.statNameLabel.text = statName
        self.statLabel.text = statValue
    }
}
