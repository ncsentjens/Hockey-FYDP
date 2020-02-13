//
//  CurrentModeViewController.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-26.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import Foundation
import UIKit

enum ShootingMode: String, Codable {
    case allSlots = "all_slots"
    case topCorners = "top_corners"
    
    init(formattedText: String) {
        switch formattedText {
        case "All Slots":
            self = .allSlots
        case "Top Corners":
            self = .topCorners
        default:
            fatalError()
        }
    }
    
    var formattedText: String {
        switch self {
        case .allSlots:
            return "All Slots"
        case .topCorners:
            return "Top Corners"
        }
    }
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
