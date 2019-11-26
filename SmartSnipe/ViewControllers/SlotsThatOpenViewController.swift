//
//  SlotsThatOpenViewController.swift
//  SmartSnipe
//
//  Created by Nick Sentjens on 2019-11-26.
//  Copyright © 2019 NickSentjens. All rights reserved.
//

import Foundation
import UIKit

class SlotsThatOpenViewController: EditSettingsViewController {
    weak var delegate: NumberOfSlotsThatOpenDelegate?
    
    override init(viewModel: EditSettingsViewModel) {
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setButtonTapped() {
        super.setButtonTapped()
        delegate?.numberOfSlotsThatOpenUpdated(Int(self.viewModel.selectedPickerValue) ?? 1)
    }
}
