//
//  SSTableViewHeaderView.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-28.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import Foundation
import UIKit

class SSTableViewHeaderView: UITableViewHeaderFooterView {
    static let height: CGFloat = 44.0
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.textLabel?.textColor = SSColors.platinum
        let backgroundView = UIView()
        backgroundView.backgroundColor = SSColors.raisinBlack
        self.backgroundView = backgroundView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
