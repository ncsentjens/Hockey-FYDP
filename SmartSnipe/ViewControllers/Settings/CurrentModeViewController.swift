//
//  CurrentModeViewController.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-26.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import Foundation
import UIKit

enum ShootingMode: String {
    case allCorners = "All Corners"
    case topCorners = "Top Corners"
}

class CurrentModeViewController: EditSettingsViewController {
    weak var delegate: CurrentModeDelegate?
    
    override init(viewModel: EditSettingsViewModel) {
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setButtonTapped() {
        super.setButtonTapped()
        delegate?.currentModeUpdated(self.viewModel.selectedPickerValue)
    }
}
