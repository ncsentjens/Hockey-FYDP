//
//  LeftRightLabel.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-25.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import Foundation
import UIKit

class LeftRightLabel: UIView {
    let leftLabel = UILabel()
    let rightLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        leftLabel.textAlignment = .left
        rightLabel.textAlignment = .right
        leftLabel.textColor = SSColors.lightGray
        rightLabel.textColor = SSColors.lightGray
        
        [leftLabel, rightLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
            $0.font = UIFont.preferredFont(forTextStyle: .body)

        }
        
        NSLayoutConstraint.activate([
            self.leftLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            self.leftLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.rightLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            self.rightLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(leftText: String, rightText: String) {
        self.leftLabel.text = leftText
        self.rightLabel.text = rightText
    }
}
