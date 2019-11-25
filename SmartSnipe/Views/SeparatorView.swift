//
//  SeparatorView.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-25.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import Foundation
import UIKit

class SeparatorView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = SSColors.lightGray50
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([self.heightAnchor.constraint(equalToConstant: 1)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
